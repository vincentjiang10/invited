from marshmallow import fields
from marshmallow_sqlalchemy import SQLAlchemyAutoSchema
from app.models import User, Event, RecipientList


class UserSchema(SQLAlchemyAutoSchema):
    """
    A Marshmallow schema that is used to validate input data and serialize/deserialize
    instances of the User SQLAlchemy model as JSON.
    """

    class Meta:
        model = User
        # Set to true so that we will not create a new instance of a model when there is a matching existing one
        # (In the case of updates)
        load_instance = True

    id = fields.Integer(dump_only=True)
    first_name = fields.String(required=True)
    last_name = fields.String(required=True)
    email = fields.String(required=True)
    password_digest = fields.String(required=True)
    session_token = fields.String(dump_only=True)
    session_expiration = fields.String(dump_only=True)
    update_token = fields.String(dump_only=True)


class EventSchema(SQLAlchemyAutoSchema):
    """
    A Marshmallow schema that is used to validate input data and serialize/deserialize
    instances of the Event SQLAlchemy model as JSON.
    """

    class Meta:
        model = Event
        load_instance = True

    id = fields.Integer(dump_only=True)
    name = fields.String(required=True)
    creator_id = fields.Integer(required=True)
    # TODO: Add other columns


class RecipientListSchema(SQLAlchemyAutoSchema):
    """
    A Marshmallow schema that is used to validate input data and serialize/deserialize
    instances of the RecipientList SQLAlchemy model as JSON.
    """

    class Meta:
        model = RecipientList
        load_instance = True

    id = fields.Integer(dump_only=True)
    title = fields.String(required=True)
    creator_id = fields.String(required=True)
    users = fields.Nested(UserSchema, many=True)
