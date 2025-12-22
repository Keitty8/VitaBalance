from flask import Blueprint, render_template

bp = Blueprint('pages', __name__, url_prefix='/pages')

@bp.route('/blog')
def blog():
    return render_template('pages/blog.html')

@bp.route('/faq')
def faq():
    return render_template('pages/faq.html')

@bp.route('/soporte')
def soporte():
    return render_template('pages/soporte.html')

@bp.route('/terminos')
def terminos():
    return render_template('pages/terminos.html')

@bp.route('/privacidad')
def privacidad():
    return render_template('pages/privacidad.html')

@bp.route('/sobre_nosotros')
def sobre_nosotros():
    return render_template('pages/sobre_nosotros.html')

@bp.route('/contacto')
def contacto():
    return render_template('pages/contacto.html')
