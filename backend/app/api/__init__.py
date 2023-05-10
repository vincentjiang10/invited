import json


# General response and status code from requests
def success_response(data, code=200):
    """
    General success response
    """
    return json.dumps(data), code


def failure_response(message, code=400):
    """
    General failure response
    """
    return json.dumps({"error": message}), code
