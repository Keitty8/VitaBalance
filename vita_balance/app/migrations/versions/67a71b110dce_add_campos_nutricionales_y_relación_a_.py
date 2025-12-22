"""Add campos nutricionales y relación a PlanSalud

Revision ID: 67a71b110dce
Revises: dee1bad3b19b
Create Date: 2025-06-27 23:35:31.517718

"""
from alembic import op
import sqlalchemy as sa


revision = '67a71b110dce'
down_revision = 'dee1bad3b19b'
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table('planes_salud', schema=None) as batch_op:
        batch_op.add_column(sa.Column('calorias', sa.Integer(), nullable=True))
        batch_op.add_column(sa.Column('proteinas', sa.Integer(), nullable=True))
        batch_op.add_column(sa.Column('rutina', sa.Text(), nullable=True))
        batch_op.add_column(sa.Column('user_id', sa.Integer(), nullable=True))
        batch_op.create_foreign_key(None, 'users', ['user_id'], ['id'])



def downgrade():
    with op.batch_alter_table('planes_salud', schema=None) as batch_op:
        batch_op.drop_constraint(None, type_='foreignkey')
        batch_op.drop_column('user_id')
        batch_op.drop_column('rutina')
        batch_op.drop_column('proteinas')
        batch_op.drop_column('calorias')

