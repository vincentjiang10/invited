from app.schemas import EventSchema
from app.models import Event
from app import db

event_schema = EventSchema()
events_schema = EventSchema(many=True)


def get_events_by_creator_id(user_id):
    """
    Get all events that were created by user
    """


def get_events_by_recipient_id(user_id):
    """
    Get all events that have user invited
    """


def create_event(body):
    """
    Create the event
    """


def add_user_to_event_by_id(user_id, event_id):
    """
    Add a user to an event
    """
