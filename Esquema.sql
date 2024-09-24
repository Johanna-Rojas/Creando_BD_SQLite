-- ESQUEMA DE LA ESTRUCTURA DE DATOS EXPORTADA DE SQLite

CREATE TABLE sqlite_sequence(name,seq);                 -- Tabla interna de SQLite para gestionar el autoincremento de las claves primarias

CREATE TABLE IF NOT EXISTS "STUDENTS" (                 -- Se crea la tabla/entidad STUDENTS en caso de que no exista previamente
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
