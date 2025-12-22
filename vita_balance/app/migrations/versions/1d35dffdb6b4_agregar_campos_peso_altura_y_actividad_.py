"""Agregar campos peso, altura y actividad al usuario

Revision ID: 1d35dffdb6b4
Revises: fc9cf8e5d651
Create Date: 2025-06-28 00:16:07.405734

"""
from alembic import op
import sqlalchemy as sa


revision = '1d35dffdb6b4'
down_revision = 'fc9cf8e5d651'
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.add_column(sa.Column('genero', sa.String(length=10), nullable=True))



def downgrade():
    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.drop_column('genero')

