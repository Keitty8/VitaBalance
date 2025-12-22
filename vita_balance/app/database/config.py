import os
from cryptography.fernet import Fernet
from dotenv import load_dotenv

load_dotenv()  # Carga las variables del archivo .env

class Config:
    SECRET_KEY = 'clave_super_secreta'
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:espoch1234@localhost:5433/vitabalance1?client_encoding=utf8&options=-csearch_path=usuarios,planes,talleres,auditoria,public'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    FERNET_KEY = os.getenv('FERNET_KEY')  # clave para encriptar datos
