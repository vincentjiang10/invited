from app import db
from app.schemas import RecipientListSchema
from app.models import RecipientList

recipient_list_schema = RecipientListSchema()
recipient_lists_schema = RecipientListSchema(many=True)