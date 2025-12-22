"""Aumentar tamaño del campo password

Revision ID: 678d628b48bb
Revises: 951fb2dcc469
Create Date: 2025-06-26 22:32:51.859287

"""
from alembic import op
import sqlalchemy as sa


revision = '678d628b48bb'
down_revision = '951fb2dcc469'
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.alter_column('password',
               existing_type=sa.VARCHAR(length=128),
               type_=sa.String(length=512),
               existing_nullable=False)



def downgrade():
    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.alter_column('password',
               existing_type=sa.String(length=512),
               type_=sa.VARCHAR(length=128),
               existing_nullable=False)

