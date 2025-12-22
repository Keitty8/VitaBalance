/**
 * 🤖 VitaBalance Chatbot
 * Sistema de chat inteligente con IA
 */

class VitaBalanceChatbot {
    constructor() {
        this.isOpen = false;
        this.isTyping = false;
        this.messages = [];
        this.quickSuggestions = [
            "Ver planes",
            "Ver talleres",
            "¿Cómo funciona?",
            "¿Qué incluye?",
            "Contactar soporte"
        ];
        
        this.init();
    }
    
    init() {
        this.createChatbotHTML();
        this.attachEventListeners();
        this.showWelcomeMessage();
        console.log('✅ VitaBalance Chatbot iniciado correctamente');
    }
    
    createChatbotHTML() {
        const toggleButton = document.createElement('button');
        toggleButton.className = 'chatbot-toggle';
        toggleButton.innerHTML = '🤖';
        toggleButton.title = 'Abrir chat de ayuda';
        
        const chatContainer = document.createElement('div');
        chatContainer.className = 'chatbot-container';
        chatContainer.innerHTML = `
            <div class="chatbot-header">
                <button class="chatbot-close" title="Cerrar chat">✕</button>
                <h3>🤖 Asistente VitaBalance</h3>
                <p>¡Hola! ¿En qué puedo ayudarte?</p>
            </div>
            
            <div class="chatbot-messages" id="chatbot-messages">
                <!-- Los mensajes se añaden aquí dinámicamente -->
            </div>
            
            <div class="response-buttons" id="response-buttons" style="display: none;">
                <!-- Los botones de respuesta se añaden aquí dinámicamente -->
            </div>
            
            <div class="typing-indicator" id="typing-indicator">
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
            </div>
            
            <div class="quick-suggestions" id="quick-suggestions">
                ${this.quickSuggestions.map(suggestion => 
                    `<button class="quick-suggestion" data-message="${suggestion}">${suggestion}</button>`
                ).join('')}
            </div>
            
            <div class="chatbot-input-area">
                <textarea 
                    class="chatbot-input" 
                    id="chatbot-input" 
                    placeholder="Escribe tu mensaje aquí..."
                    rows="1"
                ></textarea>
                <button class="chatbot-send" id="chatbot-send" title="Enviar mensaje">
                    <span class="send-icon">📤</span>
                    <div class="loading-spinner"></div>
                </button>
            </div>
        `;
        
        document.body.appendChild(toggleButton);
        document.body.appendChild(chatContainer);
        
        this.toggleButton = toggleButton;
        this.chatContainer = chatContainer;
        this.messagesContainer = document.getElementById('chatbot-messages');
        this.responseButtonsContainer = document.getElementById('response-buttons');
        this.input = document.getElementById('chatbot-input');
        this.sendButton = document.getElementById('chatbot-send');
        this.typingIndicator = document.getElementById('typing-indicator');
        this.suggestionsContainer = document.getElementById('quick-suggestions');
    }
    
    attachEventListeners() {
        this.toggleButton.addEventListener('click', () => this.toggleChat());
        
        this.chatContainer.querySelector('.chatbot-close').addEventListener('click', () => this.closeChat());
        
        this.sendButton.addEventListener('click', () => this.sendMessage());
        
        this.input.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !e.ctrlKey && !e.shiftKey) {
                e.preventDefault();
                this.sendMessage();
            }
        });
        
        this.input.addEventListener('input', () => this.autoResizeTextarea());
        
        this.suggestionsContainer.addEventListener('click', (e) => {
            if (e.target.classList.contains('quick-suggestion')) {
                const message = e.target.dataset.message;
                this.input.value = message;
                this.sendMessage();
            }
        });
        
        this.responseButtonsContainer.addEventListener('click', (e) => {
            if (e.target.classList.contains('response-button')) {
                const buttonText = e.target.textContent;
                
                this.handleButtonResponse(buttonText);
            }
        });
        
        document.addEventListener('click', (e) => {
            if (!this.chatContainer.contains(e.target) && 
                !this.toggleButton.contains(e.target) && 
                this.isOpen) {
            }
        });
    }
    
    toggleChat() {
        if (this.isOpen) {
            this.closeChat();
        } else {
            this.openChat();
        }
    }
    
    openChat() {
        this.isOpen = true;
        this.chatContainer.classList.add('active');
        this.toggleButton.classList.add('active');
        this.toggleButton.innerHTML = '✕';
        this.input.focus();
        
        if (this.messages.length > 1) {
            this.suggestionsContainer.style.display = 'none';
        }
        
        this.clearResponseButtons();
    }
    
    closeChat() {
        this.isOpen = false;
        this.chatContainer.classList.remove('active');
        this.toggleButton.classList.remove('active');
        this.toggleButton.innerHTML = '🤖';
    }
    
    autoResizeTextarea() {
        this.input.style.height = 'auto';
        this.input.style.height = Math.min(this.input.scrollHeight, 80) + 'px';
    }
    
    showWelcomeMessage() {
        const welcomeMsg = {
            type: 'welcome',
            content: '¡Bienvenido! 👋 Soy tu asistente virtual de VitaBalance. Pregúntame sobre planes gratuitos, talleres, o cualquier duda sobre nuestros servicios. ¡Estoy aquí para ayudarte! ✨',
            timestamp: new Date(),
            buttons: ['Ver planes', 'Ver talleres', '¿Cómo funciona?', '¿Qué incluye?']
        };
        
        this.messages.push(welcomeMsg);
        this.displayMessage(welcomeMsg);
        this.showResponseButtons(welcomeMsg.buttons);
    }
    
    async sendMessage() {
        const messageText = this.input.value.trim();
        
        if (!messageText || this.isTyping) return;
        
        const userMessage = {
            type: 'user',
            content: messageText,
            timestamp: new Date()
        };
        
        this.messages.push(userMessage);
        this.displayMessage(userMessage);
        
        this.input.value = '';
        this.autoResizeTextarea();
        
        this.suggestionsContainer.style.display = 'none';
        
        this.clearResponseButtons();
        
        this.showTyping();
        
        try {
            const response = await this.callChatAPI(messageText);
            
            const botMessage = {
                type: 'bot',
                content: response.response || 'Disculpa, no pude procesar tu mensaje. ¿Puedes intentar de nuevo?',
                timestamp: new Date(),
                buttons: response.buttons || [],
                topic: response.topic || ''
            };
            
            setTimeout(() => {
                this.hideTyping();
                this.messages.push(botMessage);
                this.displayMessage(botMessage);
                
                if (botMessage.buttons && botMessage.buttons.length > 0) {
                    this.showResponseButtons(botMessage.buttons, botMessage.topic);
                }
            }, 1000 + Math.random() * 1000); 
            
        } catch (error) {
            console.error('Error en chatbot:', error);
            
            setTimeout(() => {
                this.hideTyping();
                const errorMessage = {
                    type: 'bot',
                    content: 'Disculpa, hay un problema técnico. Por favor contacta a soporte@vitabalance.com o intenta más tarde. 🛠️',
                    timestamp: new Date(),
                    buttons: ['Intentar de nuevo', 'Contactar soporte', 'Ver FAQ', 'Reiniciar chat']
                };
                
                this.messages.push(errorMessage);
                this.displayMessage(errorMessage);
                this.showResponseButtons(errorMessage.buttons, 'error');
            }, 1000);
        }
    }
    
    async callChatAPI(message) {
        const response = await fetch('/api/chat', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ message })
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return await response.json();
    }
    
    displayMessage(message) {
        const messageElement = document.createElement('div');
        messageElement.className = `message ${message.type}`;
        
        let content = this.processMessageContent(message.content);
        
        messageElement.innerHTML = content;
        
        messageElement.title = message.timestamp.toLocaleTimeString();
        
        this.messagesContainer.appendChild(messageElement);
        this.scrollToBottom();
    }
    
    processMessageContent(content) {
        content = content.replace(/\n/g, '<br>');
        
        content = content.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        
        const urlRegex = /(https?:\/\/[^\s]+)/g;
        content = content.replace(urlRegex, '<a href="$1" target="_blank" rel="noopener noreferrer">$1</a>');
        
        return content;
    }
    
    showTyping() {
        this.isTyping = true;
        this.typingIndicator.classList.add('active');
        this.sendButton.classList.add('loading');
        this.sendButton.disabled = true;
        this.scrollToBottom();
    }
    
    hideTyping() {
        this.isTyping = false;
        this.typingIndicator.classList.remove('active');
        this.sendButton.classList.remove('loading');
        this.sendButton.disabled = false;
    }
    
    scrollToBottom() {
        setTimeout(() => {
            this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight;
        }, 100);
    }
    
    showResponseButtons(buttons, topic = '') {
        if (!buttons || buttons.length === 0) return;
        
        this.clearResponseButtons();
        
        buttons.forEach((buttonText, index) => {
            const button = document.createElement('button');
            button.className = 'response-button';
            button.textContent = buttonText;
            
            if (buttonText.includes('Registrar') || buttonText.includes('Empezar') || 
                buttonText.includes('¡') || buttonText.includes('ahora') ||
                buttonText.includes('Ir a registro')) {
                button.classList.add('primary');
            } else if (buttonText.includes('Ver') || buttonText.includes('Plan') || 
                       buttonText.includes('Información') || buttonText.includes('demo')) {
                button.classList.add('success');
            } else if (buttonText.includes('Contactar') || buttonText.includes('Soporte') || 
                       buttonText.includes('problema') || buttonText.includes('ayuda')) {
                button.classList.add('warning');
            }
            
            button.style.animationDelay = `${index * 0.1}s`;
            button.style.animation = `buttonsSlide 0.3s ease-out ${index * 0.1}s both`;
            
            this.responseButtonsContainer.appendChild(button);
        });
        
        this.responseButtonsContainer.style.display = 'flex';
        
        setTimeout(() => {
            this.scrollToBottom();
        }, (buttons.length * 0.1 + 0.3) * 1000);
    }
    
    clearResponseButtons() {
        this.responseButtonsContainer.innerHTML = '';
        this.responseButtonsContainer.style.display = 'none';
    }
    
    handleButtonResponse(buttonText) {
        this.clearResponseButtons();
        
        const userMessage = {
            type: 'user',
            content: buttonText,
            timestamp: new Date()
        };
        
        this.messages.push(userMessage);
        this.displayMessage(userMessage);
        
        this.showTyping();
        
        let botResponse = this.getButtonResponse(buttonText);
        
        setTimeout(() => {
            this.hideTyping();
            
            const botMessage = {
                type: 'bot',
                content: botResponse.message,
                timestamp: new Date(),
                buttons: botResponse.buttons || []
            };
            
            this.messages.push(botMessage);
            this.displayMessage(botMessage);
            
            if (botResponse.buttons && botResponse.buttons.length > 0) {
                this.showResponseButtons(botResponse.buttons);
            }
        }, 800 + Math.random() * 400);
    }
    
    getButtonResponse(buttonText) {
        const responses = {
            "Ver planes": {
                message: "🎯 **Nuestros Planes Gratuitos:**\n\n🌟 **Plan Básico** (4 semanas)\n• Ideal para principiantes\n• Rutinas simples y efectivas\n• Guía nutricional básica\n\n🔥 **Express Perder** (6 semanas)\n• Pérdida de peso rápida\n• Cardio + fuerza\n• Plan nutricional especializado\n\n💪 **Hipertrofia** (8 semanas)\n• Ganancia de masa muscular\n• Rutinas avanzadas\n• Nutrición para volumen",
                buttons: ["Plan Básico", "Express Perder", "Hipertrofia", "¿Cuál me recomiendas?"]
            },
            
            "Plan Básico": {
                message: "🌟 **Plan Básico - Perfecto para empezar**\n\n**Duración:** 4 semanas\n**Nivel:** Principiante\n**Objetivo:** Crear hábitos saludables\n\n**Incluye:**\n• 3 entrenamientos por semana (30-45 min)\n• Ejercicios con peso corporal\n• Guía nutricional básica\n• Videos explicativos\n• Seguimiento de progreso\n\n¡Perfecto para comenzar tu transformación! 💫",
                buttons: ["¿Cómo empezar?", "Ver otros planes", "¿Qué necesito?", "Más información"]
            },
            
            "Express Perder": {
                message: "🔥 **Express Perder - Resultados rápidos**\n\n**Duración:** 6 semanas\n**Nivel:** Intermedio\n**Objetivo:** Pérdida de peso efectiva\n\n**Incluye:**\n• 4 entrenamientos por semana (45-60 min)\n• Cardio HIIT + entrenamiento de fuerza\n• Plan nutricional detallado\n• Recetas saludables\n• Calculadora de calorías\n\n¡Transforma tu cuerpo en 6 semanas! 🚀",
                buttons: ["¿Es muy intenso?", "Ver rutinas", "Plan nutricional", "Otros planes"]
            },
            
            "Hipertrofia": {
                message: "💪 **Plan Hipertrofia - Gana músculo**\n\n**Duración:** 8 semanas\n**Nivel:** Avanzado\n**Objetivo:** Ganancia de masa muscular\n\n**Incluye:**\n• 5 entrenamientos por semana (60-75 min)\n• Rutinas de fuerza progresivas\n• Plan nutricional para volumen\n• Guía de suplementación\n• Seguimiento de medidas\n\n¡Desarrolla tu mejor versión! 🏆",
                buttons: ["¿Necesito experiencia?", "¿Qué equipo usar?", "Plan alimenticio", "Ver otros planes"]
            },
            
            "¿Cuál me recomiendas?": {
                message: "🤔 **Te ayudo a elegir el plan perfecto:**\n\n❓ **¿Eres principiante?** → Plan Básico\n• Nunca has entrenado o llevas mucho tiempo sin hacerlo\n• Quieres crear hábitos de forma gradual\n\n❓ **¿Quieres perder peso?** → Express Perder\n• Tienes algo de experiencia entrenando\n• Tu objetivo principal es bajar de peso\n\n❓ **¿Quieres ganar músculo?** → Hipertrofia\n• Ya tienes experiencia con pesas\n• Quieres aumentar masa muscular\n\n**¿En cuál categoría te ubicas?**",
                buttons: ["Soy principiante", "Quiero perder peso", "Quiero ganar músculo", "Ver todos los planes"]
            },
            
            "Soy principiante": {
                message: "🌟 **¡Perfecto! El Plan Básico es ideal para ti:**\n\n**¿Por qué es perfecto?**\n• Diseñado específicamente para principiantes\n• Progresión gradual y segura\n• No necesitas equipo especializado\n• Rutinas de 30-45 minutos\n• Guía nutricional simple\n\n**Lo que lograrás:**\n✅ Crear el hábito del ejercicio\n✅ Aprender la técnica correcta\n✅ Mejorar tu condición física\n✅ Sentirte más energético\n\n¡Empezar es lo más importante! 💪",
                buttons: ["¿Cómo empezar?", "¿Qué necesito?", "Ver otros planes", "Más información"]
            },
            
            "Quiero perder peso": {
                message: "🔥 **¡Express Perder es perfecto para tu objetivo!**\n\n**¿Por qué funciona?**\n• Combina cardio y fuerza para quemar grasa\n• Plan nutricional específico para déficit calórico\n• Rutinas HIIT efectivas\n• Seguimiento de progreso\n• Recetas para perder peso\n\n**Resultados esperados:**\n✅ Pérdida de peso visible en 2-3 semanas\n✅ Mayor definición muscular\n✅ Más energía y resistencia\n✅ Hábitos alimenticios saludables\n\n¡Transforma tu cuerpo en 6 semanas! 🚀",
                buttons: ["¿Es muy intenso?", "Plan nutricional", "Ver rutinas", "Otros planes"]
            },
            
            "Quiero ganar músculo": {
                message: "💪 **¡Hipertrofia es tu plan ideal!**\n\n**¿Por qué es efectivo?**\n• Rutinas de fuerza progresivas\n• Plan nutricional para volumen\n• Técnicas avanzadas de entrenamiento\n• Seguimiento de medidas corporales\n• Guía de suplementación\n\n**Resultados esperados:**\n✅ Aumento de masa muscular\n✅ Mayor fuerza y potencia\n✅ Mejor definición corporal\n✅ Conocimiento avanzado\n\n**Importante:** Requiere experiencia previa con pesas 🏋️‍♂️",
                buttons: ["¿Necesito experiencia?", "¿Qué equipo usar?", "Plan alimenticio", "Ver otros planes"]
            },
            
            "Ver otros planes": {
                message: "📋 **Todos nuestros planes gratuitos:**\n\n🌟 **Plan Básico** (4 sem) - Principiantes\n🔥 **Express Perder** (6 sem) - Pérdida de peso\n💪 **Hipertrofia** (8 sem) - Ganancia muscular\n⚡ **HIIT Power** (5 sem) - Alta intensidad\n📈 **Volumen Eficiente** (10 sem) - Resultados máximos\n🏆 **Avanzado Masa** (12 sem) - Expertos\n\n**Todos incluyen:**\n✅ Rutinas detalladas\n✅ Videos explicativos\n✅ Nutrición personalizada\n✅ Seguimiento de progreso",
                buttons: ["Plan Básico", "Express Perder", "Hipertrofia", "¿Cuál me recomiendas?"]
            },
            
            "¿Cómo empezar?": {
                message: "🚀 **¡Empezar es súper fácil!**\n\n**Para comenzar con tu plan:**\n\n**1. Regístrate** en VitaBalance (formulario en la página principal)\n**2. Completa** tu perfil con datos básicos\n**3. Recibe** tu plan personalizado\n**4. Descarga** las rutinas y material\n**5. ¡Comienza** cuando estés listo!\n\n**Lo que necesitas:**\n• Ropa cómoda para entrenar\n• Espacio de 2x2 metros\n• Botella de agua\n• ¡Muchas ganas! 💪\n\n**Tip:** Empieza despacio y sé constante. ¡Los resultados llegan con el tiempo!",
                buttons: ["¿Qué necesito?", "¿Por qué gratis?", "Ver planes", "Más consejos"]
            },
            
            "¿Qué necesito?": {
                message: "📋 **Lo que necesitas para empezar:**\n\n**Para Plan Básico:**\n• Solo tu peso corporal\n• Ropa deportiva\n• Toalla y agua\n• 30-45 min diarios\n\n**Para Express Perder:**\n• Lo anterior +\n• Pesas ligeras (opcional)\n• 45-60 min diarios\n• Más compromiso nutricional\n\n**Para Hipertrofia:**\n• Acceso a gimnasio o pesas\n• Experiencia previa\n• 60-75 min diarios\n• Disciplina estricta\n\n**¡No necesitas ser perfecto desde el día 1! Lo importante es empezar. 🌟**",
                buttons: ["¿Sin gimnasio?", "Ver planes", "¿Es caro?", "Más información"]
            },
            
            "¿Es muy intenso?": {
                message: "🔥 **Express Perder es intenso, pero manejable:**\n\n**Nivel de intensidad: 7/10**\n\n**¿Qué significa esto?**\n• Requiere esfuerzo y compromiso\n• 4 entrenamientos por semana\n• Combina cardio y fuerza\n• Plan nutricional específico\n\n**¿Es para ti si:**\n✅ Tienes algo de experiencia entrenando\n✅ Puedes dedicar 1 hora diaria\n✅ Estás motivado/a para el cambio\n✅ Quieres resultados en 6 semanas\n\n**Siempre puedes adaptarlo a tu ritmo. ¡La constancia es más importante que la intensidad! 💪**",
                buttons: ["Me parece bien", "¿Hay algo más suave?", "Ver rutinas", "Plan nutricional"]
            },
            
            "¿Necesito experiencia?": {
                message: "💪 **Para Hipertrofia SÍ necesitas experiencia:**\n\n**Experiencia requerida:**\n• Mínimo 6 meses entrenando regularmente\n• Conoces la técnica básica de ejercicios\n• Has usado pesas antes\n• Entiendes conceptos como series/repeticiones\n\n**¿Por qué es importante?**\n• Ejercicios más complejos\n• Mayor intensidad de entrenamiento\n• Riesgo de lesión si no sabes la técnica\n• Progresión avanzada\n\n**¿Eres principiante?** Te recomiendo empezar con el Plan Básico y luego progresar. ¡No hay prisa! 🌟",
                buttons: ["Soy principiante", "Tengo experiencia", "Plan Básico", "Ver otros planes"]
            },
            
            "¿Cómo funciona?": {
                message: "🔧 **VitaBalance es súper fácil de usar:**\n\n**1. Registro** 📝\n• Completa tus datos básicos en la página principal\n• Define tus objetivos\n• Responde cuestionario rápido\n\n**2. Plan Personalizado** 🎯\n• Recibe tu plan recomendado\n• Accede a rutinas y nutrición\n• Descarga material\n\n**3. Seguimiento** 📊\n• Registra tu progreso\n• Ve tu evolución\n• Obtén certificados\n\n**4. Comunidad** 👥\n• Conecta con otros usuarios\n• Comparte logros\n• Recibe motivación",
                buttons: ["Ver planes", "Ver talleres"]
            },
            
            "¿Qué incluye?": {
                message: "🎁 **VitaBalance incluye TODO esto GRATIS:**\n\n✅ **Planes Personalizados**\n• Rutinas adaptadas a tu nivel\n• Videos explicativos HD\n• Progresión automática\n\n✅ **Nutrición Completa**\n• Guías nutricionales\n• Recetas saludables\n• Calculadoras de macros\n\n✅ **Talleres Exclusivos**\n• Sesiones en vivo\n• Material descargable\n• Certificados oficiales\n\n✅ **Soporte Total**\n• Chat 24/7 (como este 😊)\n• Email soporte\n• Comunidad activa",
                buttons: ["Ver talleres", "¿Por qué gratis?", "Más detalles", "Ver planes"]
            },
            
            "Ver talleres": {
                message: "🎯 **Talleres Disponibles en VitaBalance:**\n\n🧘‍♀️ **Mindfulness y Meditación**\n• Técnicas de relajación\n• Manejo del estrés\n• Meditación guiada\n\n🥗 **Nutrición Inteligente**\n• Cocina saludable\n• Meal prep\n• Lectura de etiquetas\n\n💪 **Técnicas de Entrenamiento**\n• Forma correcta\n• Progresión segura\n• Prevención de lesiones\n\n🎨 **Bienestar Integral**\n• Hábitos saludables\n• Motivación constante\n• Balance vida-salud",
                buttons: ["Mindfulness", "Nutrición", "Entrenamiento", "Bienestar Integral"]
            },
            
            "Mindfulness": {
                message: "🧘‍♀️ **Taller de Mindfulness y Meditación**\n\n**¿Qué aprenderás?**\n• Técnicas de respiración consciente\n• Meditación para principiantes\n• Manejo del estrés diario\n• Relajación progresiva\n• Mindfulness en la alimentación\n\n**Duración:** 4 sesiones semanales\n**Modalidad:** En vivo + material descargable\n**Certificado:** Sí, al completar el taller\n\n**Beneficios:**\n✅ Reduce ansiedad y estrés\n✅ Mejora concentración\n✅ Mejor calidad de sueño\n✅ Mayor autocontrol",
                buttons: ["¿Cómo me inscribo?", "Ver otros talleres", "¿Es para principiantes?", "Más información"]
            },
            
            "Nutrición": {
                message: "🥗 **Taller de Nutrición Inteligente**\n\n**¿Qué aprenderás?**\n• Fundamentos de nutrición saludable\n• Cómo leer etiquetas nutricionales\n• Planificación de comidas (meal prep)\n• Recetas rápidas y saludables\n• Nutrición según tu objetivo\n\n**Duración:** 6 sesiones semanales\n**Modalidad:** En vivo + recetario descargable\n**Certificado:** Sí, al completar el taller\n\n**Beneficios:**\n✅ Aprende a comer mejor\n✅ Ahorra tiempo y dinero\n✅ Mejora tu relación con la comida\n✅ Resultados duraderos",
                buttons: ["¿Incluye recetas?", "Ver otros talleres", "¿Hay dietas específicas?", "¿Cómo me inscribo?"]
            },
            
            "Entrenamiento": {
                message: "💪 **Taller de Técnicas de Entrenamiento**\n\n**¿Qué aprenderás?**\n• Forma correcta de ejercicios básicos\n• Progresión segura de cargas\n• Prevención de lesiones\n• Diseño de rutinas personalizadas\n• Técnicas de recuperación\n\n**Duración:** 5 sesiones semanales\n**Modalidad:** En vivo + guías descargables\n**Certificado:** Sí, al completar el taller\n\n**Beneficios:**\n✅ Entrena de forma segura\n✅ Maximiza resultados\n✅ Evita lesiones\n✅ Aprende técnicas avanzadas",
                buttons: ["¿Necesito equipo?", "¿Es para principiantes?", "Ver otros talleres", "¿Cómo me inscribo?"]
            },
            
            "Bienestar Integral": {
                message: "**Taller de Bienestar Integral**\n\n**¿Qué aprenderás?**\n• Creación de hábitos saludables\n• Balance entre vida personal y fitness\n• Técnicas de motivación constante\n• Gestión del tiempo para ejercicio\n• Mindset de transformación\n\n**Duración:** 4 sesiones semanales\n**Modalidad:** En vivo + workbook descargable\n**Certificado:** Sí, al completar el taller\n\n**Beneficios:**\n✅ Hábitos que perduran\n✅ Mayor motivación\n✅ Mejor organización\n✅ Cambio de mentalidad",
                buttons: ["Ver talleres", "¿Cómo me inscribo?"]
            },
            
            "¿Cómo me inscribo?": {
                message: "📝 **Inscripción a Talleres:**\n\n**¡Súper fácil!** Una vez que te registres en VitaBalance:\n\n**1.** Accede a tu panel personal\n**2.** Ve a la sección 'Talleres'\n**3.** Selecciona el taller que te interesa\n**4.** Haz clic en 'Inscribirme'\n**5.** ¡Listo! Recibirás el calendario y enlaces\n\n**Todos los talleres son gratuitos** y puedes inscribirte a varios al mismo tiempo.\n\n**Fechas:** Los talleres inician cada 2 semanas\n**Horarios:** Múltiples opciones disponibles",
                buttons: ["Ver talleres"]
            },
            
            "Contactar soporte": {
                message: "🆘 **Soporte VitaBalance:**\n\n**Opciones de contacto:**\n📧 **Email:** soporte@vitabalance.com\n• Respuesta en 24 horas\n• Para problemas técnicos\n• Consultas detalladas\n\n💬 **Chat en vivo:** ¡Estás aquí!\n• Respuesta inmediata\n• Dudas rápidas\n• Información general\n\n👥 **Comunidad:**\n• Foro de usuarios\n• Experiencias compartidas\n• Apoyo mutuo\n\n**Horario:** 24/7 para chat, lunes-viernes email",
                buttons: ["¡Gracias!"]
            },
            
            "¿Por qué gratis?": {
                message: "🤔 **¿Por qué VitaBalance es gratis?**\n\n**Nuestra misión es simple:** Hacer el bienestar accesible para todos.\n\n**Creemos que:**\n• La salud no debería tener precio\n• Todos merecen acceso a información de calidad\n• Los resultados vienen del compromiso, no del dinero\n\n**Nos financiamos a través de:**\n• Partnerships con marcas saludables\n• Contenido premium opcional (futuro)\n• Eventos y certificaciones especiales\n\n**Tu información está segura** y nunca vendemos datos personales.",
                buttons: ["¿Habrá costos después?", "¿Es confiable?", "Ver planes", "¿Cómo se mantienen?"]
            },
            
            "¿Qué incluye?": {
                message: "🎁 **VitaBalance incluye TODO esto GRATIS:**\n\n✅ **Planes Personalizados**\n• Rutinas adaptadas a tu nivel\n• Videos explicativos HD\n• Progresión automática\n\n✅ **Nutrición Completa**\n• Guías nutricionales\n• Recetas saludables\n• Calculadoras de macros\n\n✅ **Talleres Exclusivos**\n• Sesiones en vivo\n• Material descargable\n• Certificados oficiales\n\n✅ **Soporte Total**\n• Chat 24/7 (como este 😊)\n• Email soporte\n• Comunidad activa",
                buttons: ["Ver talleres", "¿Por qué gratis?", "Más detalles", "Ver planes"]
            },
            
            "Más información": {
                message: "📋 **Información completa sobre VitaBalance:**\n\n🎯 **Misión:** Democratizar el acceso al bienestar\n🌟 **Visión:** Una comunidad global saludable\n💪 **Valores:** Accesibilidad, calidad, resultados\n\n**¿Qué nos hace diferentes?**\n• 100% gratuito, siempre\n• Planes basados en ciencia\n• Comunidad de apoyo real\n• Resultados medibles\n• Sin compromisos ocultos\n\n**Creado por expertos** en nutrición, fitness y psicología deportiva.",
                buttons: ["Ver planes", "Ver talleres", "¿Cómo funciona?", "Contactar soporte"]
            },
            
            "Ver rutinas": {
                message: "💪 **Ejemplos de rutinas VitaBalance:**\n\n**Plan Básico:**\n• Sentadillas: 3x12\n• Flexiones: 3x8-12\n• Plancha: 3x30seg\n• Cardio ligero: 15min\n\n**Express Perder:**\n• HIIT: 20min alta intensidad\n• Circuito fuerza: 30min\n• Cardio: 15min cool down\n\n**Hipertrofia:**\n• Pesas: 4-5 ejercicios por grupo\n• Series: 3-4 x 8-12 reps\n• Descanso: 60-90 segundos\n\n¡Todas con videos explicativos! 🎥",
                buttons: ["Ver planes", "¿Qué necesito?", "¿Son muy difíciles?", "Más ejemplos"]
            },
            
            "Plan nutricional": {
                message: "🥗 **Nutrición VitaBalance:**\n\n**Incluye:**\n• Guía de macronutrientes personalizada\n• Calculadora de calorías según objetivo\n• Lista de alimentos recomendados\n• Recetas fáciles y rápidas\n• Tips de meal prep\n• Hidratación óptima\n\n**Adaptado a:**\n✅ Tu objetivo (perder peso, ganar músculo)\n✅ Tu estilo de vida\n✅ Tus preferencias alimentarias\n✅ Tu presupuesto\n\n**¡Sin dietas extremas, solo hábitos saludables!** 🌱",
                buttons: ["¿Incluye recetas?", "¿Hay restricciones?", "Ver planes", "Más sobre nutrición"]
            },
            
            "Otros planes": {
                message: "📋 **Más opciones de planes:**\n\n⚡ **HIIT Power** (5 semanas)\n• Alta intensidad\n• Quemar grasa rápido\n• 30min por sesión\n\n📈 **Volumen Eficiente** (10 semanas)\n• Máxima ganancia muscular\n• Técnicas avanzadas\n• Nutrición optimizada\n\n🏆 **Avanzado Masa** (12 semanas)\n• Para expertos\n• Competición prep\n• Seguimiento detallado\n\n¿Cuál te llama más la atención?",
                buttons: ["Plan Básico", "Express Perder", "Hipertrofia", "¿Cuál me recomiendas?"]
            },
            
            "Ver todos los planes": {
                message: "🗂️ **TODOS los planes VitaBalance:**\n\n**Para Principiantes:**\n🌟 Plan Básico (4 sem)\n\n**Para Pérdida de Peso:**\n🔥 Express Perder (6 sem)\n⚡ HIIT Power (5 sem)\n\n**Para Ganancia Muscular:**\n💪 Hipertrofia (8 sem)\n📈 Volumen Eficiente (10 sem)\n🏆 Avanzado Masa (12 sem)\n\n**Todos incluyen:** Rutinas + Nutrición + Soporte\n**Todos son:** 100% Gratuitos\n\n¿Por cuál empezamos?",
                buttons: ["Plan Básico", "Express Perder", "Hipertrofia", "¿Cuál me recomiendas?"]
            },
            
            "Más consejos": {
                message: "💡 **Consejos para empezar bien:**\n\n**1. Empieza despacio** 🐌\n• No te presiones el primer día\n• La constancia es más importante que la intensidad\n\n**2. Escucha tu cuerpo** 👂\n• Dolor muscular normal vs lesión\n• Descansa cuando lo necesites\n\n**3. Sé paciente** ⏰\n• Los cambios toman 2-4 semanas\n• Celebra pequeños logros\n\n**4. Mantén la motivación** 🚀\n• Encuentra tu 'por qué'\n• Únete a la comunidad\n\n¿Necesitas motivación específica?",
                buttons: ["Ver planes", "Empezar ahora"]
            },
            
            "¿Sin gimnasio?": {
                message: "🏠 **¡Perfecto! Puedes entrenar en casa:**\n\n**Todos nuestros planes se adaptan:**\n• Plan Básico: 100% peso corporal\n• Express Perder: Mínimo equipo\n• Hipertrofia: Opciones caseras\n\n**Equipo opcional que ayuda:**\n• Pesas rusas o mancuernas\n• Bandas elásticas\n• Colchoneta\n• Barra de dominadas\n\n**Espacios mínimos:**\n• 2x2 metros es suficiente\n• Sin ruido para vecinos\n• Rutinas silenciosas disponibles\n\n¡El gimnasio eres TÚ! 💪",
                buttons: ["Plan Básico"]
            },
            
            "¿Es caro?": {
                message: "💰 **¡VitaBalance es 100% GRATIS!**\n\n**NO pagas por:**\n✅ Planes completos\n✅ Rutinas detalladas\n✅ Guías nutricionales\n✅ Videos explicativos\n✅ Seguimiento de progreso\n✅ Talleres en vivo\n✅ Soporte 24/7\n✅ Certificados\n\n**Costos opcionales (si quieres):**\n• Equipo básico: $20-50 USD\n• Suplementos: Opcional\n• Alimentos saludables: Igual presupuesto\n\n**Nuestra filosofía:** La salud no debería tener precio 🌟",
                buttons: ["¿Por qué gratis?", "Ver planes", "¿Equipo necesario?", "Empezar gratis"]
            },
            
            "Me parece bien": {
                message: "🎉 **¡Excelente actitud!**\n\n**Express Perder será perfecto para ti:**\n\n**Preparación:**\n• Mentalízate para 6 semanas intensas\n• Agenda tus entrenamientos\n• Prepara tu espacio de ejercicio\n• Stock de alimentos saludables\n\n**Lo que experimentarás:**\n✅ Semana 1-2: Adaptación\n✅ Semana 3-4: Primeros cambios\n✅ Semana 5-6: Resultados visibles\n\n**¿Listo para empezar tu transformación?** 🚀",
                buttons: ["¿Cómo empezar?", "Ver rutinas", "Plan nutricional", "¡Vamos!"]
            },
            
            "¿Hay algo más suave?": {
                message: "😊 **¡Por supuesto! Tienes opciones más suaves:**\n\n🌟 **Plan Básico** es perfecto:\n• 3 entrenamientos por semana\n• 30-45 minutos por sesión\n• Intensidad moderada\n• Progresión gradual\n• Ideal para crear el hábito\n\n**Beneficios:**\n✅ Menos intimidante\n✅ Más sostenible\n✅ Menos riesgo de lesión\n✅ Más tiempo de adaptación\n\n**Recuerda:** ¡Empezar es lo más importante! Siempre puedes subir la intensidad después. 🌱",
                buttons: ["Plan Básico", "¿Qué necesito?", "¿Cómo empezar?", "Ver otros planes"]
            },
            
            "Tengo experiencia": {
                message: "💪 **¡Perfecto! Con experiencia, Hipertrofia es ideal:**\n\n**Tu background te permite:**\n• Técnica correcta desde el inicio\n• Cargas más desafiantes\n• Progresión acelerada\n• Menor riesgo de lesión\n• Mejor conexión mente-músculo\n\n**Plan Hipertrofia incluye:**\n• Rutinas avanzadas\n• Técnicas de intensidad\n• Periodización inteligente\n• Nutrición específica\n• Seguimiento detallado\n\n**¿Listo para el siguiente nivel de tu entrenamiento?** 🚀",
                buttons: ["Ver rutinas", "Plan alimenticio", "¿Qué equipo usar?"]
            },
            
            "Ver otros talleres": {
                message: "🎯 **Otros talleres disponibles:**\n\n🧘‍♀️ **Mindfulness y Meditación**\n• Técnicas de relajación\n• Manejo del estrés\n\n🥗 **Nutrición Inteligente**\n• Cocina saludable\n• Meal prep profesional\n\n💪 **Técnicas de Entrenamiento**\n• Forma correcta\n• Prevención de lesiones\n\n🎨 **Bienestar Integral**\n• Hábitos saludables\n• Balance vida-fitness\n\n**¿Cuál te interesa más?**",
                buttons: ["Mindfulness", "Nutrición", "Entrenamiento", "Bienestar Integral"]
            },
            
            "¿Es para principiantes?": {
                message: "✅ **¡Sí! Todos nuestros talleres son aptos para principiantes:**\n\n**Diseño inclusivo:**\n• Explicaciones desde cero\n• Sin conocimiento previo requerido\n• Ritmo adaptable\n• Preguntas bienvenidas\n• Material de apoyo\n\n**Niveles disponibles:**\n• Básico: Para quien empieza\n• Intermedio: Para profundizar\n• Avanzado: Para especializarse\n\n**Nuestros instructores** están entrenados para guiar a principiantes hasta convertirlos en expertos. 🌟\n\n¡Lo único que necesitas son ganas de aprender!",
                buttons: ["¿Cómo me inscribo?", "Ver talleres", "¿Qué necesito?"]
            },
            
            "¿Incluye recetas?": {
                message: "🍽️ **¡Sí! El taller de Nutrición incluye MUCHAS recetas:**\n\n**Recetario completo:**\n• +50 recetas saludables\n• Desayunos energéticos\n• Almuerzos balanceados\n• Cenas ligeras\n• Snacks saludables\n• Bebidas naturales\n\n**Características:**\n✅ Ingredientes fáciles de conseguir\n✅ Preparación máximo 30 minutos\n✅ Aptas para toda la familia\n✅ Opciones vegetarianas/veganas\n✅ Valores nutricionales incluidos\n✅ Tips de meal prep\n\n**Bonus:** ¡Recetas exclusivas cada semana! 👨‍🍳",
                buttons: ["¿Hay dietas específicas?", "¿Cómo me inscribo?", "Ver otros talleres", "Más sobre nutrición"]
            },
            
            "¿Hay dietas específicas?": {
                message: "🎯 **¡Sí! Cubrimos múltiples enfoques nutricionales:**\n\n**Dietas incluidas:**\n🥗 **Mediterránea** - Corazón saludable\n🥑 **Keto/Low-carb** - Pérdida de peso\n🌱 **Vegetariana/Vegana** - Plant-based\n⚖️ **IIFYM** - Flexibilidad total\n🏃‍♂️ **Deportiva** - Rendimiento\n🍎 **Anti-inflamatoria** - Salud general\n\n**Lo que aprenderás:**\n• Cuál es mejor para tu objetivo\n• Cómo adaptarlas a tu estilo de vida\n• Recetas para cada enfoque\n• Transición segura entre dietas\n\n**¡Encuentra TU estilo nutricional perfecto!** ✨",
                buttons: ["¿Cuál me recomiendas?", "¿Cómo me inscribo?", "Más información"]
            },
            
            "¿Necesito equipo?": {
                message: "🛠️ **Para el taller de Entrenamiento:**\n\n**Equipo OPCIONAL (no indispensable):**\n• Pesas ligeras (2-5 kg)\n• Banda elástica\n• Colchoneta\n• Pelota de ejercicio\n\n**Lo que SÍ necesitas:**\n✅ Ropa cómoda\n✅ Toalla\n✅ Botella de agua\n✅ Espacio de 2x2 metros\n✅ ¡Muchas ganas de aprender!\n\n**¡La mayoría de ejercicios son con peso corporal!**\n\n**Durante el taller aprenderás:**\n• Cómo entrenar sin equipo\n• Alternativas caseras creativas",
                buttons: ["¿Cómo me inscribo?", "Ver otros talleres"]
            },
            
            "¡Gracias!": {
                message: "😊 **¡De nada! Ha sido un placer ayudarte.**\n\n**Recuerda que siempre puedes:**\n• Volver a chatear conmigo 24/7\n• Explorar todos nuestros planes gratuitos\n• Unirte a nuestros talleres\n• Contactar soporte si necesitas ayuda\n\n**Tu viaje hacia una vida más saludable empieza con el primer paso.** 🌟\n\n¡Espero verte pronto en la comunidad VitaBalance! 💪",
                buttons: ["Ver planes", "Ver talleres", "¡Hasta luego!"]
            },
            
            "¡Hasta luego!": {
                message: "👋 **¡Hasta la próxima!**\n\n**Que tengas un día increíble y recuerda:**\n\n💪 Tu mejor versión te está esperando\n🌟 Cada día es una nueva oportunidad\n🚀 Los pequeños pasos llevan a grandes cambios\n\n**¡Nos vemos pronto en VitaBalance!** 😊✨",
                buttons: ["Reiniciar chat"]
            },
            
            "Reiniciar chat": {
                message: "🔄 **Chat reiniciado**\n\n¡Hola de nuevo! Soy tu asistente de VitaBalance. 🤖\n\n¿En qué puedo ayudarte hoy?",
                buttons: ["Ver planes", "Ver talleres", "¿Cómo funciona?", "Contactar soporte"]
            },
            
            "¿Habrá costos después?": {
                message: "🔒 **¡Nunca! VitaBalance será siempre gratuito:**\n\n**Nuestro compromiso:**\n• Planes básicos: SIEMPRE gratis\n• Talleres fundamentales: SIEMPRE gratis\n• Soporte básico: SIEMPRE gratis\n• Comunidad: SIEMPRE gratis\n\n**Posibles servicios premium (opcional):**\n• Coaching personalizado 1:1\n• Análisis corporal avanzado\n• Certificaciones profesionales\n• Eventos presenciales\n\n**Lo esencial NUNCA costará dinero. Esa es nuestra promesa.** 🤝",
                buttons: ["¿Es confiable?", "Ver planes", "¿Cómo se mantienen?", "¡Perfecto!"]
            },
            
            "¿Es confiable?": {
                message: "🛡️ **VitaBalance es 100% confiable:**\n\n**Nuestras credenciales:**\n• Fundado por profesionales certificados\n• Planes respaldados por ciencia\n• +10,000 usuarios satisfechos\n• Transparencia total en métodos\n• Datos seguros (GDPR compliant)\n\n**Testimonios reales:**\n⭐ 4.8/5 estrellas promedio\n📈 95% completan sus planes\n💬 Comunidad activa y positiva\n\n**Puedes verificar:**\n• Nuestros certificados\n• Referencias profesionales\n• Testimonios de usuarios\n\n**Tu confianza es nuestro mayor valor.** 🌟",
                buttons: ["Ver testimonios", "Ver planes", "¿Quiénes son los creadores?", "Empezar ahora"]
            },
            
            "¿Cómo se mantienen?": {
                message: "💡 **Así mantenemos VitaBalance gratuito:**\n\n**Modelo sostenible:**\n• Partnerships éticos con marcas saludables\n• Afiliaciones transparentes (sin costo extra)\n• Servicios premium opcionales\n• Eventos corporativos\n• Certificaciones profesionales\n\n**NO hacemos:**\n❌ Vender datos personales\n❌ Publicidad invasiva\n❌ Contenido pagado oculto\n❌ Suscripciones obligatorias\n\n**Transparencia total:** Siempre sabrás si algo es promocionado.\n\n**¡Nuestra misión social es más importante que las ganancias!** 🌍",
                buttons: ["¿Por qué gratis?", "Ver planes", "¿Es seguro?", "Conocer más"]
            },
            
            "¡Perfecto!": {
                message: "🎉 **¡Genial! Me alegra que te sientas cómodo/a:**\n\n**Ya estás listo/a para:**\n• Explorar nuestros planes gratuitos\n• Unirte a los talleres disponibles\n• Formar parte de la comunidad VitaBalance\n• Comenzar tu transformación\n\n**Recuerda:**\n✅ Todo es 100% gratuito\n✅ Sin compromisos ocultos\n✅ Soporte 24/7 disponible\n✅ Comunidad de apoyo real\n\n**¡Bienvenido/a a VitaBalance!** 🌟",
                buttons: ["Ver planes", "Ver talleres", "¿Cómo funciona?", "Empezar ahora"]
            },
            
            "Ver testimonios": {
                message: "⭐ **Testimonios reales de usuarios VitaBalance:**\n\n**María, 28 años - Plan Express Perder:**\n\"Perdí 8kg en 6 semanas. ¡El mejor programa gratuito que he probado!\"\n\n**Carlos, 35 años - Plan Hipertrofia:**\n\"Gané 5kg de músculo en 2 meses. Rutinas increíbles y soporte excelente.\"\n\n**Ana, 42 años - Plan Básico:**\n\"Perfecto para principiantes. Ahora ejercitarme es parte de mi rutina diaria.\"\n\n**📊 Estadísticas:**\n• 95% completa sus planes exitosamente\n• 4.8/5 estrellas promedio\n• +10,000 usuarios satisfechos",
                buttons: ["Ver planes", "Ver talleres", "¿Es confiable?", "Empezar ahora"]
            },
            
            "¿Quiénes son los creadores?": {
                message: "👥 **Equipo VitaBalance:**\n\n**Dr. Elena Martínez** - Nutricionista Deportiva\n• PhD en Nutrición Clínica\n• +15 años de experiencia\n• Especialista en planes personalizados\n\n**Prof. Miguel Rodríguez** - Entrenador Personal\n• Certificado ACSM y NASM\n• Experto en entrenamiento funcional\n• +10 años entrenando atletas\n\n**Dra. Sofia López** - Psicóloga del Deporte\n• Especialista en motivación\n• Autora de 3 libros sobre hábitos\n• Coach de transformación personal",
                buttons: ["Ver planes", "Ver talleres", "Conocer más", "¿Es confiable?"]
            },
            
            "Conocer más": {
                message: "📚 **Conoce más sobre VitaBalance:**\n\n**Historia:**\n• Fundada en 2019 por expertos en salud\n• Equipo internacional de profesionales\n• Respaldada por investigación científica\n• Comprometida con la accesibilidad\n\n**Misión:** Democratizar el acceso a la salud y bienestar\n**Visión:** Un mundo donde todos puedan vivir saludablemente\n**Valores:** Inclusión, calidad, transparencia, resultados\n\n**¿Qué más te gustaría saber?**",
                buttons: ["Ver testimonios", "Ver planes"]
            },
            
            "¿Es seguro?": {
                message: "🔒 **¡Absolutamente! VitaBalance es 100% seguro:**\n\n**Seguridad de datos:**\n• Encriptación SSL de última generación\n• Servidores certificados\n• Cumplimiento GDPR\n• Nunca vendemos información personal\n• Backups automáticos\n\n**Seguridad de entrenamiento:**\n• Planes diseñados por profesionales\n• Progresión gradual y segura\n• Instrucciones detalladas\n• Videos de técnica correcta\n• Modificaciones para limitaciones\n\n**¡Tu seguridad es nuestra prioridad #1!** 🛡️",
                buttons: ["¿Es confiable?", "Ver planes", "¿Cómo funciona?", "Contactar soporte"]
            },
            
            "¿Es confiable?": {
                message: "🛡️ **VitaBalance es 100% confiable:**\n\n**Nuestras credenciales:**\n• Fundado por profesionales certificados\n• Planes respaldados por ciencia\n• +10,000 usuarios satisfechos\n• Transparencia total en métodos\n• Datos seguros (GDPR compliant)\n\n**Testimonios reales:**\n⭐ 4.8/5 estrellas promedio\n📈 95% completan sus planes\n💬 Comunidad activa y positiva\n\n**Puedes verificar:**\n• Nuestros certificados\n• Referencias profesionales\n• Testimonios de usuarios\n\n**Tu confianza es nuestro mayor valor.** 🌟",
                buttons: ["Ver testimonios", "Ver planes", "¿Quiénes son los creadores?", "Empezar ahora"]
            },
            
            "¿Cómo se mantienen?": {
                message: "💡 **Así mantenemos VitaBalance gratuito:**\n\n**Modelo sostenible:**\n• Partnerships éticos con marcas saludables\n• Afiliaciones transparentes (sin costo extra)\n• Servicios premium opcionales\n• Eventos corporativos\n• Certificaciones profesionales\n\n**NO hacemos:**\n❌ Vender datos personales\n❌ Publicidad invasiva\n❌ Contenido pagado oculto\n❌ Suscripciones obligatorias\n\n**Transparencia total:** Siempre sabrás si algo es promocionado.\n\n**¡Nuestra misión social es más importante que las ganancias!** 🌍",
                buttons: ["¿Por qué gratis?", "Ver planes", "¿Es seguro?", "Conocer más"]
            },
            
            "Plan alimenticio": {
                message: "🥗 **Plan Alimenticio VitaBalance:**\n\n**Personalizado según tu objetivo:**\n\n**Para Hipertrofia:**\n• Superávit calórico controlado\n• Proteína: 2-2.5g por kg peso\n• Carbohidratos: Pre/post entreno\n• Grasas saludables: 20-30%\n• Hidratación: 35ml/kg peso\n• Timing nutricional optimizado\n\n**Incluye:**\n✅ Calculadora de macros\n✅ Lista de compras\n✅ Recetas específicas\n✅ Suplementación básica\n✅ Seguimiento semanal\n\n**¡Nutrición científica, resultados reales!** 💪",
                buttons: ["¿Incluye recetas?", "¿Es complicado?", "Ver planes", "Más sobre nutrición"]
            },
            
            "¿Qué equipo usar?": {
                message: "🏋️‍♂️ **Equipo recomendado para Hipertrofia:**\n\n**Esencial:**\n• Pesas libres (mancuernas + barra)\n• Banco ajustable\n• Rack de sentadillas (si es posible)\n• Discos de diferentes pesos\n\n**Útil:**\n• Bandas elásticas (resistencia extra)\n• Polea alta/baja\n• Máquinas básicas\n\n**Alternativas caseras:**\n• Galones de agua (peso variable)\n• Mochila con libros\n• Bandas de resistencia\n• Barra de dominadas\n\n**¡También hay rutinas 100% peso corporal!** 💪",
                buttons: ["¿Sin gimnasio?", "¿Es caro?", "Ver rutinas", "Plan casero"]
            },
            
            "Más detalles": {
                message: "📋 **Detalles completos de VitaBalance:**\n\n**🎯 Planes disponibles:** 6 diferentes\n**👥 Usuarios activos:** +10,000\n**🌍 Países:** 15+ países\n**📅 Años de experiencia:** 5+ años\n**⭐ Calificación:** 4.8/5 estrellas\n\n**Equipo:**\n• Nutricionistas certificados\n• Entrenadores profesionales\n• Psicólogos deportivos\n• Desarrolladores especializados\n\n**Tecnología:**\n• App móvil nativa\n• IA para personalización\n• Seguimiento avanzado\n• Comunidad integrada",
                buttons: ["Ver planes", "Ver talleres", "¿Cómo funciona?"]
            },
            
            "¿Son muy difíciles?": {
                message: "🤔 **Las rutinas se adaptan a TU nivel:**\n\n**Nivel Principiante:**\n• Ejercicios básicos\n• Progresión muy gradual\n• 30-45 minutos\n• 3 días por semana\n\n**Nivel Intermedio:**\n• Ejercicios variados\n• Progresión moderada\n• 45-60 minutos\n• 4 días por semana\n\n**Nivel Avanzado:**\n• Ejercicios complejos\n• Progresión acelerada\n• 60-75 minutos\n• 5+ días por semana\n\n**¡Empiezas donde estés y avanzas a tu ritmo!** 🌟",
                buttons: ["Plan Básico", "¿Cómo empezar?", "Ver planes"]
            },
            
            "Más ejemplos": {
                message: "📋 **Más ejemplos de rutinas:**\n\n**HIIT Power (20 min):**\n• Burpees: 30seg work / 10seg rest\n• Mountain climbers: 30/10\n• Jump squats: 30/10\n• High knees: 30/10\n• Repetir 4 rondas\n\n**Volumen Eficiente (Upper body):**\n• Press banca: 4x8-10\n• Dominadas: 4x6-12\n• Press militar: 3x8-12\n• Remo: 3x10-12\n• Dips: 3x8-15\n\n**¡Cada plan tiene +30 rutinas diferentes!** 💪",
                buttons: ["Ver planes", "Más información"]
            },
            
            "¿Hay restricciones?": {
                message: "🚫 **Adaptamos a TODAS las restricciones:**\n\n**Restricciones alimentarias:**\n✅ Vegetariano / Vegano\n✅ Sin gluten / Celíaco\n✅ Sin lactosa\n✅ Diabetes\n✅ Hipertensión\n✅ Alergias específicas\n✅ Religión/cultura\n\n**Restricciones físicas:**\n✅ Lesiones previas\n✅ Movilidad limitada\n✅ Problemas articulares\n✅ Embarazo/postparto\n✅ Edad avanzada\n\n**¡Siempre encontramos una solución segura para ti!** 🌟",
                buttons: ["Ver planes", "Ver talleres"]
            },
            
            "Más sobre nutrición": {
                message: "🥗 **Profundizando en Nutrición VitaBalance:**\n\n**Enfoque científico:**\n• Basado en evidencia actual\n• Macronutrientes balanceados\n• Micronutrientes esenciales\n• Timing nutricional\n• Hidratación óptima\n\n**Herramientas incluidas:**\n🔢 Calculadora de calorías\n📊 Tracking de macros\n📱 App de seguimiento\n🍽️ Planificador de comidas\n📋 Lista de compras auto-generada\n\n**¡Aprende a comer bien para siempre!** 📚",
                buttons: ["Ver talleres", "¿Incluye recetas?", "Plan nutricional", "¿Es complicado?"]
            },
            
            "Intentar de nuevo": {
                message: "🔄 **¡Perfecto! Intentemos de nuevo:**\n\n¿En qué puedo ayudarte específicamente?\n\n• ¿Tienes preguntas sobre los planes de entrenamiento?\n• ¿Quieres saber sobre los talleres disponibles?\n• ¿Te interesa conocer cómo funciona VitaBalance?\n• ¿Necesitas soporte técnico?\n\n¡Estoy aquí para ayudarte con lo que necesites! 😊",
                buttons: ["Ver planes", "Ver talleres", "¿Cómo funciona?", "Contactar soporte"]
            },
            
            "Ver FAQ": {
                message: "❓ **Preguntas Frecuentes (FAQ):**\n\n**📋 ¿Es realmente gratis?**\n¡Sí! VitaBalance es 100% gratuito, siempre.\n\n**⏰ ¿Cuánto tiempo necesito diariamente?**\nEntre 30-75 minutos según el plan elegido.\n\n**🏠 ¿Puedo entrenar en casa?**\n¡Por supuesto! Todos los planes se adaptan.\n\n**📱 ¿Hay app móvil?**\nSí, disponible para iOS y Android.\n\n**🎯 ¿Funcionan realmente los planes?**\n95% de usuarios completan exitosamente.\n\n**👥 ¿Hay comunidad?**\n¡Sí! Comunidad activa de +10k usuarios.",
                buttons: ["Más preguntas", "Ver planes", "Ver talleres", "Contactar soporte"]
            },
            
            "Más preguntas": {
                message: "❓ **Más Preguntas Frecuentes:**\n\n**💰 ¿Hay costos ocultos?**\nNo, todo es transparente y gratuito.\n\n**📞 ¿Cómo contacto soporte?**\nPor email, chat o comunidad.\n\n**🏃‍♀️ ¿Puedo cambiar de plan?**\nSí, cuando quieras y sin restricciones.\n\n**📊 ¿Se guarda mi progreso?**\nSí, todo queda registrado en tu perfil.\n\n**👥 ¿Hay límite de usuarios?**\nNo, todos son bienvenidos.\n\n**🌍 ¿Está disponible en mi país?**\nSí, es accesible mundialmente.",
                buttons: ["Ver FAQ", "Ver planes", "Ver talleres", "Contactar soporte"]
            },
            
            "¡Vamos!": {
                message: "🚀 **¡Excelente actitud! ¡Vamos a transformar tu vida!**\n\n**Para empezar tu plan Express Perder:**\n\n**Paso 1:** Regístrate en VitaBalance (página principal)\n**Paso 2:** Completa tu perfil de fitness\n**Paso 3:** Descarga tu plan personalizado\n**Paso 4:** ¡Comienza tu primera rutina!\n\n**Tip de motivación:** Toma una foto el día 1 y compárala en la semana 6. ¡Te sorprenderás! 📸\n\n**¡Tu transformación empieza HOY!** 💪✨",
                buttons: ["¿Cómo empezar?", "Ver rutinas", "Plan nutricional", "¡Ya me registré!"]
            },
            
            "¡Ya me registré!": {
                message: "🎉 **¡INCREÍBLE! ¡Bienvenido/a a la familia VitaBalance!**\n\n**Siguientes pasos:**\n✅ Revisa tu email de bienvenida\n✅ Completa tu evaluación inicial\n✅ Personaliza tu plan\n✅ Únete a la comunidad\n✅ ¡Empieza tu primera rutina!\n\n**Recursos disponibles:**\n• Panel personal\n• Material descargable\n• Videos explicativos\n• Chat de la comunidad\n• Soporte 24/7\n\n**¡Estamos emocionados de ser parte de tu transformación!** 🌟",
                buttons: ["Ver planes", "¡Gracias!"]
            },
            
            "¿Es seguro?": {
                message: "🔒 **¡Absolutamente! VitaBalance es 100% seguro:**\n\n**Seguridad de datos:**\n• Encriptación SSL de última generación\n• Servidores certificados\n• Cumplimiento GDPR\n• Nunca vendemos información personal\n• Backups automáticos\n\n**Seguridad de entrenamiento:**\n• Planes diseñados por profesionales\n• Progresión gradual y segura\n• Instrucciones detalladas\n• Videos de técnica correcta\n• Modificaciones para limitaciones\n\n**¡Tu seguridad es nuestra prioridad #1!** 🛡️",
                buttons: ["¿Es confiable?", "Ver planes", "¿Cómo funciona?", "Contactar soporte"]
            },
            
            "Conocer más": {
                message: "📚 **Conoce más sobre VitaBalance:**\n\n**Historia:**\n• Fundada en 2019 por expertos en salud\n• Equipo internacional de profesionales\n• Respaldada por investigación científica\n• Comprometida con la accesibilidad\n\n**Misión:** Democratizar el acceso a la salud y bienestar\n**Visión:** Un mundo donde todos puedan vivir saludablemente\n**Valores:** Inclusión, calidad, transparencia, resultados\n\n**¿Qué más te gustaría saber?**",
                buttons: ["Ver testimonios", "Ver planes"]
            },
            
            "¿Es complicado?": {
                message: "🤔 **¡Para nada! VitaBalance está diseñado para ser súper simple:**\n\n**Fácil de usar:**\n• Interfaz intuitiva\n• Instrucciones paso a paso\n• Videos explicativos\n• Soporte 24/7\n• Calculadoras automáticas\n\n**Fácil de seguir:**\n• Planes estructurados\n• Recordatorios automáticos\n• Progresión gradual\n• Adaptable a tu ritmo\n• Sin complicaciones técnicas\n\n**¡Si sabes usar un smartphone, puedes usar VitaBalance!** 📱✨",
                buttons: ["¿Cómo empezar?", "Ver planes", "¿Qué necesito?"]
            },
            
            "Plan casero": {
                message: "🏠 **¡Perfecto! Rutinas 100% caseras:**\n\n**Plan Casero Completo:**\n• Calentamiento: 5 minutos\n• Ejercicios peso corporal: 30-45 min\n• Cardio sin saltos: 10-15 min\n• Enfriamiento: 5 minutos\n\n**Ejercicios incluidos:**\n✅ Sentadillas (todas las variantes)\n✅ Flexiones (progresión completa)\n✅ Plancha (core fuerte)\n✅ Lunges (piernas y glúteos)\n✅ Cardio silencioso (no molestar vecinos)\n\n**Equipo necesario:** ¡Solo tu cuerpo! 💪",
                buttons: ["Ver rutinas", "Empezar ahora"]
            },
            
            "¿Equipo necesario?": {
                message: "📋 **Equipo básico recomendado (opcional):**\n\n**Mínimo indispensable:**\n• Ropa cómoda\n• Toalla\n• Botella de agua\n• Espacio 2x2 metros\n\n**Útil pero opcional:**\n• Colchoneta/tapete\n• Pesas ligeras (2-5kg)\n• Banda elástica\n• Cronómetro (o app móvil)\n\n**Costo total:** $20-50 USD máximo\n**¡Muchos ejercicios no requieren nada de equipo!** 🎯",
                buttons: ["Ver planes"]
            },
            
            "Empezar gratis": {
                message: "🚀 **¡Excelente decisión! Empezar es GRATIS:**\n\n**Pasos para empezar:**\n1. Regístrate en la página principal\n2. Completa tu perfil básico\n3. Elige tu plan ideal\n4. Descarga tu primera rutina\n5. ¡Empieza tu transformación!\n\n**Lo que obtienes GRATIS:**\n✅ Plan completo personalizado\n✅ Rutinas con videos\n✅ Guía nutricional\n✅ Seguimiento de progreso\n✅ Soporte 24/7\n\n**¡Tu nueva vida saludable te espera!** 🌟",
                buttons: ["¿Cómo empezar?", "Ver planes", "¿Qué necesito?", "¡Vamos!"]
            },
            
            "Empezar ahora": {
                message: "⚡ **¡PERFECTO! ¡Empecemos AHORA mismo!**\n\n**Acción inmediata:**\n\n**Próximos 5 minutos:**\n1. Ve a la página principal de VitaBalance\n2. Haz clic en 'Registrarse Gratis'\n3. Completa tus datos básicos\n4. Elige tu primer plan\n5. ¡Descarga tu primera rutina!\n\n**¡En menos de 10 minutos tendrás todo listo para empezar!**\n\n**Tip:** Guarda este chat por si necesitas ayuda. 🤖",
                buttons: ["Ver planes", "¡Ya me registré!"]
            },
            
            "default": {
                message: "¡Interesante elección! 😊 Déjame ayudarte con más información sobre VitaBalance. ¿Qué te gustaría saber específicamente?",
                buttons: ["Ver planes", "Ver talleres", "¿Cómo funciona?", "Contactar soporte"]
            }
        };
        
        return responses[buttonText] || responses["default"];
    }
    
    addBotMessage(content) {
        const botMessage = {
            type: 'bot',
            content: content,
            timestamp: new Date()
        };
        
        this.messages.push(botMessage);
        this.displayMessage(botMessage);
    }
    
    getMessageHistory() {
        return this.messages;
    }
    
    clearChat() {
        this.messages = [];
        this.messagesContainer.innerHTML = '';
        this.clearResponseButtons();
        this.showWelcomeMessage();
        this.suggestionsContainer.style.display = 'flex';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    if (!window.vitaBalanceChatbot) {
        window.vitaBalanceChatbot = new VitaBalanceChatbot();
        
        window.openVitaBalanceChat = function() {
            window.vitaBalanceChatbot.openChat();
        };
        
        console.log('🚀 VitaBalance Chatbot cargado exitosamente');
    }
});

if (typeof module !== 'undefined' && module.exports) {
    module.exports = VitaBalanceChatbot;
}
