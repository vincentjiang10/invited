import json


def status_code_ok(code):
    return code >= 200 and code < 300


# General response and status code from requests
def success_response(data, code=200):
    """
    General success response
    """
    return json.dumps(data), code


def failure_response(data, code=400):
    """
    General failure response
    """
    return json.dumps(data), code
