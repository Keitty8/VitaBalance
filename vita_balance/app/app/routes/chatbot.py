from flask import Blueprint, request, jsonify, render_template
from app.services.chatbot import vitabalance_bot

bp = Blueprint('chatbot', __name__, url_prefix='/api')

@bp.route('/test')
def test_page():
    """Página de prueba del chatbot"""
    return render_template('chatbot_test.html')

@bp.route('/chat', methods=['POST'])
def chat():
    """Endpoint para el chatbot"""
    try:
        data = request.get_json()
        
        if not data or 'message' not in data:
            return jsonify({
                'error': 'Mensaje requerido',
                'response': 'Por favor, envía un mensaje para poder ayudarte. 😊'
            }), 400
        
        user_message = data['message'].strip()
        
        if not user_message:
            return jsonify({
                'error': 'Mensaje vacío',
                'response': '¿En qué puedo ayudarte hoy? Pregúntame sobre nuestros planes, talleres o cualquier duda sobre VitaBalance. 💬'
            }), 400
        
        # Generar respuesta del chatbot
        bot_response_data = vitabalance_bot.get_contextual_response(user_message)
        
        # Manejar tanto respuestas string como dict
        if isinstance(bot_response_data, dict):
            response_message = bot_response_data.get("message", "")
            response_buttons = bot_response_data.get("buttons", [])
            response_topic = bot_response_data.get("topic", "")
        else:
            # Compatibilidad hacia atrás para respuestas string
            response_message = str(bot_response_data)
            response_buttons = []
            response_topic = ""
        
        return jsonify({
            'success': True,
            'response': response_message,
            'buttons': response_buttons,
            'topic': response_topic,
            'timestamp': '2025-06-30T00:00:00Z'
        })
        
    except Exception as e:
        return jsonify({
            'error': 'Error interno del servidor',
            'response': 'Disculpa, hubo un error. Por favor contacta a soporte@vitabalance.com o intenta nuevamente. 🛠️'
        }), 500

@bp.route('/chat/health', methods=['GET'])
def health_check():
    """Endpoint para verificar el estado del chatbot"""
    return jsonify({
        'status': 'healthy',
        'service': 'VitaBalance Chatbot',
        'version': '1.0.0'
    })
