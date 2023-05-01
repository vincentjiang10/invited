from marshmallow import EXCLUDE, ValidationError
from sqlalchemy import and_
from app import db
from app.dao import DaoException
from app.schemas import EventSchema
from app.models import UserEvent
from .user_dao import get_user_by_session_token, get_user_by_id


def get_event_from_association(user_event_association):
    """
    Get the event in the user event association
    """
    return user_event_association.event


def get_events_from_all_associations(user_event_associations):
    """
    Get all the events in user event associations
    """
    return [association.event for association in user_event_associations]


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
        raise DaoException("Association not found", 404)

    return user_event_association


def get_all_user_event_associations(user_id=None, event_id=None, role=None):
    """
    Returns all associations between user and event that exist
    """
    user_event_association_query = get_user_event_association_query(
        user_id=user_id, event_id=event_id, role=role
    )

    # Get all associations
    user_event_associations = user_event_association_query.all()

    return user_event_associations


# TODO: Separate arguments into separate construct? Like a type or class?
def get_all_user_events(user_id=None, event_id=None, role=None):
    """
    Get all user events from user event associations that match
    """
    user_event_associations = get_all_user_event_associations(
        user_id=user_id, event_id=event_id, role=role
    )
    return get_events_from_all_associations(user_event_associations)


def get_first_user_event(user_id=None, event_id=None, role=None):
    """
    Get first user event from user event associations that match
    """
    user_event_association = get_first_user_event_association(
        user_id=user_id, event_id=event_id, role=role
    )
    return get_event_from_association(user_event_association)


def get_events_from_user_by_session(session_token):
    """
    Get all events created by authorized user with session token
    """

    user = get_user_by_session_token(session_token)
    events_from_user = get_all_user_events(user_id=user.id, role="creator")

    return events_from_user


def get_events_to_user_by_session(session_token):
    """
    Get all events invited to authorized user with session token
    """

    user = get_user_by_session_token(session_token)
    events_to_user = get_all_user_events(user_id=user.id, role="recipient")

    return events_to_user


def create_event_by_session(session_token, body):
    """
    Create an event by current user
    """
    try:
        event_schema = EventSchema()
        # event is of instance Event
        event = event_schema.load(body, unknown=EXCLUDE, session=db.session)
    except (ValidationError, KeyError) as _:
        raise DaoException("Missing or invalid required parameters")

    user = get_user_by_session_token(session_token)

    # Add to UserEvent an association object
    user_event_association = UserEvent(user=user, event=event, role="creator")

    db.session.add(user_event_association)
    db.session.commit()

    return event


def update_event_from_user_by_session(session_token, event_id, body):
    """
    Update event by current user
    """
    user = get_user_by_session_token(session_token)
    user_event = get_first_user_event(
        user_id=user.id, event_id=event_id, role="creator"
    )

    try:
        # Pass existing instance
        event_schema_of_instance = EventSchema(instance=user_event)
        # event is of instance Event
        updated_event = event_schema_of_instance.load(
            body, unknown=EXCLUDE, session=db.session
        )
    except ValidationError as _:
        raise DaoException("Missing or invalid required parameters")

    db.session.commit()

    return updated_event


# TODO: Add logic and check whether invited user is a friend before proceeding?
def add_user_to_event_by_ids(session_token, event_id, target_user_id):
    """
    Add a user to an event through ids
    """
    user = get_user_by_session_token(session_token)

    # Compare to see whether target user is the same as current user
    if user.id == target_user_id:
        raise DaoException("Cannot add current user as recipient")

    # Check and get event created by current user
    user_event = get_first_user_event(
        user_id=user.id, event_id=event_id, role="creator"
    )

    # Check to see whether target user exists
    target_user = get_user_by_id(target_user_id)

    # Check whether event already has user as recipient
    is_user_already_recipient = True
    try:
        _ = get_first_user_event(
            user_id=target_user.id, event_id=user_event.id, role="recipient"
        )
    except DaoException:
        is_user_already_recipient = False

    if is_user_already_recipient:
        raise DaoException("User is already a recipient")

    # New user event association
    new_user_event_association = UserEvent(
        user=target_user, event=user_event, role="recipient"
    )

    # Add and commit to database
    db.session.add(new_user_event_association)
    db.session.commit()

    return user_event


def remove_user_from_event_by_ids(session_token, event_id, user_id):
    """
    Remove a user from an event through ids
    """

    user = get_user_by_session_token(session_token)

    # Check and get event created by current user
    user_event = get_first_user_event(
        user_id=user.id, event_id=event_id, role="creator"
    )

    # Check to see whether target user exists
    target_user = get_user_by_id(user_id)

    # Check to see whether an association exists with target user as a recipient of user event
    target_user_event_association = get_first_user_event_association(
        user_id=target_user.id, event_id=user_event.id, role="recipient"
    )

    # Delete association and commit to database
    db.session.delete(target_user_event_association)
    db.session.commit()

    return user_event
