import base64
import io
from io import BytesIO
from mimetypes import guess_extension, guess_type
from datetime import datetime as dt
from PIL import Image
import random
import re
import string
from . import S3_BASE_URL, aws

EXTENSIONS = ["png", "gif", "jpg", "jpeg"]

def store_image_data(image_data):
    """
    Given image data in base64 form, does the following:
    1. Rejects if unsupported file type
    2. Generates random name for the image
    3. Attempts to decode and upload image data to AWS
    Returns dictionary to be used to add an image entry to database
    """
    try:
        extension = guess_extension(guess_type(image_data)[0])[1:]
        
        # Only accept supported extensions
        if extension not in EXTENSIONS:
            raise Exception(f"Extension {extension} is not supported")
        
        # Random string name
        salt = "".join(random.SystemRandom().choice(string.ascii_uppercase + string.ascii_lowercase + string.digits) for _ in range(32))
    
        # Remove base64 header to extract data
        image_string = re.sub("^data:image/.+;base64,", "", image_data)
        image_data = base64.b64decode(image_string)
        image = Image(BytesIO(image_data))
        image_filename = f"{salt}.{extension}"
        
        # Upload to aws
        aws.upload_image(image, image_filename)
        
        # Return image data to be stored in database
        return {
            "base_url": S3_BASE_URL,
            "salt": salt,
            "extension": extension,
            "width": image.width, 
            "height": image.height,
            "creation_date": dt.now()
        }
    except Exception as exc:
        print(f"Error while creating image: {exc}")
        