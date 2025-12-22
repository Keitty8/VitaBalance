from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from flask_login import login_required, current_user
from datetime import datetime
from app import db
from app.models.plan_salud import PlanPerderPeso, PlanGanarMasa, PlanSalud
from app.models.taller import Taller, ContenidoTaller
from app.models.user import User

bp = Blueprint('dashboard', __name__)

@bp.route('/user/dashboard', methods=['GET', 'POST'])
@login_required
def dashboard():
    if request.method == 'POST':
        peso = int(request.form['peso'])
        altura = int(request.form['altura'])
        actividad = request.form['actividad']
        objetivo = request.form['objetivo']

        current_user.peso = peso
        current_user.altura = altura
        current_user.actividad = actividad
        current_user.objetivo = objetivo
        db.session.commit()

        try:
            #PlanPerderPeso.query.filter_by(user_id=current_user.id).delete()
            #PlanGanarMasa.query.filter_by(user_id=current_user.id).delete()
            #PlanPerderPeso.query.filter_by(user_id=current_user.id).delete(synchronize_session=False)
            #PlanGanarMasa.query.filter_by(user_id=current_user.id).delete(synchronize_session=False)
            planes_a_borrar = PlanPerderPeso.query.filter_by(user_id=current_user.id).all()
            for p in planes_a_borrar:
                db.session.delete(p)
            db.session.commit()
            planes_ganar = PlanGanarMasa.query.filter_by(user_id=current_user.id).all()
            for p in planes_ganar:
                db.session.delete(p)
            db.session.commit()
            
            planes_base = PlanSalud.query.filter_by(user_id=current_user.id, tipo='plan_salud').all()
            for plan in planes_base:
                db.session.delete(plan)
            
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            print(f'Error eliminando planes: {e}')
            flash('Error actualizando el plan. Inténtalo de nuevo.', 'error')
        
        plan = None
        try:
            if objetivo == 'perder_peso':
                plan = PlanPerderPeso(
                    nombre='Plan Personalizado para Perder Peso', 
                    user_id=current_user.id,
                    imagen='express_perder.png'  
                )
            elif objetivo == 'ganar_masa':
                plan = PlanGanarMasa(
                    nombre='Plan Personalizado para Ganar Masa', 
                    user_id=current_user.id,
                    imagen='hipertrofia.png'  
                )
            else:
                plan = PlanSalud(
                    nombre='Plan Personalizado de Bienestar', 
                    user_id=current_user.id,
                    imagen='plan_basico.png',
                    tipo='plan_salud'
                )

            if plan:
                plan.generar_plan(peso, altura, actividad)
                db.session.add(plan)
                db.session.commit()
                flash('¡Tu plan personalizado ha sido actualizado!', 'success')
        except Exception as e:
            db.session.rollback()
            print(f'Error creando plan: {e}')
            flash('Error creando el plan. Inténtalo de nuevo.', 'error')

        return redirect(url_for('dashboard.dashboard'))

    plan = None
    if current_user.objetivo == 'perder_peso':
        plan = PlanPerderPeso.query.filter_by(user_id=current_user.id).order_by(PlanPerderPeso.id.desc()).first()
    elif current_user.objetivo == 'ganar_masa':
        plan = PlanGanarMasa.query.filter_by(user_id=current_user.id).order_by(PlanGanarMasa.id.desc()).first()
    else:
        plan = PlanSalud.query.filter_by(user_id=current_user.id, tipo='plan_salud').order_by(PlanSalud.id.desc()).first()
    
    planes = [plan] if plan else []
    
    if current_user.objetivo and current_user.actividad:
        talleres = Taller.query.filter(
            Taller.objetivo == current_user.objetivo,
            Taller.nivel_actividad == current_user.actividad,
            Taller.fecha > datetime.now()
        ).order_by(Taller.fecha).all()
        
        if not talleres:
            talleres = Taller.query.filter(
                Taller.objetivo == current_user.objetivo,
                Taller.fecha > datetime.now()
            ).order_by(Taller.fecha).all()
            
        if not talleres:
            talleres = Taller.query.filter(
                Taller.nivel_actividad == current_user.actividad,
                Taller.fecha > datetime.now()
            ).order_by(Taller.fecha).limit(4).all()
            
    elif current_user.objetivo:
        talleres = Taller.query.filter(
            Taller.objetivo == current_user.objetivo,
            Taller.fecha > datetime.now()
        ).order_by(Taller.fecha).all()
    else:
        talleres = Taller.query.filter(
            Taller.fecha > datetime.now()
        ).order_by(Taller.fecha).limit(6).all()

    return render_template('dashboard.html', user=current_user, planes=planes, talleres=talleres)

@bp.route('/taller/<int:id>')
@login_required
def ver_taller(id):
    """Mostrar detalles completos del taller"""
    taller = Taller.query.get_or_404(id)
    esta_inscrito = current_user in taller.participantes
    puede_inscribirse = taller.puede_inscribirse(current_user)
    
    return render_template('taller_detalle.html', 
                         taller=taller, 
                         esta_inscrito=esta_inscrito,
                         puede_inscribirse=puede_inscribirse,
                         user=current_user)

@bp.route('/taller/<int:id>/inscribirse', methods=['POST'])
@login_required
def inscribirse_taller(id):
    """Inscribirse a un taller"""
    taller = Taller.query.get_or_404(id)
    
    if current_user in taller.participantes:
        flash('Ya estás inscrito en este taller.', 'info')
    elif taller.esta_lleno:
        flash('Este taller ya no tiene cupos disponibles.', 'warning')
    else:
        taller.participantes.append(current_user)
        db.session.commit()
        flash(f'¡Te has inscrito exitosamente al taller "{taller.nombre}"!', 'success')
    
    return redirect(url_for('dashboard.ver_taller', id=id))

@bp.route('/taller/<int:id>/desinscribirse', methods=['POST'])
@login_required
def desinscribirse_taller(id):
    """Desinscribirse de un taller"""
    taller = Taller.query.get_or_404(id)
    
    if current_user in taller.participantes:
        taller.participantes.remove(current_user)
        db.session.commit()
        flash(f'Te has desinscrito del taller "{taller.nombre}".', 'info')
    else:
        flash('No estás inscrito en este taller.', 'warning')
    
    return redirect(url_for('dashboard.ver_taller', id=id))

@bp.route('/mis-talleres')
@login_required
def mis_talleres():
    """Ver talleres en los que el usuario está inscrito"""
    talleres_inscritos = current_user.talleres_inscritos
    return render_template('mis_talleres.html', talleres=talleres_inscritos, user=current_user)

@bp.route('/taller/<int:id>/contenido')
@login_required
def contenido_taller(id):
    """Ver el contenido completo del taller"""
    taller = Taller.query.get_or_404(id)
    
    if current_user not in taller.participantes:
        flash('Debes estar inscrito en este taller para acceder al contenido.', 'warning')
        return redirect(url_for('dashboard.ver_taller', id=id))
    
    rutinas_diarias, otros_contenidos = taller.get_contenidos_por_dia()
    progreso = taller.get_progreso(current_user)
    siguiente_contenido = taller.get_siguiente_contenido(current_user)
    
    return render_template('taller_contenido.html', 
                         taller=taller,
                         rutinas_diarias=rutinas_diarias,
                         otros_contenidos=otros_contenidos,
                         progreso=progreso,
                         siguiente_contenido=siguiente_contenido,
                         user=current_user)

@bp.route('/taller/<int:taller_id>/contenido/<int:contenido_id>/completar', methods=['POST'])
@login_required
def completar_contenido(taller_id, contenido_id):
    """Marcar un contenido como completado"""
    taller = Taller.query.get_or_404(taller_id)
    contenido = ContenidoTaller.query.get_or_404(contenido_id)
    
    if current_user not in taller.participantes:
        return jsonify({'error': 'No estás inscrito en este taller'}), 403
    
    if contenido.taller_id != taller.id:
        return jsonify({'error': 'Contenido no válido'}), 400
    
    contenido.marcar_completado(current_user)
    
    nuevo_progreso = taller.get_progreso(current_user)
    
    return jsonify({
        'success': True,
        'progreso': nuevo_progreso,
        'mensaje': f'¡Contenido "{contenido.titulo}" completado!'
    })

@bp.route('/taller/<int:taller_id>/progreso')
@login_required
def progreso_taller(taller_id):
    """API para obtener el progreso actual del taller"""
    taller = Taller.query.get_or_404(taller_id)
    
    if current_user not in taller.participantes:
        return jsonify({'error': 'No estás inscrito en este taller'}), 403
    
    progreso = taller.get_progreso(current_user)
    contenidos_completados = [
        {
            'id': contenido.id,
            'titulo': contenido.titulo,
            'completado': contenido.esta_completado_por(current_user)
        }
        for contenido in taller.contenidos
    ]
    
    return jsonify({
        'progreso': progreso,
        'contenidos': contenidos_completados
    })

@bp.route('/guia-talleres')
@login_required
def guia_talleres():
    """Muestra la guía de cómo usar los talleres"""
    return render_template('guia_talleres.html', user=current_user)
