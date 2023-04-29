from app.schemas import EventSchema
from app.models import Event
from app import db

event_schema = EventSchema()
events_schema = EventSchema(many=True)
