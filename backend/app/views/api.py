import json
from flask import Blueprint, jsonify, request
from app.views import failure_response, success_response
from app.dao import event_dao, recipient_list_dao, user_dao
from app.auth import encrypt_password

api_bp = Blueprint("api", __name__, url_prefix="/api")


@api_bp.route("/")
def hello():
    """
    Default (test) endpoint
    """

    return success_response({"message": "Hurray!!"})


@api_bp.route("/register/", methods=["POST"])
def register_account():
    """
    Endpoint for registering an account
    """

    # Load request data into python dictionary
    body = json.loads(request.data)

    # We change and transform user password to password digest because we do not want to store actual password in database
    user_password = body.get("password")
    if user_password is None:
        return failure_response({"error": "Missing or invalid password"}, 400)
    user_password_digest = encrypt_password(user_password)

    # Set password digest
    body["password_digest"] = user_password_digest

    return user_dao.create_user(body)


@api_bp.route("/login/", methods=["POST"])
def login():
    """
    Endpoint for logging a user in using username and password
    """

    body = json.loads(request.data)

    return user_dao.verify_credentials(body)


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
