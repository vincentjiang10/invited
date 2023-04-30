import json
from marshmallow import EXCLUDE, ValidationError
from app import db
from app.schemas import UserSchema
from app.models import User
from app.auth import UserAuthentication, new_session_info, new_session_time
from app.views import failure_response, success_response

user_schema = UserSchema()
users_schema = UserSchema(many=True)


def _expire_session(user):
    """
    Given user, expire the session and update user state
    """
    user.session_expiration = new_session_time()


def _renew_session(user):
    """
    Given user instance, updates user state from new session
    """
    user_session_info = new_session_info()
    user.session_token, user.session_expiration, user.update_token = (
        user_session_info["session_token"],
        user_session_info["session_expiration"],
        user_session_info["update_token"],
    )


def get_user_by_email(email):
    """
    Returns user by email, None if user is not in database
    """

    return User.query.filter(User.email == email).first()


def get_user_by_session_token(session_token, expire_session=False):
    """
    Returns user by session token
    """
    user = User.query.filter(User.session_token == session_token).first()
    if user is None:
        return failure_response({"error": "User not found"})

    # Create authentication object and bind to existing user
    user_auth = UserAuthentication(user)
    is_user_verified = user_auth.verify_session(session_token)

    if expire_session:
        _expire_session(user)
    db.session.commit()

    return (
        failure_response({"error": "User verification failed"})
        if not is_user_verified
        else success_response(user_schema.dump(user))
    )


def get_user_by_update_token(update_token, renew_session=False):
    """
    Returns user by update token
    """
    user = User.query.filter(User.update_token == update_token).first()
    if user is None:
        return failure_response({"error": "User not found"})

    # Create authentication object and bind to existing user
    user_auth = UserAuthentication(user)
    is_user_verified = user_auth.verify_update_token(update_token)

    if not is_user_verified:
        return failure_response({"error": "User verification failed"})

    # Update session and commit
    if renew_session:
        _renew_session(user)
        db.session.commit()

    return success_response(user_schema.dump(user))


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
        user = user_schema.load(body, unknown=EXCLUDE, session=db.session)
    except ValidationError as _:
        return failure_response({"error": "Missing or invalid email or name"}, 400)

    # Renew session and update user state
    _renew_session(user)

    # Add user to database and commit changes
    db.session.add(user)
    db.session.commit()

    # Return serialized user
    return success_response(user_schema.dump(user), 201)


def verify_credentials(body):
    """
    Verifies whether or not user in data has the correct password
    """

    # Check to whether a user with the same email exists
    user_email = body.get("email")
    existing_user = get_user_by_email(user_email)
    if existing_user is None:
        return failure_response({"error": "User not found"})

    user_password = body.get("password")
    if user_password is None:
        return failure_response({"error": "Missing password"}, 400)
    # Create authentication object and bind to existing user
    user_auth = UserAuthentication(existing_user)
    is_user_verified = user_auth.verify_password(user_password)

    return (
        failure_response({"error": "Password is incorrect"}, 400)
        if not is_user_verified
        else success_response(user_schema.dump(existing_user))
    )
