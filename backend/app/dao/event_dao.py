from app import db
from .user_dao import get_user_by_session_token
from app.models import Event, UserEvent


def get_events_from_user_by_session(session_token):
    """
    Get all events created by authorized user with session token
    """

    user_response, code = get_user_by_session_token(session_token)
    if code != 200:
        return user_response, code
    user = user_response

    events_from_user_associations = UserEvent.query.filter(
        UserEvent.user_id == user.id and UserEvent.role == "creator"
    ).all()

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
    if code != 200:
        return user_response, code
    user = user_response

    events_to_user_associations = UserEvent.query.filter(
        UserEvent.user_id == user.id and UserEvent.role == "recipient"
    ).all()

    # Map to events from association
    events_to_user = [association.event for association in events_to_user_associations]

    return events_to_user, 200


def create_event_by_session(event, session_token):
    """
    Create an event by current user
    """

    user_response, code = get_user_by_session_token(session_token)
    if code != 200:
        return user_response, code
    user = user_response

    # Add to UserEvent an association object
    user_event_association = UserEvent(user=user, event=event, role="creator")

    db.session.add(user_event_association)
    db.session.commit()

    return event, 201


# TODO: Add logic and check whether invited user is a friend before proceeding?
def add_user_to_event_by_email(event_id, user_email):
    """
    Add a user to an event through email
    """


def remove_user_from_event_by_email(event_id, user_email):
    """
    Remove a user from an event through email
    """
