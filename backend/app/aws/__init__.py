import os

BASE_DIR = os.getcwd()
S3_BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")
S3_BASE_URL = f"https://{S3_BUCKET_NAME}.s3.us-east-1.amazonaws.com"


class AwsException(Exception):
    """
    General Dao exception raised when a dao operations fails
    """

    def __init__(self, message):
        self.message = message
