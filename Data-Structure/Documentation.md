## :books: Descripción de la estructura de la base de datos LJ-Academy

### Diagrama Entidad- Relación

Antes de almacenar y gestionar la información relacionada con los estudiantes, cursos e instructores en SQLite, recurrimos a la plataforma **Miro** para diseñar el diagrama entidad-relación (DER) y asi tener un panorama claro para ejecutar.

¿Por qué con "Miro"? 
Esta una herramienta de pizarra digital posicionada como líder en el mercado, que ademas de permitir diseñar diagramas como el ER, tiene un enfoque en la colaboración en tiempo real, ideal para el trabajo en equipo. Para ello, cuenta con una alta variedad de plantillas prediseñadas, etiquetas personalizables y conectores predefinidos, ofreciendo flexibilidad y personalización, integracion con otras herramientas y una visualizacion clara y concisa.

Mediante el siguiente enlace puedes ingresar para visualizar y comentar el diagrama:
[Diagrama ER - Diseñado en Miro](https://miro.com/welcomeonboard/QjZycnJKcklWMXV1RjU5d01PSnIzcDFoakVBb0JaeVJ1YVBFRzduQkpHbWhCZUFJVTlYbGpJcW9GbVo5N291QnwzNDU4NzY0NjAwODgzNTAyOTIyfDI=?share_link_id=505044779475)

### Caracteristicas claves que componen el DER

***Entidades:***
"Objetos o conceptos sobre los que se almacena la información"

- STUDENTS
- COURSES
- INSTRUCTORS
- REGISTRATIONS

***Atributos:***
"Características o propiedades de una entidad"

- STUDENTS: Unique Identifier (ID), First Name, Last Name, Age, Email, Academic Program.
- COURSES: Course ID, Course Name, Description, Credits, Instructor.
- INSTRUCTORS: Intructor ID, Frirst Name, Last Name, Professional Title.
- REGISTATIONS: Registration ID, Student ID, Course ID, Qualification.

**Load Date** y **Update Date** son atributos que se incluyen en todas las entidades, debido a que es una buena practica conocer la fecha de carga y fecha de actualización de un registro, factores importantes para la auditoria y trazabilidad, la gestion e integridad de datos, el analisis de datos y en muchos sectores para el cumplimiento normativo.

***Relaciones y cardinalidad:***
"Conexiones entre las entidades y cantidad de instancias de una entidad que pueden estar relacionadas con una instancia de otra entidad"

- STUDENTS - REGISTRATIONS: Un estudiante puede tener muchos registros (muchos a uno), pero un registro solo pertenece a un estudiante.
- REGISTRATIONS - COURSES: Un registro siempre pertenece a un solo curso (uno a uno), y un curso puede tener muchos registros (muchos a uno).
- COURSES - INSTRUCTORS: Un curso es impartido por solo un instructor, pero un instructor puede impartir muchos cursos (uno a muchos).

***Claves primarias:***
"Atributo que identifica de manera única cada registro de la entidad"

- STUDENTS: Student ID
- COURSES: Course ID
- INSTRUCTORS: Instructor ID
- REGISTRATIONS: Registration ID

***Claves foráneas:***
"Atributo o conjunto de atributos que se utilizan para establecer relaciones entre entidades"

- REGISTRATIONS: Student ID y Course ID
- COURSES: Instructor ID

### Consideraciones de diseño

***Normalización:***
La base de datos está normalizada a la tercera forma normal (3FN), lo que garantiza la integridad de los datos y reduce la redundancia.