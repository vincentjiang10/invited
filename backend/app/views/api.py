import json
from flask import Blueprint, jsonify, request
from app.dao import event_dao, recipient_list_dao, user_dao
from app.auth import encrypt_password

api_bp = Blueprint("api", __name__, url_prefix="/api")


def success_response(data, code=200):
    """
    General success response
    """
    return json.dumps(data), code


def failure_response(message, code=404):
    """
    General failure response
    """
    return json.dumps({"error": message}), code


@api_bp.route("/register/", methods=["POST"])
def register_account():
    """
    Endpoint for registering an account
    """

    # Load request data into python dictionary
    data = json.loads(request.data)

    # Check to see whether duplicate email exists
    user_email = data.get("email")
    existing_user = user_dao.get_user_by_email(user_email)
    if existing_user is not None:
        return failure_response({"error": "User already exists"}, 400)

    # We change and transform user password to password digest because we do not want to store actual password in database
    user_password = data.get("password")
    if user_password is None:
        return failure_response({"error": "Missing or invalid password"}, 400)
    user_password_digest = encrypt_password(user_password)

    # Set password digest
    data["password_digest"] = user_password_digest

    serialized_user = user_dao.create_user(data)
    if serialized_user is None:
        return failure_response({"error": "Database access error"}, 400)

    return success_response(serialized_user)


@api_bp.route("/login/", methods=["POST"])
def login():
    """
    Endpoint for logging a user in using username and password
    """

    pass


@api_bp.route("/logout/", methods=["POST"])
def logout():
    """
    Endpoint for logging a user out using username and password
    """

    pass


@api_bp.route("/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session
    """

    pass
