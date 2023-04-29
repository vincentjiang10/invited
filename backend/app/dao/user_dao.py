import json
from marshmallow import EXCLUDE, ValidationError
from app import db
from app.schemas import UserSchema
from app.models import User
from app.auth import UserAuthentication, new_session_info

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


def create_user(data):
    """
    Create a user given request data, returning a response for the calling api endpoint
    """

    try:
        # user is of instance User
        user = user_schema.load(data, unknown=EXCLUDE)
    except ValidationError as _:
        return None

    # Renew session and update user state
    renew_session(user)

    # Add user to database and commit changes
    db.session.add(user)
    db.session.commit()

    # Return serialized user
    return user_schema.dump(user)


def get_user_by_email(email):
    """
    Returns user by email, None if user is not in database
    """

    # TODO: Finish
    return 0
