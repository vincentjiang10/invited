from marshmallow import fields
from marshmallow_enum import EnumField
from marshmallow_sqlalchemy import SQLAlchemyAutoSchema
from app.models import User, Event, RecipientList

class UserSchema(SQLAlchemyAutoSchema):
    """
    A Marshmallow schema that is used to validate input data and serialize/deserialize
    instances of the User SQLAlchemy model.
    """

    class Meta:
        model = User
        # Set to true so that we will not create a new instance of a model
        # when there is a matching existing one (In the case of updates)
        load_instance = True

    id = fields.Integer(dump_only=True)
    first_name = fields.String(required=True, load_only=True)
    last_name = fields.String(required=True, load_only=True)
    email = fields.String(required=True, load_only=True)
    password_digest = fields.Raw(required=True, load_only=True)
    session_token = fields.String(dump_only=True)
    session_expiration = fields.String(dump_only=True)
    update_token = fields.String(dump_only=True)


class EventSchema(SQLAlchemyAutoSchema):
    """
    A Marshmallow schema that is used to validate input data and serialize/deserialize
    instances of the Event SQLAlchemy model.
    """

    class Meta:
        model = Event
        load_instance = True

    id = fields.Integer(dump_only=True)
    name = fields.String(required=True)
    location = fields.String(required=True)
    start_time = fields.DateTime(required=True)
    end_time = fields.DateTime(required=True)
    description = fields.String(required=True)
    access = EnumField(Event.Access, required=True)


class RecipientListSchema(SQLAlchemyAutoSchema):
    """
    A Marshmallow schema that is used to validate input data and serialize/deserialize
    instances of the RecipientList SQLAlchemy model.
    """

    class Meta:
        model = RecipientList
        load_instance = True

    id = fields.Integer(dump_only=True)
    title = fields.String(required=True)
    users = fields.Nested(UserSchema, many=True)
