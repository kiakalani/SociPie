import re
from flask import current_app, Blueprint, request, jsonify
from werkzeug.security import generate_password_hash,\
    check_password_hash
from sqlalchemy import Column, Integer, String
class RecipeUser(current_app.config["DATABASE"]["BASE"]):
    __tablename__ = "recipe_user"
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True)
    username = Column(String, unique=True)
    name = Column(String, nullable=False)
    password = Column(String, nullable=False)

    def __init__(self, email, username, name, password):
        self.email = email
        self.username = username
        self.name = name
        self.password = password

bp = Blueprint("auth", __name__, url_prefix="/auth")

@bp.route("/signup", methods=["POST"])
def signup():
    received_data = request.get_json()
    required_keys = [
        "email", "username", "name",
        "password", "repeat_password"
    ]
    for key in required_keys:
        if key not in received_data or len(received_data[key]) < 2:
            return jsonify({
                "type": "Invalid",
                "item": key
            }), 400
    
    # validate email
    email_value = received_data["email"].lower()
    email_pattern = re.compile(r'^(?P<name>\S+)@\S+\.\S+$')
    if not email_pattern.match(email_value):
        return jsonify({
            "type": "Invalid",
            "item": "email"
        }), 400
    if RecipeUser.query.filter(
        RecipeUser.email == email_value
    ).first():
        return jsonify({
            "type": "Duplicate",
            "item": "email"
        }), 400

    # Validate username
    username_value = received_data["username"].lower()
    if RecipeUser.query.filter(
        RecipeUser.username == username_value
    ).first():
        return jsonify({
            "type": "Duplicate",
            "item": "username"
        }), 400
    
    # validate password
    if (received_data["password"] != received_data["repeat_password"]):
        return jsonify({
            "type": "Mismatch",
            "item": "password"
        }), 400
    
    # Password regex: 1 upper, 1 lower, 1 number, 1 special character, 8 characters min
    password_pattern = re.compile(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};\':"\\|,.<>/?]).{8,}$'
    )
    if (not password_pattern.match(received_data["password"])):
        return jsonify({
            "type": "Invalid",
            "item": "password"
        }), 400
    
    password_str = generate_password_hash(received_data["password"])

    user_inst = RecipeUser(
        email_value,
        username_value,
        received_data["username"],
        password_str
    )
    db_session = current_app.config["DATABASE"]["SESSION"]
    db_session.add(user_inst)
    db_session.commit()

    return jsonify({
        "type": "Success"
    }), 200
    
    
@bp.route("/signin", methods=["POST"])
def signin():
    
    received_data = request.get_json()
    required_keys = ["username", "password"]
    for key in required_keys:
        if key not in received_data:
            return jsonify({
                "type": "Invalid",
                "item": "Login"
            }), 400
    user: RecipeUser = RecipeUser.query.filter(
        RecipeUser.username == received_data["username"]
    ).first()
    if not user:
        return jsonify({
            "type": "Invalid",
            "item": "Login"
        }), 400
    if not check_password_hash(user.password, received_data["password"]):
        return jsonify({
            "type": "Invalid",
            "item": "Login"
        }), 400
    access_token = current_app.config["JWT_CREATE_TOKEN"](user.username, "access")
    refresh_token = current_app.config["JWT_CREATE_TOKEN"](user.username, "refresh")
    return jsonify({
        "type": "success",
        "token": {
            "access": access_token,
            "refresh": refresh_token
        }
    })

@bp.route("/refresh", methods=["POST"])
def refresh():
    refresh_token = request.headers.get("Authorization")
    if not refresh_token:
        return jsonify({
            "type": "Invalid",
            "item": "Login"
        }), 400
    username = current_app.config["JWT_PARSE_TOKEN"](refresh_token)
    if username is None:
        return jsonify({
            "type": "Invalid",
            "item": "Login"
        }), 400
    access_token = current_app.config["JWT_CREATE_TOKEN"](username["username"], "access")
    return jsonify({
        "type": "success",
        "token": access_token
    }), 200

@bp.route("testlogin", methods=["POST"])
def testlogin():
    token = request.headers.get("Authorization")
    username = current_app.config["JWT_PARSE_TOKEN"](token)
    if username is None or username["token_type"] != "access":
        return jsonify({
            "type": "Invalid",
            "item": "login"
        }), 400
    
    user = RecipeUser.query.filter(RecipeUser.username == username["username"]).first()
    if not user:
        return jsonify({
            "type": "Invalid",
            "item": "login"
        }), 400
    
    return jsonify({
        "type": "Success",
        "name": user.name,
        "email": user.email
    }), 200