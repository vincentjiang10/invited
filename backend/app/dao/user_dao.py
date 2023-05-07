from marshmallow import EXCLUDE, ValidationError
from app import db
from app.models import User
from app.dao import DaoException
from app.auth import (
    UserAuthentication,
    new_session_info,
    new_session_time,
    encrypt_password,
)
from app.schemas import UserSchemas, AssetSchemas
from app.aws.image import store_image_data

# Initialize schema objects
user_schema = UserSchemas.user_schema
asset_schema = AssetSchemas.asset_schema


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
        raise DaoException("User not found with id", 404)
    return user


def get_user_by_email(user_email):
    """
    Returns user by email if user exists, otherwise returns error message. Also returns status code
    """

    user = User.query.filter(User.email == user_email).first()
    if user is None:
        raise DaoException("User not found with email", 404)
    return user


def get_user_by_session_token(session_token, expire_session=False):
    """
    Returns user by session token if successful, or failure message otherwise
    """
    user = User.query.filter(User.session_token == session_token).first()
    if user is None:
        raise DaoException("User not found in session", 404)

    # Create authentication object and bind to existing user
    user_auth = UserAuthentication(user)
    is_user_verified = user_auth.verify_session(session_token)

    if not is_user_verified:
        raise DaoException("User verification failed")

    if expire_session:
        _expire_session(user)
    db.session.commit()

    return user


def get_user_by_update_token(update_token, renew_session=False):
    """
    Returns user by update token
    """
    user = User.query.filter(User.update_token == update_token).first()
    if user is None:
        raise DaoException("User is not found", 404)

    # Create authentication object and bind to existing user
    user_auth = UserAuthentication(user)
    is_user_verified = user_auth.verify_update_token(update_token)

    if not is_user_verified:
        raise DaoException("User verification failed")

    # Update session and commit
    if renew_session:
        _renew_session(user)
        db.session.commit()

    return user


def create_user(body):
    """
    Create a user given body request data, returning a response for the calling api endpoint
    """
    # We change and transform user password to password digest because we do not want to store actual password in database
    user_password = body.get("password")
    if user_password is None:
        raise DaoException("Missing or invalid password")
    user_password_digest = encrypt_password(user_password)

    # Set password digest
    body["password_digest"] = user_password_digest

    # Check to see whether user with the same email already exists
    user_email = body.get("email")
    if user_email is None:
        raise DaoException("Missing email")

    does_user_exist = True
    try:
        _ = get_user_by_email(user_email)
    except DaoException:
        does_user_exist = False

    if does_user_exist:
        raise DaoException("User already exists")

    try:
        # user is of instance User
        user = user_schema.load(body, unknown=EXCLUDE, session=db.session)
    except ValidationError as exc:
        raise DaoException(str(exc)) from exc

    # Renew session and update user state
    _renew_session(user)

    # Add user to database and commit changes
    db.session.add(user)
    db.session.commit()

    # Return serialized user
    return user


def get_all_users():
    """
    Get all users
    """
    users = User.query.all()

    return users


# TODO: Think about the case of passwords and emails and whether more logic is required for editing these fields
def update_user_profile_by_session(session_token, body):
    """
    Updates the current user profile information
    """

    try:
        user = get_user_by_session_token(session_token)

        # Image upload logic
        image_data = body.get("profile_picture")
        if image_data is not None:
            # TODO: Take into account the case of image update
            # Check whether user currently has an image (If yes, then remove that image at the end, if everything else is a success)
            current_profile_image = user.profile_picture

            # Create new image through the store_image_data() method in aws.image
            new_image_body = store_image_data(image_data)

            print("\033[91m{}\033[00m".format(new_image_body))

            new_image = asset_schema.load(
                new_image_body, unknown=EXCLUDE, partial=True, session=db.session
            )

            # Overwrite public_profile of current user with new image
            user.profile_picture = new_image

            # Add new image to database
            db.session.add(new_image)

            # Delete original profile image
            if current_profile_image is not None:
                db.session.delete(current_profile_image)

        # TODO: prevent update of some fields! (session_token, etc)
        updated_user = user_schema.load(
            body, unknown=EXCLUDE, instance=user, partial=True, session=db.session
        )
    except ValidationError as exc:
        raise DaoException(str(exc)) from exc

    db.session.commit()

    return updated_user


def verify_credentials(body):
    """
    Verifies whether or not user in data has the correct password
    """

    # Check to whether a user with the same email exists
    user_email = body.get("email")
    if user_email is None:
        raise DaoException("Missing email")
    existing_user = get_user_by_email(user_email)

    user_password = body.get("password")
    if user_password is None:
        raise DaoException("Missing password")
    # Create authentication object and bind to existing user
    user_auth = UserAuthentication(existing_user)
    is_user_verified = user_auth.verify_password(user_password)

    if not is_user_verified:
        raise DaoException("Password is incorrect")

    return existing_user
