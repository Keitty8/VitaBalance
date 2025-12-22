from flask import Blueprint, render_template, jsonify, request
from flask_login import login_required, current_user
from app.models.user import User
from app.models.plan_salud import PlanSalud
from app.models.taller import Taller
from app import db
from datetime import datetime, timedelta
from sqlalchemy import func, extract

bp = Blueprint('admin', __name__, url_prefix='/admin')

@bp.route('/dashboard')
@login_required
def dashboard():
    if current_user.role != 'admin':
        return "Acceso denegado", 403
    return render_template('admin/dashboard.html')

@bp.route('/estadisticas')
@login_required
def estadisticas():
    if current_user.role != 'admin':
        return jsonify({})

    periodo = request.args.get('periodo', 'total') 
    
    objetivos = db.session.query(User.objetivo, func.count(User.id)).group_by(User.objetivo).all()
    usuarios_por_objetivo = {(obj or 'Sin objetivo'): count for obj, count in objetivos}

    tipos = db.session.query(PlanSalud.tipo, func.count(PlanSalud.id)).group_by(PlanSalud.tipo).all()
    planes_por_tipo = {(tipo or 'Sin tipo'): count for tipo, count in tipos}
    
    generos = db.session.query(User.genero, func.count(User.id)).group_by(User.genero).all()
    usuarios_por_genero = {(gen or 'No especificado'): count for gen, count in generos}
    
    actividades = db.session.query(User.actividad, func.count(User.id)).group_by(User.actividad).all()
    usuarios_por_actividad = {(act or 'No especificado'): count for act, count in actividades}
    
    talleres_obj = db.session.query(Taller.objetivo, func.count(Taller.id)).group_by(Taller.objetivo).all()
    talleres_por_objetivo = {(obj or 'Sin objetivo'): count for obj, count in talleres_obj}
    
    total_cupos = db.session.query(func.sum(Taller.cupos)).scalar() or 0
    promedio_cupos = db.session.query(func.avg(Taller.cupos)).scalar() or 0
    
    total_usuarios = User.query.count()
    total_planes = PlanSalud.query.count()
    total_talleres = Taller.query.count()
    
    calorias_por_tipo = db.session.query(
        PlanSalud.tipo, 
        func.avg(PlanSalud.calorias)
    ).filter(PlanSalud.calorias.isnot(None)).group_by(PlanSalud.tipo).all()
    
    promedio_calorias = {tipo: round(avg, 0) for tipo, avg in calorias_por_tipo if avg}

    return jsonify({
        "usuarios_por_objetivo": usuarios_por_objetivo,
        "planes_por_tipo": planes_por_tipo,
        "usuarios_por_genero": usuarios_por_genero,
        "usuarios_por_actividad": usuarios_por_actividad,
        "talleres_por_objetivo": talleres_por_objetivo,
        "estadisticas_generales": {
            "total_usuarios": total_usuarios,
            "total_planes": total_planes,
            "total_talleres": total_talleres,
            "total_cupos": total_cupos,
            "promedio_cupos": round(promedio_cupos, 1)
        },
        "promedio_calorias": promedio_calorias
    })
