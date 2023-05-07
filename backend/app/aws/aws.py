import boto3
import os
from . import S3_BUCKET_NAME, BASE_DIR, AwsException


def upload_image(image, image_filename):
    """
    Uploads image to aws
    """

    try:
        # Save image locally onto server
        image_temporary_location = f"{BASE_DIR}/{image_filename}"
        image.save(image_temporary_location)

        # Upload image into aws
        s3_client = boto3.client("s3")
        s3_client.upload_file(image_temporary_location, S3_BUCKET_NAME, image_filename)

        # Make image url public
        s3_resource = boto3.resource("s3")
        object_acl = s3_resource.ObjectAcl(S3_BUCKET_NAME, image_filename)
        object_acl.put(ACL="public-read")

        # Remove local image
        os.remove(image_temporary_location)

    except Exception as exc:
        raise AwsException(f"Error while uploading image: {exc}") from exc
