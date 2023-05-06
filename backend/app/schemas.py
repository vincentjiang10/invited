from marshmallow import fields
from marshmallow_enum import EnumField
from marshmallow_sqlalchemy import SQLAlchemyAutoSchema
from app.models import User, Event, RecipientList, Asset


class AssetSchema(SQLAlchemyAutoSchema):
    """
    A Marshmallow schema that is used to validate input data and serialize/deserialize
    instances of the Asset SQLAlchemy model.
    """
    
    class Meta:
        model = Asset
        load_instance = True
    
    id = fields.Integer(dump_only=True)
    user_id = fields.Integer()
    base_url = fields.String()
    salt = fields.String()
    extension = fields.String()
    width = fields.String()
    height = fields.String()
    creation_date = fields.DateTime(required=True)
    
class AssetSchemas:
    """
    A few Asset schemas
    """

    _asset_exclude_list = []
    _assets_exclude_list = _asset_exclude_list
    asset_schema = AssetSchema(exclude=_asset_exclude_list)
    assets_schema = AssetSchema(
        many=True, exclude=_assets_exclude_list
    )
    
    
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
        exclude = []

    id = fields.Integer(dump_only=True)
    first_name = fields.String(required=True)
    last_name = fields.String(required=True)
    email = fields.String(required=True)
    password_digest = fields.Raw(required=True, load_only=True)
    session_token = fields.String(dump_only=True)
    session_expiration = fields.String(dump_only=True)
    update_token = fields.String(dump_only=True)
    profile_picture = fields.Nested(AssetSchema, only=["id", "base_url", "extension"])

class UserSchemas:
    """
    A few User schemas
    """

    _user_exclude_list = [
        "profile_picture"
    ]
    _users_exclude_list = _user_exclude_list
    user_schema = UserSchema(exclude=_user_exclude_list)
    users_schema = UserSchema(many=True, exclude=_users_exclude_list)

    _user_private_exclude_list = [
        "session_token",
        "session_expiration",
        "update_token",
    ]
    _users_private_exclude_list = _user_private_exclude_list
    user_private_schema = UserSchema(exclude=_user_private_exclude_list)
    users_private_schema = UserSchema(many=True, exclude=_users_private_exclude_list)

    # TODO: public info is the same as user private info for now
    _user_public_exclude_list = [
        "session_token",
        "session_expiration",
        "update_token",
    ]
    _users_public_exclude_list = _user_public_exclude_list
    user_public_schema = UserSchema(exclude=_user_private_exclude_list)
    users_public_schema = UserSchema(many=True, exclude=_users_public_exclude_list)


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

class EventSchemas:
    """
    A few Event schemas
    """

    _event_exclude_list = []
    _events_exclude_list = _event_exclude_list
    event_schema = EventSchema(exclude=_event_exclude_list)
    events_schema = EventSchema(many=True, exclude=_events_exclude_list)


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

class RecipientListSchemas:
    """
    A few Recipient List schemas
    """

    _recipient_list_exclude_list = []
    _recipient_lists_exclude_list = _recipient_list_exclude_list
    recipient_list_schema = RecipientListSchema(exclude=_recipient_list_exclude_list)
    recipient_lists_schema = RecipientListSchema(
        many=True, exclude=_recipient_lists_exclude_list
    )