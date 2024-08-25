from flask import Flask, request, jsonify
from flask_jwt_extended import JWTManager
from sqlalchemy import create_engine, Engine
from sqlalchemy.orm import scoped_session, sessionmaker,\
declarative_base, DeclarativeBase, session

app = Flask(__name__)

# JWT Creation for authentication
app.config["JWT_SECRET_KEY"] = 'Temporary_Secret_Key'
app.config["JWT"] = JWTManager(app)

# DB creation
__db  = create_engine("sqlite:///test.db")
app.config["DATABASE"] = {
    "ENGINE": __db,
    "SESSION": scoped_session(sessionmaker(autoflush=False, bind=__db)),
    "BASE": declarative_base()
}
app.config["DATABASE"]["BASE"].query = app.config["DATABASE"]["SESSION"].query_property()

# Upon closing, close the database
@app.teardown_appcontext
def teardown(exception=None):
    app.config["DATABASE"]["SESSION"].remove()


with app.app_context():
    # Import and register all blueprints here
    import auth
    app.register_blueprint(auth.bp)
    # Setup the database models
    app.config["DATABASE"]["BASE"].metadata.create_all(
        bind=app.config["DATABASE"]["ENGINE"]
    )




if __name__ == "__main__":
    app.run()
