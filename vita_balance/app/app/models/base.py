from abc import ABC, abstractmethod

class PlanComponent(ABC):
    @abstractmethod
    def mostrar(self) -> str:
        pass