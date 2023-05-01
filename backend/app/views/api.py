import json
from flask import Blueprint, request
from marshmallow import EXCLUDE, ValidationError
from app import db
from app.views import status_code_ok, success_response, failure_response
from app.dao import event_dao, recipient_list_dao, user_dao
from app.schemas import UserSchema, EventSchema, RecipientListSchema
from app.auth import encrypt_password

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


@api_bp.route("/users/register/", methods=["POST"])
def register_account():
    """
    Endpoint for registering an account
    """

    # Load request data into python dictionary
    body = json.loads(request.data)

    # We change and transform user password to password digest because we do not want to store actual password in database
    user_password = body.get("password")
    if user_password is None:
        return failure_response({"error": "Missing or invalid password"})
    user_password_digest = encrypt_password(user_password)

    # Set password digest
    body["password_digest"] = user_password_digest

    # Check to see whether user with the same email already exists
    user_email = body.get("email")
    _, code = user_dao.get_user_by_email(user_email)
    if status_code_ok(code):
        return failure_response({"error": "User already exists"})

    try:
        # user is of instance User
        user = user_schema.load(body, unknown=EXCLUDE, session=db.session)
    except ValidationError as _:
        return failure_response({"error": "Missing or invalid email or name"})

    user_response, code = user_dao.create_user(user)
    if code != 201:
        return failure_response(user_response, code)

    # Serialize user
    user_serialized = user_schema.dump(user_response)

    return success_response(user_serialized, 201)


def extract_token(request_headers):
    """
    Helper function to extract token from header
    """
    auth_header = request_headers.get("Authorization")
    if auth_header is None:
        return {"error": "Missing auth header"}, 404
    bearer_token = auth_header.replace("Bearer", "").strip()
    if not bearer_token:
        return {"error": "Invalid auth header"}, 400
    return bearer_token, 200


@api_bp.route("/users/login/", methods=["POST"])
def login():
    """
    Endpoint for logging a user in using username and password
    """
    body = json.loads(request.data)

    user_response, code = user_dao.verify_credentials(body)
    if not status_code_ok(code):
        return failure_response(user_response, code)

    # Serialize user
    user_serialized = user_schema.dump(user_response)

    return success_response(user_serialized)


@api_bp.route("/users/logout/", methods=["POST"])
def logout():
    """
    Endpoint for logging a user out using username and password
    """
    token_response, code = extract_token(request.headers)
    if not status_code_ok(code):
        return failure_response(token_response, code)
    session_token = token_response

    user_reponse, code = user_dao.get_user_by_session_token(
        session_token, expire_session=True
    )
    if not status_code_ok(code):
        return user_reponse, code

    return success_response({"message": "Sucessfully logged out"})


@api_bp.route("/users/secret/", methods=["POST"])
def secret_message():
    """
    Endpoint for verifying session token and returning a secret message
    """
    token_response, code = extract_token(request.headers)
    if not status_code_ok(code):
        return failure_response(token_response, code)
    session_token = token_response

    user_reponse, code = user_dao.get_user_by_session_token(session_token)
    if not status_code_ok(code):
        return user_reponse, code

    return success_response({"message": "Wow, what a cool secret message"})


@api_bp.route("/users/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session
    """
    token_response, code = extract_token(request.headers)
    if not status_code_ok(code):
        return failure_response(token_response, code)
    update_token = token_response

    user_response, code = user_dao.get_user_by_update_token(
        update_token, renew_session=True
    )
    if not status_code_ok(code):
        return failure_response(user_response, code)

    user_serialized = user_schema.dump(user_response)

    return success_response(user_serialized)


# ------------------------- User Events ---------------------------#
event_schema = EventSchema()
events_schema = EventSchema(many=True)


# TODO: Can have a different schema than individual events (Where additional information can be revealed)
@api_bp.route("/events/from/users/")
def get_events_created_by_user_by_token():
    """
    Endpoint for getting all events that has been created by the current user
    """
    # Get token
    token_response, code = extract_token(request.headers)
    if not status_code_ok(code):
        return failure_response(token_response, code)
    session_token = token_response

    # Get events
    events_response, code = event_dao.get_events_from_user_by_session(session_token)
    if not status_code_ok(code):
        return failure_response(events_response, code)

    # Serialization
    events_serialized = events_schema.dump(events_response)

    return success_response(events_serialized, 200)


@api_bp.route("/events/to/users/")
def get_events_invited_to_user_by_token():
    """
    Endpoint for getting all events that has been received by the current user
    """
    token_response, code = extract_token(request.headers)
    if not status_code_ok(code):
        return failure_response(token_response, code)
    session_token = token_response

    events_response, code = event_dao.get_events_to_user_by_session(session_token)
    if not status_code_ok(code):
        return failure_response(events_response, code)

    events_serialized = events_schema.dump(events_response)

    return success_response(events_serialized, 200)


# TODO
@api_bp.route("/events/public/to/users/")
def get_user_to_public_events():
    """
    Endpoint for getting all public events
    """


@api_bp.route("/events/from/users/", methods=["POST"])
def create_event_by_token():
    """
    Endpoint for creating an event by the current user
    """
    token_response, code = extract_token(request.headers)
    if not status_code_ok(code):
        return failure_response(token_response, code)
    session_token = token_response

    body = json.loads(request.data)
    try:
        # event is of instance Event
        event = event_schema.load(body, unknown=EXCLUDE, session=db.session)
    except ValidationError as _:
        return failure_response({"error": "Missing event name"})

    event_response, code = event_dao.create_event_by_session(event, session_token)
    if code != 201:
        return failure_response(event_response, code)

    # Serialize event
    event_serialized = event_schema.dump(event_response)

    return success_response(event_serialized, 201)


@api_bp.route("/events/<int:event_id>/from/users/<int:user_id>/", methods=["POST"])
def add_user_to_event(event_id, user_id):
    """
    Endpoint for adding a user to an event by email
    """
    token_response, code = extract_token(request.headers)
    if not status_code_ok(code):
        return failure_response(token_response, code)
    session_token = token_response

    event_response, code = event_dao.add_user_to_event_by_ids(
        session_token, event_id, user_id
    )
    if not status_code_ok(code):
        return failure_response(event_response, code)

    event_serialized = event_schema.dump(event_response)

    return success_response(event_serialized, 200)


@api_bp.route("/events/<int:event_id>/from/users/<int:user_id>/", methods=["DELETE"])
def delete_user_from_event(event_id, user_id):
    """
    Endpoint for removing a user from an event by email
    """
    token_response, code = extract_token(request.headers)
    if not status_code_ok(code):
        return failure_response(token_response, code)
    session_token = token_response

    event_response, code = event_dao.remove_user_from_event_by_ids(
        session_token, event_id, user_id
    )
    if not status_code_ok(code):
        return failure_response(event_response, code)

    event_serialized = event_schema.dump(event_response)

    return success_response(event_serialized, 200)


# ----------------------------- Recipient Lists -----------------------------#
recipient_list_schema = RecipientListSchema()
recipient_lists_schema = RecipientListSchema(many=True)

# TODO: Finish
