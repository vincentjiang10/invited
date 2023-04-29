from app import db

# TODO: Add friendship association + feature


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
    events = db.relationship("Event", cascade="delete")

    # Define many-to-many relationship by connecting to association table
    recipient_lists = db.relationship("RecipientList", cascade="delete")

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

    # Has one corresponding creator_id
    creator_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    # Has a few potential recipients
    recipients = db.relationship("User")

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
    users = db.relationship("User")

    def __init__(self, **kwargs):
        """
        Initializes an recipient list object
        """

        self.title = kwargs.get("title")
        self.creator_id = kwargs.get("creator_id")
