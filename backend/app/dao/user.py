from app import db
from app.schemas import UserSchema

user_schema = UserSchema()
users_schema = UserSchema(many=True)

