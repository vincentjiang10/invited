from app import db

class User(db.Model):
    """
    User model (One-to-many relation to Recipient lists)
    """
    
    __tablename__ = "user"    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    first_name = db.Column(db.String, nullable=False)
    last_name = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False)

    # defining the reverse side of the relationship
    events = db.relationship("Event", cascade="delete")

    # define many-to-many relationship by connecting to association table
    recipient_lists = db.relationship("Recipient", cascade="delete")
    
    def __init__(self, **kwargs):
        """
        Initializes a Course object
        """

        self.first_name = kwargs.get("first_name", "")
        self.last_name = kwargs.get("last_name", "")
        self.email = kwargs.get("email", "")


    def serialize(self, **attr_ops):
        """
        Serializes a Course object
        """
        
        data = {}

        # get attributes
        attr_names = ["first_name", "last_name", "email"]
        for attr_name in attr_names:
            if (attr_ops.get(attr_name, True)):
                data[attr_name] = getattr(self, attr_name)

        attr_names = ["events", "recipient_lists"]
        for attr_name in attr_names:
            # serialize if not disabled
            if (attr_ops.get(attr_name, True)):
                # get attributes from User object
                data[attr_name] = [model.serialize() for model in getattr(self, attr_name)]
        
        return data
    
class Event(db.Model):
    """
    Event model (One-to-Many relation with User)
    """

    __tablename__ = "event"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)

    # has one corresponding creator_id
    creator_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    # has a few potential recipient lists
    recipient_lists = db.relationship("RecipientList")

    # has a few potential recipients
    recipients = db.relationship("User")

    def __init__(self, **kwargs):
        """
        Initializes an event object
        """

        self.name = kwargs.get("name", "")
        self.creator_id = kwargs.get("creator_id", "")
    
    def serialize(self, **attr_ops):
        """
        Serializes an event object
        """
        
        data = {}

        # Get attributes
        if (attr_ops.get("name", True)):
            data["name"] = getattr(self, "name")

        creator_id = getattr(self, "creator_id")

        # Just like SQL querying
        creator = User.query.filter_by(id = creator_id).first()
        data["creator"] = creator.serialize(events=False, recipient_lists=False)

        attr_names = ["recipients", "recipient_lists"]
        for attr_name in attr_names:
            # serialize if not disabled
            if (attr_ops.get(attr_name, True)):
                # get attributes from User object
                data[attr_name] = [model.serialize() for model in getattr(self, attr_name)]        

        return data
    
class RecipientList(db.Model):
    """
    Recipient list model (One-to-Many relation with User)
    """
    
    __tablename__ = "recipient_list"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String, nullable=False)

    # has one corresponding creator_id
    creator_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    # users in the recipient list
    users = db.relationship("User")
    
    def __init__(self, **kwargs):
        """
        Initializes an recipient list object
        """

        self.title = kwargs.get("title", "")
        self.creator_id = kwargs.get("creator_id", "")
    
    def serialize(self, **attr_ops):
        """
        Serializes a recipient list object
        """
        
        data = {}

        # Get attributes
        if (not attr_ops.get("title")):
            data["title"] = getattr(self, "title")
        
        creator_id = getattr(self, "creator_id")

        # Just like SQL querying
        creator = User.query.filter_by(id = creator_id).first()
        data["creator"] = creator.serialize(events=False, recipient_lists=False)

        
        return data