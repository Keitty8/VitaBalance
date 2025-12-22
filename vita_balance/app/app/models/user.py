from app import db
from flask_login import UserMixin
from app.utils import encrypt_data, decrypt_data

class User(UserMixin, db.Model):
    __tablename__ = 'users'
    __table_args__ = {'schema': 'usuarios'}

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(512), nullable=False)
    role = db.Column(db.String(20), default='usuario')
    #genero = db.Column(db.String(10), nullable=True)
    objetivo = db.Column(db.String(50), nullable=True)
    #peso = db.Column(db.Integer)
    #altura = db.Column(db.Integer)
    # Campos encriptados
    _peso = db.Column("peso", db.String(256))
    _altura = db.Column("altura", db.String(256))
    _genero = db.Column("genero", db.String(256))
    _actividad = db.Column("actividad", db.String(256))

    #actividad = db.Column(db.String(20))

    # Getter y Setter para peso
    @property
    def peso(self):
        if self._peso:
            try:
                return int(decrypt_data(self._peso))
            except Exception:
                return None
        return None

    @peso.setter
    def peso(self, value):
        if value is not None:
            self._peso = encrypt_data(str(value))
        else:
            self._peso = None

    # Getter y Setter para altura
    @property
    def altura(self):
        if self._altura:
            try:
                return int(decrypt_data(self._altura))
            except Exception:
                return None
        return None

    @altura.setter
    def altura(self, value):
        if value is not None:
            self._altura = encrypt_data(str(value))
        else:
            self._altura = None

    # Getter y Setter para genero
    @property
    def genero(self):
        if self._genero:
            try:
                return decrypt_data(self._genero)
            except Exception:
                return None
        return None

    @genero.setter
    def genero(self, value):
        if value:
            self._genero = encrypt_data(value)
        else:
            self._genero = None

    # Getter y Setter para actividad
    @property
    def actividad(self):
        if self._actividad:
            try:
                return decrypt_data(self._actividad)
            except Exception:
                return None
        return None

    @actividad.setter
    def actividad(self, value):
        if value:
            self._actividad = encrypt_data(value)
        else:
            self._actividad = None

    def __repr__(self):
        return f'<User {self.username}>'
