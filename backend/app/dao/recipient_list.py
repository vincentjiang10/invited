from app import db
from app.schemas import RecipientListSchema

recipient_list_schema = RecipientListSchema()
recipient_lists_schema = RecipientListSchema(many=True)