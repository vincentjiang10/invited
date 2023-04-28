from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from app.config import Config
from app.views.api import api_bp

# Init db
db = SQLAlchemy()

# Init ma
ma = Marshmallow()

def create_app() -> Flask:
    """
    Creates a Flask application instance and initializes the necessary extensions.

    Returns:
        app (Flask): The Flask application instance.
    """
    app = Flask(__name__)

    # Load configuration variables
    app.config.from_object(Config)

    # Register blueprints
    app.register_blueprint(api_bp)

    # Bind to flask instance
    db.init_app(app)
    ma.init_app(app)

    with app.app_context():
        db.create_all()

    return app
