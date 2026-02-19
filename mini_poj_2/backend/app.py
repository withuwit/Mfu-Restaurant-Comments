from flask import Flask, jsonify, request
import mysql.connector

from flask_cors import CORS

app = Flask(__name__)
CORS(app)
# กำหนดค่าการเชื่อมต่อ MySQL
db_config = {
    'host': 'localhost',
    'user': 'root',  # เปลี่ยนถ้ามีรหัสผ่านหรือ user อื่น
    'password': '',  # ใส่รหัสผ่านถ้ามี
    'database': 'mini_poj'
}
def get_db_connection():
    return mysql.connector.connect(**db_config)

@app.route('/')
def home():
    return 'Backend is running!'

@app.route('/users', methods=['GET'])
def get_users():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    users = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(users)
# เพิ่ม route สำหรับ login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE username=%s AND password=%s', (username, password))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    if user:
        return jsonify({'message': f'Welcome, {username}!'}), 200
    else:
        return jsonify({'message': 'Invalid username or password.'}), 401

if __name__ == '__main__':
    app.run(debug=True)
@app.route('/')
def home():
    return 'Backend is running!'
from flask import Flask, jsonify, request
import mysql.connector

app = Flask(__name__)

# กำหนดค่าการเชื่อมต่อ MySQL
db_config = {
    'host': 'localhost',
    'user': 'root',  # เปลี่ยนถ้ามีรหัสผ่านหรือ user อื่น
    'password': '',  # ใส่รหัสผ่านถ้ามี
    'database': 'mini_poj'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

@app.route('/users', methods=['GET'])
def get_users():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT id, username FROM users')
    users = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(users)


# เพิ่ม route สำหรับ login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE username=%s AND password=%s', (username, password))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    if user:
        return jsonify({'message': f'Welcome, {username}!'}), 200
    else:
        return jsonify({'message': 'Invalid username or password.'}), 401

if __name__ == '__main__':
    app.run(debug=True)
