from flask import Blueprint, jsonify, request

api_bp = Blueprint('api', __name__, url_prefix='/api')

@api_bp.route('/')
def test_route():
    return "test", 200