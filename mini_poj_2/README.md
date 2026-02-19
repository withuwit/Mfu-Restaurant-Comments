# Mini Project Full Stack Structure

## โครงสร้างไฟล์

- frontend/
  - public/
    - index.html
    - style.css
  - src/
    - main.js
  - package.json
- backend/
  - app.py
  - requirements.txt
- database/
  - schema.sql
  - seed.sql

## โปรแกรมที่ควรติดตั้ง

### Frontend
- Node.js (แนะนำเวอร์ชัน LTS)
- npm (มากับ Node.js)

### Backend
- Python 3.10+ (แนะนำ 3.13 ตามที่คุณมี)
- pip (มากับ Python)
- Flask (ติดตั้งด้วย pip)

### Database
- XAMPP (MySQL/MariaDB) หรือใช้ SQLite (ง่ายสุด)
- หากใช้ XAMPP ให้เปิด MySQL ผ่าน XAMPP Control Panel

## วิธีเริ่มต้น

1. ติดตั้งโปรแกรมตามด้านบน
2. สร้าง virtual environment (Python):
   ```sh
   python -m venv venv
   venv\Scripts\activate
   pip install -r backend/requirements.txt
   ```
3. รัน backend:
   ```sh
   python backend/app.py
   ```
4. เปิด frontend/public/index.html ในเบราว์เซอร์
5. จัดการฐานข้อมูลผ่าน XAMPP หรือ SQLite ตามที่เลือก

---

**หมายเหตุ:**
- หากต้องการเชื่อมต่อ Python กับ MySQL ให้ติดตั้งไลบรารี `mysql-connector-python` หรือ `pymysql`
- หากใช้ SQLite ไม่ต้องติดตั้งอะไรเพิ่มใน Python
