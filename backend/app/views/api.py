import json
from functools import wraps
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


def api_function_decorator_factory(require=None):
    """
    Function factory to respond to api endpoints.
    Callback should return serialized output and status code and is in the form:
    {flask_args, require} -> serialized, code
    """

    def api_function_decorator(callback):
        @wraps(callback)
        
        # We return an api function that dynamically add to kwargs
        def api_function(*args, **kwargs):
            try:
                # Add to kwargs
                if require is not None:
                    for key in require:
                        if key == "body":
                            kwargs[key] = json.loads(request.data)
                        elif key == "token":
                            kwargs[key] = extract_token(request.headers)

                # Unpack resulting tuple from callback
                return success_response(*callback(*args, **kwargs))

            except DaoException as exc:
                return failure_response(exc.message, exc.code)

        return api_function

    return api_function_decorator


# Define default api function decorator
default_api_function_decorator = api_function_decorator_factory()


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


@api_bp.route("/")
def hello():
    """
    Default (test) endpoint
    """

    return success_response({"message": "Hurray!!"})


@api_bp.route("/users/register/", methods=["POST"])
@api_function_decorator_factory(require=["body"])
def register_account(body):
    """
    Endpoint for registering an account
    """
    user = user_dao.create_user(body)
    # Serialize user
    user_serialized = user_schema.dump(user)

    return user_serialized, 201


@api_bp.route("/users/login/", methods=["POST"])
@api_function_decorator_factory(require=["body"])
def login(body):
    """
    Endpoint for logging a user in using username and password
    """
    user = user_dao.verify_credentials(body)
    # Serialize user
    user_serialized = user_schema.dump(user)

    return user_serialized, 200


@api_bp.route("/users/logout/", methods=["POST"])
@api_function_decorator_factory(require=["token"])
def logout(token):
    """
    Endpoint for logging a user out using username and password
    """
    _ = user_dao.get_user_by_session_token(token, expire_session=True)

    return {"message": "Successfully logged out"}, 200


@api_bp.route("/users/public/profiles/")
@default_api_function_decorator
def public_user_profiles():
    """
    Endpoint for getting all public user profiles
    """
    all_users = user_dao.get_all_users()
    users_public_profiles = users_public_schema.dump(all_users)

    return users_public_profiles, 200


# Note: order of decorators matter
@api_bp.route("/users/<int:user_id>/public/profiles/")
@default_api_function_decorator
def public_user_profile(user_id):
    """
    Endpoint for getting single user public profile info (can include additional info may not have)
    """
    user = user_dao.get_user_by_id(user_id)
    user_public_profile = user_public_schema.dump(user)

    return user_public_profile, 200


@api_bp.route("/users/profiles/")
@api_function_decorator_factory(require=["token"])
def user_info(token):
    """
    Endpoint for getting user private profile info
    """
    user = user_dao.get_user_by_session_token(token)
    user_private_info = user_private_schema.dump(user)

    return user_private_info, 200


@api_bp.route("/users/profiles/", methods=["POST"])
@api_function_decorator_factory(require=["body", "token"])
def update_user_profile(body, token):
    """
    Updates the current user's profile information (So not all user information can be updated, just profile info)
    """
    updated_user = user_dao.update_user_profile_by_session(token, body)
    user_private_info = user_private_schema.dump(updated_user)

    return user_private_info, 200


@api_bp.route("/users/session/", methods=["POST"])
@api_function_decorator_factory(require=["token"])
def update_session(token):
    """
    Endpoint for updating a user's session
    """
    user = user_dao.get_user_by_update_token(token, renew_session=True)
    user_serialized = user_schema.dump(user)

    return user_serialized, 200


# ------------------------- User Events ---------------------------#
event_schema = EventSchemas.event_schema
events_schema = EventSchemas.events_schema


@api_bp.route("/events/public/to/users/")
@default_api_function_decorator
def get_user_to_public_events():
    """
    Endpoint for getting all public events
    """
    public_events = event_dao.get_all_public_events()
    events_serialized = events_schema.dump(public_events)
    return events_serialized, 200


@api_bp.route("/events/from/users/")
@api_function_decorator_factory(require=["token"])
def get_events_created_by_user(token):
    """
    Endpoint for getting all events that has been created by the current user
    """
    # Get events
    events = event_dao.get_events_from_user_by_session(token)
    # Serialization
    events_serialized = events_schema.dump(events)

    return events_serialized, 200


@api_bp.route("/events/to/users/")
@api_function_decorator_factory(require=["token"])
def get_events_invited_to_user(token):
    """
    Endpoint for getting all events that has been received by the current user
    """
    # Private events invited to user
    events = event_dao.get_events_to_user_by_session(token)
    events_serialized = events_schema.dump(events)

    return events_serialized, 200


# TODO: Delete this later
@api_bp.route("/events/from/users/anonymized/", methods=["POST"])
@api_function_decorator_factory(require=["body"])
def create_anonymized_public_event(body):
    """
    Endpoint for creating an anonymized event
    """
    created_event = event_dao.create_anonymized_event(body)

    # Serialize event
    event_serialized = event_schema.dump(created_event)

    return event_serialized, 201


@api_bp.route("/events/from/users/", methods=["POST"])
@api_function_decorator_factory(require=["body", "token"])
def create_event_by_token(body, token):
    """
    Endpoint for creating an event by the current user
    """
    session_token = token
    created_event = event_dao.create_event_by_session(session_token, body)
    # Serialize event
    event_serialized = event_schema.dump(created_event)

    return event_serialized, 201


@api_bp.route("/events/<int:event_id>/from/users/update/", methods=["POST"])
@default_api_function_decorator
def update_event_by_id(event_id):
    """
    Endpoint for modifying an event by id
    """
    body = json.loads(request.data)
    session_token = extract_token(request.headers)

    updated_event = event_dao.update_event_from_user_by_session(
        session_token, event_id, body
    )

    # Serialize event
    event_serialized = event_schema.dump(updated_event)

    return event_serialized, 200


@api_bp.route("/events/<int:event_id>/from/users/add/", methods=["POST"])
@default_api_function_decorator
def add_user_to_event(event_id):
    """
    Endpoint for adding a user to an event by email
    """
    target_user_email = request.args.get("target_email")
    session_token = extract_token(request.headers)

    user_event = event_dao.add_user_to_event_by_email(
        session_token, event_id, target_user_email
    )

    event_serialized = event_schema.dump(user_event)

    return event_serialized, 200


@api_bp.route("/events/<int:event_id>/from/users/remove/", methods=["DELETE"])
@default_api_function_decorator
def delete_user_from_event(event_id):
    """
    Endpoint for removing a user from an event by email
    """
    target_user_email = request.args.get("target_email")
    session_token = extract_token(request.headers)
    event_dao.remove_user_from_event_by_email(
        session_token, event_id, target_user_email
    )

    return None, 204


@api_bp.route("/events/<int:event_id>/from/users/all/", methods=["DELETE"])
@default_api_function_decorator
def delete_all_recipients_from_event(event_id):
    """
    Endpoint for removing all recipients from an event
    """
    session_token = extract_token(request.headers)
    event_dao.remove_all_recipients_from_event(session_token, event_id)

    return None, 204


@api_bp.route("/events/<int:event_id>/from/users/", methods=["DELETE"])
@default_api_function_decorator
def delete_event_from_user_by_session(event_id):
    """
    Delete an event from the current user
    """
    session_token = extract_token(request.headers)
    event_dao.remove_event_by_session(session_token, event_id)

    return None, 204


# ----------------------------- Recipient Lists -----------------------------#
recipient_list_schema = RecipientListSchemas.recipient_list_schema
recipient_lists_schema = RecipientListSchemas.recipient_lists_schema

# TODO: Continue
