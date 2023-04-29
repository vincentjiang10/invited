import json
from marshmallow import EXCLUDE, ValidationError
from app import db
from app.schemas import UserSchema
from app.models import User
from app.auth import UserAuthentication, new_session_info
from app.views import failure_response, success_response

user_schema = UserSchema()
users_schema = UserSchema(many=True)


def renew_session(user):
    """
    Given user instance, updates state from new session
    """
    user_session_info = new_session_info()
    user.session_token, user.session_expiration, user.update_token = (
        user_session_info["session_token"],
        user_session_info["session_expiration"],
        user_session_info["update_token"],
    )


def create_user(body):
    """
    Create a user given request data, returning a response for the calling api endpoint
    """

    # Check to see whether user with the same email already exists
    user_email = body.get("email")
    existing_user = get_user_by_email(user_email)
    if existing_user is not None:
        return failure_response({"error": "User already exists"}, 400)

    try:
        # user is of instance User
        user = user_schema.load(body, unknown=EXCLUDE)
    except ValidationError as _:
        return failure_response({"error": "Missing or invalid email or name"}, 400)

    # Renew session and update user state
    renew_session(user)

    # Add user to database and commit changes
    db.session.add(user)
    db.session.commit()

    # Return serialized user
    return success_response(user_schema.dump(user), 201)


def get_user_by_email(email):
    """
    Returns user by email, None if user is not in database
    """

    # TODO: Finish
    return 0


def verify_credentials(body):
    """
    Verifies whether or not user in data has the correct password
    """

    # Check to whether a user with the same email exists
    user_email = body.get("email")
    existing_user = get_user_by_email(user_email)
    if existing_user is None:
        return failure_response({"error": "User not found"})

    # Create authentication object and bind to existing user
    user_password = body.get("password")
    if user_password is None:
        return failure_response({"error": "Missing password"}, 400)
    user_auth = UserAuthentication(existing_user)

    return (
        failure_response({"error": "Password is incorrect"}, 400)
        if user_auth.verify_password(user_password)
        else success_response(user_schema.dump(existing_user))
    )
