from app import db


# -------------------------- Associations --------------------------#
# Association objects
class Friendship(db.Model):
    """
    Represents many-to-many friendship relationship between users
    """

    __tablename__ = "friendship"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id_1 = db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
    user_id_2 = db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
    status = db.Column(db.String)

    # TODO: Add back_populates columns


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

    user = db.relationship("User", back_populates="recipient_lists")
    recipient_list = db.relationship("Recipient_List", back_populates="users")


class UserEvent(db.Model):
    """
    Represents many-to-many relationship between user and event
    """

    __tablename__ = "user_event"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
    event_id = db.Column("event_id", db.Integer, db.ForeignKey("event.id"))
    role = db.Column(db.String)

    user = db.relationship("User", back_populates="events")
    event = db.relationship("Event", back_populates="users")


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
    password_digest = db.Column(db.String, nullable=False)

    # Session information
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    # Defining the reverse side of the relationship
    events = db.relationship("UserEvent", back_populates="user")

    # Define many-to-many relationship by connecting to association table
    recipient_lists = db.relationship("UserRecipientList", back_populates="user")

    def __init__(self, **kwargs):
        """
        Initializes a Course object
        """

        self.first_name = kwargs.get("first_name")
        self.last_name = kwargs.get("last_name")
        self.email = kwargs.get("email")
        self.password_digest = kwargs.get("password_digest")


class Event(db.Model):
    """
    Event model (One-to-Many relation with User)
    """

    __tablename__ = "event"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    users = db.relationship("UserEvent", back_populates="event")

    def __init__(self, **kwargs):
        """
        Initializes an event object
        """

        self.name = kwargs.get("name")
        self.creator_id = kwargs.get("creator_id")


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
    users = db.relationship("UserRecipientList", back_populates="recipient_list")

    def __init__(self, **kwargs):
        """
        Initializes an recipient list object
        """

        self.title = kwargs.get("title")
        self.creator_id = kwargs.get("creator_id")
