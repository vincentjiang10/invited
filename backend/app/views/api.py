import json
from flask import Blueprint, jsonify, request
from app.dao import event_dao, recipient_list_dao, user_dao

api_bp = Blueprint('api', __name__, url_prefix='/api')

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

    pass

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

