from app import db
from app.models import User
from app.auth import UserAuthentication, new_session_info, new_session_time
from app.views import status_code_ok


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

def get_user_by_id(user_id):
    """
    Returns user by email
    """
    user = User.query.filter(User.id == user_id).first()
    if user is None:
        return {"error": "User not found with id"}, 404
    return user, 200

def get_user_by_email(email):
    """
    Returns user by email if user exists, otherwise returns error message. Also returns status code
    """

    user = User.query.filter(User.email == email).first()
    if user is None:
        return {"error": "User not found with email"}, 404
    return user, 200


def get_user_by_session_token(session_token, expire_session=False):
    """
    Returns user by session token if successful, or failure message otherwise
    """
    user = User.query.filter(User.session_token == session_token).first()
    if user is None:
        return {"error": "User not found in session"}, 404

    # Create authentication object and bind to existing user
    user_auth = UserAuthentication(user)
    is_user_verified = user_auth.verify_session(session_token)

    if not is_user_verified:
        return {"error": "User verification failed"}, 400

    if expire_session:
        _expire_session(user)
    db.session.commit()

    return user, 200


def get_user_by_update_token(update_token, renew_session=False):
    """
    Returns user by update token
    """
    user = User.query.filter(User.update_token == update_token).first()
    if user is None:
        return {"error": "User is not found through update token"}, 404

    # Create authentication object and bind to existing user
    user_auth = UserAuthentication(user)
    is_user_verified = user_auth.verify_update_token(update_token)

    if not is_user_verified:
        return {"error": "User verification failed"}, 400

    # Update session and commit
    if renew_session:
        _renew_session(user)
        db.session.commit()

    return user, 200


def create_user(user):
    """
    Create a user given request data, returning a response for the calling api endpoint
    """

    # Renew session and update user state
    _renew_session(user)

    # Add user to database and commit changes
    db.session.add(user)
    db.session.commit()

    # Return serialized user
    return user, 201


def verify_credentials(body):
    """
    Verifies whether or not user in data has the correct password
    """

    # Check to whether a user with the same email exists
    user_email = body.get("email")
    existing_user, code = get_user_by_email(user_email)
    if not status_code_ok(code):
        return {"error": "User not found by email"}, 404

    user_password = body.get("password")
    if user_password is None:
        return {"error": "Missing password"}, 400
    # Create authentication object and bind to existing user
    user_auth = UserAuthentication(existing_user)
    is_user_verified = user_auth.verify_password(user_password)

    if not is_user_verified:
        return {"error": "Password is incorrect"}, 400

    return existing_user, 200
