from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user
from app import db
from app.models.plan_salud import PlanSalud, PlanPerderPeso, PlanGanarMasa

bp = Blueprint('planes', __name__, url_prefix='/planes')

@bp.route('/')
@login_required
def index():
    if current_user.role != 'admin':
        flash('Acceso restringido solo para administradores.', 'warning')
        return redirect(url_for('dashboard.dashboard'))

    planes = PlanSalud.query.all()
    return render_template('planes/index.html', planes=planes)

@bp.route('/crear', methods=['GET', 'POST'])
@login_required
def crear():
    if current_user.role != 'admin':
        flash('Solo el administrador puede crear planes.', 'danger')
        return redirect(url_for('planes.index'))

    if request.method == 'POST':
        tipo = request.form.get('tipo')
        nombre = request.form.get('nombre')
        descripcion = request.form.get('descripcion')
        imagen = request.form.get('imagen')

        if tipo == 'perder_peso':
            plan = PlanPerderPeso(nombre=nombre, descripcion=descripcion, imagen=imagen, user_id=current_user.id)
        elif tipo == 'ganar_masa':
            plan = PlanGanarMasa(nombre=nombre, descripcion=descripcion, imagen=imagen, user_id=current_user.id)
        else:
            flash('Tipo de plan no válido', 'error')
            return redirect(url_for('planes.crear'))
        
        # ✅ Validar peso y altura antes de generar el plan
        peso = current_user.peso or 70       # valor por defecto si es None
        altura = current_user.altura or 170  # valor por defecto si es None
        actividad = current_user.actividad or 'moderada'

        try:
            plan.generar_plan(peso, altura, actividad)
        except Exception as e:
            flash(f'Error al generar el plan: {str(e)}', 'danger')
            return redirect(url_for('planes.crear'))

        db.session.add(plan)
        db.session.commit()
        flash('Plan generado correctamente', 'success')
        return redirect(url_for('planes.index'))

    return render_template('planes/crear.html')

@bp.route('/editar/<int:id>', methods=['GET', 'POST'])
@login_required
def editar(id):
    if current_user.role != 'admin':
        flash('Solo el administrador puede editar planes.', 'danger')
        return redirect(url_for('planes.index'))

    plan = PlanSalud.query.get_or_404(id)

    if request.method == 'POST':
        plan.nombre = request.form['nombre']
        plan.descripcion = request.form['descripcion']
        plan.tipo = request.form['tipo']
        plan.imagen = request.form.get('imagen')
        plan.calorias = int(request.form['calorias']) if request.form['calorias'] else None
        plan.proteinas = int(request.form['proteinas']) if request.form['proteinas'] else None
        plan.rutina = request.form['rutina']
        
        db.session.commit()
        flash('Plan actualizado correctamente', 'success')
        return redirect(url_for('planes.index'))

    return render_template('planes/editar.html', plan=plan)

@bp.route('/eliminar/<int:id>', methods=['POST'])
@login_required
def eliminar(id):
    if current_user.role != 'admin':
        flash('Solo el administrador puede eliminar planes.', 'danger')
        return redirect(url_for('planes.index'))

    plan = PlanSalud.query.get_or_404(id)
    db.session.delete(plan)
    db.session.commit()
    flash('Plan eliminado', 'success')
    return redirect(url_for('planes.index'))
