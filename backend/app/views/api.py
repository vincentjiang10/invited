import json
from flask import Blueprint, request
from app.views import success_response, failure_response
from app.dao import event_dao, recipient_list_dao, user_dao, DaoException
from app.schemas import UserSchema, EventSchema, RecipientListSchema

api_bp = Blueprint("api", __name__, url_prefix="/api")

# ------------------------- User Authentication ---------------------------#
# Initialize schemas for deserialization and serialization
user_schema = UserSchema()
users_schema = UserSchema(many=True)


@api_bp.route("/")
def hello():
    """
    Default (test) endpoint
    """

    return success_response({"message": "Hurray!!"})


# TODO: fix error when registering with missing parameters
@api_bp.route("/users/register/", methods=["POST"])
def register_account():
    """
    Endpoint for registering an account
    """

    # Load request data into python dictionary
    body = json.loads(request.data)

    try:
        user = user_dao.create_user(body)
    except DaoException as de:
        return failure_response(de.message, de.code)

    # Serialize user
    user_serialized = user_schema.dump(user)

    return success_response(user_serialized, 201)


def extract_token(request_headers):
    """
    Helper function to extract token from header
    """
    auth_header = request_headers.get("Authorization")
    if auth_header is None:
        raise DaoException("Missing auth header", 404)
    bearer_token = auth_header.replace("Bearer", "").strip()
    if not bearer_token:
        raise DaoException("Invalid auth header")
    return bearer_token


# TODO: Add exception catching for dao operations
@api_bp.route("/users/login/", methods=["POST"])
def login():
    """
    Endpoint for logging a user in using username and password
    """
    body = json.loads(request.data)

    try:
        user = user_dao.verify_credentials(body)
    except DaoException as de:
        return failure_response(de.message, de.code)

    # Serialize user
    user_serialized = user_schema.dump(user)

    return success_response(user_serialized)


@api_bp.route("/users/logout/", methods=["POST"])
def logout():
    """
    Endpoint for logging a user out using username and password
    """
    try:
        session_token = extract_token(request.headers)
        _ = user_dao.get_user_by_session_token(session_token, expire_session=True)
    except DaoException as de:
        return failure_response(de.message, de.code)

    return success_response({"message": "Successfully logged out"})


@api_bp.route("/users/info/", methods=["POST"])
def user_info():
    """
    Endpoint for verifying session token and returning a secret message
    """
    try:
        session_token = extract_token(request.headers)
        user_info = user_dao.get_user_secret_info(session_token)
    except DaoException as de:
        return failure_response(de.message, de.code)

    return success_response(user_info)


@api_bp.route("/users/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session
    """
    try:
        update_token = extract_token(request.headers)

        user = user_dao.get_user_by_update_token(update_token, renew_session=True)
    except DaoException as de:
        return failure_response(de.message, de.code)

    user_serialized = user_schema.dump(user)

    return success_response(user_serialized)


# ------------------------- User Events ---------------------------#
event_schema = EventSchema()
events_schema = EventSchema(many=True)


# TODO: Fix duplicates
@api_bp.route("/events/public/to/users/")
def get_user_to_public_events():
    """
    Endpoint for getting all public events
    """
    try:
        public_events = event_dao.get_all_public_events()
    except DaoException as de:
        return failure_response(de.message, de.code)

    # Serialization
    events_serialized = events_schema.dump(public_events)

    return success_response(events_serialized, 200)


# TODO: Can have a different schema than individual events (Where additional information can be revealed)
@api_bp.route("/events/from/users/")
def get_events_created_by_user_by_token():
    """
    Endpoint for getting all events that has been created by the current user
    """
    try:
        # Get token
        session_token = extract_token(request.headers)

        # Get events
        events = event_dao.get_events_from_user_by_session(session_token)
    except DaoException as de:
        return failure_response(de.message, de.code)

    # Serialization
    events_serialized = events_schema.dump(events)

    return success_response(events_serialized, 200)


@api_bp.route("/events/to/users/")
def get_events_invited_to_user_by_token():
    """
    Endpoint for getting all events that has been received by the current user
    """
    try:
        session_token = extract_token(request.headers)
        # Private events invited to user
        events = event_dao.get_events_to_user_by_session(session_token)
    except DaoException as de:
        return failure_response(de.message, de.code)

    events_serialized = events_schema.dump(events)

    return success_response(events_serialized, 200)


@api_bp.route("/events/from/users/", methods=["POST"])
def create_event_by_token():
    """
    Endpoint for creating an event by the current user
    """
    body = json.loads(request.data)

    try:
        session_token = extract_token(request.headers)

        created_event = event_dao.create_event_by_session(session_token, body)
    except DaoException as de:
        return failure_response(de.message, de.code)

    # Serialize event
    event_serialized = event_schema.dump(created_event)

    return success_response(event_serialized, 201)


@api_bp.route("/events/<int:event_id>/from/users/update/", methods=["POST"])
def update_event_by_id(event_id):
    """
    Endpoint for modifying an event by id
    """
    body = json.loads(request.data)

    try:
        session_token = extract_token(request.headers)

        updated_event = event_dao.update_event_from_user_by_session(
            session_token, event_id, body
        )
    except DaoException as de:
        return failure_response(de.message, de.code)

    # Serialize event
    event_serialized = event_schema.dump(updated_event)

    return success_response(event_serialized, 201)


@api_bp.route("/events/<int:event_id>/from/users/", methods=["POST"])
def add_user_to_event(event_id):
    """
    Endpoint for adding a user to an event by email
    """
    target_user_email = request.args.get("target_email")

    try:
        session_token = extract_token(request.headers)
        user_event = event_dao.add_user_to_event_by_email(
            session_token, event_id, target_user_email
        )
    except DaoException as de:
        return failure_response(de.message, de.code)

    event_serialized = event_schema.dump(user_event)

    return success_response(event_serialized, 200)


@api_bp.route("/events/<int:event_id>/from/users/", methods=["DELETE"])
def delete_user_from_event(event_id):
    """
    Endpoint for removing a user from an event by email
    """
    target_user_email = request.args.get("target_email")

    try:
        session_token = extract_token(request.headers)

        event_dao.remove_user_from_event_by_email(
            session_token, event_id, target_user_email
        )
    except DaoException as de:
        return failure_response(de.message, de.code)

    return success_response(None, 204)


@api_bp.route("/events/<int:event_id>/from/users/", methods=["DELETE"])
def delete_all_recipients_from_event(event_id):
    """
    Endpoint for removing all recipients from an event
    """
    try:
        session_token = extract_token(request.headers)

        event_dao.remove_all_recipients_from_event(session_token, event_id)
    except DaoException as de:
        return failure_response(de.message, de.code)

    return success_response(None, 204)


# ----------------------------- Recipient Lists -----------------------------#
recipient_list_schema = RecipientListSchema()
recipient_lists_schema = RecipientListSchema(many=True)

# TODO: Finish
