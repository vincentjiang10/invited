class Config:
    db_filename = "invites.db"

    SQLALCHEMY_DATABASE_URI = f"sqlite:///{db_filename}"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ECHO = True
    DEBUG = True
