import json
from flask import Blueprint, request
from marshmallow import EXCLUDE, ValidationError
from app import db
from app.dao import event_dao, recipient_list_dao, user_dao
from app.schemas import UserSchema, EventSchema, RecipientListSchema
from app.auth import encrypt_password

api_bp = Blueprint("api", __name__, url_prefix="/api")


# General response and status code from requests
def success_response(data, code=200):
    """
    General success response
    """
    return json.dumps(data), code


def failure_response(data, code=400):
    """
    General failure response
    """
    return json.dumps(data), code


# Initialize schemas
user_schema = UserSchema()
users_schema = UserSchema(many=True)
event_schema = EventSchema()
events_schema = EventSchema(many=True)
recipient_list_schema = RecipientListSchema()
recipient_lists_schema = RecipientListSchema(many=True)


# ------------------------- User Authentication ---------------------------#
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
    if code == 200:
        return failure_response({"error": "User already exists"})

    try:
        # user is of instance User
        user = user_schema.load(body, unknown=EXCLUDE, session=db.session)
    except ValidationError as _:
        return failure_response({"error": "Missing or invalid email or name"})

    data_response, code = user_dao.create_user(user)
    if code != 201:
        return failure_response(data_response, code)

    # Serialize user
    user_serialized = user_schema.dump(data_response)

    return success_response(user_serialized, 201)


def extract_token(request_headers):
    """
    Helper function to extract token from header
    """
    auth_header = request_headers.get("Authorization")
    if auth_header is None:
        return failure_response({"error": "Missing auth header"})
    bearer_token = auth_header.replace("Bearer", "").strip()
    if not bearer_token:
        return failure_response({"error": "Invalid auth header"})
    return success_response({"bearer_token": bearer_token})


@api_bp.route("/users/login/", methods=["POST"])
def login():
    """
    Endpoint for logging a user in using username and password
    """
    body = json.loads(request.data)

    data_response, code = user_dao.verify_credentials(body)
    if code != 200:
        return failure_response(data_response, code)

    # Serialize user
    user_serialized = user_schema.dump(data_response)

    return success_response(user_serialized)


@api_bp.route("/users/logout/", methods=["POST"])
def logout():
    """
    Endpoint for logging a user out using username and password
    """
    token_response, code = extract_token(request.headers)
    if code != 200:
        return token_response
    session_token = json.loads(token_response)["bearer_token"]

    data_reponse, code = user_dao.get_user_by_session_token(
        session_token, expire_session=True
    )
    if code != 200:
        return data_reponse, code

    return success_response({"message": "Sucessfully logged out"})


@api_bp.route("/users/secret/", methods=["POST"])
def secret_message():
    """
    Endpoint for verifying session token and returning a secret message
    """
    token_response, code = extract_token(request.headers)
    if code != 200:
        return token_response
    # Get session token
    session_token = json.loads(token_response)["bearer_token"]

    data_reponse, code = user_dao.get_user_by_session_token(session_token)
    if code != 200:
        return data_reponse, code

    return success_response({"message": "Wow, what a cool secret message"})


@api_bp.route("/users/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session
    """
    token_response, code = extract_token(request.headers)
    if code != 200:
        return token_response
    # Get session token
    update_token = json.loads(token_response)["bearer_token"]

    data_response, code = user_dao.get_user_by_update_token(
        update_token, renew_session=True
    )
    if code != 200:
        return failure_response(data_response, code)

    user_serialized = user_schema.dump(data_response)

    return success_response(user_serialized)


# ------------------------- User Events ---------------------------#


# TODO: Can have a different schema than individual events
# TODO: Fix routes to start with events!
@api_bp.route("/events/from/users/")
def get_events_created_by_user_by_token():
    """
    Endpoint for getting all events that has been created by the current user
    """


@api_bp.route("/events/from/users/", methods=["POST"])
def create_event_by_token():
    """
    Endpoint for creating an event by the current user
    """


@api_bp.route("/events/<int:event_id>/from/users/")
def get_event_created_by_token(event_id):
    """
    Endpoint for getting a specific event that has been created by the current user
    """


@api_bp.route("/events/to/users/")
def get_events_invited_to_user_by_token():
    """
    Endpoint for getting all events that has been received by the current user
    """


@api_bp.route("/events/<int:event_id>/to/users/")
def get_event_invited_to_user_by_token(event_id):
    """
    Endpoint for getting a specific event that has been received by the current user
    """


@api_bp.route("/events/public/to/users/")
def get_user_to_public_events():
    """
    Endpoint for getting all public events
    """


@api_bp.route(
    "/events/<int:event_id>/from/users/<string:user_email>/", methods=["POST"]
)
def add_user_to_event(event_id, user_email):
    """
    Endpoint for adding a user to an event by email
    """


@api_bp.route(
    "/events/<int:event_id>/from/users/<string:user_email>/", methods=["DELETE"]
)
def delete_user_from_event(event_id, user_email):
    """
    Endpoint for removing a user from an event by email
    """
