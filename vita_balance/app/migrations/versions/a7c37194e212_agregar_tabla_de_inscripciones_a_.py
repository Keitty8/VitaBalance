"""Agregar tabla de inscripciones a talleres

Revision ID: a7c37194e212
Revises: 1d35dffdb6b4
Create Date: 2025-06-29 23:33:35.852967

"""
from alembic import op
import sqlalchemy as sa


revision = 'a7c37194e212'
down_revision = '1d35dffdb6b4'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table('inscripciones',
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('taller_id', sa.Integer(), nullable=False),
    sa.Column('fecha_inscripcion', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['taller_id'], ['talleres.id'], ),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
    sa.PrimaryKeyConstraint('user_id', 'taller_id')
    )
    with op.batch_alter_table('planes_salud', schema=None) as batch_op:
        batch_op.drop_column('imagen')



def downgrade():
    with op.batch_alter_table('planes_salud', schema=None) as batch_op:
        batch_op.add_column(sa.Column('imagen', sa.VARCHAR(length=255), autoincrement=False, nullable=True))

    op.drop_table('inscripciones')
