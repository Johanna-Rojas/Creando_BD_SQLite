-- ESQUEMA DE LA ESTRUCTURA DE DATOS EXPORTADA DE SQLite
-- La forma de exportar los datos se realizó desde la terminal Bash -> sqlite3 LJ-Academy.db ".shema" > Esquema.sql
-- Nota: en SQLite no es posible exportar todas las consultas, por ello el scrip a sido modificado manualmente (copiando y pegando las sentencias y documentando)

-- CREACIÓN DE OBJETOS (Base de datos, tablas, indices y vistas)

CREATE DATABASE LJ-Academy;          -- Se crea la base de datos llamada LJ-Academy

CREATE TABLE sqlite_sequence(name,seq);          -- Se crea una tabla interna de SQLite para gestionar el autoincremento de las claves primarias

CREATE TABLE IF NOT EXISTS "STUDENTS" (          -- Se crea la tabla/entidad STUDENTS en caso de que no exista previamente
	"STUDENT_ID"	INTEGER,                            -- Se agrega el primer atributo o columna de la tabla, como tipo de dato valores enteros
	"FIRSTNAME"	TEXT,                                   -- Segundo atributo de tipo texto
	"LASTNAME"	TEXT,
	"AGE"	INTEGER,
	"EMAIL"	TEXT,
	"ACADEMICPROGRAM"	TEXT,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,         -- Establece el valor de tiempo actual cuando se inserta un nuevo registro
	"UPDATE_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,     -- Establece el valor de tiempo actual cuando se inserta o actualiza un registro
	PRIMARY KEY("STUDENT_ID" AUTOINCREMENT)             -- Clave primaria autoincrementable, se le asignan valores únicos a esos registros
);

CREATE TABLE IF NOT EXISTS "INSTRUCTORS" (              -- Se crea la tabla/entidad INSTRUCTORS en caso de que no exista previamente
	"INSTRUCTORS_ID"	INTEGER,
	"FIRSTNAME"	TEXT,
	"LASTNAME"	TEXT,
	"PROFESSIONALTITLE"	TEXT,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("INSTRUCTORS_ID" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "COURSES" (                  -- Se crea la tabla/entidad COURSES en caso de que no exista previamente
	"COURSE_ID"	INTEGER,
	"COURSENAME"	TEXT,
	"DESCRIPTION"	TEXT,
	"CREDITS"	NUMERIC,
	"INSTRUCTOR_ID"	INTEGER,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	NUMERIC DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("COURSE_ID" AUTOINCREMENT),
	FOREIGN KEY("INSTRUCTOR_ID") REFERENCES "INSTRUCTORS"("INSTRUCTORS_ID")     -- Clave foránea que relaciona la entidad COURSES con INSTRUCTORS
);

CREATE TABLE IF NOT EXISTS "REGISTRATIONS" (            -- Se crea la tabla/entidad REGISTRATIONS en caso de que no exista previamente
	"REGISTRATION_ID"	INTEGER,
	"STUDENT_ID"	INTEGER,
	"COURSE_ID"	INTEGER,
	"QUALIFICATION"	REAL,                               -- Atributo de tipo decimal
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("REGISTRATION_ID" AUTOINCREMENT),
	FOREIGN KEY("COURSE_ID") REFERENCES "COURSES"("COURSE_ID"),     -- Clave foránea que relaciona la entidad REGISTRATIONS con COURSES
	FOREIGN KEY("STUDENT_ID") REFERENCES "STUDENTS"("STUDENT_ID")   -- Clave foránea que relaciona la entidad REGISTRATIONS con STUDENTS
);

CREATE INDEX idx_COURSENAME                            -- Se crea un índice único llamado idx_coursename (Evita la duplicación de datos)
ON COURSES(COURSENAME);                                -- En el campo COURSENAME de la tabla COURSES

CREATE INDEX idx_QUALIFICATION                         -- Se crea un índice único para acelerar consultas, optimizar el ordenamiento, etc
ON REGISTRATIONS(QUALIFICATION)                        -- En el campo QUALIFICATION de la tabla REGISTRATIONS

CREATE VIEW Students_Registered_Course AS              -- Creando una vista de los estudiantes registrados en un curso especifico(tabla virtual)
SELECT s.FIRSTNAME, s.LASTNAME, s.ACADEMICPROGRAM, c.COURSENAME, c.ACADEMIC_CREDITS, r.QUALIFICATION      --Selección de los campos a mostrar
FROM [STUDENTS]s                                       -- Obtener los datos de la tabla STUDENTS cuyo alias es "s"
INNER JOIN [REGISTRATIONS]r ON e.STUDENT_ID = r.STUDENT_ID -- Uniendo la tabla STUDENTS con la tabla REGISTRATIONS con la condición de que coincidan los ID
INNER JOIN [COURSES]c ON r.COURSE_ID = c.COURSE_ID; -- Uniendo la tabla REGISTRATIONS con la tabla COURSES cuando coincidan los ID

DROP VIEW Students_Registered_Course      -- Eliminando la vista creada, dado que se presentan errores

CREATE VIEW STUDENTS_COURSE AS              -- Optimizando el nombre, SQLite discrimina entre mayusculas y minusculas
SELECT s.FIRSTNAME, s.LASTNAME, s.ACADEMICPROGRAM, c.COURSENAME, c.ACADEMIC_CREDITS, r.QUALIFICATION      
FROM [STUDENTS]s                                      
INNER JOIN [REGISTRATIONS]r ON s.STUDENT_ID = r.STUDENT_ID -- Error e.STUDENT_ID - Correción s.STUDENT_ID No existe la tabla con el alias "e"  
INNER JOIN [COURSES]c ON r.COURSE_ID = c.COURSE_ID;

-- MODIFICACIÓN DE OBJETOS

ALTER TABLE COURSES                                     -- Modificar la tabla COURSES
RENAME COLUMN CREDITS TO ACADEMIC_CREDITS               -- Renombrar la columna CREDITS como ACADEMIC_CREDITS

-- PROCEDIMIENTOS (Trigger) QUE SE EJECUTARÁN AUTOMÁTICAMENTE SEGÚN LAS INDICACIONES

CREATE TRIGGER BEFORE_UPDATE_REGISTRATIONS              -- Se crea un Trigger llamado BEFORE_UPDATE_REGISTRATIONS
BEFORE UPDATE ON REGISTRATIONS                          -- Especifica que el Trigger se ejecutará antes de una actualización en la tabla
BEGIN                                                   -- Inicializa el bloque de código a ejecutar al activar el Trigger
	UPDATE REGISTRATIONS                                -- Actualiza la tabla REGISTRATIONS
	SET UPDATE_DATE = datetime('now')                   -- Estable el valor de la columna en la fecha y hora actuales (formato ISO 8601)
	WHERE ROWID = NEW.ROWID;                            -- Filtra la actualización para que solo se aplique al registro modificado
	END;                                                -- Finaliza el bloque de codigo del Trigger

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

-- INSERTANDO DATOS
