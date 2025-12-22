SELECT * FROM public.users
ORDER BY id ASC 

ALTER TABLE talleres
ADD COLUMN IF NOT EXISTS dias_semana VARCHAR(100) NOT NULL DEFAULT 'Lunes',
ADD COLUMN IF NOT EXISTS nivel_actividad VARCHAR(20);

ALTER TABLE talleres DROP COLUMN nivel_actividad;


UPDATE users 
SET password = 'scrypt:32768:8:1$2kooCEmAdcuKROSM$b77b856de7e73b86de7bbdba9d4e4e3435398f0af50528e9ab6d457db8919cea90344ca8b28db3b6ea28c9ad7ad7ac05038793d4935ac73dda1a5025cf9c47e5'
WHERE email = 'admin@admin.com';

ALTER TABLE users ALTER COLUMN peso TYPE VARCHAR(256);
ALTER TABLE users ALTER COLUMN altura TYPE VARCHAR(256);
ALTER TABLE users ALTER COLUMN genero TYPE VARCHAR(256);


--1) VER LAS TABLAS DE SCHEMA PUBLIC
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- 2) CREAR LOS SCHEMAS
CREATE SCHEMA usuarios AUTHORIZATION postgres;
CREATE SCHEMA planes AUTHORIZATION postgres;
CREATE SCHEMA talleres AUTHORIZATION postgres;
CREATE SCHEMA auditoria AUTHORIZATION postgres;
CREATE SCHEMA migrations AUTHORIZATION postgres;  -- opcional para alembic_version

-- 3) MOVER TABLAS del schema public a los nuevos schemas
-- mover primero tablas que no dependen de otras (o secuencias)
ALTER TABLE public.planes_salud SET SCHEMA planes;
ALTER TABLE public.planes_ganar_masa SET SCHEMA planes;
ALTER TABLE public.planes_perder_peso SET SCHEMA planes;

ALTER TABLE public.talleres SET SCHEMA talleres;

-- users e inscripciones (inscripciones referencia users y talleres)
ALTER TABLE public.users SET SCHEMA usuarios;
ALTER TABLE public.inscripciones SET SCHEMA usuarios;

-- alembic_version la colocamos en migrations (opcional)
ALTER TABLE public.alembic_version SET SCHEMA migrations;


--6) MOVER SECUENCIAS Y AJUSTAR DEFAULTs
--Las secuencias están en public. Mueve las secuencias correspondientes 
--y actualiza los DEFAULT para apuntar a la nueva ruta:

-- Mover secuencias
ALTER SEQUENCE public.planes_salud_id_seq SET SCHEMA planes;
ALTER SEQUENCE public.talleres_id_seq SET SCHEMA talleres;
ALTER SEQUENCE public.users_id_seq SET SCHEMA usuarios;

-- Reajustar DEFAULTs a la nueva ruta (por si el nextval se referenciaba con public.*)
ALTER TABLE planes.planes_salud ALTER COLUMN id SET DEFAULT nextval('planes.planes_salud_id_seq'::regclass);
ALTER TABLE talleres.talleres ALTER COLUMN id SET DEFAULT nextval('talleres.talleres_id_seq'::regclass);
ALTER TABLE usuarios.users ALTER COLUMN id SET DEFAULT nextval('usuarios.users_id_seq'::regclass);

--7) CREAR auditoria.tb_auditoria y auditoria.tb_error
CREATE TABLE auditoria.tb_auditoria (
    id serial PRIMARY KEY,
    fecha timestamptz NOT NULL DEFAULT now(),
    usuario_id integer NULL,               -- id del usuario que hizo la acción (si aplica)
    modulo character varying(100) NOT NULL, -- módulo o fuente (ej: 'usuarios', 'talleres')
    accion character varying(100) NOT NULL, -- tipo: 'INSERT', 'UPDATE', 'DELETE', etc.
    descripcion text,                       -- descripción humana
    datos jsonb                             -- datos adicionales (payload, antes/despues)
);

CREATE TABLE auditoria.tb_error (
    id serial PRIMARY KEY,
    fecha timestamptz NOT NULL DEFAULT now(),
    nivel character varying(20) DEFAULT 'ERROR', -- 'ERROR', 'WARNING', 'INFO'
    modulo character varying(100),
    descripcion text,
    contexto jsonb                              -- contexto técnico, stack, query, user, etc
);


--8) Ejemplo: trigger para insertar en auditoría cuando se crea un usuario

-- función que registra inserciones en users
CREATE OR REPLACE FUNCTION auditoria.fn_audit_users_insert()
RETURNS trigger LANGUAGE plpgsql AS
$$
BEGIN
  INSERT INTO auditoria.tb_auditoria (usuario_id, modulo, accion, descripcion, datos)
  VALUES (NEW.id, 'usuarios', 'INSERT', 'Se creó usuario', to_jsonb(NEW));
  RETURN NEW;
END;
$$;

-- trigger
CREATE TRIGGER trg_audit_users_insert
AFTER INSERT ON usuarios.users
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_audit_users_insert();

--9) Ejemplo: usar tb_error desde la aplicación (pseudocódigo)
INSERT INTO auditoria.tb_error (nivel, modulo, descripcion, contexto)
VALUES ('ERROR', 'talleres', 'No se pudo crear taller: cupos nulo', jsonb_build_object('user_id', 5, 'error_msg', 'NOT NULL violation', 'stack', '...'));



--Paso 1: Crear una función de auditoría genérica
CREATE OR REPLACE FUNCTION auditoria.fn_registrar_auditoria()
RETURNS trigger LANGUAGE plpgsql AS
$$
BEGIN
  INSERT INTO auditoria.tb_auditoria (fecha, modulo, accion, descripcion, datos)
  VALUES (
    now(),
    TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,  -- ejemplo: usuarios.users
    TG_OP,                                   -- tipo de operación: INSERT, UPDATE o DELETE
    'Operación ' || TG_OP || ' en ' || TG_TABLE_NAME,
    CASE WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD) ELSE to_jsonb(NEW) END
  );
  RETURN NEW;
END;
$$;


--Paso 2: Crear triggers en las tablas que deseas auditar
-- Usuarios
CREATE TRIGGER trg_audit_users
AFTER INSERT OR UPDATE OR DELETE ON usuarios.users
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_registrar_auditoria();

-- Talleres
CREATE TRIGGER trg_audit_talleres
AFTER INSERT OR UPDATE OR DELETE ON talleres.talleres
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_registrar_auditoria();

-- Planes
CREATE TRIGGER trg_audit_planes_salud
AFTER INSERT OR UPDATE OR DELETE ON planes.planes_salud
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_registrar_auditoria();

CREATE TRIGGER trg_audit_planes_perder
AFTER INSERT OR UPDATE OR DELETE ON planes.planes_perder_peso
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_registrar_auditoria();

CREATE TRIGGER trg_audit_planes_ganar
AFTER INSERT OR UPDATE OR DELETE ON planes.planes_ganar_masa
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_registrar_auditoria();

-- Inscripciones (usuarios que se registran a talleres)
CREATE TRIGGER trg_audit_inscripciones
AFTER INSERT OR UPDATE OR DELETE ON usuarios.inscripciones
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_registrar_auditoria();


--Opcional: registrar también los errores
CREATE OR REPLACE FUNCTION auditoria.fn_auditoria_con_errores()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  BEGIN
    INSERT INTO auditoria.tb_auditoria (fecha, modulo, accion, descripcion, datos)
    VALUES (
      now(),
      TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
      TG_OP,
      'Operación ' || TG_OP || ' en ' || TG_TABLE_NAME,
      CASE WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD) ELSE to_jsonb(NEW) END
    );

  EXCEPTION WHEN OTHERS THEN
    -- Si ocurre un error, lo guardamos en tb_error
    PERFORM auditoria.fn_registrar_error(
      TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
      SQLERRM,
      jsonb_build_object(
        'operacion', TG_OP,
        'tabla', TG_TABLE_NAME,
        'datos', CASE WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD) ELSE to_jsonb(NEW) END
      )
    );
  END;

  RETURN NEW;
END;
$$;


--Crear triggers que usen esta nueva función
-- Usuarios
DROP TRIGGER IF EXISTS trg_audit_users ON usuarios.users;
CREATE TRIGGER trg_audit_users
AFTER INSERT OR UPDATE OR DELETE ON usuarios.users
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_auditoria_con_errores();

-- Talleres
DROP TRIGGER IF EXISTS trg_audit_talleres ON talleres.talleres;
CREATE TRIGGER trg_audit_talleres
AFTER INSERT OR UPDATE OR DELETE ON talleres.talleres
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_auditoria_con_errores();

-- Planes
DROP TRIGGER IF EXISTS trg_audit_planes_salud ON planes.planes_salud;
CREATE TRIGGER trg_audit_planes_salud
AFTER INSERT OR UPDATE OR DELETE ON planes.planes_salud
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_auditoria_con_errores();

DROP TRIGGER IF EXISTS trg_audit_planes_perder ON planes.planes_perder_peso;
CREATE TRIGGER trg_audit_planes_perder
AFTER INSERT OR UPDATE OR DELETE ON planes.planes_perder_peso
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_auditoria_con_errores();

DROP TRIGGER IF EXISTS trg_audit_planes_ganar ON planes.planes_ganar_masa;
CREATE TRIGGER trg_audit_planes_ganar
AFTER INSERT OR UPDATE OR DELETE ON planes.planes_ganar_masa
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_auditoria_con_errores();

-- Inscripciones
DROP TRIGGER IF EXISTS trg_audit_inscripciones ON usuarios.inscripciones;
CREATE TRIGGER trg_audit_inscripciones
AFTER INSERT OR UPDATE OR DELETE ON usuarios.inscripciones
FOR EACH ROW EXECUTE FUNCTION auditoria.fn_auditoria_con_errores();




--SIGUIENTE QUE MODIFIQUE PARA QUE SE VEA USUARIO_ID:
CREATE OR REPLACE FUNCTION auditoria.fn_auditoria_con_errores()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_usuario_id INTEGER;
BEGIN
  -- Intentamos determinar el id del usuario
  IF TG_TABLE_SCHEMA = 'usuarios' AND TG_TABLE_NAME = 'users' THEN
    v_usuario_id := COALESCE(NEW.id, OLD.id);
  ELSIF TG_TABLE_SCHEMA = 'usuarios' AND TG_TABLE_NAME = 'inscripciones' THEN
    v_usuario_id := COALESCE(NEW.user_id, OLD.user_id);
  ELSIF TG_TABLE_SCHEMA = 'talleres' THEN
    v_usuario_id := COALESCE(NEW.usuario_id, OLD.usuario_id);
  ELSIF TG_TABLE_SCHEMA = 'planes' THEN
    v_usuario_id := COALESCE(NEW.usuario_id, OLD.usuario_id);
  ELSE
    v_usuario_id := NULL;
  END IF;

  BEGIN
    INSERT INTO auditoria.tb_auditoria (fecha, usuario_id, modulo, accion, descripcion, datos)
    VALUES (
      now(),
      v_usuario_id,
      TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
      TG_OP,
      'Operación ' || TG_OP || ' en ' || TG_TABLE_NAME,
      CASE WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD) ELSE to_jsonb(NEW) END
    );

  EXCEPTION WHEN OTHERS THEN
    -- Si ocurre un error, lo guardamos en tb_error
    PERFORM auditoria.fn_registrar_error(
      TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
      SQLERRM,
      jsonb_build_object(
        'operacion', TG_OP,
        'tabla', TG_TABLE_NAME,
        'usuario_id', v_usuario_id,
        'datos', CASE WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD) ELSE to_jsonb(NEW) END
      )
    );
  END;

  RETURN NEW;
END;
$$;





CREATE OR REPLACE FUNCTION auditoria.fn_registrar_error(
    p_modulo TEXT,
    p_descripcion TEXT,
    p_contexto JSONB DEFAULT '{}'::JSONB
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO auditoria.tb_error (fecha, modulo, descripcion, contexto)
  VALUES (now(), p_modulo, p_descripcion, p_contexto);
END;
$$;



-- Función auxiliar para obtener setting seguro
CREATE OR REPLACE FUNCTION auditoria.fn_get_session_userid()
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
  v TEXT;
BEGIN
  BEGIN
    v := current_setting('app.user_id', true);
    IF v IS NULL THEN
      RETURN NULL;
    ELSE
      RETURN v::integer;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    RETURN NULL;
  END;
END;
$$;


-- Función principal mejorada
CREATE OR REPLACE FUNCTION auditoria.fn_auditoria_con_errores()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_usuario_id INTEGER;
  j_old jsonb;
  j_new jsonb;
  j_changed jsonb := '{}'::jsonb;
  k text;
  v_old_json jsonb;
  v_new_json jsonb;
BEGIN
  -- 1) Determinar valores JSONs de OLD/NEW según operación
  IF TG_OP = 'INSERT' THEN
    j_old := '{}'::jsonb;
    j_new := to_jsonb(NEW);
  ELSIF TG_OP = 'UPDATE' THEN
    j_old := to_jsonb(OLD);
    j_new := to_jsonb(NEW);
  ELSIF TG_OP = 'DELETE' THEN
    j_old := to_jsonb(OLD);
    j_new := '{}'::jsonb;
  ELSE
    j_old := '{}'::jsonb;
    j_new := '{}'::jsonb;
  END IF;

  -- 2) Intentar deducir usuario_id por convenciones de columnas
  v_usuario_id := NULL;

  -- Si es tabla de usuarios, el actor puede ser el mismo registro (ej: creación/edición)
  IF TG_TABLE_SCHEMA = 'usuarios' AND TG_TABLE_NAME = 'users' THEN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
      v_usuario_id := COALESCE(NEW.id, OLD.id);
    ELSE
      v_usuario_id := COALESCE(OLD.id, NULL);
    END IF;

  -- Inscripciones: campo común user_id
  ELSIF TG_TABLE_SCHEMA = 'usuarios' AND TG_TABLE_NAME = 'inscripciones' THEN
    v_usuario_id := COALESCE(NEW.user_id::integer, OLD.user_id::integer);

  -- Si otras tablas usan created_by, user_id, usuario_id, cliente_id
  ELSE
    BEGIN
      -- probar campos comunes en NEW/OLD (si existen)
      v_usuario_id := COALESCE(
        (CASE WHEN (j_new ? 'user_id') THEN (j_new->>'user_id')::integer END),
        (CASE WHEN (j_old ? 'user_id') THEN (j_old->>'user_id')::integer END),
        (CASE WHEN (j_new ? 'usuario_id') THEN (j_new->>'usuario_id')::integer END),
        (CASE WHEN (j_old ? 'usuario_id') THEN (j_old->>'usuario_id')::integer END),
        (CASE WHEN (j_new ? 'created_by') THEN (j_new->>'created_by')::integer END),
        (CASE WHEN (j_old ? 'created_by') THEN (j_old->>'created_by')::integer END),
        (CASE WHEN (j_new ? 'cliente_id') THEN (j_new->>'cliente_id')::integer END),
        (CASE WHEN (j_old ? 'cliente_id') THEN (j_old->>'cliente_id')::integer END)
      );
    EXCEPTION WHEN OTHERS THEN
      v_usuario_id := NULL;
    END;
  END IF;

  -- 3) Si aún no tenemos usuario_id intentamos leer variable de sesión (si tu app la seteó)
  IF v_usuario_id IS NULL THEN
    v_usuario_id := auditoria.fn_get_session_userid();
  END IF;

  -- 4) Construir JSON de cambios: iterar por todas las claves presentes en old || new
  FOR k IN SELECT jsonb_object_keys(j_old || j_new)
  LOOP
    v_old_json := NULL;
    v_new_json := NULL;
    BEGIN
      v_old_json := j_old -> k;
    EXCEPTION WHEN OTHERS THEN
      v_old_json := NULL;
    END;
    BEGIN
      v_new_json := j_new -> k;
    EXCEPTION WHEN OTHERS THEN
      v_new_json := NULL;
    END;

    IF (v_old_json IS DISTINCT FROM v_new_json) THEN
      j_changed := j_changed || jsonb_build_object(
        k,
        jsonb_build_object('old', COALESCE(v_old_json, 'null'::jsonb), 'new', COALESCE(v_new_json, 'null'::jsonb))
      );
    END IF;
  END LOOP;

  -- 5) Insertar en tb_auditoria (datos completos: antes, despues, changed)
  BEGIN
    INSERT INTO auditoria.tb_auditoria
      (fecha, usuario_id, modulo, accion, descripcion, datos)
    VALUES
      (
        now(),
        v_usuario_id,
        TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
        TG_OP,
        'Operación ' || TG_OP || ' en ' || TG_TABLE_NAME,
        jsonb_build_object(
          'antes', CASE WHEN j_old = '{}'::jsonb THEN NULL ELSE j_old END,
          'despues', CASE WHEN j_new = '{}'::jsonb THEN NULL ELSE j_new END,
          'changed', CASE WHEN j_changed = '{}'::jsonb THEN NULL ELSE j_changed END
        )
      );
  EXCEPTION WHEN OTHERS THEN
    -- 6) Si falla la inserción de auditoría, registramos en tb_error
    PERFORM auditoria.fn_registrar_error(
      TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
      SQLERRM,
      jsonb_build_object(
        'operacion', TG_OP,
        'tabla', TG_TABLE_NAME,
        'usuario_id', v_usuario_id,
        'antes', CASE WHEN j_old = '{}'::jsonb THEN NULL ELSE j_old END,
        'despues', CASE WHEN j_new = '{}'::jsonb THEN NULL ELSE j_new END
      )
    );
  END;

  -- 7) Retornar NEW para triggers AFTER ... FOR EACH ROW
  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  ELSE
    RETURN NEW;
  END IF;
END;
$$;





--ESTE SI EL EL BUENO
CREATE OR REPLACE FUNCTION auditoria.fn_auditoria_con_errores()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_usuario_id INTEGER;
BEGIN
  -- ✅ Intentar obtener el id de usuario desde la variable de sesión (Flask -> PostgreSQL)
  BEGIN
    v_usuario_id := current_setting('app.user_id', true)::integer;
  EXCEPTION WHEN OTHERS THEN
    v_usuario_id := NULL;
  END;

  -- Si no se pudo, intentar inferirlo desde la tabla
  IF v_usuario_id IS NULL THEN
    IF TG_TABLE_SCHEMA = 'usuarios' AND TG_TABLE_NAME = 'users' THEN
      v_usuario_id := COALESCE(NEW.id, OLD.id);
    ELSIF TG_TABLE_SCHEMA = 'usuarios' AND TG_TABLE_NAME = 'inscripciones' THEN
      v_usuario_id := COALESCE(NEW.user_id, OLD.user_id);
    ELSIF TG_TABLE_SCHEMA IN ('talleres', 'planes') THEN
      v_usuario_id := COALESCE(NEW.user_id, OLD.user_id);
    END IF;
  END IF;

  BEGIN
    INSERT INTO auditoria.tb_auditoria (fecha, usuario_id, modulo, accion, descripcion, datos)
    VALUES (
      now(),
      v_usuario_id,
      TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
      TG_OP,
      'Operación ' || TG_OP || ' en ' || TG_TABLE_NAME,
      jsonb_build_object(
        'antes', CASE WHEN TG_OP <> 'INSERT' THEN to_jsonb(OLD) ELSE NULL END,
        'despues', CASE WHEN TG_OP <> 'DELETE' THEN to_jsonb(NEW) ELSE NULL END
      )
    );
  EXCEPTION WHEN OTHERS THEN
    PERFORM auditoria.fn_registrar_error(
      TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
      SQLERRM,
      jsonb_build_object(
        'operacion', TG_OP,
        'tabla', TG_TABLE_NAME,
        'usuario_id', v_usuario_id,
        'datos', CASE WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD) ELSE to_jsonb(NEW) END
      )
    );
  END;

  RETURN NEW;
END;
$$;



CREATE TABLE talleres.contenido_taller (
    id SERIAL PRIMARY KEY,
    taller_id INTEGER NOT NULL REFERENCES talleres.talleres(id),
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo_contenido VARCHAR(50) NOT NULL,
    dia_programa INTEGER,
    url_contenido VARCHAR(500),
    duracion_minutos INTEGER,
    orden INTEGER DEFAULT 0,
    es_obligatorio BOOLEAN DEFAULT FALSE,
    fecha_disponible TIMESTAMPTZ DEFAULT now()
);
