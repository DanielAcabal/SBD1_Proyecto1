--           Insert data in model
--Asociado
INSERT INTO asociado (nombre,apellido) SELECT distinct NOMBRE_ASOCIADO,APELLIDO_ASOCIADO  FROM temporal WHERE nombre_asociado IS NOT null;
--Contacto
INSERT INTO contacto (nombre) SELECT distinct contacto_fisico  FROM temporal WHERE contacto_fisico IS NOT null;
--Hospital
INSERT INTO hospital (nombre,direccion) SELECT distinct nombre_hospital,direccion_hospital  FROM temporal WHERE nombre_hospital IS NOT null;
--Lugar
INSERT INTO lugar (nombre) SELECT distinct ubicacion_victima  FROM temporal WHERE ubicacion_victima IS NOT null;
--Tratamiento
INSERT INTO tratamiento  (nombre,efectividad) SELECT distinct tratamiento,efectividad  FROM TEMPORAL WHERE tratamiento IS NOT null;
--Estado
INSERT INTO estado  (nombre) SELECT distinct estado_victima  FROM TEMPORAL WHERE estado_victima IS NOT null;
--Victima
INSERT INTO VICTIMA (nombre,apellido,direccion,fecha_muerte,id_estado,fecha_confirmacion,fecha_sospecha,id_hospital)
SELECT DISTINCT NOMBRE_victima, apellido_victima,direccion_victima,fecha_muerte,id_estado,fecha_confirmacion,primera_sospecha ,id_hospital 
FROM TEMPORAL 
left JOIN HOSPITAL ON NOMBRE_HOSPITAL=nombre AND DIRECCION_HOSPITAL=direccion
JOIN estado ON estado.nombre=estado_victima
WHERE nombre_victima IS NOT NULL;
--Ubicacion
INSERT INTO UBICACION (fecha_llegada,fecha_salida,id_lugar,id_victima)
SELECT DISTINCT fecha_llegada,fecha_retiro,id_lugar,id_victima FROM TEMPORAL 
JOIN LUGAR  ON ubicacion_victima=lugar.nombre 
JOIN victima ON victima.nombre=nombre_victima AND victima.apellido=apellido_victima
WHERE nombre_victima IS NOT null;
--Observacion
INSERT INTO OBSERVACION  (fecha_inicio,fecha_fin,efectividad,id_tratamiento,id_victima)
SELECT DISTINCT inicio_tratamiento,fin_tratamiento,efectividad_victima,TRATAMIENTO.id_tratamiento,victima.id_victima FROM TEMPORAL 
INNER JOIN TRATAMIENTO ON temporal.TRATAMIENTO=TRATAMIENTO.nombre
INNER JOIN victima ON temporal.NOMBRE_VICTIMA=victima.nombre AND APELLIDO_VICTIMA=victima.apellido
WHERE INICIO_TRATAMIENTO  IS NOT null;
--Relacion
INSERT INTO RELACION  (fecha_conocio,id_victima,id_asociado)
SELECT DISTINCT FECHA_CONOCIO,id_victima,id_asociado FROM TEMPORAL 
INNER JOIN victima ON NOMBRE_VICTIMA=victima.nombre AND APELLIDO_VICTIMA=victima.apellido
INNER JOIN ASOCIADO ON NOMBRE_ASOCIADO=asociado.nombre AND APELLIDO_ASOCIADO=asociado.apellido
WHERE FECHA_CONOCIO  IS NOT null;
--Interaccion
INSERT INTO INTERACCION  (fecha_inicio,fecha_fin,id_contacto,id_relacion)
SELECT DISTINCT t.INICIO_CONTACTO,t.FIN_CONTACTO ,id_contacto,r.ID_RELACION  FROM TEMPORAL t
INNER JOIN CONTACTO c ON t.CONTACTO_FISICO=c.nombre
INNER JOIN VICTIMA v ON t.NOMBRE_VICTIMA=v.NOMBRE AND t.APELLIDO_VICTIMA=v.APELLIDO 
INNER JOIN ASOCIADO a ON t.NOMBRE_ASOCIADO=a.NOMBRE AND t.APELLIDO_ASOCIADO=a.APELLIDO 
INNER JOIN RELACION r ON r.ID_VICTIMA=v.ID_VICTIMA AND r.ID_ASOCIADO=a.ID_ASOCIADO 
WHERE INICIO_CONTACTO IS NOT NULL;
