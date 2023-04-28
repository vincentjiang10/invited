from app import db
from app.schemas import EventSchema

event_schema = EventSchema()
events_schema = EventSchema(many=True)
