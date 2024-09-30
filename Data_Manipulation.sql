-- Nota: SQLite no almacena de forma explicita el historial de las sentencias, 
-- por ello, el scrip a sido modificado manualmente 
-- Copiando/pegando las sentencias y documentando como parte del proceso de aprendizaje
----------------------------------------------------------------------------------------------------
-- MANIPULACIÓN DE DATOS (DML) / CONSULTAS
----------------------------------------------------------------------------------------------------
-- AGREGANDO DISPARADORES PARA ACTUALIZAR LOS CAMPOS DE UPDATE_DATE EN CADA TABLA

CREATE TRIGGER BEFORE_UPDATE_REGISTRATIONS     -- Crea un Trigger (procedimiento que se ejecutará automáticamente según las indicaciones)
BEFORE UPDATE ON REGISTRATIONS                 -- Especifica que el Trigger se ejecutará antes de una actualización en la tabla
BEGIN                                          -- Inicializa el bloque de código a ejecutar al activar el Trigger
	UPDATE REGISTRATIONS                       -- Actualiza la tabla REGISTRATIONS
	SET UPDATE_DATE = datetime('now')          -- Establece el valor de la columna en la fecha y hora actuales (formato ISO 8601)
	WHERE ROWID = NEW.ROWID;                   -- Filtra la actualización para que solo se aplique al registro modificado
END;                                           -- Finaliza el bloque de codigo del Trigger

CREATE TRIGGER BEFORE_UPDATE_INSTRUCTORS
BEFORE UPDATE ON INSTRUCTORS
BEGIN
	UPDATE INSTRUCTORS
	SET UPDATE_DATE = datetime('now')
	WHERE ROWID = NEW.ROWID;
END;

CREATE TRIGGER BEFORE_UPDATE_COURSES
BEFORE UPDATE ON COURSES
BEGIN
	UPDATE COURSES
	SET UPDATE_DATE = datetime('now')
	WHERE ROWID = NEW.ROWID;
END;

CREATE TRIGGER BEFORE_UPDATE_STUDENTS
BEFORE UPDATE ON STUDENTS
BEGIN
	UPDATE STUDENTS
	SET UPDATE_DATE = datetime('now')
	WHERE ROWID = NEW.ROWID;
END;

-- INSERTANDO NUEVOS REGISTROS EN LAS TABLAS STUDENTS Y REGISTRATIONS

INSERT INTO STUDENTS (FIRSTNAME, LASTNAME, AGE, EMAIL, ACADEMICPROGRAM)
	   VALUES ("Oliver","Jones",17,"oliverj@gmail.com","mechanical engineering"),
			  ("Jack","Valencia",21,"valenciajack@gmail.com","commercial engineering"),
			  ("Harry","Taylor",19,"harry2050@gmail.com","systems engineering"),
			  ("Amelia","Alvarez",16,"ameliaa@gmail.com","industrial engineering"),
			  ("Olivia","Martin",28,"olivia12m@gmail.com","systems engineering"),
			  ("Emily","Roy",24,"royemily1@gmail.com","civil engineering"),
			  ("George","Zapata",20,"georgepitu@gmail.com","physical engineering"),
			  ("Poppy","Wilson",23,"prinwilson@gmail.com","commercial engineering"),
			  ("William","Rodriguez",18,"williamrodriguez@gmail.com","civil engineering"),
			  ("Lily","García",25,"lilygarcía1@gmail.com","electrical engineering"),
			  ("Thomas","Brown",22,"thomas1690@gmail.com","physical engineering"),
			  ("Charlie","Johnson",20,"charliejohnson@gmail.com","civil engineering");

INSERT INTO REGISTRATIONS (STUDENT_ID, COURSE_ID)
       VALUES (10,3),(10,5),(10,7),(10,9),
              (11,4),(11,5),(11,6),(11,10),
			  (12,3),(12,7),(12,9),(12,11),(12,5),
			  (13,3),(13,5),(13,6),
			  (14,5),(14,6),
			  (15,4),(15,10),
			  (16,1),(16,2),(16,10),(16,8),
			  (17,5),(17,6),
			  (18,11),(18,3),(18,9),
			  (19,8),(19,5),
			  (20,1),(20,2),(20,8),(20,10),
			  (21,11),(21,7),(21,3);

-- ELIMINANDO UN REGISTRO DE LA TABLA REGISTRATIONS

DELETE FROM REGISTRATIONS
WHERE STUDENT_ID = 17;
DELETE FROM STUDENTS
WHERE STUDENT_ID = 17;

-- ACTUALIZANDO LOS REGISTROS NULL DEL CAMPO QUALIFICATION DE LA TABLA REGISTRATIONS
-- Nota: la idea es actualizar múltiples registros del mismo campo, 
-- esto se puede hacer mediante sentencias individuales o por lotes 
-- dependera de la cantidad de los registros y la complejidad de los valores

-- Actualizaciones individuales

UPDATE REGISTRATIONS SET QUALIFICATION = 3.7 WHERE REGISTRATION_ID = 27;
UPDATE REGISTRATIONS SET QUALIFICATION = 2.9 WHERE REGISTRATION_ID = 28;
UPDATE REGISTRATIONS SET QUALIFICATION = 2.0 WHERE REGISTRATION_ID = 29;
UPDATE REGISTRATIONS SET QUALIFICATION = 4.2 WHERE REGISTRATION_ID = 30;

-- Actualización por lotes en SQLite mediante Subconsultas

0CREATE TEMPORARY TABLE NEW_QUALIFICATIONS     -- Crea una tabla temporal cuyo nombre es NEW_QUALIFICATIONS
(
	REGISTRATION_ID INTEGER,                  -- Agrega el campo REGISTRATION_ID con tipo de dato valor entero
	NEW_QUALIFICATION REAL                    -- Agrega el campo NEW_QUALIFICATION con tipo de dato decimal
);

INSERT INTO NEW_QUALIFICATIONS (REGISTRATION_ID, NEW_QUALIFICATION)     -- Inserta los registros de la tabla temporal
       VALUES (31,4.0),(32,4.3),(33,4.1),                               -- Los ID 33, 34, 35 pertenecen al estudiante con ID 12 = Harry Taylor
	          (34,3.1),(35,3.8),(36,3.5),(37,3.9),(38,3.2),             -- Cada fila de registro pertenece a un solo estudiante
			  (39,2.1),(40,2.8),(41,2.5),
			  (42,5.0),(43,5.0),
			  (44,4.9),(45,5.0),
			  (46,2.5),(47,3.0),(48,2.9),(49,3.0),
			  (52,3.6),(53,3.1),(54,3.4),
			  (55,2.7),(56,3.0),
			  (57,5.0),(58,4.9),(59,4.9),(60,5.0),
			  (61,3.7),(62,4.1),(63,3.5);

UPDATE REGISTRATIONS                 -- Actualiza los registros de la tabla que cumplan con la condición de que los valores sean nulos(**)
SET QUALIFICATION =                  -- El valor devuelto de la subconsulta se asigna a QUALIFICATION
	(
		SELECT NEW_QUALIFICATION     -- Subconsulta: Busca en la tabla temporal el registro con el mismo ID
		FROM NEW_QUALIFICATIONS      -- Si es coincidente, el valor NEW.QUALIFICATION se devuelve a la consulta proncipal
		WHERE REGISTRATIONS.REGISTRATION_ID = NEW_QUALIFICATIONS.REGISTRATION_ID     
	)     
WHERE QUALIFICATION IS NULL;         -- (**)

DROP TABLE NEW_QUALIFICATIONS;       -- Elimina la tabla temporal

-- OPERANDO CON LOS DATOS PARA POSTERIORES ANALISIS

-- Agrupando el promedio de calificaciones por curso

SELECT c.INSTRUCTOR_ID, c.COURSENAME,     --Devuelve los campos según el siguiente formato "Tabla.Columna"
       printf("%.2f", avg(r.QUALIFICATION)) AS AVERAGE     -- Calcula el promedio de calificaciones y lo formatea a 2 decimales [printf("%.2f")]
FROM REGISTRATIONS r     -- Realiza la consulta sobre esta tabla
INNER JOIN COURSES c     -- Combina las tablas registrations y courses
ON r.COURSE_ID = c.COURSE_ID     -- Según esta condición (los ID de ambas tablas coincidan)
GROUP BY r.COURSE_ID     -- Agrupa los resultados por el campo course_ID de la tabla registrations
-- Resultado: 11 filas devueltas en 16ms

-- Agrupando datos de los cursos (Estudiantes,Instructor,Calificaciones)

SELECT sc.COURSENAME AS COURSE, sc.ACADEMIC_CREDITS AS CEDITS,
	   CONCAT(i.FIRSTNAME,' ',i.LASTNAME) AS INSTRUCTOR_NAME,     -- Une dos columnas de texto y asigna un alias "Nombre del instructor"
	   COUNT(DISTINCT sc.FIRSTNAME) AS NUM_STUDENTS,     -- Cuenta la cantidad de nombres distintos
	   printf("%.2f", avg(sc.QUALIFICATION)) AS AVERAGE_GRADE
FROM STUDENTS_COURSE sc
INNER JOIN COURSES c ON sc.COURSENAME = c.COURSENAME 
INNER JOIN INSTRUCTORS i ON c.INSTRUCTOR_ID = i.INSTRUCTORS_ID
GROUP BY sc.COURSENAME
-- Resultado: 11 filas devueltas en 33ms

-- Estudiantes registrados en el curso de Matematicas I

SELECT CONCAT(FIRSTNAME,' ',LASTNAME) AS STUDENT_NAME, 
	   ACADEMICPROGRAM, QUALIFICATION 
FROM STUDENTS_COURSE
WHERE COURSENAME = "Mathematics I"
-- Resultado: 9 filas devueltas en 20ms

-- Estudiantes que tomaron más de 3 cursos

SELECT s.FIRSTNAME, r.STUDENT_ID, COUNT(*) AS NUM_COURSES 
FROM REGISTRATIONS r
INNER JOIN STUDENTS s ON r.STUDENT_ID = s.STUDENT_ID
GROUP BY r.STUDENT_ID     -- Agrupa los registros por ID
HAVING NUM_COURSES > 3    -- Filtra el grupo, dejando solo los que hayan escogido más de 3 cursos
-- Resultado: 6 filas devueltas en 30ms

-- Estudiantes que han tenido la calificación más alta en cada curso

SELECT CONCAT(s.FIRSTNAME,' ',s.LASTNAME) AS STUDENT_NAME, 
	   s.AGE,
       c.COURSENAME AS COURSE, 
	   s.ACADEMICPROGRAM,
	   MAX(r.QUALIFICATION) AS MAX_QUALIFICATION     -- Encuentra el valor maximo del campo Qualification para cada curso(**)
FROM REGISTRATIONS r
INNER JOIN STUDENTS s ON r.STUDENT_ID = s.STUDENT_ID
INNER JOIN COURSES c ON r.COURSE_ID = c.COURSE_ID
GROUP BY r.COURSE_ID
ORDER BY MAX_QUALIFICATION DESC, STUDENT_NAME     -- (**)
-- Resultado: 11 filas devueltas en 34ms     

-- Estudiantes con la calificación más baja en cada curso

SELECT CONCAT(s.FIRSTNAME,' ',s.LASTNAME) AS STUDENT_NAME, 
       c.COURSENAME AS COURSE, 
	   min(r.QUALIFICATION) AS MIN_QUALIFICATION     -- Encuentra el valor minimo del campo Qualification para cada curso(**)
FROM REGISTRATIONS r
INNER JOIN STUDENTS s ON r.STUDENT_ID = s.STUDENT_ID
INNER JOIN COURSES c ON r.COURSE_ID = c.COURSE_ID
GROUP BY r.COURSE_ID     -- (**)
ORDER BY MIN_QUALIFICATION, STUDENT_NAME      

-- Identificando la mayor variación de calificaciones en los cursos

SELECT c.COURSENAME, 
	   CONCAT(i.FIRSTNAME,' ',i.LASTNAME) AS INSTRUCTOR_NAME,
	   COUNT(DISTINCT STUDENT_ID) AS NUM_STUDENTS,
	   printf("%.2f", avg(QUALIFICATION)) AS AVERAGE_GRADE,
	   MAX(QUALIFICATION)-MIN(QUALIFICATION) AS RATING_RANGE
FROM REGISTRATIONS r
INNER JOIN COURSES c ON r.COURSE_ID = c.COURSE_ID
INNER JOIN INSTRUCTORS i ON c.INSTRUCTOR_ID = i.INSTRUCTORS_ID
GROUP BY r.COURSE_ID
ORDER BY RATING_RANGE DESC
-- Resultado: 11 filas devueltas en 26ms

-- Calculando el promedio semestral

SELECT CONCAT(s.FIRSTNAME,' ',s.LASTNAME) AS STUDENT_NAME, 
	   s.AGE, s.ACADEMICPROGRAM,
	   COUNT(r.COURSE_ID) AS TOTAL_COURSES,     -- Cuenta la cantidad de cursos matriculados por estudiante(**)
	   SUM(ACADEMIC_CREDITS) AS TOTAL_CREDITS,     -- Suma la cantidad de creditos matriculados por estudiante(**)
	   printf("%.2f", SUM(r.QUALIFICATION * c.ACADEMIC_CREDITS) / SUM(ACADEMIC_CREDITS))     -- Promedio de notas teniendo según los creditos
	   AS SEMESTER_AVERAGE     -- Alias del promedio de calificaciones o notas
FROM STUDENTS s
INNER JOIN REGISTRATIONS r ON s.STUDENT_ID = r.STUDENT_ID
INNER JOIN COURSES c ON r.COURSE_ID = c.COURSE_ID
GROUP BY STUDENT_NAME     -- (**)
ORDER BY SEMESTER_AVERAGE DESC     -- Ordena la tabla según el promedio de calificaciones (mayor a menor)
-- Resultado: 20 filas devueltas en 46ms