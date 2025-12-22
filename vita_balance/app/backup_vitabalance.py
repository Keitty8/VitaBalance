import subprocess
from getpass import getpass
import os

# Configuración de la base de datos
pg_dump_path = r"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe"  # Ruta a pg_dump.exe
host = "localhost"
port = "5433"
user = "postgres"
database = "vitabalance"
output_file = os.path.expanduser(r"~\Downloads\vitabalance_backup.sql")  # Carpeta Descargas

# Solicitar contraseña de forma segura
password = getpass("Ingresa la contraseña de PostgreSQL: ")

# Construir el comando
command = [
    pg_dump_path,
    "-U", user,
    "-h", host,
    "-p", port,
    "-F", "c",   # Formato custom (puede cambiar a "p" para plain SQL)
    "-f", output_file,
    database
]

# Ejecutar pg_dump con la variable de entorno PGPASSWORD
env = os.environ.copy()
env["espoch1234"] = password

try:
    subprocess.run(command, check=True, env=env)
    print(f"Backup realizado correctamente en: {output_file}")
except subprocess.CalledProcessError as e:
    print("Error al generar el backup:", e)
