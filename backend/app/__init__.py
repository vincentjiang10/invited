from flask import Flask
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    # Set configuration variables
    db_filename = "invites.db"

    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["SQLALCHEMY_ECHO"] = True

    # Register blueprints
    from .views.api import api_bp
    app.register_blueprint(api_bp)

    db.init_app(app)

    with app.app_context():
        db.create_all()

    return app
