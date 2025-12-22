from .base import PlanComponent

class PlanConcreto(PlanComponent):
    def __init__(self, nombre: str, descripcion: str):
        self.nombre = nombre
        self.descripcion = descripcion

    def mostrar(self) -> str:
        return f"📋 {self.nombre}: {self.descripcion}"