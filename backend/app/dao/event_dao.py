from sqlalchemy import and_
from app import db
from app.models import UserEvent
from .user_dao import get_user_by_session_token, get_user_by_id
from app.views import status_code_ok


def get_user_event_by_id(user, event_id):
    """
    Gets a user-created event by id
    """
    user_event_association, code = get_first_user_event_association(
        user_id=user.id, event_id=event_id
    )
    if not status_code_ok(code):
        return user_event_association, code

    user_event = user_event_association.event
    return user_event, 200


def get_user_event_association_query(user_id=None, event_id=None, role=None):
    """
    Returns query of associations between user and event
    """
    # Dynamically build filters
    filters = []
    if user_id is not None:
        filters.append(UserEvent.user_id == user_id)
    if event_id is not None:
        filters.append(UserEvent.event_id == event_id)
    if role is not None:
        filters.append(UserEvent.role == role)

    return UserEvent.query.filter(and_(*filters))


def get_first_user_event_association(user_id=None, event_id=None, role=None):
    """
    Returns the first association between user and event that exist
    """
    user_event_association_query = get_user_event_association_query(
        user_id=user_id, event_id=event_id, role=role
    )

    # Get first association
    user_event_association = user_event_association_query.first()

    # If no association is found
    if user_event_association is None:
        return {"error": "Association not found"}, 404

    return user_event_association, 200


def get_all_user_event_associations(user_id=None, event_id=None, role=None):
    """
    Returns all associations between user and event that exist
    """
    user_event_association_query = get_user_event_association_query(
        user_id=user_id, event_id=event_id, role=role
    )

    # Get all associations
    user_event_associations = user_event_association_query.all()

    return user_event_associations, 200


def get_events_from_user_by_session(session_token):
    """
    Get all events created by authorized user with session token
    """

    user_response, code = get_user_by_session_token(session_token)
    if not status_code_ok(code):
        return user_response, code
    user = user_response

    events_from_user_associations = get_all_user_event_associations(
        user_id=user.id, role="creator"
    )

    # Map to events from association
    events_from_user = [
        association.event for association in events_from_user_associations
    ]

    return events_from_user, 200


def get_events_to_user_by_session(session_token):
    """
    Get all events invited to authorized user with session token
    """

    user_response, code = get_user_by_session_token(session_token)
    if not status_code_ok(code):
        return user_response, code
    user = user_response

    events_to_user_associations = get_all_user_event_associations(
        user_id=user.id, role="recipient"
    )

    # Map to events from association
    events_to_user = [association.event for association in events_to_user_associations]

    return events_to_user, 200


def create_event_by_session(event, session_token):
    """
    Create an event by current user
    """

    user_response, code = get_user_by_session_token(session_token)
    if not status_code_ok(code):
        return user_response, code
    user = user_response

    # Add to UserEvent an association object
    user_event_association = UserEvent(user=user, event=event, role="creator")

    db.session.add(user_event_association)
    db.session.commit()

    return event, 201


# TODO: Add logic and check whether invited user is a friend before proceeding?
def add_user_to_event_by_ids(session_token, event_id, target_user_id):
    """
    Add a user to an event through ids
    """
    user_response, code = get_user_by_session_token(session_token)
    if not status_code_ok(code):
        return user_response, code
    user = user_response

    # Compare to see whether target user is the same as current user
    if user.id == target_user_id:
        return {"error": "Cannot add current user as recipient"}, 400

    # Check and get event created by current user
    event_response, code = get_user_event_by_id(user, event_id)
    if not status_code_ok(code):
        return event_response, code
    user_event = event_response

    # Check to see whether target user exists
    user_response, code = get_user_by_id(target_user_id)
    if not status_code_ok(code):
        return user_response, code
    target_user = user_response

    # Check whether event already has user as recipient
    _, code = get_first_user_event_association(
        user_id=target_user.id, event_id=user_event.id, role="recipient"
    )
    if status_code_ok(code):
        return {"error": "Recipient already added"}, 400

    # New user event association
    new_user_event_association = UserEvent(
        user=target_user, event=user_event, role="recipient"
    )

    # Add and commit to database
    db.session.add(new_user_event_association)
    db.session.commit()

    return user_event, 200


def remove_user_from_event_by_ids(session_token, event_id, user_id):
    """
    Remove a user from an event through ids
    """

    user_response, code = get_user_by_session_token(session_token)
    if not status_code_ok(code):
        return user_response, code
    user = user_response

    # Check and get event created by current user
    event_response, code = get_user_event_by_id(user, event_id)
    if not status_code_ok(code):
        return event_response, code
    user_event = event_response

    # Check to see whether target user exists
    user_response, code = get_user_by_id(user_id)
    if not status_code_ok(code):
        return user_response, code
    target_user = user_response

    # Check to see whether an association exists with target user as a recipient of user event
    target_user_event_association, code = get_first_user_event_association(
        user_id=target_user.id, event_id=user_event.id, role="recipient"
    )
    if not status_code_ok(code):
        return target_user_event_association, code

    # Delete association and commit to database
    db.session.delete(target_user_event_association)
    db.session.commit()

    return user_event, 200
