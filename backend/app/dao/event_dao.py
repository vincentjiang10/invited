from app.models import Event
from app import db


def get_events_to_user_by_session(session_token):
    """
    Get all events created by authorized user with session token
    """
    


def get_events_from_user_by_session(session_token):
    """
    Get all events invited to authorized user with session token
    """


def create_event_by_session(session_token):
    """
    Create an event 
    """

# TODO: Add logic and check whether invited user is a friend before proceeding?
def add_user_to_event_by_email(event_id, user_email):
    """
    Add a user to an event through email
    """
    
def remove_user_from_event_by_email(event_id, user_email):
    """
    Remove a user from an event through email
    """