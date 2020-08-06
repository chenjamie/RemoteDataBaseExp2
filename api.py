#Author: Jamie Chen

from flask import Flask
from flask import request
from flask_sqlalchemy import SQLAlchemy
from flask import jsonify
from requests import Response
from datetime import datetime
import json 

HOST_IP = ''

app = Flask(__name__)

app.config["DEBUG"] = True

#set up for PostgreSQL connection

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://username:password@hostname/database_name'

db = SQLAlchemy(app)

#models

class User(db.Model):
	__tablename__ = 'users'
	email = db.Column('email',db.String(30), primary_key=True) #required
	password = db.Column('password', db.String(30)) #required
	name = db.Column('name', db.String(30)) #required
	birthday = db.Column('birthday', db.Date)
	salary = db.Column('salary', db.Float)
	is_admin = db.Column('is_admin', db.Boolean)
	login_num = db.Column('login_num', db.Integer)
	timestamp = db.Column('timestamp', db.DateTime)
	
@app.route('/hello')
def home():
    return 'Hello'

@app.route('/register', methods=["GET"])
def register():
	print('register')
	# get info from link
	email_ = request.args.get("email", default="", type=str)
	password_ = request.args.get("password", default="", type=str)
	name_ = request.args.get("name", default="", type=str)
	if name_ is "" or password_ is "" or email_ is "":
		return "Make sure values of name, email, and password are valid"
	
	salary_ = request.args.get("salary", default=0.00, type=float)
	
	day = request.args.get("day", default=0, type=int)
	month = request.args.get("month", default=0, type=int)
	year = request.args.get("year", default=0, type=int)
	birthday_ = None
	current_time = datetime.utcnow()   
	print(current_time)
	if year != 0:
		birthday_ = datetime(year, month, day)
	
	
	print(email_ +" "+ password_ + name_)
	try: # add new user
		user = User(email=email_, password=password_, name = name_, login_num = 0, salary = salary_, birthday = birthday_, is_admin = False, timestamp = current_time)
		db.session.add(user)
		db.session.commit()
		return "Register Success"
	except Exception as e:
		print(e)
		return "Error with server, unable to register, try using another email"
		
@app.route('/login', methods=["GET"])
def login():
	print('login')
	email_ = request.args.get("email", default="", type=str)
	password_ = request.args.get("password", default="", type=str)
	print(email_ +" "+ password_)
	try:

		user = User.query.filter_by(email=email_)
		for u in user:
			print(password_ +" submitted")
			print(u.password + " actual")
			if u.password == password_:	
				print(u.timestamp)

				birthday_ = u.birthday
				birthday_str = "None"
				if u.birthday is not None:
					birthday_str  = str(birthday_.year) + "-" + str(birthday_.month) + "-" + str(birthday_.day)
				name_ = "None"
				if u.name is not None or len(u.name) is not	0:
					name_ = u.name
				print('|' + name_ + '|')
				is_admin_ = u.is_admin
				timestamp_ = datetime.utcnow()
				num = u.login_num
				u.login_num = num + 1
				db.session.commit()
				u.timestamp = timestamp_ # incrment login_num and update timestamp
				print(u.timestamp)
				db.session.commit()
				r = jsonify(email = u.email, password = u.password, name = name_, is_admin = u.is_admin, birthday = birthday_str, salary = u.salary, login_num = u.login_num, timestamp = u.timestamp)
				return r
			else:
				return "Login Failed"

	except Exception as e:
		print(e)
		return "Error with server"

@app.route('/getList', methods=["GET"])
def getList():
	users = User.query.all()
	cols = ['name', 'email', 'password', 'salary', 'birthday', 'timestamp', 'is_admin', 'login_num']
	users = [{col: getattr(u, col) for col in cols} for u in users]
	print(users)
	return jsonify(users)

	
@app.route('/changeValue', methods=["GET"])
def changeValue():
	user_email =  request.args.get("email", default="", type=str)	
	field = request.args.get("field", default="", type=str)
	current_time = datetime.utcnow()   
	var = ""
	day = 0
	month = 0
	year = 0
	try:
		user = User.query.filter_by(email = user_email).first()

		if field == "salary":
			value = request.args.get("value", default="", type=float)
			user.salary = value;
		elif  field == "birthday":
			day = request.args.get("day", default="", type=int)
			month = request.args.get("month", default="", type=int)
			year = request.args.get("year", default="", type=int)
			user.birthday = datetime(year, month, day)
		elif  field == "name":
			value = request.args.get("value", default="", type=str)
			user.name = value
		elif  field == "password":
			value = request.args.get("value", default="", type=str)
			user.password = value
		elif  field == "email":
			new_email = request.args.get("value", default="", type=str)
			user.email = new_email
		elif field == "admin":
			is_admin = user.is_admin
			user.is_admin = not is_admin

		user.timestamp = current_time
		db.session.commit()
		return "Success"
	except Exception as e:
		print(e)
		return "Error with server, please make sure inputs are valid"

if __name__ == '__main__':
    app.run(host = HOST_IP)
