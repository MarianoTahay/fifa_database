-- Verion 1.0 --

-- Lo primero es registrar los estadios donde se realizara la copa mundial --

CREATE TABLE estadios (
    nombre VARCHAR(100) NOT NULL PRIMARY KEY,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    localidad VARCHAR(100) NOT NULL
);

-- Luego que se deberia de registrar son los EQUIPOS --

CREATE TABLE equipos (
    nombre VARCHAR(100) NOT NULL PRIMARY KEY,
    participaciones_previas INTEGER NOT NULL CHECK (participaciones_previas >= 0),
    mundiales_ganados INTEGER NOT NULL CHECK (mundiales_ganados >= 0),
    fecha_afiliacion DATE NOT NULL
);

-- Una vez teniendo los equipos, ellos deciden a que jugadores poner por lo que, se registran los JUGADORES --

/*
"GK",  # Goalkeeper
"CB",  # Center-back
"RB",  # Right-back
"LB",  # Left-back
"SW",  # Sweeper
"DM",  # Defensive midfielder
"CM",  # Central midfielder
"AM",  # Attacking midfielder
"RM",  # Right midfielder
"RW",  # Right winger
"LM",  # Left midfielder
"LW",  # Left winger
"CF",  # Center forward
"SS"   # Second striker
*/

CREATE TABLE jugadores (
    nombre_equipo VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    posicion CHAR(2) NOT NULL CHECK (posicion IN ('GK', 'CB', 'RB', 'LB', 'SW', 'DM', 'CM', 'AM', 'RM', 'RW', 'LM', 'LW', 'CF', 'SS')),
    dorsal INT NOT NULL CHECK (dorsal > 0),
    pierna_habilidosa CHAR(1) NOT NULL CHECK (pierna_habilidosa IN ('L', 'R')),
    fecha_nacimiento DATE NOT NULL,
    pais_origen VARCHAR(100) NOT NULL,

    PRIMARY KEY (nombre_equipo, dorsal),
    FOREIGN KEY (nombre_equipo) REFERENCES equipos(nombre)
);

-- Tambien se registran los directores tecnicos --

CREATE TABLE directores_tecnicos (
    id SERIAL PRIMARY KEY,
    nombre_equipo VARCHAR(100) NOT NULL, 
    nombre VARCHAR(100) NOT NULL,
    rango VARCHAR(1) NOT NULL CHECK (rango IN ('P', 'S')),
    fecha_nacimiento DATE NOT NULL,
    pais_origen VARCHAR(100) NOT NULL,

    FOREIGN KEY (nombre_equipo) REFERENCES equipos(nombre)
);

-- Terminado lo anterios, se deben de registrar todos los INVOLUCRADOS en los partidos --

CREATE TABLE personal (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    designacion VARCHAR(10) NOT NULL CHECK (designacion IN ('arbitro', 'asistente', 'var')),
    fecha_nacimiento DATE NOT NULL,
    pais_origen VARCHAR(100) NOT NULL
);

-- Ahora ya habiendo registrado a todos los equpipos e individuos a participar, podemos pasar a la primera fase de la copa, la FASE DE GRUPOS --

CREATE TABLE fase_grupos (
    grupo CHAR(1) NOT NULL CHECK (grupo IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H')),
    nombre_equipo VARCHAR(100) NOT NULL,
    partidos INT NOT NULL CHECK (partidos >= 0),
    diferencia_goles INT NOT NULL CHECK (diferencia_goles >= 0),
    puntos INT NOT NULL CHECK (puntos >= 0),

    PRIMARY KEY (grupo, nombre_equipo),
    FOREIGN KEY (nombre_equipo) REFERENCES equipos(nombre)
);

-- Para poder continuar con la fase de octavos, primero necesitamos que los equipos jueguen, por lo que se pasara a diseñar los PARTIDOS de manera simplificada --

CREATE TABLE partidos (
    id SERIAL PRIMARY KEY,

    fase VARCHAR(10) NOT NULL CHECK (fase IN ('grupos', 'octavos', 'cuartos', 'semis', 'final')),

    nombre_equipo_uno VARCHAR(100) NOT NULL,
    nombre_equipo_dos VARCHAR(100) NOT NULL,

    director_tecnico_equipo_uno INT NOT NULL,
    director_tecnico_equipo_dos INT NOT NULL,

    fecha DATE NOT NULL,

    nombre_estadio VARCHAR(100) NOT NULL,

    tiempo_inicial TIME NOT NULL,
    timpo_final TIME NOT NULL,

    arbitro INT NOT NULL,
    asistente_uno INT NOT NULL,
    asistente_dos INT NOT NULL,
    asistente_tres INT NOT NULL,
    var INT NOT NULL,

    FOREIGN KEY (nombre_equipo_uno) REFERENCES equipos(nombre),
    FOREIGN KEY (nombre_equipo_dos) REFERENCES equipos(nombre),

    FOREIGN KEY (director_tecnico_equipo_uno) REFERENCES directores_tecnicos(id),
	FOREIGN KEY (director_tecnico_equipo_dos) REFERENCES directores_tecnicos(id),

    FOREIGN kEY (nombre_estadio) REFERENCES estadios(nombre),
	
    FOREIGN KEY (arbitro) REFERENCES personal(id),
    FOREIGN KEY (asistente_uno) REFERENCES personal(id),
    FOREIGN KEY (asistente_dos) REFERENCES personal(id),
    FOREIGN KEY (asistente_tres) REFERENCES personal(id),
    FOREIGN KEY (var) REFERENCES personal(id)
);

-- ESTADISTICAS del partido --

CREATE TABLE alineacion (
    id_partido INT NOT NULL,
    nombre_equipo VARCHAR(100) NOT NULL,
    dorsal_jugador VARCHAR(100) NOT NULL,
    
    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo, dorsal_jugador) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE cambio_jugador (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador_uno VARCHAR(100) NOT NULL,
    dorsal_jugador_dos VARCHAR(100) NOT NULL,
	
    tiempo_cambio TIME NOT NULL

    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo) REFERENCES equipos(nombre),
    FOREIGN KEY (nombre_equipo, dorsal_jugador_uno) REFERENCES jugadores(nombre_equipo, dorsal),
    FOREIGN KEY (nombre_equipo, dorsal_jugador_dos) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE goles (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador_anotador VARCHAR(100) NOT NULL,
    dorsal_jugador_asistente VARCHAR(100),

    tipo_gol VARCHAR(100) NOT NULL CHECK (tipo_gol IN ('partido', 'penal')),
	
    tiempo_gol TIME NOT NULL

    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo) REFERENCES equipos(nombre),
    FOREIGN KEY (nombre_equipo, dorsal_jugador_anotador) REFERENCES jugadores(nombre_equipo, dorsal),
    FOREIGN KEY (nombre_equipo, dorsal_jugador_asistente) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE tiros_libres (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador VARCHAR(100) NOT NULL,

    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo, dorsal_jugador) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE tarjeta_amarilla (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador VARCHAR(100) NOT NULL,

    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo, dorsal_jugador) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE tarjeta_roja (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador VARCHAR(100) NOT NULL,

    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo, dorsal_jugador) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE penales (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador VARCHAR(100) NOT NULL,

	FOREIGN KEY (nombre_equipo, dorsal_jugador) REFERENCES jugadores(nombre_equipo, dorsal)
);

------------------------------------------------------------------------

CREATE TABLE octavos (
    grupo CHAR(1) NOT NULL,
    nombre_equipo VARCHAR(100) NOT NULL,

    PRIMARY KEY (grupo, nombre_equipo),
    FOREIGN KEY (grupo, nombre_equipo) REFERENCES fase_grupos(grupo, nombre_equipo)
);

CREATE TABLE cuartos (
    grupo CHAR(1) NOT NULL,
    nombre_equipo VARCHAR(100) NOT NULL,

    PRIMARY KEY (grupo, nombre_equipo),
    FOREIGN KEY (grupo, nombre_equipo) REFERENCES octavos(grupo, nombre_equipo)
);

CREATE TABLE semis (
    grupo CHAR(1) NOT NULL,
    nombre_equipo VARCHAR(100) NOT NULL,

    PRIMARY KEY (grupo, nombre_equipo),
    FOREIGN KEY (grupo, nombre_equipo) REFERENCES cuartos(grupo, nombre_equipo)
);