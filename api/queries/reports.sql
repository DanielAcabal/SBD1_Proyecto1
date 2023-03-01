---CONSULTAS------
--- OK-- hospital, su dirección y el número de fallecidos por cada hospital registrado.
SELECT h.nombre,h.direccion,count(e.nombre) FROM hospital h
JOIN victima v ON h.ID_HOSPITAL=v.ID_HOSPITAL 
JOIN estado e ON v.id_estado=e.id_estado
WHERE e.nombre='Muerte' GROUP BY h.nombre,h.DIRECCION ;
--- OK-- nombre, apellido de todas las víctimas en cuarentena que presentaron una efectividad mayor a 5 en el tratamiento “Transfusiones de sangre”.
SELECT v.nombre,v.apellido FROM OBSERVACION obs
JOIN victima v ON OBS.ID_VICTIMA=v.ID_VICTIMA 
JOIN estado e ON e.id_estado=v.id_estado
JOIN TRATAMIENTO t ON t.ID_TRATAMIENTO = OBS.ID_TRATAMIENTO 
WHERE e.nombre='En cuarentena' AND obs.EFECTIVIDAD>5 AND t.NOMBRE LIKE 'Transfusiones de sangre';

--- OK-- nombre, apellido y dirección de las víctimas fallecidas con más de tres personas asociadas.
SELECT v.nombre,v.apellido,v.direccion,count(r.ID_ASOCIADO) AS Asociados FROM RELACION r 
JOIN VICTIMA v ON r.ID_VICTIMA=v.ID_VICTIMA 
JOIN ESTADO e ON v.id_estado=e.id_estado
WHERE e.nombre='Muerte' HAVING count(r.ID_ASOCIADO)>3 GROUP BY v.nombre,v.apellido,v.direccion ;

--- (Pendiente) nombre y apellido de todas las víctimas en estado “Suspendida” que tuvieron contacto físico de tipo “Beso” con más de 2 de sus asociados.
SELECT v.nombre,v.apellido,v.DIRECCION  FROM INTERACCION i
JOIN RELACION r ON i.ID_RELACION=r.ID_RELACION 
JOIN contacto c ON i.ID_CONTACTO=c.ID_CONTACTO 
JOIN VICTIMA v ON r.ID_VICTIMA=v.ID_VICTIMA 
JOIN ESTADO e ON v.id_estado=e.id_estado
WHERE e.nombre='Muerte' AND c.NOMBRE='Beso' GROUP BY v.nombre,v.apellido,v.direccion;

--- OK -- Top 5 de víctimas que más tratamientos se han aplicado del tratamiento “Oxígeno”.
SELECT v.nombre,v.apellido,count(o.ID_TRATAMIENTO)  FROM OBSERVACION o 
JOIN VICTIMA v ON o.ID_VICTIMA=v.ID_VICTIMA 
JOIN TRATAMIENTO t ON o.ID_TRATAMIENTO=t.ID_TRATAMIENTO 
WHERE t.NOMBRE='Oxigeno' group BY v.nombre,v.apellido ORDER BY count(o.ID_TRATAMIENTO ) DESC FETCH NEXT 5 ROWS ONLY  ;


--- OK -- nombre, el apellido y la fecha de fallecimiento de todas las
--víctimas que se movieron por la dirección “1987 Delphine Well” a los
--cuales se les aplicó "Manejo de la presión arterial" como tratamiento
SELECT v.nombre,v.apellido,v.fecha_muerte FROM UBICACION u 
JOIN VICTIMA v ON u.ID_VICTIMA=v.ID_VICTIMA
JOIN OBSERVACION o ON o.ID_VICTIMA=v.ID_VICTIMA 
JOIN TRATAMIENTO t ON o.ID_TRATAMIENTO=t.ID_TRATAMIENTO
JOIN LUGAR l ON u.ID_LUGAR=l.ID_LUGAR
WHERE l.NOMBRE='1987 Delphine Well' AND t.NOMBRE LIKE 'Manejo%';

-- (pendiente) nombre, apellido y dirección de las víctimas que tienen menos
-- de 2 allegados los cuales hayan estado en un hospital y que se le
-- hayan aplicado únicamente dos tratamientos
SELECT DISTINCT  v.NOMBRE_VICTIMA ,v.APELLIDO_VICTIMA ,v.DIRECCION_VICTIMA ,a.NOMBRE_ASOCIADO ,a.APELLIDO_ASOCIADO  
FROM temporal v 
JOIN TEMPORAL a ON v.NOMBRE_VICTIMA =a.NOMBRE_ASOCIADO
WHERE v.NOMBRE_VICTIMA=a.NOMBRE_ASOCIADO ;--AND v.APELLIDO_VICTIMA=a.APELLIDO_ASOCIADO 

--- OK-- número de mes de la fecha de la primera sospecha,
-- nombre y apellido de las víctimas que más tratamientos se han
-- aplicado y las que menos. (Todo en una misma consulta).

SELECT nombre,apellido,MES_SOSPECHA,TRATAMIENTOS FROM (
SELECT v.NOMBRE,v.APELLIDO,EXTRACT(MONTH FROM v.FECHA_SOSPECHA) mes_sospecha,count(o.ID_VICTIMA) tratamientos FROM OBSERVACION o
JOIN VICTIMA v ON o.ID_VICTIMA=v.ID_VICTIMA 
GROUP BY v.NOMBRE,v.APELLIDO,v.FECHA_SOSPECHA ) 
t JOIN (
SELECT 	max(count(o.ID_VICTIMA)) ma ,min(count(o.ID_VICTIMA)) mi  FROM OBSERVACION o
JOIN VICTIMA v ON o.ID_VICTIMA=v.ID_VICTIMA 
GROUP BY v.NOMBRE,v.APELLIDO,v.FECHA_SOSPECHA) 
ON t.tratamientos=ma OR t.tratamientos=mi;


-- ok -- porcentaje de víctimas que le corresponden a cada hospital (victimas totales o solo atendidas????)
SELECT v.ID_HOSPITAL,h.NOMBRE , (count(v.ID_VICTIMA)/(SELECT count(*) FROM VICTIMA v2 WHERE ID_HOSPITAL IS NOT NULL))*100 por_victimas FROM VICTIMA v
JOIN HOSPITAL h ON v.ID_HOSPITAL=h.ID_HOSPITAL 
WHERE h.ID_HOSPITAL IS NOT null
GROUP BY v.ID_HOSPITAL,h.NOMBRE ORDER BY v.ID_HOSPITAL asc ; 

-- porcentaje del contacto físico más común de cada
--hospital de la siguiente manera: nombre de hospital, nombre del
--contacto físico, porcentaje de víctimas.
SELECT h.NOMBRE hospital,c.nombre contacto,(count(v.ID_VICTIMA)*100/(SELECT count(*) FROM interaccion)) porcentaje FROM INTERACCION i
JOIN CONTACTO c ON i.ID_CONTACTO=c.ID_CONTACTO 
JOIN RELACION r ON i.ID_RELACION=r.ID_RELACION 
JOIN VICTIMA v ON r.ID_VICTIMA=v.ID_VICTIMA 
JOIN HOSPITAL h ON v.ID_HOSPITAL=h.ID_HOSPITAL
GROUP BY h.NOMBRE,c.NOMBRE ORDER BY h.NOMBRE asc
