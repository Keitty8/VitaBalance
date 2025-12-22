import requests
import json
import re
from typing import Dict, List

class VitaBalanceChatbot:
    def __init__(self):
        self.conversation_context = {}
        
        self.knowledge_base = {
            "planes": {
                "basico": "El Plan Básico es perfecto para principiantes, dura 4 semanas con rutinas simples y efectivas.",
                "express_perder": "Express Perder es un programa intensivo de 6 semanas para perder peso de forma rápida y saludable.",
                "hipertrofia": "El plan de Hipertrofia es avanzado, dura 8 semanas y está diseñado para desarrollar masa muscular.",
                "hiit_power": "HIIT Power combina entrenamientos de alta intensidad para quemar grasa rápidamente.",
                "volumen_eficiente": "Volumen Eficiente optimiza el tiempo de entrenamiento con máximos resultados.",
                "avanzado_masa": "Plan Avanzado Masa está diseñado para usuarios experimentados que buscan ganar músculo."
            },
            "talleres": {
                "info": "Nuestros talleres incluyen sesiones en vivo, material descargable y certificados de finalización.",
                "tipos": "Ofrecemos talleres de nutrición, mindfulness, técnicas de relajación y actividades prácticas."
            },
            "preguntas_frecuentes": {
                "registro": "Para registrarte, completa el formulario en la página principal con tus datos básicos y objetivos.",
                "duracion": "Los planes van desde 4 hasta 12 semanas, dependiendo de tus objetivos y nivel.",
                "soporte": "Tenemos soporte a través del email info@vitabalance.com y este chat inteligente 24/7.",
                "acceso": "Una vez registrado, accedes a tu panel personal donde puedes ver planes y talleres.",
                "certificados": "Al completar talleres y planes obtienes certificados digitales verificables.",
                "gratuito": "VitaBalance es completamente gratuito. Estamos en fase de crecimiento sin costos.",
                "requisitos": "Solo necesitas una conexión a internet y ganas de transformar tu vida."
            },
            "beneficios": [
                "Planes personalizados según tus objetivos",
                "Plataforma web responsive (funciona en móviles)",
                "Comunidad de apoyo y motivación",
                "Seguimiento detallado de progreso",
                "Certificados de logros descargables",
                "Soporte personalizado gratuito",
                "Acceso completo sin costos ocultos"
            ],
            
            "response_buttons": {
                "planes_info": [
                    "Plan Básico",
                    "Express Perder", 
                    "Hipertrofia",
                    "¿Cuál me recomiendas?"
                ],
                "plan_basico": [
                    "¿Cómo empezar?",
                    "Ver otros planes", 
                    "¿Qué necesito?",
                    "Más información"
                ],
                "express_perder": [
                    "¿Es muy intenso?",
                    "Ver rutinas",
                    "Plan nutricional", 
                    "Otros planes"
                ],
                "hipertrofia": [
                    "¿Necesito experiencia?",
                    "¿Qué equipo usar?",
                    "Plan alimenticio",
                    "Ver otros planes"
                ],
                "talleres_info": [
                    "Mindfulness",
                    "Nutrición", 
                    "Entrenamiento",
                    "Bienestar Integral"
                ],
                "registro": [
                    "¿Cómo empezar?",
                    "¿Qué necesito?",
                    "¿Por qué gratis?",
                    "Ver planes"
                ],
                "soporte": [
                    "Intentar de nuevo",
                    "Contactar soporte", 
                    "Ver FAQ",
                    "Reiniciar chat"
                ],
                "bienvenida": [
                    "Ver planes",
                    "Ver talleres", 
                    "¿Cómo funciona?",
                    "¿Qué incluye?"
                ],
                "precios": [
                    "¿Habrá costos después?",
                    "¿Es confiable?", 
                    "Ver planes",
                    "¿Cómo se mantienen?"
                ],
                "beneficios": [
                    "Ver talleres",
                    "¿Por qué gratis?",
                    "Más detalles", 
                    "Ver planes"
                ],
                "despedida": [
                    "¡Gracias!"
                ],
                "general": [
                    "Ver planes",
                    "Ver talleres",
                    "¿Cómo funciona?",
                    "Contactar soporte"
                ]
            }
        }
        
        self.hf_api_url = "https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium"
    
    def get_contextual_response(self, user_message: str, user_id: str = "default") -> dict:
        """Genera respuesta con botones basada en el contexto de VitaBalance"""
        user_message_lower = user_message.lower()
        
        if user_id not in self.conversation_context:
            self.conversation_context[user_id] = {
                "last_topic": None,
                "interested_plans": [],
                "questions_asked": []
            }
        
        context = self.conversation_context[user_id]
        response_data = {
            "message": "",
            "buttons": [],
            "topic": None
        }
        
        if any(keyword in user_message_lower for keyword in ["plan", "programa", "rutina"]):
            context["last_topic"] = "planes"
            if "basico" in user_message_lower or "principiante" in user_message_lower:
                response_data["message"] = f"🌟 {self.knowledge_base['planes']['basico']} Es ideal para comenzar tu transformación de manera gradual y segura."
                response_data["buttons"] = self.knowledge_base["response_buttons"]["plan_basico"]
                response_data["topic"] = "plan_basico"
            elif "express" in user_message_lower or "perder peso" in user_message_lower:
                response_data["message"] = f"🔥 {self.knowledge_base['planes']['express_perder']} Incluye nutrición especializada y ejercicios cardiovasculares efectivos."
                response_data["buttons"] = self.knowledge_base["response_buttons"]["express_perder"]
                response_data["topic"] = "express_perder"
            elif "hipertrofia" in user_message_lower or "musculo" in user_message_lower or "masa" in user_message_lower:
                response_data["message"] = f"💪 {self.knowledge_base['planes']['hipertrofia']} Requiere experiencia previa en entrenamiento con pesas y disciplina constante."
                response_data["buttons"] = self.knowledge_base["response_buttons"]["hipertrofia"]
                response_data["topic"] = "hipertrofia"
            else:
                response_data["message"] = "📋 VitaBalance ofrece varios planes personalizados:\n\n🌟 **Plan Básico** (4 sem) - Ideal para principiantes\n🔥 **Express Perder** (6 sem) - Para pérdida de peso\n💪 **Hipertrofia** (8 sem) - Para ganar músculo\n⚡ **HIIT Power** - Alta intensidad\n📈 **Volumen Eficiente** - Máximos resultados\n🏆 **Avanzado Masa** - Para expertos"
                response_data["buttons"] = self.knowledge_base["response_buttons"]["planes_info"]
                response_data["topic"] = "planes_general"
        
        # Respuestas sobre talleres - SINCRONIZADO CON CHATBOT.JS
        elif any(keyword in user_message_lower for keyword in ["taller", "curso", "actividad"]):
            context["last_topic"] = "talleres"
            response_data["message"] = f"🎯 {self.knowledge_base['talleres']['info']} {self.knowledge_base['talleres']['tipos']} Los talleres son completamente gratuitos y están diseñados para complementar tu plan de salud."
            response_data["buttons"] = self.knowledge_base["response_buttons"]["talleres_info"]
            response_data["topic"] = "talleres"
        
        elif any(keyword in user_message_lower for keyword in ["precio", "costo", "pagar", "gratis", "free"]):
            context["last_topic"] = "precios"
            response_data["message"] = f"🎉 ¡Excelente noticia! {self.knowledge_base['preguntas_frecuentes']['gratuito']} Todos nuestros planes, talleres y funciones están disponibles sin costo alguno."
            response_data["buttons"] = self.knowledge_base["response_buttons"]["precios"]
            response_data["topic"] = "precios"
        
        elif any(keyword in user_message_lower for keyword in ["app", "movil", "celular", "telefono", "aplicacion"]):
            context["last_topic"] = "app_movil"
            response_data["message"] = "📱 Actualmente no tenemos app móvil nativa, pero nuestra plataforma web está completamente optimizada para móviles. Funciona perfectamente en tu navegador como si fuera una app. ¡Pronto tendremos app nativa!"
            response_data["buttons"] = self.knowledge_base["response_buttons"]["general"]
            response_data["topic"] = "app_movil"
        
        elif any(keyword in user_message_lower for keyword in ["registro", "registrar", "empezar", "comenzar", "inscribir"]):
            context["last_topic"] = "registro"
            response_data["message"] = f"🚀 {self.knowledge_base['preguntas_frecuentes']['registro']} El proceso es súper simple y toma menos de 2 minutos. ¡Y es completamente gratis!"
            response_data["buttons"] = self.knowledge_base["response_buttons"]["registro"]
            response_data["topic"] = "registro"
        
        elif any(keyword in user_message_lower for keyword in ["ayuda", "soporte", "problema", "contacto", "error"]):
            context["last_topic"] = "soporte"
            response_data["message"] = f"🆘 {self.knowledge_base['preguntas_frecuentes']['soporte']} Estoy aquí para resolver la mayoría de tus dudas al instante."
            response_data["buttons"] = self.knowledge_base["response_buttons"]["soporte"]
            response_data["topic"] = "soporte"
        
        elif any(keyword in user_message_lower for keyword in ["beneficio", "ventaja", "incluye", "obtengo", "que hay"]):
            context["last_topic"] = "beneficios"
            benefits = "\n".join([f"✅ {benefit}" for benefit in self.knowledge_base['beneficios']])
            response_data["message"] = f"🎁 Al unirte a VitaBalance obtienes:\n\n{benefits}"
            response_data["buttons"] = self.knowledge_base["response_buttons"]["beneficios"]
            response_data["topic"] = "beneficios"
        
        elif any(keyword in user_message_lower for keyword in ["hola", "buenos", "buenas", "saludos", "hi"]):
            context["last_topic"] = "saludo"
            response_data["message"] = "¡Hola! 👋 Soy tu asistente virtual de VitaBalance. Estoy aquí para ayudarte con información sobre nuestros planes gratuitos, talleres y servicios. ¿En qué puedo ayudarte hoy?"
            response_data["buttons"] = self.knowledge_base["response_buttons"]["bienvenida"]
            response_data["topic"] = "saludo"
        
        elif any(keyword in user_message_lower for keyword in ["adios", "gracias", "bye", "chao"]):
            context["last_topic"] = "despedida"
            response_data["message"] = "¡De nada! 😊 Fue un placer ayudarte. Recuerda que estoy aquí 24/7 para resolver tus dudas sobre VitaBalance. ¡Que tengas un excelente día y éxito en tu transformación! 🌟"
            response_data["buttons"] = self.knowledge_base["response_buttons"]["despedida"]
            response_data["topic"] = "despedida"
        
        else:
            response_data = self.get_ai_response_with_buttons(user_message, context)
        
        context["questions_asked"].append(user_message_lower)
        if len(context["questions_asked"]) > 10:  
            context["questions_asked"] = context["questions_asked"][-10:]
            
        return response_data
    
    def get_ai_response_with_buttons(self, message: str, context: dict) -> dict:
        """Genera respuesta usando IA como fallback con botones contextuales - SINCRONIZADO CON CHATBOT.JS"""
        try:
            fallback_responses = [
                {
                    "message": "Interesante pregunta. En VitaBalance nos enfocamos en tu bienestar integral de forma completamente gratuita. 💪",
                    "buttons": self.knowledge_base["response_buttons"]["general"],
                    "topic": "general"
                },
                {
                    "message": "¡Excelente! VitaBalance tiene muchas opciones para ayudarte sin costo alguno. 🎯",
                    "buttons": self.knowledge_base["response_buttons"]["planes_info"],
                    "topic": "general"
                },
                {
                    "message": "Me parece una consulta importante. En VitaBalance tenemos toda la información que necesitas. 📞",
                    "buttons": self.knowledge_base["response_buttons"]["soporte"],
                    "topic": "general"
                }
            ]
            
            if any(word in message.lower() for word in ["ejercicio", "rutina", "entrenar", "fitness"]):
                return {
                    "message": "🏋️‍♀️ Para ejercicios y rutinas, nuestros planes personalizados gratuitos son ideales. Van desde nivel principiante hasta avanzado.",
                    "buttons": self.knowledge_base["response_buttons"]["planes_info"],
                    "topic": "ejercicios"
                }
            elif any(word in message.lower() for word in ["dieta", "comida", "nutricion", "comer"]):
                return {
                    "message": "🥗 La nutrición es fundamental en VitaBalance. Nuestros planes incluyen guías nutricionales gratuitas adaptadas a tus objetivos.",
                    "buttons": self.knowledge_base["response_buttons"]["talleres_info"],
                    "topic": "nutricion"
                }
            elif any(word in message.lower() for word in ["tiempo", "cuanto", "duracion", "cuando"]):
                return {
                    "message": "⏰ Nuestros planes van de 4 a 12 semanas. El tiempo exacto depende de tus objetivos y nivel de compromiso.",
                    "buttons": self.knowledge_base["response_buttons"]["planes_info"],
                    "topic": "tiempo"
                }
            elif any(word in message.lower() for word in ["funciona", "como", "que", "donde"]):
                return {
                    "message": "🔧 VitaBalance funciona de manera simple: te registras gratis, eliges tu plan personalizado, y sigues tu progreso paso a paso.",
                    "buttons": self.knowledge_base["response_buttons"]["bienvenida"],
                    "topic": "funcionamiento"
                }
            else:
                selected_response = fallback_responses[len(message) % len(fallback_responses)]
                return selected_response
                
        except Exception as e:
            return {
                "message": "Disculpa, tengo una pequeña falla técnica. Pero puedo ayudarte con información sobre nuestros planes gratuitos, talleres y servicios de VitaBalance. 😊",
                "buttons": self.knowledge_base["response_buttons"]["soporte"],
                "topic": "error"
            }

    def get_ai_response(self, message: str) -> str:
        """Genera respuesta usando IA como fallback"""
        try:
            context = f"Eres un asistente virtual de VitaBalance, una plataforma de bienestar integral. Responde de manera amigable y profesional sobre salud, fitness y bienestar. Usuario pregunta: {message}"
            
            fallback_responses = [
                "Interesante pregunta. En VitaBalance nos enfocamos en tu bienestar integral. ¿Te gustaría saber más sobre nuestros planes personalizados? 💪",
                "¡Excelente! VitaBalance tiene muchas opciones para ayudarte. ¿Prefieres información sobre planes de entrenamiento o talleres? 🎯",
                "Me parece una consulta importante. Nuestro equipo de expertos en VitaBalance puede darte información más detallada. ¿Quieres que te conecte con soporte? 📞",
                "¡Perfecto! En VitaBalance creemos que cada persona es única. ¿Has considerado hacer nuestro cuestionario para un plan personalizado? ✨"
            ]
            
            if any(word in message.lower() for word in ["ejercicio", "rutina", "entrenar"]):
                return "🏋️‍♀️ Para ejercicios y rutinas, nuestros planes personalizados son ideales. Van desde nivel principiante hasta avanzado. ¿Cuál es tu nivel actual de actividad física?"
            elif any(word in message.lower() for word in ["dieta", "comida", "nutricion"]):
                return "🥗 La nutrición es clave en VitaBalance. Nuestros planes incluyen guías nutricionales adaptadas a tus objetivos. ¿Buscas perder peso, ganar masa muscular o mantener?"
            elif any(word in message.lower() for word in ["tiempo", "cuanto", "duracion"]):
                return "⏰ Nuestros planes van de 4 a 12 semanas. El tiempo exacto depende de tus objetivos. ¿Prefieres algo intensivo y rápido o un cambio gradual?"
            else:
                return fallback_responses[len(message) % len(fallback_responses)]
                
        except Exception as e:
            return "Disculpa, tengo una pequeña falla técnica. Pero puedo ayudarte con información sobre nuestros planes, talleres y servicios de VitaBalance. ¿Qué te interesa saber? 😊"

vitabalance_bot = VitaBalanceChatbot()
