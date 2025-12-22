from flask import Blueprint, render_template, request, redirect, url_for, flash
from werkzeug.security import generate_password_hash, check_password_hash
from app.models.user import User
from app import db
from flask_login import login_user, logout_user, login_required
from sqlalchemy.exc import IntegrityError

bp = Blueprint('auth', __name__, url_prefix='/auth')

@bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user = User.query.filter_by(email=email).first()
        if user and check_password_hash(user.password, password):
            login_user(user)
            print("ROL del usuario:", user.role)

            flash('Inicio de sesión exitoso', 'success')
            if user.role == 'admin':
                return redirect(url_for('admin.dashboard'))
            else:
                return redirect(url_for('dashboard.dashboard'))
        else:
            flash('Credenciales incorrectas', 'error')
            return redirect(url_for('auth.login'))

    return render_template('login.html')

@bp.route('/register', methods=['POST'])
def register():
    username = request.form['username']
    email = request.form['email']
    password = request.form['password']
    objetivo = request.form['objetivo']
    genero = request.form['genero']
    peso = request.form['peso']
    altura = request.form['altura']
    actividad = request.form['actividad']

    existing_user = User.query.filter((User.username == username) | (User.email == email)).first()
    if existing_user:
        print("⚠ Usuario ya registrado:", existing_user.username)
        flash('Usuario o correo ya registrado.')
        return redirect(url_for('home.index'))


    hashed_pw = generate_password_hash(password)
    new_user = User(username=username, email=email, password=hashed_pw, objetivo=objetivo, genero=genero, peso=int(peso), altura=int(altura), actividad=actividad)
    
    try:
        db.session.add(new_user)
        db.session.commit()
        
        login_user(new_user)

        if new_user.role == 'admin':
            return redirect(url_for('admin.dashboard'))
        return redirect(url_for('dashboard.dashboard'))
        
    except IntegrityError as e:
        db.session.rollback()
        print(f"Error de integridad en la base de datos: {str(e)}")
        
        if "duplicate key value violates unique constraint" in str(e) and "users_pkey" in str(e):
            flash('Error interno del sistema. Por favor, intenta de nuevo en unos momentos.', 'error')
        else:
            flash('Error al crear el usuario. Verifica que el nombre de usuario y email no estén ya en uso.', 'error')
        
        return redirect(url_for('home.index'))
    except Exception as e:
        db.session.rollback()
        print(f"Error inesperado: {str(e)}")
        flash('Error inesperado al crear el usuario. Por favor, intenta de nuevo.', 'error')
        return redirect(url_for('home.index'))

@bp.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Sesión cerrada correctamente', 'info')
    return redirect(url_for('home.index'))
