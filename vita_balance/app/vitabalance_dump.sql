--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: vitadmin
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO vitadmin;

--
-- Name: contenido_taller; Type: TABLE; Schema: public; Owner: vitadmin
--

CREATE TABLE public.contenido_taller (
    id integer NOT NULL,
    taller_id integer NOT NULL,
    titulo character varying(200) NOT NULL,
    descripcion text,
    tipo_contenido character varying(50) NOT NULL,
    dia_programa integer,
    url_contenido character varying(500),
    duracion_minutos integer,
    orden integer,
    es_obligatorio boolean,
    fecha_disponible timestamp without time zone
);


ALTER TABLE public.contenido_taller OWNER TO vitadmin;

--
-- Name: contenido_taller_id_seq; Type: SEQUENCE; Schema: public; Owner: vitadmin
--

CREATE SEQUENCE public.contenido_taller_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contenido_taller_id_seq OWNER TO vitadmin;

--
-- Name: contenido_taller_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vitadmin
--

ALTER SEQUENCE public.contenido_taller_id_seq OWNED BY public.contenido_taller.id;


--
-- Name: inscripciones; Type: TABLE; Schema: public; Owner: vitadmin
--

CREATE TABLE public.inscripciones (
    user_id integer NOT NULL,
    taller_id integer NOT NULL,
    fecha_inscripcion timestamp without time zone
);


ALTER TABLE public.inscripciones OWNER TO vitadmin;

--
-- Name: planes_ganar_masa; Type: TABLE; Schema: public; Owner: vitadmin
--

CREATE TABLE public.planes_ganar_masa (
    id integer NOT NULL
);


ALTER TABLE public.planes_ganar_masa OWNER TO vitadmin;

--
-- Name: planes_perder_peso; Type: TABLE; Schema: public; Owner: vitadmin
--

CREATE TABLE public.planes_perder_peso (
    id integer NOT NULL
);


ALTER TABLE public.planes_perder_peso OWNER TO vitadmin;

--
-- Name: planes_salud; Type: TABLE; Schema: public; Owner: vitadmin
--

CREATE TABLE public.planes_salud (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    tipo character varying(50),
    calorias integer,
    proteinas integer,
    rutina text,
    user_id integer,
    imagen character varying(255)
);


ALTER TABLE public.planes_salud OWNER TO vitadmin;

--
-- Name: planes_salud_id_seq; Type: SEQUENCE; Schema: public; Owner: vitadmin
--

CREATE SEQUENCE public.planes_salud_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.planes_salud_id_seq OWNER TO vitadmin;

--
-- Name: planes_salud_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vitadmin
--

ALTER SEQUENCE public.planes_salud_id_seq OWNED BY public.planes_salud.id;


--
-- Name: progreso_contenido; Type: TABLE; Schema: public; Owner: vitadmin
--

CREATE TABLE public.progreso_contenido (
    user_id integer NOT NULL,
    contenido_id integer NOT NULL,
    completado boolean,
    fecha_completado timestamp without time zone
);


ALTER TABLE public.progreso_contenido OWNER TO vitadmin;

--
-- Name: talleres; Type: TABLE; Schema: public; Owner: vitadmin
--

CREATE TABLE public.talleres (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    cupos integer NOT NULL,
    objetivo character varying(50) NOT NULL,
    fecha timestamp without time zone NOT NULL,
    nivel_actividad character varying(20),
    dias_semana character varying(100) NOT NULL
);


ALTER TABLE public.talleres OWNER TO vitadmin;

--
-- Name: talleres_id_seq; Type: SEQUENCE; Schema: public; Owner: vitadmin
--

CREATE SEQUENCE public.talleres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.talleres_id_seq OWNER TO vitadmin;

--
-- Name: talleres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vitadmin
--

ALTER SEQUENCE public.talleres_id_seq OWNED BY public.talleres.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: vitadmin
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    email character varying(120) NOT NULL,
    password character varying(512) NOT NULL,
    role character varying(20),
    objetivo character varying(50),
    peso integer,
    altura integer,
    actividad character varying(20),
    genero character varying(10)
);


ALTER TABLE public.users OWNER TO vitadmin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: vitadmin
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO vitadmin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vitadmin
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: contenido_taller id; Type: DEFAULT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.contenido_taller ALTER COLUMN id SET DEFAULT nextval('public.contenido_taller_id_seq'::regclass);


--
-- Name: planes_salud id; Type: DEFAULT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.planes_salud ALTER COLUMN id SET DEFAULT nextval('public.planes_salud_id_seq'::regclass);


--
-- Name: talleres id; Type: DEFAULT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.talleres ALTER COLUMN id SET DEFAULT nextval('public.talleres_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: vitadmin
--

COPY public.alembic_version (version_num) FROM stdin;
6112efb44bdf
\.


--
-- Data for Name: contenido_taller; Type: TABLE DATA; Schema: public; Owner: vitadmin
--

COPY public.contenido_taller (id, taller_id, titulo, descripcion, tipo_contenido, dia_programa, url_contenido, duracion_minutos, orden, es_obligatorio, fecha_disponible) FROM stdin;
1	11	Día 1: Entrenamiento de Fuerza Básico	Rutina de fuerza para principiantes con ejercicios fundamentales	rutina	1	https://www.youtube.com/watch?v=A5wqXRv0DIQ	30	1	t	2025-06-30 16:44:43.661375
2	11	Día 2: Cardio y Resistencia	Entrenamiento cardiovascular para mejorar resistencia	rutina	2	https://www.youtube.com/watch?v=A2cHRBAVux4	25	2	t	2025-06-30 16:44:43.661375
3	11	Día 3: Entrenamiento de Core	Fortalecimiento del core y estabilidad	rutina	3	https://www.youtube.com/watch?v=b82tCDHlx4E	20	3	t	2025-06-30 16:44:43.661375
4	11	Día 4: Entrenamiento de Piernas	Rutina enfocada en el tren inferior	rutina	4	https://www.youtube.com/watch?v=B0-XXKyiFoU	35	4	t	2025-06-30 16:44:43.661375
5	11	Día 5: HIIT Intenso	Entrenamiento de intervalos de alta intensidad	rutina	5	https://www.youtube.com/watch?v=dy3KGwvLDYQ	25	5	t	2025-06-30 16:44:43.661375
6	11	Día 6: Flexibilidad y Movilidad	Sesión de estiramiento y mejora de movilidad	rutina	6	https://www.youtube.com/watch?v=1n9xu1eQZqI	30	6	t	2025-06-30 16:44:43.661375
7	11	Día 7: Rutina de Recuperación Activa	Ejercicios suaves para recuperación y relajación	rutina	7	https://www.youtube.com/watch?v=-zj1xL8N93M	20	7	t	2025-06-30 16:44:43.661375
8	11	Seguimiento Nutricional	Guía completa para el seguimiento de tu nutrición durante el programa	video	\N	https://www.youtube.com/watch?v=Vm0WS4G5wcQ	15	8	f	2025-06-30 16:44:43.661375
9	11	Sesión en Vivo Semanal	Sesión interactiva en vivo para resolver dudas y motivación	sesion_vivo	\N	https://www.youtube.com/watch?v=AFbwgsnzcpU	60	9	f	2025-06-30 16:44:43.661375
10	11	Guía Completa de Nutrición del Deportista	Manual descargable con toda la información nutricional necesaria	documento	\N	https://www.esi.academy/wp-content/uploads/La-guía-completa-de-la-nutrición-del-deportista.pdf	\N	10	f	2025-06-30 16:44:43.661375
11	11	Alimentación, Nutrición e Hidratación en el Deporte	Guía complementaria sobre hidratación y alimentación deportiva	documento	\N	https://www.sochob.cl/pdf/libros/Alimentacion,%20nutricion%20e%20hidratacion%20en%20el%20deporte.pdf	\N	11	f	2025-06-30 16:44:43.661375
12	12	Fundamentos del Ejercicio - Parte 1	Introducción a los conceptos básicos del entrenamiento	video	\N	https://www.youtube.com/watch?v=naRDSZN4Yjw	25	1	t	2025-06-30 16:44:43.684415
13	12	Fundamentos del Ejercicio - Parte 2	Técnicas correctas y prevención de lesiones	video	\N	https://www.youtube.com/watch?v=NncmQk5a9Dg	30	2	t	2025-06-30 16:44:43.684415
14	13	Cardio Intensivo para Quemar Grasa	Rutina de cardio de alta intensidad para maximizar la quema de calorías	video	\N	https://www.youtube.com/watch?v=XCB8pgnt9no	20	1	t	2025-06-30 16:44:43.692424
15	13	Entrenamiento Metabólico	Ejercicios para acelerar el metabolismo y seguir quemando calorías	video	\N	https://www.youtube.com/watch?v=QhuMeVnn_qU	25	2	t	2025-06-30 16:44:43.692424
16	14	Ejercicios Básicos de Hipertrofia	Fundamentos para el crecimiento muscular efectivo	video	\N	https://www.youtube.com/watch?app=desktop&v=PerIyFMqZu8	35	1	t	2025-06-30 16:44:43.699405
17	14	Entrenamiento Avanzado: Piernas y Glúteos	Técnicas avanzadas para el desarrollo del tren inferior	video	\N	https://www.youtube.com/watch?v=iD-_3jgeXX4	40	2	t	2025-06-30 16:44:43.699405
18	1	Día 1: Activación Cardiovascular	Rutina suave de activación para preparar el cuerpo	rutina	1	https://youtube.com/cardio-dia1	25	1	t	2025-07-01 00:37:06.668158
19	1	Día 2: Cardio de Intensidad Moderada	Incrementamos la intensidad con ejercicios funcionales	rutina	2	https://youtube.com/cardio-dia2	30	2	t	2025-07-01 00:37:06.668158
20	1	Día 3: Circuito Funcional Básico	Combinamos cardio y fuerza funcional	rutina	3	https://youtube.com/cardio-dia3	35	3	t	2025-07-01 00:37:06.668158
21	1	Día 4: Cardio Danzado	Rutina cardiovascular con ritmo y diversión	rutina	4	https://youtube.com/cardio-dia4	30	4	t	2025-07-01 00:37:06.668158
22	1	Día 5: Intervalos de Alta Intensidad	HIIT adaptado para quemar más calorías	rutina	5	https://youtube.com/cardio-dia5	28	5	t	2025-07-01 00:37:06.668158
23	1	Día 6: Cardio de Resistencia	Mejoramos la resistencia cardiovascular	rutina	6	https://youtube.com/cardio-dia6	40	6	t	2025-07-01 00:37:06.668158
24	1	Día 7: Rutina de Recuperación Activa	Estiramiento y ejercicios suaves de recuperación	rutina	7	https://youtube.com/cardio-dia7	20	7	t	2025-07-01 00:37:06.668158
25	1	Guía de Nutrición para Cardio	PDF con recomendaciones nutricionales para potenciar el cardio	guia	\N	https://drive.google.com/nutricion-cardio.pdf	\N	8	f	2025-07-01 00:37:06.668158
26	1	Sesión en Vivo: Dudas sobre Técnica	Sesión interactiva para resolver dudas sobre técnica cardiovascular	live	\N	https://zoom.us/sesion-cardio	60	9	f	2025-07-01 00:37:06.668158
27	4	Introducción a las Mancuernas	Conoce los fundamentos del entrenamiento con mancuernas y técnica básica	rutina	1	https://youtube.com/watch?v=intro_mancuernas	45	1	t	2025-07-01 00:41:18.191695
28	4	Guía de Técnica Básica	PDF con técnicas correctas para ejercicios básicos con mancuernas	guia	1	/static/guides/tecnica_basica_mancuernas.pdf	15	2	t	2025-07-01 00:41:18.191695
29	4	Tren Superior Básico	Rutina de pecho, hombros y brazos con mancuernas ligeras	rutina	2	https://youtube.com/watch?v=tren_superior_basico	40	3	t	2025-07-01 00:41:18.191695
30	4	Descanso Activo y Movilidad	Ejercicios de movilidad y estiramientos para recuperación	rutina	3	https://youtube.com/watch?v=movilidad_fuerza	30	4	f	2025-07-01 00:41:18.191695
31	4	Tren Inferior con Mancuernas	Sentadillas, peso muerto y ejercicios de piernas con mancuernas	rutina	4	https://youtube.com/watch?v=tren_inferior_mancuernas	45	5	t	2025-07-01 00:41:18.191695
32	4	Núcleo y Estabilidad	Fortalecimiento del core para mejores levantamientos	rutina	5	https://youtube.com/watch?v=core_fuerza	35	6	t	2025-07-01 00:41:18.191695
33	4	Circuito de Fuerza Completo	Combinación de todos los ejercicios aprendidos en circuito	rutina	6	https://youtube.com/watch?v=circuito_completo	50	7	t	2025-07-01 00:41:18.191695
34	4	Evaluación y Progreso	Medición de progreso y planificación de siguientes pasos	evaluacion	7	https://youtube.com/watch?v=evaluacion_progreso	30	8	t	2025-07-01 00:41:18.191695
35	4	Nutrición para Principiantes	Guía básica de alimentación para ganar masa muscular	guia	\N	/static/guides/nutricion_principiantes.pdf	20	9	f	2025-07-01 00:41:18.191695
36	18	Fundamentos del Peso Libre	Introducción a barras, mancuernas y seguridad en el gimnasio	rutina	1	https://youtube.com/watch?v=fundamentos_peso_libre	50	1	t	2025-07-01 00:42:30.470479
37	18	Manual de Seguridad	Guía completa de seguridad para entrenamientos con peso libre	guia	1	/static/guides/seguridad_peso_libre.pdf	20	2	t	2025-07-01 00:42:30.470479
38	18	Técnica de Sentadilla	Aprendizaje paso a paso de la sentadilla con barra	rutina	2	https://youtube.com/watch?v=tecnica_sentadilla	45	3	t	2025-07-01 00:42:30.470479
39	18	Técnica de Press de Banca	Fundamentos del press de banca seguro y efectivo	rutina	3	https://youtube.com/watch?v=press_banca_principiantes	40	4	t	2025-07-01 00:42:30.470479
40	18	Peso Muerto para Principiantes	Técnica correcta del peso muerto convencional	rutina	4	https://youtube.com/watch?v=peso_muerto_basico	45	5	t	2025-07-01 00:42:30.470479
41	18	Press Militar y Hombros	Desarrollo de hombros con press militar básico	rutina	5	https://youtube.com/watch?v=press_militar_basico	35	6	t	2025-07-01 00:42:30.470479
42	18	Rutina Completa de Iniciación	Primera rutina completa combinando todos los ejercicios	rutina	6	https://youtube.com/watch?v=rutina_iniciacion_completa	55	7	t	2025-07-01 00:42:30.470479
43	18	Planificación del Progreso	Cómo progresar de forma segura en peso libre	evaluacion	7	https://youtube.com/watch?v=planificacion_progreso	30	8	t	2025-07-01 00:42:30.470479
44	18	Calculadora de Cargas	Herramienta para calcular pesos de entrenamiento	herramienta	\N	/static/tools/calculadora_cargas.html	10	9	f	2025-07-01 00:42:30.470479
45	6	Principios de Sobrecarga Progresiva	Fundamentos científicos de la progresión en el entrenamiento	rutina	1	https://youtube.com/watch?v=sobrecarga_progresiva	45	1	t	2025-07-01 00:43:13.348079
46	6	Manual de Periodización	Guía completa sobre periodización del entrenamiento	guia	1	/static/guides/periodizacion_entrenamiento.pdf	25	2	t	2025-07-01 00:43:13.348079
47	6	Progresión en Ejercicios Básicos	Cómo aumentar cargas en sentadilla, press banca y peso muerto	rutina	2	https://youtube.com/watch?v=progresion_ejercicios_basicos	50	3	t	2025-07-01 00:43:13.348079
48	6	Técnicas de Intensificación	Drop sets, rest-pause y otras técnicas avanzadas	rutina	3	https://youtube.com/watch?v=tecnicas_intensificacion	45	4	t	2025-07-01 00:43:13.348079
49	6	Periodización Linear vs Ondulada	Comparación y aplicación de diferentes tipos de periodización	rutina	4	https://youtube.com/watch?v=tipos_periodizacion	40	5	t	2025-07-01 00:43:13.348079
50	6	Manejo de Mesociclos	Planificación de bloques de entrenamiento de 4-6 semanas	rutina	5	https://youtube.com/watch?v=mesociclos_entrenamiento	35	6	t	2025-07-01 00:43:13.348079
51	6	Rutina Periodizada Práctica	Implementación de una rutina con progresión planificada	rutina	6	https://youtube.com/watch?v=rutina_periodizada	60	7	t	2025-07-01 00:43:13.348079
52	6	Evaluación y Ajustes	Cómo evaluar progreso y hacer ajustes al programa	evaluacion	7	https://youtube.com/watch?v=evaluacion_ajustes	30	8	t	2025-07-01 00:43:13.348079
53	6	Planilla de Seguimiento	Excel para tracking de cargas y progresión	herramienta	\N	/static/tools/planilla_seguimiento.xlsx	15	9	f	2025-07-01 00:43:13.348079
54	19	Fundamentos de Fuerza Funcional	Qué es la fuerza funcional y por qué es importante	rutina	1	https://youtube.com/watch?v=fundamentos_fuerza_funcional	40	1	t	2025-07-01 00:43:45.6573
55	19	Guía de Movimientos Funcionales	Patrones de movimiento esenciales para la vida diaria	guia	1	/static/guides/movimientos_funcionales.pdf	20	2	t	2025-07-01 00:43:45.658298
56	19	Entrenamientos Multiplanares	Ejercicios en los tres planos de movimiento	rutina	2	https://youtube.com/watch?v=entrenamientos_multiplanares	45	3	t	2025-07-01 00:43:45.658298
57	19	Cadenas Cinéticas y Integración	Entrenamiento de cadenas musculares completas	rutina	3	https://youtube.com/watch?v=cadenas_cineticas	50	4	t	2025-07-01 00:43:45.658298
58	19	Estabilidad y Movilidad	Balance entre estabilidad y movilidad en ejercicios	rutina	4	https://youtube.com/watch?v=estabilidad_movilidad	40	5	t	2025-07-01 00:43:45.658298
59	19	Entrenamiento con Implementos	Kettlebells, TRX, balones medicinales y más	rutina	5	https://youtube.com/watch?v=entrenamiento_implementos	55	6	t	2025-07-01 00:43:45.658298
60	19	Circuito Funcional Avanzado	Rutina completa integrando todos los conceptos	rutina	6	https://youtube.com/watch?v=circuito_funcional_avanzado	50	7	t	2025-07-01 00:43:45.658298
61	19	Aplicación Deportiva	Cómo adaptar fuerza funcional a deportes específicos	rutina	7	https://youtube.com/watch?v=aplicacion_deportiva	35	8	t	2025-07-01 00:43:45.658298
62	19	Rutinas por Deporte	Programas específicos para diferentes deportes	guia	\N	/static/guides/rutinas_por_deporte.pdf	30	9	f	2025-07-01 00:43:45.658298
63	5	Ciencia de la Hipertrofia	Mecanismos fisiológicos del crecimiento muscular	rutina	1	https://youtube.com/watch?v=ciencia_hipertrofia	45	1	t	2025-07-01 00:45:06.835146
64	5	Manual de Hipertrofia Avanzada	Guía científica completa sobre crecimiento muscular	guia	1	/static/guides/hipertrofia_avanzada.pdf	30	2	t	2025-07-01 00:45:06.835146
65	5	Entrenamiento de Volumen Alto	Rutinas de alto volumen para máximo crecimiento	rutina	2	https://youtube.com/watch?v=volumen_alto_hipertrofia	70	3	t	2025-07-01 00:45:06.835146
66	5	Técnicas de Intensidad Avanzadas	Cluster sets, rest-pause, drop sets y más	rutina	3	https://youtube.com/watch?v=intensidad_avanzada	60	4	t	2025-07-01 00:45:06.835146
67	5	Periodización DUP para Hipertrofia	Periodización ondulada diaria aplicada a hipertrofia	rutina	4	https://youtube.com/watch?v=dup_hipertrofia	50	5	t	2025-07-01 00:45:06.835146
68	5	Especialización Muscular	Técnicas para desarrollar grupos musculares rezagados	rutina	5	https://youtube.com/watch?v=especializacion_muscular	55	6	t	2025-07-01 00:45:06.835146
69	5	Entrenamiento Avanzado Completo	Rutina de hipertrofia con todas las técnicas avanzadas	rutina	6	https://youtube.com/watch?v=hipertrofia_completa	80	7	t	2025-07-01 00:45:06.835146
70	5	Planificación a Largo Plazo	Estrategias para progresar por años en hipertrofia	evaluacion	7	https://youtube.com/watch?v=planificacion_largo_plazo	40	8	t	2025-07-01 00:45:06.835146
71	5	Calculadora de Volumen	Herramienta para calcular volumen óptimo por músculo	herramienta	\N	/static/tools/calculadora_volumen.html	15	9	f	2025-07-01 00:45:06.835146
72	23	Introducción al Powerlifting	Historia, reglas y fundamentos del powerlifting competitivo	rutina	1	https://youtube.com/watch?v=intro_powerlifting	45	1	t	2025-07-01 00:47:33.607054
73	23	Reglamento Oficial IPF	Guía completa del reglamento internacional de powerlifting	guia	1	/static/guides/reglamento_ipf.pdf	25	2	t	2025-07-01 00:47:33.607054
74	23	Técnica Avanzada de Sentadilla	Perfeccionamiento de la sentadilla para competición	rutina	2	https://youtube.com/watch?v=sentadilla_competicion	60	3	t	2025-07-01 00:47:33.607054
75	23	Press Banca de Competición	Técnica específica para maximizar el press banca	rutina	3	https://youtube.com/watch?v=press_banca_competicion	55	4	t	2025-07-01 00:47:33.607054
76	23	Peso Muerto Máximo	Técnicas para maximizar el peso muerto convencional y sumo	rutina	4	https://youtube.com/watch?v=peso_muerto_maximo	65	5	t	2025-07-01 00:47:33.607054
77	23	Periodización Conjugada	Método Westside Barbell para fuerza máxima	rutina	5	https://youtube.com/watch?v=metodo_westside	50	6	t	2025-07-01 00:47:33.607054
78	23	Simulacro de Competición	Práctica completa de una competición de powerlifting	rutina	6	https://youtube.com/watch?v=simulacro_competicion	90	7	t	2025-07-01 00:47:33.607054
79	23	Preparación Mental y Estrategia	Aspectos psicológicos y estratégicos de la competición	evaluacion	7	https://youtube.com/watch?v=preparacion_mental	40	8	t	2025-07-01 00:47:33.607054
80	23	Calculadora de Wilks	Herramienta para calcular puntuación Wilks y DOTS	herramienta	\N	/static/tools/calculadora_wilks.html	10	9	f	2025-07-01 00:47:33.607054
81	14	Entrenamiento de Frecuencia Alta	Entrenamiento de cada músculo 3-4 veces por semana	rutina	3	https://youtube.com/watch?v=frecuencia_alta	55	3	t	2025-07-01 00:49:01.442036
82	14	Optimización del TUT	Tiempo bajo tensión para máxima hipertrofia	rutina	4	https://youtube.com/watch?v=tiempo_bajo_tension	50	4	t	2025-07-01 00:49:01.442036
83	14	Entrenamiento Excéntrico	Uso de excéntricas controladas para hipertrofia	rutina	5	https://youtube.com/watch?v=entrenamiento_excentrico	45	5	t	2025-07-01 00:49:01.442036
84	14	Rutina Push/Pull/Legs Avanzada	Rutina de 6 días con técnicas avanzadas	rutina	6	https://youtube.com/watch?v=ppl_avanzado	75	6	t	2025-07-01 00:49:01.442036
85	14	Deload y Recuperación	Semanas de descarga y estrategias de recuperación	evaluacion	7	https://youtube.com/watch?v=deload_recuperacion	35	7	t	2025-07-01 00:49:01.442036
86	14	Suplementación Avanzada	Guía de suplementos para hipertrofia avanzada	guia	\N	/static/guides/suplementacion_avanzada.pdf	25	8	f	2025-07-01 00:49:01.442036
87	2	Fundamentos de la Bailoterapia	Introducción a los beneficios del baile para quemar calorías	rutina	1	https://youtube.com/watch?v=fundamentos_bailoterapia	40	1	t	2025-07-01 01:01:27.293527
88	2	Calentamiento Dinámico	Rutina de calentamiento específica para baile	rutina	2	https://youtube.com/watch?v=calentamiento_baile	15	2	t	2025-07-01 01:01:27.293527
89	2	Ritmos Latinos Básicos	Salsa, merengue y bachata para principiantes	rutina	3	https://youtube.com/watch?v=ritmos_latinos	45	3	t	2025-07-01 01:01:27.293527
90	2	Cardio Dance Intenso	Rutina de alta intensidad con música moderna	rutina	4	https://youtube.com/watch?v=cardio_dance	50	4	t	2025-07-01 01:01:27.293527
91	2	Zumba Fitness	Clase completa de Zumba para quemar calorías	rutina	5	https://youtube.com/watch?v=zumba_fitness	55	5	t	2025-07-01 01:01:27.293527
92	2	Baile de Resistencia	Coreografías largas para mejorar resistencia cardiovascular	rutina	6	https://youtube.com/watch?v=baile_resistencia	60	6	t	2025-07-01 01:01:27.293527
93	2	Estiramiento y Relajación	Rutina de enfriamiento con estiramientos suaves	rutina	7	https://youtube.com/watch?v=estiramiento_baile	20	7	t	2025-07-01 01:01:27.293527
94	2	Playlist Motivacional	Lista de canciones ideales para bailoterapia	guia	\N	/static/guides/playlist_bailoterapia.pdf	10	8	f	2025-07-01 01:01:27.293527
95	2	Nutrición para Bailarines	Guía nutricional para optimizar el rendimiento en baile	guia	\N	/static/guides/nutricion_bailarines.pdf	15	9	f	2025-07-01 01:01:27.293527
96	3	Introducción al HIIT	Fundamentos del entrenamiento intervalado de alta intensidad	rutina	1	https://youtube.com/watch?v=intro_hiit	35	1	t	2025-07-01 01:02:08.267996
97	3	HIIT Principiante	Rutina HIIT básica de 20 minutos	rutina	2	https://youtube.com/watch?v=hiit_principiante	25	2	t	2025-07-01 01:02:08.267996
98	3	HIIT Intermedio	Rutina de intensidad media con ejercicios complejos	rutina	3	https://youtube.com/watch?v=hiit_intermedio	30	3	t	2025-07-01 01:02:08.267996
99	3	HIIT Avanzado	Rutina de alta intensidad para atletas experimentados	rutina	4	https://youtube.com/watch?v=hiit_avanzado	35	4	t	2025-07-01 01:02:08.267996
100	3	Tabata Protocol	Entrenamiento Tabata de 4 minutos extremos	rutina	5	https://youtube.com/watch?v=tabata_protocol	20	5	t	2025-07-01 01:02:08.267996
101	3	HIIT Metabólico	Circuito metabólico para máxima quema de calorías	rutina	6	https://youtube.com/watch?v=hiit_metabolico	40	6	t	2025-07-01 01:02:08.267996
102	3	Recuperación Activa	Ejercicios suaves para recuperación post-HIIT	rutina	7	https://youtube.com/watch?v=recuperacion_hiit	15	7	t	2025-07-01 01:02:08.267996
103	3	Guía de Intervalos	Manual para diseñar tus propios entrenamientos HIIT	guia	\N	/static/guides/intervalos_hiit.pdf	20	8	f	2025-07-01 01:02:08.267996
104	3	Timer HIIT	Herramienta de cronometraje para entrenamientos	herramienta	\N	/static/tools/timer_hiit.html	5	9	f	2025-07-01 01:02:08.267996
105	15	Introducción al Cardio	Beneficios del ejercicio cardiovascular para principiantes	rutina	1	https://youtube.com/watch?v=intro_cardio_principiantes	30	1	t	2025-07-01 01:03:23.200598
106	15	Caminata Activa	Técnicas de caminata para mejorar condición física	rutina	2	https://youtube.com/watch?v=caminata_activa	25	2	t	2025-07-01 01:03:23.200598
107	15	Cardio de Bajo Impacto	Ejercicios cardiovasculares suaves para articulaciones	rutina	3	https://youtube.com/watch?v=cardio_bajo_impacto	35	3	t	2025-07-01 01:03:23.200598
108	15	Rutina de Escalones	Entrenamiento cardiovascular usando escalones o step	rutina	4	https://youtube.com/watch?v=rutina_escalones	30	4	t	2025-07-01 01:03:23.200598
109	15	Aqua Aeróbicos	Ejercicios en agua para cardio sin impacto	rutina	5	https://youtube.com/watch?v=aqua_aerobicos	40	5	t	2025-07-01 01:03:23.200598
110	15	Cardio Progresivo	Rutina que aumenta gradualmente en intensidad	rutina	6	https://youtube.com/watch?v=cardio_progresivo	35	6	t	2025-07-01 01:03:23.200598
111	15	Relajación y Estiramiento	Rutina de enfriamiento y estiramientos post-cardio	rutina	7	https://youtube.com/watch?v=relajacion_cardio	20	7	t	2025-07-01 01:03:23.200598
112	15	Plan de Progresión	Guía para avanzar gradualmente en intensidad	guia	\N	/static/guides/progresion_cardio.pdf	15	8	f	2025-07-01 01:03:23.200598
113	15	Monitor de Frecuencia Cardíaca	Guía para monitorear intensidad del ejercicio	guia	\N	/static/guides/frecuencia_cardiaca.pdf	10	9	f	2025-07-01 01:03:23.200598
114	16	HIIT Científico	Base científica del HIIT para quemar grasa	rutina	1	https://youtube.com/watch?v=hiit_cientifico	35	1	t	2025-07-01 01:05:52.285018
115	16	Quemagrasas Express	Rutina HIIT de 15 minutos para quemar grasa	rutina	2	https://youtube.com/watch?v=quemagrasas_express	20	2	t	2025-07-01 01:05:52.285018
116	16	HIIT Compuesto	Ejercicios compuestos en formato HIIT	rutina	3	https://youtube.com/watch?v=hiit_compuesto	30	3	t	2025-07-01 01:05:52.285018
117	16	Sprint Intervals	Intervalos de sprint para máxima quema calórica	rutina	4	https://youtube.com/watch?v=sprint_intervals	25	4	t	2025-07-01 01:05:52.285018
118	16	HIIT Metabólico Extremo	Rutina de máxima intensidad para atletas avanzados	rutina	5	https://youtube.com/watch?v=hiit_extremo	35	5	t	2025-07-01 01:05:52.286015
119	16	EMOM Quemagrasas	Every Minute On the Minute para quemar grasa	rutina	6	https://youtube.com/watch?v=emom_quemagrasas	30	6	t	2025-07-01 01:05:52.286015
120	16	Recuperación Metabólica	Técnicas de recuperación para entrenamientos intensos	rutina	7	https://youtube.com/watch?v=recuperacion_metabolica	20	7	t	2025-07-01 01:05:52.286015
121	16	Periodización HIIT	Cómo periodizar entrenamientos HIIT para resultados óptimos	guia	\N	/static/guides/periodizacion_hiit.pdf	25	8	f	2025-07-01 01:05:52.286015
122	16	Suplementación Pre-HIIT	Guía de suplementos para maximizar rendimiento	guia	\N	/static/guides/suplementos_hiit.pdf	15	9	f	2025-07-01 01:05:52.286015
123	17	Fundamentos del Aqua Fitness	Beneficios del ejercicio acuático para quemar calorías	rutina	1	https://youtube.com/watch?v=fundamentos_aqua	35	1	t	2025-07-01 01:07:01.107229
124	17	Calentamiento Acuático	Rutina de calentamiento específica para ejercicio en agua	rutina	2	https://youtube.com/watch?v=calentamiento_aqua	20	2	t	2025-07-01 01:07:01.107229
125	17	Aqua Aeróbicos Básico	Movimientos básicos de aeróbicos en agua	rutina	3	https://youtube.com/watch?v=aqua_aerobicos_basico	40	3	t	2025-07-01 01:07:01.107229
126	17	Aqua Running	Técnica de correr en agua profunda	rutina	4	https://youtube.com/watch?v=aqua_running	35	4	t	2025-07-01 01:07:01.107229
127	17	Resistencia Acuática	Ejercicios de resistencia usando la densidad del agua	rutina	5	https://youtube.com/watch?v=resistencia_acuatica	45	5	t	2025-07-01 01:07:01.107229
128	17	Aqua HIIT	Intervalos de alta intensidad adaptados al agua	rutina	6	https://youtube.com/watch?v=aqua_hiit	40	6	t	2025-07-01 01:07:01.107229
129	17	Relajación Acuática	Ejercicios de enfriamiento y flotación relajante	rutina	7	https://youtube.com/watch?v=relajacion_acuatica	25	7	t	2025-07-01 01:07:01.107229
130	17	Equipamiento Acuático	Guía de accesorios para maximizar entrenamientos en agua	guia	\N	/static/guides/equipamiento_aqua.pdf	15	8	f	2025-07-01 01:07:01.107229
131	17	Seguridad en Aqua Fitness	Protocolo de seguridad para ejercicio acuático	guia	\N	/static/guides/seguridad_aqua.pdf	10	9	t	2025-07-01 01:07:01.107229
132	7	Introducción al Yoga	Historia, filosofía y beneficios del yoga	rutina	1	https://youtube.com/watch?v=introduccion_yoga	30	1	t	2025-07-01 01:07:30.738192
133	7	Respiración Básica (Pranayama)	Técnicas fundamentales de respiración yogui	rutina	2	https://youtube.com/watch?v=pranayama_basico	25	2	t	2025-07-01 01:07:30.738192
134	7	Posturas de Pie (Asanas)	Posturas fundamentales en posición de pie	rutina	3	https://youtube.com/watch?v=asanas_pie	40	3	t	2025-07-01 01:07:30.738192
135	7	Posturas Sentadas	Asanas en posición sentada para flexibilidad	rutina	4	https://youtube.com/watch?v=posturas_sentadas	35	4	t	2025-07-01 01:07:30.738192
136	7	Saludo al Sol	Secuencia clásica del Surya Namaskara	rutina	5	https://youtube.com/watch?v=saludo_sol	30	5	t	2025-07-01 01:07:30.738192
137	7	Posturas de Relajación	Asanas restaurativas para descanso profundo	rutina	6	https://youtube.com/watch?v=posturas_relajacion	45	6	t	2025-07-01 01:07:30.738192
138	7	Meditación Guiada	Introducción a la meditación sentada	rutina	7	https://youtube.com/watch?v=meditacion_guiada	20	7	t	2025-07-01 01:07:30.738192
139	7	Manual de Yoga	Guía completa con ilustraciones de todas las posturas	guia	\N	/static/guides/manual_yoga.pdf	30	8	f	2025-07-01 01:07:30.738192
140	7	Música para Yoga	Playlist relajante para práctica de yoga	guia	\N	/static/guides/musica_yoga.pdf	10	9	f	2025-07-01 01:07:30.738192
141	8	Fundamentos de la Respiración	Anatomía respiratoria y respiración consciente	rutina	1	https://youtube.com/watch?v=fundamentos_respiracion	25	1	t	2025-07-01 01:07:58.293072
142	8	Respiración Abdominal	Técnica de respiración diafragmática profunda	rutina	2	https://youtube.com/watch?v=respiracion_abdominal	20	2	t	2025-07-01 01:07:58.293072
143	8	Respiración 4-7-8	Técnica relajante para reducir estrés y ansiedad	rutina	3	https://youtube.com/watch?v=respiracion_478	15	3	t	2025-07-01 01:07:58.293072
144	8	Meditación Mindfulness	Atención plena para principiantes	rutina	4	https://youtube.com/watch?v=mindfulness_principiantes	20	4	t	2025-07-01 01:07:58.293072
145	8	Respiración Alternada	Nadi Shodhana para equilibrar el sistema nervioso	rutina	5	https://youtube.com/watch?v=respiracion_alternada	25	5	t	2025-07-01 01:07:58.293072
146	8	Meditación Body Scan	Escaneo corporal para relajación profunda	rutina	6	https://youtube.com/watch?v=body_scan	30	6	t	2025-07-01 01:07:58.293072
147	8	Meditación de Gratitud	Práctica de agradecimiento para bienestar mental	rutina	7	https://youtube.com/watch?v=meditacion_gratitud	15	7	t	2025-07-01 01:07:58.293072
148	8	Guía de Meditación	Manual completo sobre diferentes tipos de meditación	guia	\N	/static/guides/guia_meditacion.pdf	25	8	f	2025-07-01 01:07:58.293072
149	8	App de Meditación	Timer y guías de audio para práctica diaria	herramienta	\N	/static/tools/timer_meditacion.html	10	9	f	2025-07-01 01:07:58.293072
150	9	Fundamentos del Pilates	Historia, principios y beneficios del método Pilates	rutina	1	https://youtube.com/watch?v=fundamentos_pilates	35	1	t	2025-07-01 01:08:26.876995
151	9	Respiración Pilates	Técnica respiratoria específica del método	rutina	2	https://youtube.com/watch?v=respiracion_pilates	20	2	t	2025-07-01 01:08:26.876995
152	9	Powerhouse Activation	Activación del centro de fuerza corporal	rutina	3	https://youtube.com/watch?v=powerhouse_pilates	30	3	t	2025-07-01 01:08:26.876995
153	9	Pilates para Columna	Ejercicios específicos para salud espinal	rutina	4	https://youtube.com/watch?v=pilates_columna	40	4	t	2025-07-01 01:08:26.876995
154	9	Corrección Postural	Ejercicios para corregir desequilibrios posturales	rutina	5	https://youtube.com/watch?v=correccion_postural	45	5	t	2025-07-01 01:08:26.876995
155	9	Pilates con Accesorios	Uso de pelotas, bandas y otros implementos	rutina	6	https://youtube.com/watch?v=pilates_accesorios	50	6	t	2025-07-01 01:08:26.876995
156	9	Rutina Completa Mat Pilates	Secuencia completa de ejercicios en colchoneta	rutina	7	https://youtube.com/watch?v=mat_pilates_completo	55	7	t	2025-07-01 01:08:26.876995
157	9	Manual de Posturas	Guía ilustrada de posturas correctas e incorrectas	guia	\N	/static/guides/manual_posturas.pdf	20	8	f	2025-07-01 01:08:26.876995
158	9	Evaluación Postural	Herramienta de autoevaluación postural	herramienta	\N	/static/tools/evaluacion_postural.html	15	9	f	2025-07-01 01:08:26.876995
159	20	Introducción al Yoga Restaurativo	Principios y beneficios del yoga pasivo y reparador	rutina	1	https://youtube.com/watch?v=intro_yoga_restaurativo	30	1	t	2025-07-01 01:10:09.571748
160	20	Posturas con Apoyo	Asanas restaurativas usando almohadas y mantas	rutina	2	https://youtube.com/watch?v=posturas_apoyo	40	2	t	2025-07-01 01:10:09.571748
161	20	Yoga para el Estrés	Secuencia específica para reducir estrés y ansiedad	rutina	3	https://youtube.com/watch?v=yoga_estres	35	3	t	2025-07-01 01:10:09.571748
162	20	Yoga para Mejor Sueño	Rutina nocturna para mejorar calidad del descanso	rutina	4	https://youtube.com/watch?v=yoga_sueno	30	4	t	2025-07-01 01:10:09.571748
163	20	Yin Yoga	Posturas pasivas mantenidas por largos períodos	rutina	5	https://youtube.com/watch?v=yin_yoga	50	5	t	2025-07-01 01:10:09.571748
164	20	Yoga Nidra	Meditación de relajación profunda guiada	rutina	6	https://youtube.com/watch?v=yoga_nidra	45	6	t	2025-07-01 01:10:09.571748
165	20	Ritual de Autocuidado	Secuencia completa de autocuidado con yoga	rutina	7	https://youtube.com/watch?v=ritual_autocuidado	60	7	t	2025-07-01 01:10:09.571748
166	20	Guía de Props	Manual de accesorios para yoga restaurativo	guia	\N	/static/guides/props_yoga_restaurativo.pdf	15	8	f	2025-07-01 01:10:09.571748
167	20	Música Relajante	Playlist de música ambiente para relajación	guia	\N	/static/guides/musica_relajante.pdf	10	9	f	2025-07-01 01:10:09.571748
168	10	Revisión de Conceptos Básicos	Repaso de fundamentos del entrenamiento	guia	1	\N	20	1	t	2025-07-01 01:18:48.109672
169	10	Evaluación Práctica	Prueba práctica de los conocimientos adquiridos	evaluacion	1	\N	30	2	t	2025-07-01 01:18:48.109672
170	13	Fundamentos de la Pérdida de Peso	Conceptos básicos: déficit calórico, metabolismo, nutrición	guia	1	\N	25	3	t	2025-07-01 01:18:48.116656
171	13	Rutina Express Quemagrasas	Circuito de 20 minutos: burpees, jumping jacks, mountain climbers	rutina	1	\N	20	4	t	2025-07-01 01:18:48.116656
172	13	Cardio Intenso Intervalos	HIIT de 15 minutos para máxima quema de calorías	rutina	2	\N	15	5	t	2025-07-01 01:18:48.116656
173	13	Plan Nutricional Express	Guía rápida de alimentación para pérdida de peso	guia	2	\N	30	6	t	2025-07-01 01:18:48.116656
174	20	Principios del Fitness	Conceptos fundamentales: tipos de ejercicio, frecuencia, intensidad	guia	1	\N	30	3	t	2025-07-01 01:18:48.123304
175	20	Evaluación Física Inicial	Cómo medir tu nivel de condición física actual	evaluacion	1	\N	20	4	t	2025-07-01 01:18:48.123304
176	20	Rutina de Fuerza Básica	Ejercicios con peso corporal: sentadillas, flexiones, plancha	rutina	2	\N	25	5	t	2025-07-01 01:18:48.123304
177	20	Cardio para Principiantes	Introducción al ejercicio cardiovascular de bajo impacto	rutina	2	\N	20	6	t	2025-07-01 01:18:48.123304
178	20	Flexibilidad y Movilidad	Rutina de estiramiento y movilidad articular	rutina	3	\N	30	7	t	2025-07-01 01:18:48.123304
179	20	Planificación de tu Rutina	Cómo crear un plan de entrenamiento personalizado	guia	3	\N	25	8	f	2025-07-01 01:18:48.123304
180	21	Qué es el Entrenamiento Funcional	Principios y beneficios del entrenamiento funcional	guia	1	\N	20	1	t	2025-07-01 01:18:48.130285
181	21	Movimientos Básicos Funcionales	Sentadilla, peso muerto, empuje, tracción - patrones fundamentales	rutina	1	\N	35	2	t	2025-07-01 01:18:48.130285
182	21	Entrenamiento con Kettlebells	Swing, press, goblet squat - ejercicios funcionales con kettlebell	rutina	2	\N	30	3	t	2025-07-01 01:18:48.130285
183	21	Functional Training con TRX	Ejercicios en suspensión para fuerza funcional	rutina	2	\N	25	4	t	2025-07-01 01:18:48.130285
184	21	Circuito Funcional Completo	Combinación de movimientos funcionales en circuito	rutina	3	\N	40	5	t	2025-07-01 01:18:48.130285
185	21	Aplicación en la Vida Diaria	Cómo transferir los ejercicios a actividades cotidianas	guia	3	\N	20	6	f	2025-07-01 01:18:48.130285
186	22	Progresión desde Pilates Básico	Revisión de fundamentos y progresión a nivel intermedio	guia	1	\N	15	1	t	2025-07-01 01:18:48.138264
187	22	Serie Clásica Intermedia	Teaser, Roll Over, Corkscrew - ejercicios de nivel intermedio	rutina	1	\N	35	2	t	2025-07-01 01:18:48.138264
188	22	Pilates con Props	Ejercicios con pelota, banda elástica y magic circle	rutina	2	\N	30	3	t	2025-07-01 01:18:48.138264
189	22	Trabajo Avanzado de Core	Ejercicios desafiantes para el centro: Double Leg Stretch, Criss Cross	rutina	2	\N	25	4	t	2025-07-01 01:18:48.138264
190	22	Pilates de Pie	Ejercicios en posición vertical para fuerza y equilibrio	rutina	3	\N	30	5	t	2025-07-01 01:18:48.138264
191	22	Secuencia de Flujo Intermedio	Rutina completa conectando todos los ejercicios aprendidos	rutina	3	\N	40	6	t	2025-07-01 01:18:48.138264
192	20	Nutrición Básica para Fitness	Fundamentos de nutrición deportiva para principiantes	guia	4	\N	25	9	t	2025-07-01 01:19:32.691342
193	20	Hidratación y Recuperación	Importancia de la hidratación y técnicas de recuperación	guia	4	\N	20	10	f	2025-07-01 01:19:32.691342
194	20	Rutina Completa Semanal	Plan de entrenamiento completo para la primera semana	rutina	5	\N	45	11	t	2025-07-01 01:19:32.691342
195	20	Seguimiento y Progreso	Cómo medir y registrar tu progreso en el fitness	guia	5	\N	15	12	f	2025-07-01 01:19:32.691342
196	14	Suplementación para Hipertrofia	Guía de suplementos efectivos para el crecimiento muscular	guia	5	\N	30	9	f	2025-07-01 01:19:32.691342
197	14	Rutina de Especialización	Programa especializado para grupos musculares rezagados	rutina	5	\N	50	10	t	2025-07-01 01:19:32.691342
198	10	Análisis de Resultados	Interpretación de los resultados de la evaluación	guia	2	\N	25	3	t	2025-07-01 01:20:33.911703
199	10	Plan de Mejora Personal	Creación de un plan personalizado basado en los resultados	guia	2	\N	30	4	t	2025-07-01 01:20:33.911703
200	10	Ejercicios de Refuerzo	Rutina de ejercicios para mejorar áreas débiles identificadas	rutina	3	\N	35	5	t	2025-07-01 01:20:33.911703
201	10	Seguimiento y Reevaluación	Cómo hacer seguimiento del progreso y cuándo reevaluar	guia	3	\N	20	6	f	2025-07-01 01:20:33.911703
202	12	Equipamiento Básico para Casa	Qué equipo necesitas para entrenar en casa efectivamente	guia	6	\N	20	13	f	2025-07-01 01:20:33.911703
203	12	Rutina de Fuerza Progresiva	Progresión semanal en ejercicios de fuerza	rutina	6	\N	40	14	t	2025-07-01 01:20:33.911703
204	12	Cardio Variado para Principiantes	Diferentes tipos de ejercicio cardiovascular adaptados	rutina	7	\N	30	15	t	2025-07-01 01:20:33.911703
205	12	Hábitos Saludables Diarios	Cómo integrar el fitness en tu rutina diaria	guia	7	\N	25	16	t	2025-07-01 01:20:33.911703
\.


--
-- Data for Name: inscripciones; Type: TABLE DATA; Schema: public; Owner: vitadmin
--

COPY public.inscripciones (user_id, taller_id, fecha_inscripcion) FROM stdin;
2	11	2025-06-30 16:49:23.384082
2	17	2025-07-01 00:30:26.616165
2	19	2025-07-01 00:36:16.972333
2	18	2025-07-01 00:36:33.000892
2	14	2025-07-01 00:36:54.685793
2	21	2025-07-01 00:39:41.917651
2	16	2025-07-01 01:23:20.689116
\.


--
-- Data for Name: planes_ganar_masa; Type: TABLE DATA; Schema: public; Owner: vitadmin
--

COPY public.planes_ganar_masa (id) FROM stdin;
41
\.


--
-- Data for Name: planes_perder_peso; Type: TABLE DATA; Schema: public; Owner: vitadmin
--

COPY public.planes_perder_peso (id) FROM stdin;
\.


--
-- Data for Name: planes_salud; Type: TABLE DATA; Schema: public; Owner: vitadmin
--

COPY public.planes_salud (id, nombre, descripcion, tipo, calorias, proteinas, rutina, user_id, imagen) FROM stdin;
4	Plan Hipertrofia Clásica	Superávit de 500 cal/día. Proteínas: 130g.	ganar_masa	2600	130	Pesas 5 días/semana + movilidad	4	hipertrofia.png
5	Plan Volumen Eficiente	Incremento calórico progresivo para volumen limpio.	ganar_masa	2800	140	Entrenamiento dividido 6 días	5	volumen_eficiente.png
6	Plan Avanzado Masa	Superávit agresivo para atletas intermedios.	ganar_masa	3100	150	Pesas + calistenia avanzada	6	avanzado_masa.png
1	Plan Básico Quema Grasa	Déficit de 500 cal/día. Proteínas: 85g. Rutina: cardio ligero.	perder_peso	1450	90	Caminar 40min + abdominales básicos	1	express_perder.png
2	Plan HIIT Power	Déficit controlado. Rutina intensa para resultados rápidos.	perder_peso	1500	91	HIIT 30min + pesas ligeras	2	plan_basico.png
12	Plan personalizado	Superávit de 500 cal/día. Proteínas: 121g. Rutina: Hipertrofia 4 días/semana + movilidad.	ganar_masa	2482	121	Hipertrofia 4 días/semana + movilidad	2	hiit_power.png
13	Plan personalizado	Déficit de 500 cal/día. Proteínas: 110g. Rutina: 30 min cardio + fuerza con peso corporal.	perder_peso	1482	110	30 min cardio + fuerza con peso corporal	2	plan_basico.png
29	Plan Personalizado para Perder Peso	Plan de PÉRDIDA DE PESO: Déficit de 500 cal/día. Proteínas: 121g. Rutina: 45 min cardio intenso + entrenamiento de fuerza completo 5-6 veces/semana.	perder_peso	1930	121	45 min cardio intenso + entrenamiento de fuerza completo 5-6 veces/semana	2	express_perder.png
30	Plan Personalizado para Ganar Masa	Plan de GANANCIA DE MASA: Superávit de 500 cal/día. Proteínas: 132g. Rutina: Hipertrofia avanzada 5-6 días/semana + cardio ligero.	ganar_masa	2930	132	Hipertrofia avanzada 5-6 días/semana + cardio ligero	2	hipertrofia.png
31	Plan Personalizado para Perder Peso	Plan de PÉRDIDA DE PESO: Déficit de 500 cal/día. Proteínas: 121g. Rutina: 45 min cardio intenso + entrenamiento de fuerza completo 5-6 veces/semana.	perder_peso	1930	121	45 min cardio intenso + entrenamiento de fuerza completo 5-6 veces/semana	2	express_perder.png
3	Plan Express Perder Grasa	Plan corto de impacto semanal con déficit calórico fuerte.	perder_peso	1300	100	Cardio 5x semana + estiramiento	3	express_perder.png
14	Plan personalizado	Superávit de 500 cal/día. Proteínas: 121g. Rutina: Hipertrofia 4 días/semana + movilidad.	ganar_masa	2482	121	Hipertrofia 4 días/semana + movilidad	2	hiit_power.png
15	Plan personalizado	Superávit de 500 cal/día. Proteínas: 110g. Rutina: Hipertrofia 4 días/semana + movilidad.	ganar_masa	2034	110	Hipertrofia 4 días/semana + movilidad	2	hiit_power.png
16	Plan personalizado	Déficit de 500 cal/día. Proteínas: 99g. Rutina: 30 min cardio + fuerza con peso corporal.	perder_peso	1034	99	30 min cardio + fuerza con peso corporal	2	plan_basico.png
17	Plan personalizado	Déficit de 500 cal/día. Proteínas: 121g. Rutina: 30 min cardio + fuerza con peso corporal.	perder_peso	1930	121	30 min cardio + fuerza con peso corporal	2	plan_basico.png
18	Plan personalizado	Superávit de 500 cal/día. Proteínas: 132g. Rutina: Hipertrofia 4 días/semana + movilidad.	ganar_masa	2930	132	Hipertrofia 4 días/semana + movilidad	2	hipertrofia.png
19	Plan personalizado	Déficit de 500 cal/día. Proteínas: 121g. Rutina: 30 min cardio + fuerza con peso corporal.	perder_peso	1930	121	30 min cardio + fuerza con peso corporal	2	express_perder.png
20	Plan personalizado	Superávit de 500 cal/día. Proteínas: 132g. Rutina: Hipertrofia 4 días/semana + movilidad.	ganar_masa	2930	132	Hipertrofia 4 días/semana + movilidad	2	\N
21	Plan Personalizado para Perder Peso	Plan de PÉRDIDA DE PESO: Déficit de 500 cal/día. Proteínas: 121g. Rutina: 30 min cardio + fuerza con peso corporal.	perder_peso	1930	121	30 min cardio + fuerza con peso corporal	2	express_perder.png
22	Plan Personalizado para Ganar Masa	Plan de GANANCIA DE MASA: Superávit de 500 cal/día. Proteínas: 132g. Rutina: Hipertrofia 4 días/semana + movilidad.	ganar_masa	2930	132	Hipertrofia 4 días/semana + movilidad	2	hipertrofia.png
32	Plan Personalizado para Ganar Masa	Plan de GANANCIA DE MASA: Superávit de 500 cal/día. Proteínas: 132g. Rutina: Hipertrofia avanzada 5-6 días/semana + cardio ligero.	ganar_masa	2930	132	Hipertrofia avanzada 5-6 días/semana + cardio ligero	2	hipertrofia.png
33	Plan Personalizado para Perder Peso	Plan de PÉRDIDA DE PESO: Déficit de 500 cal/día. Proteínas: 121g. Rutina: 45 min cardio intenso + entrenamiento de fuerza completo 5-6 veces/semana.	perder_peso	1930	121	45 min cardio intenso + entrenamiento de fuerza completo 5-6 veces/semana	2	express_perder.png
34	Plan Personalizado para Perder Peso	Plan de PÉRDIDA DE PESO: Déficit de 500 cal/día. Proteínas: 99g. Rutina: Caminar 30 min diarios + ejercicios básicos de peso corporal 3 veces/semana.	perder_peso	1034	99	Caminar 30 min diarios + ejercicios básicos de peso corporal 3 veces/semana	2	express_perder.png
35	Plan Personalizado para Perder Peso	Plan de PÉRDIDA DE PESO: Déficit de 500 cal/día. Proteínas: 110g. Rutina: 30 min cardio moderado + fuerza con peso corporal 4 veces/semana.	perder_peso	1482	110	30 min cardio moderado + fuerza con peso corporal 4 veces/semana	2	express_perder.png
36	Plan Personalizado para Ganar Masa	Plan de GANANCIA DE MASA: Superávit de 500 cal/día. Proteínas: 121g. Rutina: Hipertrofia 4 días/semana + flexibilidad.	ganar_masa	2482	121	Hipertrofia 4 días/semana + flexibilidad	2	hipertrofia.png
37	Plan Personalizado para Ganar Masa	Plan de GANANCIA DE MASA: Superávit de 500 cal/día. Proteínas: 110g. Rutina: Entrenamiento básico de fuerza 3 días/semana + descanso activo.	ganar_masa	2034	110	Entrenamiento básico de fuerza 3 días/semana + descanso activo	2	hipertrofia.png
38	Plan Personalizado para Ganar Masa	Plan de GANANCIA DE MASA: Superávit de 500 cal/día. Proteínas: 132g. Rutina: Hipertrofia avanzada 5-6 días/semana + cardio ligero.	ganar_masa	2930	132	Hipertrofia avanzada 5-6 días/semana + cardio ligero	2	hipertrofia.png
40	Plan Personalizado para Perder Peso	Plan de PÉRDIDA DE PESO: Déficit de 500 cal/día. Proteínas: 121g. Rutina: 45 min cardio intenso + entrenamiento de fuerza completo 5-6 veces/semana.	perder_peso	1930	121	45 min cardio intenso + entrenamiento de fuerza completo 5-6 veces/semana	2	express_perder.png
41	Plan Personalizado para Ganar Masa	Plan de GANANCIA DE MASA: Superávit de 500 cal/día. Proteínas: 132g. Rutina: Hipertrofia avanzada 5-6 días/semana + cardio ligero.	ganar_masa	2930	132	Hipertrofia avanzada 5-6 días/semana + cardio ligero	2	hipertrofia.png
\.


--
-- Data for Name: progreso_contenido; Type: TABLE DATA; Schema: public; Owner: vitadmin
--

COPY public.progreso_contenido (user_id, contenido_id, completado, fecha_completado) FROM stdin;
2	1	f	\N
\.


--
-- Data for Name: talleres; Type: TABLE DATA; Schema: public; Owner: vitadmin
--

COPY public.talleres (id, nombre, descripcion, cupos, objetivo, fecha, nivel_actividad, dias_semana) FROM stdin;
4	Fuerza Base con Mancuernas	Aumenta masa muscular con entrenamientos efectivos.	13	ganar_masa	2025-07-19 00:27:49.235099	bajo	Lunes, Miércoles y Viernes
5	Rutina de Hipertrofia Avanzada	Aumenta masa muscular con entrenamientos efectivos.	20	ganar_masa	2025-07-18 00:27:49.236116	alto	Lunes, Miércoles y Viernes
6	Técnicas de Carga Progresiva	Aumenta masa muscular con entrenamientos efectivos.	19	ganar_masa	2025-07-26 00:27:49.236116	moderado	Lunes, Miércoles y Viernes
14	Hipertrofia Avanzada	Programa avanzado para ganancia de masa muscular con técnicas especializadas.	20	ganar_masa	2025-07-05 11:44:43.695423	alto	Lunes, Miércoles y Viernes
2	Bailoterapia Quema Calorías	Mejora tu resistencia cardiovascular y quema grasa.	15	perder_peso	2025-07-13 00:27:49.234262	moderado	Lunes, Miércoles y Viernes
3	HIIT con Peso Corporal	Mejora tu resistencia cardiovascular y quema grasa.	11	perder_peso	2025-07-02 00:27:49.235099	alto	Lunes, Miércoles y Viernes
7	Yoga para Principiantes	Actividades para equilibrio físico y mental.	13	mejorar_salud	2025-07-16 00:27:49.237098	bajo	Lunes, Miércoles y Viernes
8	Respiración y Meditación Guiada	Actividades para equilibrio físico y mental.	15	mejorar_salud	2025-07-21 00:27:49.238096	bajo	Lunes, Miércoles y Viernes
9	Pilates para la Postura	Actividades para equilibrio físico y mental.	14	mejorar_salud	2025-07-14 00:27:49.238096	moderado	Lunes, Miércoles y Viernes
1	Cardio Funcional Express	Mejora tu resistencia cardiovascular y quema grasa.	12	perder_peso	2025-07-24 00:27:49.231265	\N	Lunes, Miércoles y Viernes
10	Taller Test Pasado	Taller para probar filtro de fecha	10	perder_peso	2025-06-25 00:31:52.296193	\N	Lunes, Miércoles y Viernes
11	Rutinas Personales 7 Días	Programa completo de 7 días con rutinas personalizadas para alcanzar tus objetivos fitness. Incluye videos guiados, seguimiento nutricional y sesiones en vivo.	50	mejorar_salud	2025-07-01 11:44:19.729095	\N	Lunes, Miércoles y Viernes
13	Express Perder Peso	Programa intensivo diseñado específicamente para pérdida de peso efectiva y saludable.	25	perder_peso	2025-07-02 11:44:43.687014	\N	Lunes, Miércoles y Viernes
15	Cardio para Principiantes	Rutinas de cardio de bajo impacto perfectas para empezar tu viaje de pérdida de peso	15	perder_peso	2025-07-03 13:17:22.775056	bajo	Lunes y Miércoles
16	HIIT Quemagrasas	Entrenamiento de alta intensidad para maximizar la quema de calorías	12	perder_peso	2025-07-05 13:17:22.775056	alto	Martes y Jueves
17	Aqua Fitness	Ejercicios en agua de intensidad moderada, ideal para articulaciones	10	perder_peso	2025-07-07 13:17:22.775056	moderado	Miércoles y Viernes
18	Introducción al Peso Libre	Aprende los fundamentos del entrenamiento con pesas desde cero	8	ganar_masa	2025-07-04 13:17:22.775056	bajo	Lunes, Miércoles y Viernes
19	Fuerza Funcional	Desarrollo de fuerza aplicable a la vida diaria	12	ganar_masa	2025-07-08 13:17:22.775056	moderado	Lunes y Miércoles
20	Yoga Restaurativo	Yoga suave para reducir estrés y mejorar flexibilidad	20	mejorar_salud	2025-07-02 13:17:22.775056	bajo	Todos los días
12	Plan Básico - Introducción al Fitness	Programa de introducción perfecto para principiantes. Aprende los fundamentos del ejercicio y la alimentación saludable.	30	mejorar_salud	2025-07-03 11:44:43.673362	bajo	Lunes, Miércoles y Viernes
21	Entrenamiento Funcional	Movimientos naturales para mejorar la calidad de vida	15	mejorar_salud	2025-07-09 13:17:22.775056	alto	Lunes a Viernes
22	Pilates Intermedio	Fortalecimiento del core y mejora de la postura	12	mejorar_salud	2025-07-10 13:17:22.775056	moderado	Martes y Jueves
23	Powerlifting y Fuerza Máxima	Entrenamiento avanzado de fuerza con técnicas de powerlifting y levantamiento olímpico	15	ganar_masa	2025-07-10 19:39:23.734556	alto	Lunes, Miércoles, Viernes
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: vitadmin
--

COPY public.users (id, username, email, password, role, objetivo, peso, altura, actividad, genero) FROM stdin;
9	Katty Moyano	katty@gmail.com	scrypt:32768:8:1$fVpXHaqTrYUHTo1M$798a70011300a373b05c2ccc9c4bde9ab2d07555f08393401c9d34ef6c0e863abbb545dc4666460b4ef5754f7f301d18fb9edef0dddc211ad612d185ae1c9a87	usuario	mejorar_salud	55	157	moderado	femenino
1	Carla	carlitalomas13@gmail.com	scrypt:32768:8:1$IznSLAZOHqKQ6eoL$8336909701d5c8d2975a9e2dcda1bbe483da7610181d382b05d620feedaadc92f6e2ec2ba154515c36f5d7fb5ca1ef59ab5a8a05b54f2f3bc83bcf887072a06a	usuario	perder_peso	55	160	alto	Femenino
0	Admin	admin@admin.com	scrypt:32768:8:1$DWWN5KtE1kBCfmXY$b86ef30b09a51bd4705c51f99a8002964a742faa06e283d91c99d473ec5822304079929973f1ab8e5770f975e9a4a0fd93ad2121bc3ed9ae6fd7e0b2d47860e3	admin	ninguno	0	0	ninguno	ninguno
4	Daniel	daniel@gmail.com	scrypt:32768:8:1$vxHjH1qMUmcKZOcz$1e6ed3e5ab12bcbcd807a74f7a3117e964dc7cd5d42c718b4bf5a4d578e3b086f6bf4c0b25019dd508bda93db595235a3cfb64a9d57d51dcce8695a6956128b9	usuario	ganar_masa	70	165	moderado	masculino
7	usuario7	usuario7@example.com	pbkdf2:sha256:260000$Ww8NVlOzyf7jsyhu$e6bfb5deae2a2998f3c4f80130e37f9d71cd546acfc3e8e3b0a19642cc89c894	usuario	ganar_masa	58	170	bajo	femenino
8	usuario8	usuario8@example.com	pbkdf2:sha256:260000$Ww8NVlOzyf7jsyhu$e6bfb5deae2a2998f3c4f80130e37f9d71cd546acfc3e8e3b0a19642cc89c894	usuario	ganar_masa	60	180	moderado	masculino
3	Kelly	kelly@gmail.com	scrypt:32768:8:1$OgQp8DINl60y4Rum$45431dddab57ad53a1e0c02eda1709a0bca608504d510949415ff837e4bbcee8d3b35dd99b17ebd38e702f714a74d3450d595ba2b6af59c252109cbdcabc58f3	usuario	perder_peso	56	165	bajo	femenino
5	usuario5	usuario5@example.com	pbkdf2:sha256:260000$Ww8NVlOzyf7jsyhu$e6bfb5deae2a2998f3c4f80130e37f9d71cd546acfc3e8e3b0a19642cc89c894	usuario	ganar_masa	65	160	moderado	femenino
6	usuario6	usuario6@example.com	pbkdf2:sha256:260000$Ww8NVlOzyf7jsyhu$e6bfb5deae2a2998f3c4f80130e37f9d71cd546acfc3e8e3b0a19642cc89c894	usuario	ganar_masa	72	168	alto	masculino
2	Carlal	cl@gmail.com	scrypt:32768:8:1$BJGwqMIiNAAzRbi5$0c528d586ee87a4df3cfbfdb53b6469f3279327bbe4bddbf832c6fde625fa54daeddafa6a5c668788d91f94d2ac8a8c0030cf3797cde04f4f3975ec4f2cbd0f9	usuario	ganar_masa	55	160	alto	femenino
\.


--
-- Name: contenido_taller_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vitadmin
--

SELECT pg_catalog.setval('public.contenido_taller_id_seq', 205, true);


--
-- Name: planes_salud_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vitadmin
--

SELECT pg_catalog.setval('public.planes_salud_id_seq', 41, true);


--
-- Name: talleres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vitadmin
--

SELECT pg_catalog.setval('public.talleres_id_seq', 23, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vitadmin
--

SELECT pg_catalog.setval('public.users_id_seq', 9, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: contenido_taller contenido_taller_pkey; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.contenido_taller
    ADD CONSTRAINT contenido_taller_pkey PRIMARY KEY (id);


--
-- Name: inscripciones inscripciones_pkey; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT inscripciones_pkey PRIMARY KEY (user_id, taller_id);


--
-- Name: planes_ganar_masa planes_ganar_masa_pkey; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.planes_ganar_masa
    ADD CONSTRAINT planes_ganar_masa_pkey PRIMARY KEY (id);


--
-- Name: planes_perder_peso planes_perder_peso_pkey; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.planes_perder_peso
    ADD CONSTRAINT planes_perder_peso_pkey PRIMARY KEY (id);


--
-- Name: planes_salud planes_salud_pkey; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.planes_salud
    ADD CONSTRAINT planes_salud_pkey PRIMARY KEY (id);


--
-- Name: progreso_contenido progreso_contenido_pkey; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.progreso_contenido
    ADD CONSTRAINT progreso_contenido_pkey PRIMARY KEY (user_id, contenido_id);


--
-- Name: talleres talleres_pkey; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.talleres
    ADD CONSTRAINT talleres_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: contenido_taller contenido_taller_taller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.contenido_taller
    ADD CONSTRAINT contenido_taller_taller_id_fkey FOREIGN KEY (taller_id) REFERENCES public.talleres(id);


--
-- Name: inscripciones inscripciones_taller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT inscripciones_taller_id_fkey FOREIGN KEY (taller_id) REFERENCES public.talleres(id);


--
-- Name: inscripciones inscripciones_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT inscripciones_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: planes_ganar_masa planes_ganar_masa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.planes_ganar_masa
    ADD CONSTRAINT planes_ganar_masa_id_fkey FOREIGN KEY (id) REFERENCES public.planes_salud(id);


--
-- Name: planes_perder_peso planes_perder_peso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.planes_perder_peso
    ADD CONSTRAINT planes_perder_peso_id_fkey FOREIGN KEY (id) REFERENCES public.planes_salud(id);


--
-- Name: planes_salud planes_salud_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.planes_salud
    ADD CONSTRAINT planes_salud_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: progreso_contenido progreso_contenido_contenido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.progreso_contenido
    ADD CONSTRAINT progreso_contenido_contenido_id_fkey FOREIGN KEY (contenido_id) REFERENCES public.contenido_taller(id);


--
-- Name: progreso_contenido progreso_contenido_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vitadmin
--

ALTER TABLE ONLY public.progreso_contenido
    ADD CONSTRAINT progreso_contenido_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

