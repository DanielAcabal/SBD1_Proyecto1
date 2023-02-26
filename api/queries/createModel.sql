CREATE TABLE asociado (
    id_asociado INTEGER NOT NULL PRIMARY KEY
    nombre      VARCHAR2(20) NOT NULL,
    apellido    VARCHAR2(20) NOT NULL,
);

CREATE TABLE contacto (
    id_contacto INTEGER NOT NULL PRIMARY KEY,
    nombre      VARCHAR2(25) NOT NULL
);

CREATE TABLE hospital (
    id_hospital INTEGER NOT NULL PRIMARY KEY
    nombre      VARCHAR2(30) NOT NULL,
    direccion   VARCHAR2(50) NOT NULL,
);

CREATE TABLE lugar (
    id_lugar INTEGER NOT NULL PRIMARY KEY,
    nombre   VARCHAR2(50)
);

CREATE TABLE tratamiento (
    id_tratamiento INTEGER NOT NULL PRIMARY KEY,
    nombre         VARCHAR2(20) NOT NULL,
    efectividad    INTEGER NOT NULL
);

CREATE TABLE victima (
    id_victima           INTEGER NOT NULL PRIMARY KEY,
    nombre               VARCHAR2(25) NOT NULL,
    apellido             VARCHAR2(30) NOT NULL,
    direccion            VARCHAR2(70) NOT NULL,
    fecha_muerte         TIMESTAMP,
    estado               VARCHAR2(20) NOT NULL,
    fecha_confirmacion   TIMESTAMP NOT NULL,
    fecha_sospecha       TIMESTAMP NOT NULL,
    id_hospital 				 INTEGER NOT NULL,
		CONSTRAINT victima_hospital_fk FOREIGN KEY ( id_hospital ) REFERENCES hospital(id_hospital)
);

CREATE TABLE ubicacion (
		id                 INTEGER NOT NULL PRIMARY KEY,
    fecha_llegada      TIMESTAMP NOT NULL,
    fecha_salida       TIMESTAMP NOT NULL,
		id_lugar 					 INTEGER NOT NULL,
		id_victima 				 INTEGER NOT NULL,
		CONSTRAINT ubicacion_lugar_fk FOREIGN KEY ( id_lugar ) REFERENCES lugar(id_lugar),
		CONSTRAINT ubicacion_victima_fk FOREIGN KEY ( id_victima ) REFERENCES victima(id_victima)
);

CREATE TABLE observacion (
		id                         INTEGER NOT NULL PRIMARY KEY,
    fecha_inicio               TIMESTAMP NOT NULL,
    fecha_fin                  TIMESTAMP NOT NULL,
    efectividad                INTEGER NOT NULL,
		id_tratamiento   					 INTEGER NOT NULL,
		id_victima								 INTEGER NOT NULL, 
		CONSTRAINT observacion_tratamiento_fk FOREIGN KEY ( id_tratamiento ) REFERENCES tratamiento(id_tratamiento),
		CONSTRAINT observacion_victima_fk FOREIGN KEY ( id_victima ) REFERENCES victima(id_victima)
);

CREATE TABLE relacion (
    id_relacion          INTEGER NOT NULL PRIMARY KEY,
    fecha_conocio        TIMESTAMP NOT NULL,
		id_victima 					 INTEGER NOT NULL,
		id_asociado					 INTEGER NOT NULL, 
		CONSTRAINT relacion_victima_fk FOREIGN KEY ( id_victima ) REFERENCES victima(id_victima),
		CONSTRAINT relacion_asociado_fk FOREIGN KEY ( id_asociado ) REFERENCES asociado(id_asociado)
);

CREATE TABLE interaccion (
		id                   INTEGER NOT NULL PRIMARY KEY,
    fecha_inicio         TIMESTAMP NOT NULL,
    fecha_fin            TIMESTAMP NOT NULL,
		id_contacto 				 INTEGER NOT NULL, 
		id_relacion					 INTEGER NOT NULL, 
		CONSTRAINT interaccion_contacto_fk FOREIGN KEY ( id_contacto ) REFERENCES contacto(id_contacto),
		CONSTRAINT interaccion_relacion_fk FOREIGN KEY ( id_relacion ) REFERENCES relacion(id_relacion)
);

CREATE SEQUENCE asociado_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20;
CREATE SEQUENCE lugar_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20;
CREATE SEQUENCE ubicacion_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20;
CREATE SEQUENCE relacion_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20;
CREATE SEQUENCE victima_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20;
CREATE SEQUENCE hospital_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20;
CREATE SEQUENCE interaccion_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20;
CREATE SEQUENCE observacion_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20;
CREATE SEQUENCE tratamiento_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20;
CREATE SEQUENCE contacto_seq
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	INCREMENT BY 1
	CACHE 20
