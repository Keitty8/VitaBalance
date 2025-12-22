from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user
from app import db
from app.models.taller import Taller

bp = Blueprint('talleres', __name__, url_prefix='/talleres')

@bp.route('/')
@login_required
def index():
    if current_user.role != 'admin':
        flash('Acceso restringido solo para administradores.', 'warning')
        return redirect(url_for('dashboard.dashboard'))
        
    talleres = Taller.query.all()
    return render_template('talleres/index.html', talleres=talleres)

@bp.route('/crear', methods=['GET', 'POST'])
@login_required
def crear():
    if current_user.role != 'admin':
        flash('Solo el administrador puede crear talleres.', 'danger')
        return redirect(url_for('talleres.index'))
        
    if request.method == 'POST':
        nombre = request.form['nombre']
        descripcion = request.form['descripcion']
        dias_semana = request.form['dias_semana']
        cupos = request.form['cupos']
        objetivo = request.form['objetivo']
        nivel_actividad = request.form.get('nivel_actividad', 'moderado')
        taller = Taller(nombre=nombre, descripcion=descripcion, dias_semana=dias_semana, cupos=int(cupos), objetivo=objetivo, nivel_actividad=nivel_actividad)

        db.session.add(taller)
        db.session.commit()

        flash('Taller creado correctamente', 'success')
        return redirect(url_for('talleres.index'))

    return render_template('talleres/crear.html')

@bp.route('/editar/<int:id>', methods=['GET', 'POST'])
@login_required
def editar(id):
    if current_user.role != 'admin':
        flash('Solo el administrador puede editar talleres.', 'danger')
        return redirect(url_for('talleres.index'))
        
    taller = Taller.query.get_or_404(id)
    
    if request.method == 'POST':
        taller.nombre = request.form['nombre']
        taller.descripcion = request.form['descripcion']
        taller.dias_semana = request.form['dias_semana']
        taller.cupos = int(request.form['cupos'])
        taller.objetivo = request.form['objetivo']
        taller.nivel_actividad = request.form.get('nivel_actividad', taller.nivel_actividad or 'moderado')
        
        db.session.commit()
        flash('Taller actualizado correctamente', 'success')
        return redirect(url_for('talleres.index'))
    
    return render_template('talleres/editar.html', taller=taller)

@bp.route('/eliminar/<int:id>', methods=['POST'])
@login_required
def eliminar(id):
    if current_user.role != 'admin':
        flash('Solo el administrador puede eliminar talleres.', 'danger')
        return redirect(url_for('talleres.index'))
        
    taller = Taller.query.get_or_404(id)
    db.session.delete(taller)
    db.session.commit()
    
    flash('Taller eliminado correctamente', 'success')
    return redirect(url_for('talleres.index'))
