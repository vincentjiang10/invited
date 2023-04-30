import json
from flask import Blueprint, request
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


def extract_token(request_headers):
    """
    Helper function to extract token from header
    """
    auth_header = request_headers.get("Authorization")
    if auth_header is None:
        return failure_response({"error": "Missing auth header"})
    bearer_token = auth_header.replace("Bearer", "").strip()
    if not bearer_token:
        return failure_response({"error": "Invalid auth header"}, 400)
    return success_response({"bearer_token": bearer_token})


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


@api_bp.route("/secret/", methods=["POST"])
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


@api_bp.route("/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session
    """
    token_response, code = extract_token(request.headers)
    if code != 200:
        return token_response
    # Get session token
    update_token = json.loads(token_response)["bearer_token"]

    return user_dao.get_user_by_update_token(update_token, renew_session=True)
