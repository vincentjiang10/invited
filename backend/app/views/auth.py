import hashlib
import os
import datetime as dt
import bcrypt


class UserAuthentication:
    def __init__(self, user):
        self.user = user

    def encrypt_password(self, user_password):
        """
        Encrypts user password
        """
        return bcrypt.hashpw(user_password.encode("utf8"), bcrypt.gensalt())
    
    def _urlsafe_base_64(self):
        """
        Generates randomly hashed tokens used (for session and update tokens)
        """
        return hashlib.sha1(os.urandom(64)).hexdigest()

    def renew_session(self):
        """
        Return new tokens and expiration dates for a new session
        """
        session_expiration_date = dt.datetime.now() + dt.timedelta(days=1)
        
        # Assign to and update self.user
        self.user.session_token = self._urlsafe_base_64()
        self.user.session_expiration = session_expiration_date
        self.user.update_token =  self._urlsafe_base_64()
        
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

    def verify_update_token(self, update_token):
        """
        Verifies update token
        """
        return self.user.update_token == update_token

#------------------------------ Other authentication logic ------------------------------#

def extract_token():
    """
    Helper function to extract token from header
    """
    
    pass
