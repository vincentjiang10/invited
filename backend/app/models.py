from enum import Enum
from app import db


# TODO: Divide user fields into private, public, and internal (hidden from all clients)


# -------------------------- Associations --------------------------#
class UserRecipientList(db.Model):
    """
    Represents many-to-many relationship between user and recipient lists
    """

    __tablename__ = "user_recipient_list"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
    recipient_list_id = db.Column(
        "recipient_list_id", db.Integer, db.ForeignKey("recipient_list.id")
    )
    role = db.Column(db.String)

    user = db.relationship("User", back_populates="recipient_list_association")
    recipient_list = db.relationship("RecipientList", back_populates="user_association")


class UserEvent(db.Model):
    """
    Represents many-to-many relationship between user and event
    """

    class Role(Enum):
        CREATOR = "CREATOR"
        RECIPIENT = "RECIPIENT"

    __tablename__ = "user_event"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
    event_id = db.Column("event_id", db.Integer, db.ForeignKey("event.id"))
    role = db.Column(db.Enum(Role))

    user = db.relationship("User", back_populates="event_association")
    event = db.relationship("Event", back_populates="user_association")


# ----------------------------- Models -----------------------------#
class User(db.Model):
    """
    User model (One-to-many relation to Recipient lists)
    """

    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # User information
    first_name = db.Column(db.String, nullable=False)
    last_name = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False)
    password_digest = db.Column(db.LargeBinary, nullable=False)

    # Session information
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    # Define many-to-many relationships
    event_association = db.relationship("UserEvent", back_populates="user")
    recipient_list_association = db.relationship(
        "UserRecipientList", back_populates="user"
    )

    # Define 1-to-1 relation with asset
    profile_picture = db.relationship("Asset", backref="user", uselist=False)


class Event(db.Model):
    """
    Event model (One-to-Many relation with User)
    """

    class Access(Enum):
        PUBLIC = "PUBLIC"
        PRIVATE = "PRIVATE"

    __tablename__ = "event"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    start_time = db.Column(db.DateTime, nullable=False)
    end_time = db.Column(db.DateTime, nullable=False)
    location = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    access = db.Column(db.Enum(Access), nullable=False)

    user_association = db.relationship("UserEvent", back_populates="event")


class RecipientList(db.Model):
    """
    Recipient list model (One-to-Many relation with User)
    """

    __tablename__ = "recipient_list"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String, nullable=False)

    # Has one corresponding creator_id
    creator_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    # Users in the recipient list
    user_association = db.relationship(
        "UserRecipientList", back_populates="recipient_list"
    )


# TODO: Community model? Implement events in a community, which can be assessed and seen by only users within that community? Can be public or more specific


class Asset(db.Model):
    """
    Asset model (for images)
    """

    __tablename__ = "asset"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"))
    base_url = db.Column(db.String, nullable=False)
    salt = db.Column(db.String, nullable=False)
    extension = db.Column(db.String, nullable=False)
    width = db.Column(db.Integer, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    creation_date = db.Column(db.DateTime, nullable=False)
