import json
from flask import Blueprint, request
from app.views import success_response, failure_response
from app.dao import event_dao, recipient_list_dao, user_dao, DaoException
from app.schemas import UserSchemas, EventSchemas, RecipientListSchemas

api_bp = Blueprint("api", __name__, url_prefix="/api")

# ------------------------- User Authentication ---------------------------#
# User schemas
user_schema = UserSchemas.user_schema
users_schema = UserSchemas.users_schema
user_private_schema = UserSchemas.user_private_schema
users_private_schema = UserSchemas.users_private_schema
user_public_schema = UserSchemas.user_public_schema
users_public_schema = UserSchemas.users_public_schema


# TODO: Add security (https) to vm + research how to deploy production instance of server
# TODO: Factor out common structure between all functions and instead supply callback
# TODO: Add custom schemas for user session, public, and private profiles


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

    try:
        user = user_dao.create_user(body)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

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


@api_bp.route("/users/login/", methods=["POST"])
def login():
    """
    Endpoint for logging a user in using username and password
    """
    body = json.loads(request.data)

    try:
        user = user_dao.verify_credentials(body)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

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
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    return success_response({"message": "Successfully logged out"})


@api_bp.route("/users/public/profile/")
def public_user_profiles():
    """
    Endpoint for getting all public user profiles
    """
    try:
        all_users = user_dao.get_all_users
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    users_public_profiles = users_public_schema.dump(all_users)
    return success_response(users_public_profiles)


@api_bp.route("/users/<int:user_id>/public/profile")
def public_user_profile(user_id):
    """
    Endpoint for getting single user public profile info (can include additional info may not have)
    """
    try:
        user = user_dao.get_user_by_id(user_id)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    user_public_profile = user_public_schema.dump(user)
    return success_response(user_public_profile)


@api_bp.route("/users/profile/")
def user_info():
    """
    Endpoint for getting user private profile info
    """
    try:
        session_token = extract_token(request.headers)
        user = user_dao.get_user_by_session_token(session_token)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    user_private_info = user_private_schema.dump(user)
    return success_response(user_private_info)


@api_bp.route("/users/profile/", methods=["POST"])
def update_user_profile():
    """
    Updates the current user's profile information (So not all user information can be updated, just profile info)
    """
    body = json.loads(request.data)

    try:
        session_token = extract_token(request.headers)

        user_dao.update_user_profile_by_session(session_token, body)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    return success_response(None, 204)


@api_bp.route("/users/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session
    """
    try:
        update_token = extract_token(request.headers)

        user = user_dao.get_user_by_update_token(update_token, renew_session=True)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    user_serialized = user_schema.dump(user)

    return success_response(user_serialized)


# ------------------------- User Events ---------------------------#
event_schema = EventSchemas.event_schema
events_schema = EventSchemas.events_schema


@api_bp.route("/events/public/to/users/")
def get_user_to_public_events():
    """
    Endpoint for getting all public events
    """
    try:
        public_events = event_dao.get_all_public_events()
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    # Serialization
    events_serialized = events_schema.dump(public_events)

    return success_response(events_serialized, 200)


@api_bp.route("/events/from/users/")
def get_events_created_by_user():
    """
    Endpoint for getting all events that has been created by the current user
    """
    try:
        # Get token
        session_token = extract_token(request.headers)

        # Get events
        events = event_dao.get_events_from_user_by_session(session_token)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    # Serialization
    events_serialized = events_schema.dump(events)

    return success_response(events_serialized, 200)


@api_bp.route("/events/to/users/")
def get_events_invited_to_user():
    """
    Endpoint for getting all events that has been received by the current user
    """
    try:
        session_token = extract_token(request.headers)
        # Private events invited to user
        events = event_dao.get_events_to_user_by_session(session_token)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    events_serialized = events_schema.dump(events)

    return success_response(events_serialized, 200)


# TODO: Delete this later
@api_bp.route("/events/from/users/anonymized/", methods=["POST"])
def create_anonymized_public_event():
    """
    Endpoint for creating an anonymized event
    """
    body = json.loads(request.data)

    try:
        created_event = event_dao.create_anonymized_event(body)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    # Serialize event
    event_serialized = event_schema.dump(created_event)

    return success_response(event_serialized, 201)


@api_bp.route("/events/from/users/", methods=["POST"])
def create_event_by_token():
    """
    Endpoint for creating an event by the current user
    """
    body = json.loads(request.data)

    try:
        session_token = extract_token(request.headers)

        created_event = event_dao.create_event_by_session(session_token, body)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

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
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    # Serialize event
    event_serialized = event_schema.dump(updated_event)

    return success_response(event_serialized, 200)


@api_bp.route("/events/<int:event_id>/from/users/add/", methods=["POST"])
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
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    event_serialized = event_schema.dump(user_event)

    return success_response(event_serialized, 200)


@api_bp.route("/events/<int:event_id>/from/users/remove/", methods=["DELETE"])
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
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    return success_response(None, 204)


@api_bp.route("/events/<int:event_id>/from/users/all/", methods=["DELETE"])
def delete_all_recipients_from_event(event_id):
    """
    Endpoint for removing all recipients from an event
    """
    try:
        session_token = extract_token(request.headers)

        event_dao.remove_all_recipients_from_event(session_token, event_id)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    return success_response(None, 204)


@api_bp.route("/events/<int:event_id>/from/users/", methods=["DELETE"])
def delete_event_from_user_by_session(event_id):
    """
    Delete an event from the current user
    """
    try:
        session_token = extract_token(request.headers)

        event_dao.remove_event_by_session(session_token, event_id)
    except DaoException as exc:
        return failure_response(exc.message, exc.code)

    return success_response(None, 204)


# ----------------------------- Recipient Lists -----------------------------#
recipient_list_schema = RecipientListSchemas.recipient_list_schema
recipient_lists_schema = RecipientListSchemas.recipient_lists_schema

# TODO: Continue
