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

class EventSchema(SQLAlchemyAutoSchema):
    """
    A Marshmallow schema that is used to validate input data and serialize/deserialize
    instances of the Event SQLAlchemy model as JSON.
    """
    class Meta:
        model = Event
        load_instance = True

class RecipientListSchema(SQLAlchemyAutoSchema):
    """
    A Marshmallow schema that is used to validate input data and serialize/deserialize
    instances of the RecipientList SQLAlchemy model as JSON.
    """
    class Meta:
        model = RecipientList
        load_instance = True