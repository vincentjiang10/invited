import hashlib
import os
import datetime as dt
import bcrypt


class UserAuthentication:
    def __init__(self, user):
        self.user = user

    def verify_password(self, password):
        """
        Verifies user password
        """
        return bcrypt.checkpw(self.user.password_digest, password.encode("utf8"))

    def verify_session_token(self, session_token):
        """
        Verifies session token
        """
        return self.user.session_token == session_token

    def verify_session_expiration(self, current_time):
        """
        Verifies whether or not session has expired
        """
        return self.user.session_expiration > current_time

    def verify_session(self, session_token):
        """
        Verifies session
        """
        return self.verify_session_token(
            session_token
        ) and self.verify_session_expiration(dt.datetime.now())

    def verify_update_token(self, update_token):
        """
        Verifies update token
        """
        return self.user.update_token == update_token


# ------------------------------ Other authentication logic ------------------------------#


def _urlsafe_base_64():
    """
    Generates randomly hashed tokens used (for session and update tokens)
    """
    return hashlib.sha1(os.urandom(64)).hexdigest()


def new_session_time():
    """
    Returns the new time of the user
    """
    return dt.datetime.now()


def new_session_info():
    """
    Returns new tokens and expiration dates for a new session
    """
    session_expiration_date = dt.datetime.now() + dt.timedelta(days=1)

    # Return new session user info
    return {
        "session_token": _urlsafe_base_64(),
        "session_expiration": session_expiration_date,
        "update_token": _urlsafe_base_64(),
    }


def encrypt_password(user_password):
    """
    Encrypts user password
    """
    return bcrypt.hashpw(user_password.encode("utf8"), bcrypt.gensalt())
