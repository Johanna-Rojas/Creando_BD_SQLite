CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "INSTRUCTORS" (
	"INSTRUCTORS_ID"	INTEGER,
	"FIRSTNAME"	TEXT,
	"LASTNAME"	TEXT,
	"PROFESSIONALTITLE"	TEXT,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("INSTRUCTORS_ID" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "COURSES" (
	"COURSE_ID"	INTEGER,
	"COURSENAME"	TEXT,
	"DESCRIPTION"	TEXT,
	"CREDITS"	NUMERIC,
	"INSTRUCTOR_ID"	INTEGER,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	NUMERIC DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("COURSE_ID" AUTOINCREMENT),
	FOREIGN KEY("INSTRUCTOR_ID") REFERENCES "INSTRUCTORS"("INSTRUCTORS_ID")
);
CREATE TABLE IF NOT EXISTS "REGISTRATIONS" (
	"REGISTRATION_ID"	INTEGER,
	"STUDENT_ID"	INTEGER,
	"COURSE_ID"	INTEGER,
	"QUALIFICATION"	REAL,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("REGISTRATION_ID" AUTOINCREMENT),
	FOREIGN KEY("COURSE_ID") REFERENCES "COURSES"("COURSE_ID"),
	FOREIGN KEY("STUDENT_ID") REFERENCES "STUDENTS"("STUDENT_ID")
);
CREATE TRIGGER BEFORE_UPDATE_REGISTRATIONS
BEFORE UPDATE ON REGISTRATIONS
BEGIN
	UPDATE REGISTRATIONS
	SET UPDATE_DATE = datetime('now')
	WHERE ROWID = NEW.ROWID;
	END;
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
CREATE TABLE IF NOT EXISTS "STUDENTS" (
	"STUDENT_ID"	INTEGER,
	"FIRSTNAME"	TEXT,
	"LASTNAME"	TEXT,
	"AGE"	INTEGER,
	"EMAIL"	TEXT,
	"ACADEMICPROGRAM"	TEXT,
	"LOAD_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	"UPDATE_DATE"	TEXT DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("STUDENT_ID" AUTOINCREMENT)
);
CREATE TRIGGER BEFORE_UPDATE_STUDENTS
BEFORE UPDATE ON STUDENTS
BEGIN
	UPDATE STUDENTS
	SET UPDATE_DATE = datetime('now')
	WHERE ROWID = NEW.ROWID;
END;
