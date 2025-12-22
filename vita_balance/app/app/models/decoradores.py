from .base import PlanComponent

class DecoradorPlan(PlanComponent):
    def __init__(self, componente: PlanComponent):
        self.componente = componente

    def mostrar(self) -> str:
        return self.componente.mostrar()

class PromocionDecorator(DecoradorPlan):
    def mostrar(self) -> str:
        return f"🔥 [PROMOCIÓN] {self.componente.mostrar()}"

class NivelDecorator(DecoradorPlan):
    def __init__(self, componente: PlanComponent, nivel: str):
        super().__init__(componente)
        self.nivel = nivel

    def mostrar(self) -> str:
        return f"{self.componente.mostrar()} — Nivel: {self.nivel}"

class VipDecorator(DecoradorPlan):
    def mostrar(self) -> str:
        return f"{self.componente.mostrar()} ⭐ VIP"
