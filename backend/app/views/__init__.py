import json


def success_response(data, code=200):
    """
    General success response
    """
    return json.dumps(data), code


def failure_response(data, code=404):
    """
    General failure response
    """
    return json.dumps(data), code
