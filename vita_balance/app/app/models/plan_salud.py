from app import db
from flask_login import current_user

class PlanSalud(db.Model):
    __tablename__ = 'planes_salud'
    __table_args__ = {'schema': 'planes'}

    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    descripcion = db.Column(db.Text)
    tipo = db.Column(db.String(50))
    calorias = db.Column(db.Integer)
    proteinas = db.Column(db.Integer)
    rutina = db.Column(db.Text)
    imagen = db.Column(db.String(255), nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('usuarios.users.id'))
    
    
    user = db.relationship('User', backref='planes_salud')

    __mapper_args__ = {
        'polymorphic_identity': 'plan_salud',
        'polymorphic_on': tipo
    }

    def generar_plan(self, peso, altura, actividad):
        """
        TEMPLATE METHOD: Define el algoritmo completo de generación de planes.
        Este método puede ser sobrescrito por las subclases para casos específicos.
        """
        if self.tipo == 'plan_salud':
            self.calcular_macros_basico(peso, altura, actividad)
            self.seleccionar_ejercicio_basico()
            self.generar_mensaje_basico()
        else:
            self.calcular_macros(peso, altura, actividad)
            self.seleccionar_ejercicio()
            self.generar_mensaje()
        
        return self

    def calcular_macros_basico(self, peso, altura, actividad):
        """Cálculo básico para planes generales de salud"""
        tmb = 10 * peso + 6.25 * altura - 5 * 25 + 5 
        factor = {'bajo': 1.2, 'moderado': 1.55, 'alto': 1.725}
        self.calorias = int(tmb * factor.get(actividad, 1.55))
        self.proteinas = int(peso * 1.8)  

    def seleccionar_ejercicio_basico(self):
        """Rutina básica para salud general adaptada al nivel de actividad"""
        actividad = current_user.actividad if current_user else 'moderado'
        
        if actividad == 'bajo':
            self.rutina = "Caminar 150 min/semana + ejercicios básicos de flexibilidad"
        elif actividad == 'alto':
            self.rutina = "Ejercicio variado 250 min/semana + 3 días de fuerza + flexibilidad"
        else:
            self.rutina = "Ejercicio moderado 150 min/semana + 2 días de fuerza"

    def generar_mensaje_basico(self):
        """Mensaje para plan de salud general"""
        self.descripcion = f"Plan de BIENESTAR GENERAL: Mantén tu salud con {self.calorias} kcal/día y {self.proteinas}g de proteína."

    def calcular_macros(self, peso, altura, actividad):
        """Calcula calorías y macronutrientes según el objetivo específico"""
        raise NotImplementedError("Las subclases deben implementar calcular_macros()")

    def seleccionar_ejercicio(self):
        """Selecciona la rutina de ejercicios apropiada para el objetivo"""
        raise NotImplementedError("Las subclases deben implementar seleccionar_ejercicio()")

    def generar_mensaje(self):
        """Genera un mensaje descriptivo del plan personalizado"""
        raise NotImplementedError("Las subclases deben implementar generar_mensaje()")


class PlanPerderPeso(PlanSalud):
    """
    Implementación concreta del Template Method para PÉRDIDA DE PESO.
    Sobrescribe los métodos abstractos con lógica específica para déficit calórico.
    """
    __tablename__ = 'planes_perder_peso'
    __table_args__ = {'schema': 'planes'}
    id = db.Column(db.Integer, db.ForeignKey('planes.planes_salud.id'), primary_key=True)

    __mapper_args__ = {
        'polymorphic_identity': 'perder_peso'
    }

    def calcular_macros(self, peso, altura, actividad):
        """Implementación específica: Crea DÉFICIT calórico para pérdida de peso"""
        genero = current_user.genero

        if genero == 'femenino':
            tmb = 10 * peso + 6.25 * altura - 5 * 22 - 161
            prote_factor = {'bajo': 1.8, 'moderado': 2.0, 'alto': 2.2}
        else:
            tmb = 10 * peso + 6.25 * altura - 5 * 22 + 5
            prote_factor = {'bajo': 2.0, 'moderado': 2.2, 'alto': 2.4}

        factor = {'bajo': 1.2, 'moderado': 1.55, 'alto': 1.9}
        self.calorias = int(tmb * factor.get(actividad, 1.2) - 500)
        self.proteinas = int(peso * prote_factor.get(actividad, 2.0))

    def seleccionar_ejercicio(self):
        """Implementación específica: Rutina enfocada en cardio y quema de grasa"""
        actividad = current_user.actividad if current_user else 'moderado'
        
        if actividad == 'bajo':
            self.rutina = "Caminar 30 min diarios + ejercicios básicos de peso corporal 3 veces/semana"
        elif actividad == 'alto':
            self.rutina = "45 min cardio intenso + entrenamiento de fuerza completo 5-6 veces/semana"
        else:
            self.rutina = "30 min cardio moderado + fuerza con peso corporal 4 veces/semana"

    def generar_mensaje(self):
        """Implementación específica: Mensaje orientado a pérdida de peso"""
        self.descripcion = f"Plan de PÉRDIDA DE PESO: Déficit de 500 cal/día. Proteínas: {self.proteinas}g. Rutina: {self.rutina}."


class PlanGanarMasa(PlanSalud):
    """
    Implementación concreta del Template Method para GANANCIA DE MASA MUSCULAR.
    Sobrescribe los métodos abstractos con lógica específica para superávit calórico.
    """
    __tablename__ = 'planes_ganar_masa'
    __table_args__ = {'schema': 'planes'}
    id = db.Column(db.Integer, db.ForeignKey('planes.planes_salud.id'), primary_key=True)

    __mapper_args__ = {
        'polymorphic_identity': 'ganar_masa'
    }

    def calcular_macros(self, peso, altura, actividad):
        """Implementación específica: Crea SUPERÁVIT calórico para ganancia de masa"""
        genero = current_user.genero

        if genero == 'femenino':
            tmb = 10 * peso + 6.25 * altura - 5 * 22 - 161
            prote_factor = {'bajo': 2.0, 'moderado': 2.2, 'alto': 2.4}
        else:
            tmb = 10 * peso + 6.25 * altura - 5 * 22 + 5
            prote_factor = {'bajo': 2.2, 'moderado': 2.5, 'alto': 2.7}

        factor = {'bajo': 1.2, 'moderado': 1.55, 'alto': 1.9}
        self.calorias = int(tmb * factor.get(actividad, 1.55) + 500)
        self.proteinas = int(peso * prote_factor.get(actividad, 2.5))

    def seleccionar_ejercicio(self):
        """Implementación específica: Rutina enfocada en hipertrofia y fuerza"""
        actividad = current_user.actividad if current_user else 'moderado'
        
        if actividad == 'bajo':
            self.rutina = "Entrenamiento básico de fuerza 3 días/semana + descanso activo"
        elif actividad == 'alto':
            self.rutina = "Hipertrofia avanzada 5-6 días/semana + cardio ligero"
        else:
            self.rutina = "Hipertrofia 4 días/semana + flexibilidad"

    def generar_mensaje(self):
        """Implementación específica: Mensaje orientado a ganancia de masa muscular"""
        self.descripcion = f"Plan de GANANCIA DE MASA: Superávit de 500 cal/día. Proteínas: {self.proteinas}g. Rutina: {self.rutina}."
