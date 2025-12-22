"""Inicial con SQLite

Revision ID: 951fb2dcc469
Revises: 
Create Date: 2025-06-26 22:30:05.088365

"""
from alembic import op
import sqlalchemy as sa


revision = '951fb2dcc469'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    op.create_table('planes_salud',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('nombre', sa.String(length=100), nullable=False),
    sa.Column('descripcion', sa.Text(), nullable=True),
    sa.Column('tipo', sa.String(length=50), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('talleres',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('nombre', sa.String(length=100), nullable=False),
    sa.Column('descripcion', sa.Text(), nullable=True),
    sa.Column('horario', sa.String(length=100), nullable=False),
    sa.Column('cupos', sa.Integer(), nullable=False),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('users',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('username', sa.String(length=64), nullable=False),
    sa.Column('email', sa.String(length=120), nullable=False),
    sa.Column('password', sa.String(length=128), nullable=False),
    sa.Column('role', sa.String(length=20), nullable=True),
    sa.Column('objetivo', sa.String(length=50), nullable=True),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('email'),
    sa.UniqueConstraint('username')
    )
    op.create_table('planes_ganar_masa',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['id'], ['planes_salud.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('planes_perder_peso',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['id'], ['planes_salud.id'], ),
    sa.PrimaryKeyConstraint('id')
    )


def downgrade():
    op.drop_table('planes_perder_peso')
    op.drop_table('planes_ganar_masa')
    op.drop_table('users')
    op.drop_table('talleres')
    op.drop_table('planes_salud')
