from app import db
from datetime import datetime

# Tablas intermedias
inscripciones = db.Table('inscripciones',
    db.Column('user_id', db.Integer, db.ForeignKey('usuarios.users.id'), primary_key=True),
    db.Column('taller_id', db.Integer, db.ForeignKey('talleres.talleres.id'), primary_key=True),
    db.Column('fecha_inscripcion', db.DateTime, default=datetime.utcnow)
)

# Tabla intermedia para progreso de contenido
progreso_contenido = db.Table(
    'progreso_contenido',
    db.Column('user_id', db.Integer, db.ForeignKey('usuarios.users.id', ondelete='CASCADE'), primary_key=True),
    db.Column('contenido_id', db.Integer, db.ForeignKey('talleres.contenido_taller.id', ondelete='CASCADE'), primary_key=True),
    schema='talleres'
)

# Modelo de contenido de taller
class ContenidoTaller(db.Model):
    __tablename__ = 'contenido_taller'
    __table_args__ = {'schema': 'talleres'} 
    
    id = db.Column(db.Integer, primary_key=True)
    taller_id = db.Column(db.Integer, db.ForeignKey('talleres.talleres.id'), nullable=False)
    #taller_id = db.Column(db.Integer, db.ForeignKey('talleres.id'), nullable=False)
    titulo = db.Column(db.String(200), nullable=False)
    descripcion = db.Column(db.Text, nullable=True)
    tipo_contenido = db.Column(db.String(50), nullable=False)  
    dia_programa = db.Column(db.Integer, nullable=True)  
    url_contenido = db.Column(db.String(500), nullable=True)  
    duracion_minutos = db.Column(db.Integer, nullable=True) 
    orden = db.Column(db.Integer, default=0)  
    es_obligatorio = db.Column(db.Boolean, default=False)
    fecha_disponible = db.Column(db.DateTime, default=datetime.utcnow)
    
    taller = db.relationship('Taller', backref='contenidos')
    
    usuarios_completaron = db.relationship('User', secondary=progreso_contenido, backref='contenidos_completados')
    
    def __repr__(self):
        return f'<ContenidoTaller {self.titulo}>'
    
    def esta_completado_por(self, user):
        """Verifica si un usuario ha completado este contenido"""
        return user in self.usuarios_completaron
    
    def marcar_completado(self, user):
        """Marca el contenido como completado por un usuario"""
        if not self.esta_completado_por(user):
            self.usuarios_completaron.append(user)
            db.session.commit()

# Modelo de taller
class Taller(db.Model):
    __tablename__ = 'talleres'
    __table_args__ = {'schema': 'talleres'} 

    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    descripcion = db.Column(db.Text, nullable=True)
    dias_semana = db.Column(db.String(100), nullable=False)
    fecha = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    cupos = db.Column(db.Integer, nullable=False)
    objetivo = db.Column(db.String(50), nullable=False)
    nivel_actividad = db.Column(db.String(20), nullable=True)
    horario = db.Column(db.String(50), nullable=False, default="09:00")  # <-- nuevo campo con default

    participantes = db.relationship('User', secondary=inscripciones, backref='talleres_inscritos')

    def __repr__(self):
        return f'<Taller {self.nombre}>'
    
    @property
    def cupos_disponibles(self):
        """Retorna los cupos disponibles del taller"""
        return self.cupos - len(self.participantes)
    
    @property
    def esta_lleno(self):
        """Verifica si el taller está lleno"""
        return len(self.participantes) >= self.cupos
    
    @property
    def esta_vigente(self):
        """Verifica si el taller aún no ha pasado"""
        return self.fecha > datetime.now()
    
    @property
    def ha_finalizado(self):
        """Verifica si el taller ya finalizó"""
        return self.fecha <= datetime.utcnow()
    
    @property
    def dias_restantes(self):
        """Calcula los días restantes hasta el taller"""
        if self.fecha > datetime.utcnow():
            delta = self.fecha - datetime.utcnow()
            return delta.days
        return 0
    
    def puede_inscribirse(self, user):
        """Verifica si un usuario puede inscribirse al taller"""
        return (not self.esta_lleno and 
                user not in self.participantes and 
                self.esta_vigente)
    
    def get_progreso(self, user):
        """Obtiene el progreso del usuario en el taller"""
        if user not in self.participantes:
            return 0
        
        contenidos_totales = len(self.contenidos)
        if contenidos_totales == 0:
            return 0
        
        contenidos_completados = sum(
            1 for contenido in self.contenidos if contenido.esta_completado_por(user)
        )
        
        try:
            progreso = int((contenidos_completados / contenidos_totales) * 100)
        except Exception:
            progreso = 0
        
        return progreso
    
    def get_contenidos_por_dia(self):
        """Obtiene los contenidos organizados por día"""
        rutinas_diarias = {}
        otros_contenidos = []
        
        for contenido in sorted(self.contenidos, key=lambda x: x.orden):
            if contenido.tipo_contenido == 'rutina' and contenido.dia_programa:
                if contenido.dia_programa not in rutinas_diarias:
                    rutinas_diarias[contenido.dia_programa] = []
                rutinas_diarias[contenido.dia_programa].append(contenido)
            else:
                otros_contenidos.append(contenido)
        
        return rutinas_diarias, otros_contenidos
    
    def get_siguiente_contenido(self, user):
        """Obtiene el siguiente contenido que el usuario debe completar"""
        for contenido in sorted(self.contenidos, key=lambda x: x.orden):
            if not contenido.esta_completado_por(user):
                return contenido
        return None
    
    # Ejemplo de método robusto si se quiere usar peso/altura del usuario
    def generar_rutina_para_usuario(self, user):
        """Genera rutina usando peso y altura, evitando None"""
        try:
            peso = user.peso or 70
            altura = user.altura or 170
            actividad = user.actividad or 'moderada'
            # Aquí iría la lógica de generación de rutina usando peso, altura y actividad
            return f"Rutina generada para {user.username} con peso {peso}kg y altura {altura}cm"
        except Exception as e:
            print(f"Error generando rutina para {user.username}: {e}")
            return None
