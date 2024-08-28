from datetime import datetime, timedelta
from flask import Flask, request, jsonify
import jwt
from sqlalchemy import create_engine, Engine
from sqlalchemy.orm import scoped_session, sessionmaker,\
declarative_base, DeclarativeBase, session
import secrets
app = Flask(__name__)

# JWT Creation for authentication
app.config["SECRET_KEY"] = secrets.token_hex(32)
app.config["JWT_SECRET_KEY"] = secrets.token_hex(32)
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(minutes=15)
app.config["JWT_REFRESH_TOKEN_EXPIRES"] = timedelta(days=30)
def __create_token(user_id, token_type="access"):
    payload = {
        "user_id": user_id,
        "exp": datetime.datetime.now(datetime.UTC) + app.config["JWT_ACCESS_TOKEN_EXPIRES" if token_type == "access" else "JWT_REFRESH_TOKEN_EXPIRES"],
        "iat": datetime.datetime.now(datetime.UTC),
        "token_type": token_type
    }
    return jwt.encode(payload, app.config["JWT_SECRET_KEY"], algorithm="HS256")
def __parse_token(token):
    try:
        data = jwt.decode(token, app.config["JWT_SECRET_KEY"], algorithms=["HS256"])
        if data["token_type"] != "access" and data["token_type"] != "refresh":
            return None
        return {"username": data["user_id"], "token_type": data["token_type"]}
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None

    
app.config["JWT_CREATE_TOKEN"] = __create_token
app.config["JWT_PARSE_TOKEN"] = __parse_token

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
