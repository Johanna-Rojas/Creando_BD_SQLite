-- ESQUEMA DE LA ESTRUCTURA DE DATOS EXPORTADA DE SQLite
-- La forma de exportar los datos se realizó desde la terminal Bash -> sqlite3 LJ-Academy.db ".schema" > Esquema.sql
-- Nota: SQLite no almacena de forma explicita el historial de las sentencias, por ello, el scrip a sido modificado manualmente (copiando/pegando las sentencias y documentando como parte del proceso de aprendizaje)

----------------------------------------------------------------------------------------------------
-- CREACIÓN DE OBJETOS (DATABASE, TABLE, INDEX y VIEW) DDL
----------------------------------------------------------------------------------------------------

CREATE DATABASE LJ-Academy;     -- Crea la base de datos llamada LJ-Academy

CREATE TABLE sqlite_sequence(name,seq);     -- Crea una tabla interna de SQLite para gestionar el autoincremento de las claves primarias

CREATE TABLE IF NOT EXISTS "STUDENTS" (     -- Crea la tabla/entidad STUDENTS en caso de que no exista previamente
	"STUDENT_ID"	INTEGER,     -- Agrega el primer atributo o columna de la tabla, como tipo de dato valores enteros
	"FIRSTNAME"	TEXT,            -- Agrega el segundo atributo de tipo texto
	"LASTNAME"	TEXT,
	"AGE"	INTEGER,
	"EMAIL"	TEXT,
	"ACADEMICPROGRAM"	TEXT,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,         -- Establece el valor de tiempo actual cuando se inserta un nuevo registro
	"UPDATE_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,     -- Establece el valor de tiempo actual cuando se inserta o actualiza un registro
	PRIMARY KEY("STUDENT_ID" AUTOINCREMENT)             -- Define la clave primaria autoincrementable, asigna valores únicos a los registros
);

CREATE TABLE IF NOT EXISTS "INSTRUCTORS" (     -- Crea la tabla/entidad INSTRUCTORS en caso de que no exista previamente
	"INSTRUCTORS_ID"	INTEGER,
	"FIRSTNAME"	TEXT,
	"LASTNAME"	TEXT,
	"PROFESSIONALTITLE"	TEXT,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("INSTRUCTORS_ID" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "COURSES" (     -- Crea la tabla/entidad COURSES en caso de que no exista previamente
	"COURSE_ID"	INTEGER,
	"COURSENAME"	TEXT,
	"DESCRIPTION"	TEXT,
	"CREDITS"	NUMERIC,
	"INSTRUCTOR_ID"	INTEGER,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	NUMERIC DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("COURSE_ID" AUTOINCREMENT),
	FOREIGN KEY("INSTRUCTOR_ID") REFERENCES "INSTRUCTORS"("INSTRUCTORS_ID")     -- Define la clave foránea - Relación entre la entidad COURSES e INSTRUCTORS
);

CREATE TABLE IF NOT EXISTS "REGISTRATIONS" (     -- Crea la tabla/entidad REGISTRATIONS en caso de que no exista previamente
	"REGISTRATION_ID"	INTEGER,
	"STUDENT_ID"	INTEGER,
	"COURSE_ID"	INTEGER,
	"QUALIFICATION"	REAL,     -- Agrega atributo de tipo decimal
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("REGISTRATION_ID" AUTOINCREMENT),
	FOREIGN KEY("COURSE_ID") REFERENCES "COURSES"("COURSE_ID"),     -- Define la clave foránea que relaciona la entidad REGISTRATIONS con COURSES
	FOREIGN KEY("STUDENT_ID") REFERENCES "STUDENTS"("STUDENT_ID")   -- Define la clave foránea que relaciona la entidad REGISTRATIONS con STUDENTS
);

CREATE INDEX idx_COURSENAME         -- Crea un índice único llamado idx_coursename (Evita la duplicación de datos)
ON COURSES(COURSENAME);             -- En el campo COURSENAME de la tabla COURSES

CREATE INDEX idx_QUALIFICATION      -- Crea un índice único para acelerar consultas, optimizar el ordenamiento, etc
ON REGISTRATIONS(QUALIFICATION);    -- En el campo QUALIFICATION de la tabla REGISTRATIONS

CREATE VIEW STUDENTS_COURSE AS     -- Crea una vista de los estudiantes en los cursos registrados y su calificación (tabla virtual)
SELECT s.FIRSTNAME, s.LASTNAME, s.ACADEMICPROGRAM, c.COURSENAME, c.ACADEMIC_CREDITS, r.QUALIFICATION     --Selecciona los campos a mostrar 
FROM [STUDENTS]s       -- Obtiene los datos de la tabla STUDENTS cuyo alias es "s"                                  
INNER JOIN [REGISTRATIONS]r ON s.STUDENT_ID = r.STUDENT_ID     -- Une la tabla STUDENTS con REGISTRATIONS - Cuando coincidan los ID  
INNER JOIN [COURSES]c ON r.COURSE_ID = c.COURSE_ID     -- Une la tabla REGISTRATIONS con la tabla COURSES cuando coincidan los ID
/* STUDENTS_COURSE(FIRSTNAME,LASTNAME,ACADEMICPROGRAM,COURSENAME,ACADEMIC_CREDITS,QUALIFICATION) */;

----------------------------------------------------------------------------------------------------
-- MODIFICACIÓN DE OBJETOS (ALTER, RENAME, DROP) DDL
----------------------------------------------------------------------------------------------------

ALTER TABLE COURSES     -- Modificar la tabla COURSES
RENAME COLUMN CREDITS TO ACADEMIC_CREDITS     -- Renombra la columna CREDITS como ACADEMIC_CREDITS

CREATE VIEW Students_Registered_Course AS     -- Crea una vista de los estudiantes registrados en un curso especifico(tabla virtual)
SELECT s.FIRSTNAME, s.LASTNAME, s.ACADEMICPROGRAM, c.COURSENAME, c.ACADEMIC_CREDITS, r.QUALIFICATION     --Selecciona los campos a mostrar 
FROM [STUDENTS]s     -- Obtiene los datos de la tabla STUDENTS cuyo alias es "s"
INNER JOIN [REGISTRATIONS]r ON e.STUDENT_ID = r.STUDENT_ID     -- Error e.STUDENT_ID - Correción s.STUDENT_ID No existe la tabla con alias "e"  
INNER JOIN [COURSES]c ON r.COURSE_ID = c.COURSE_ID;     -- Une la tabla REGISTRATIONS con la tabla COURSES cuando coincidan los ID  

DROP VIEW Students_Registered_Course;     -- Elimina la vista creada, dado que se presentaban errores