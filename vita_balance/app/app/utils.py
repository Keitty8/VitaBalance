from cryptography.fernet import Fernet
import os

# Clave de Fernet (usa la tuya)
KEY = os.environ.get("FERNET_KEY", "i7wYGzolpzysvvi0qWKyJpC0fOwogpd9pv6zQ-k068I=").encode()
fernet = Fernet(KEY)

def encrypt_data(value: str) -> str:
    """Encripta un valor como string y devuelve texto cifrado"""
    return fernet.encrypt(value.encode()).decode()

def decrypt_data(value: str) -> str:
    """Desencripta un valor cifrado y devuelve texto original"""
    return fernet.decrypt(value.encode()).decode()
