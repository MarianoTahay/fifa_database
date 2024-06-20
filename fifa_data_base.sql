-- Verion 1.0 --
DROP TABLE alineacion;
DROP TABLE cambio_jugador;
DROP TABLE goles;
DROP TABLE tiros_libres;
DROP TABLE tarjeta_amarilla;
DROP TABLE tarjeta_roja;
DROP TABLE partidos;
DROP TABLE estadios;
DROP TABLE partido_final;
DROP TABLE semis;
DROP TABLE cuartos;
DROP TABLE octavos;
DROP TABLE fase_grupos;
DROP TABLE jugadores;
DROP TABLE directores_tecnicos;
DROP TABLE equipos;
DROP TABLE personal;

/*
Considerando que el mundial FIFA Catar 2022 está próximo se le requiere diseñar el sistema de información para 
registrar todo lo acontecido en el mismo.
*/

-- 8 estadios --
CREATE TABLE estadios (
    nombre VARCHAR(100) NOT NULL PRIMARY KEY,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    localidad VARCHAR(100) NOT NULL
);


-- 32 equipos --
CREATE TABLE equipos (
    nombre VARCHAR(100) NOT NULL PRIMARY KEY,
    participaciones_previas INTEGER NOT NULL CHECK (participaciones_previas >= 0),
    mundiales_ganados INTEGER NOT NULL CHECK (mundiales_ganados >= 0),
    fecha_afiliacion DATE NOT NULL
);

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

-- 26 jugadores por equipo --
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

-- Un director principal P y dos secundarios S por equipo --
CREATE TABLE directores_tecnicos (
    id SERIAL PRIMARY KEY,
    nombre_equipo VARCHAR(100) NOT NULL, 
    nombre VARCHAR(100) NOT NULL,
    rango VARCHAR(1) NOT NULL CHECK (rango IN ('P', 'S')),
    fecha_nacimiento DATE NOT NULL,
    pais_origen VARCHAR(100) NOT NULL,

    FOREIGN KEY (nombre_equipo) REFERENCES equipos(nombre)
);

-- 36 arbitros, 69 asistentes, 24 para el var --
CREATE TABLE personal (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    designacion VARCHAR(10) NOT NULL CHECK (designacion IN ('arbitro', 'asistente', 'var')),
    fecha_nacimiento DATE NOT NULL,
    pais_origen VARCHAR(100) NOT NULL
);


CREATE TABLE fase_grupos (
    grupo CHAR(1) NOT NULL CHECK (grupo IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H')),
    nombre_equipo VARCHAR(100) NOT NULL,
    partidos INT NOT NULL CHECK (partidos >= 0),
    diferencia_goles INT NOT NULL CHECK (diferencia_goles >= 0),
    puntos INT NOT NULL CHECK (puntos >= 0),

    PRIMARY KEY (grupo, nombre_equipo),
    FOREIGN KEY (nombre_equipo) REFERENCES equipos(nombre)
);


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
    dorsal_jugador INT NOT NULL,

    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo, dorsal_jugador) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE cambio_jugador (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador_uno INT NOT NULL,
    dorsal_jugador_dos INT NOT NULL,
	
    tiempo_cambio TIME NOT NULL,

	PRIMARY KEY (id_partido, nombre_equipo, tiempo_cambio),
    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo) REFERENCES equipos(nombre),
    FOREIGN KEY (nombre_equipo, dorsal_jugador_uno) REFERENCES jugadores(nombre_equipo, dorsal),
    FOREIGN KEY (nombre_equipo, dorsal_jugador_dos) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE goles (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador_anotador INT NOT NULL,
    dorsal_jugador_asistente INT,

    tipo_gol VARCHAR(100) NOT NULL CHECK (tipo_gol IN ('partido', 'penal')),
	
    tiempo_gol TIME NOT NULL,

	PRIMARY KEY(id_partido, tiempo_gol),
    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo) REFERENCES equipos(nombre),
    FOREIGN KEY (nombre_equipo, dorsal_jugador_anotador) REFERENCES jugadores(nombre_equipo, dorsal),
    FOREIGN KEY (nombre_equipo, dorsal_jugador_asistente) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE tiros_libres (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador INT NOT NULL,

	tiempo_tiro TIME NOT NULL,

	PRIMARY KEY (id_partido, tiempo_tiro),
    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo, dorsal_jugador) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE tarjeta_amarilla (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador INT NOT NULL,

	tiempo_amarilla TIME NOT NULL,

	PRIMARY KEY (id_partido, nombre_equipo, dorsal_jugador, tiempo_amarilla),
    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo, dorsal_jugador) REFERENCES jugadores(nombre_equipo, dorsal)
);

CREATE TABLE tarjeta_roja (
    id_partido INT NOT NULL,
	
    nombre_equipo VARCHAR(100) NOT NULL,
	
    dorsal_jugador INT NOT NULL,

	tiempo_roja TIME NOT NULL,

	PRIMARY KEY (id_partido, nombre_equipo, dorsal_jugador, tiempo_roja),
    FOREIGN KEY (id_partido) REFERENCES partidos(id),
    FOREIGN KEY (nombre_equipo, dorsal_jugador) REFERENCES jugadores(nombre_equipo, dorsal)
);

------------------------------------------------------------------------

-- (W) de win, (L) de lose, (P) de pending
CREATE TABLE octavos (
    grupo CHAR(1) NOT NULL,
    nombre_equipo VARCHAR(100) NOT NULL,
	resultado VARCHAR(1) NOT NULL CHECK(resultado IN ('W', 'L', 'P')),

    PRIMARY KEY (grupo, nombre_equipo),
    FOREIGN KEY (grupo, nombre_equipo) REFERENCES fase_grupos(grupo, nombre_equipo)
);

CREATE TABLE cuartos (
    grupo CHAR(1) NOT NULL,
    nombre_equipo VARCHAR(100) NOT NULL,
	resultado VARCHAR(1) NOT NULL CHECK(resultado IN ('W', 'L', 'P')),

    PRIMARY KEY (grupo, nombre_equipo),
    FOREIGN KEY (grupo, nombre_equipo) REFERENCES octavos(grupo, nombre_equipo)
);

CREATE TABLE semis (
    grupo CHAR(1) NOT NULL,
    nombre_equipo VARCHAR(100) NOT NULL,
	resultado VARCHAR(1) NOT NULL CHECK(resultado IN ('W', 'L', 'P')),

    PRIMARY KEY (grupo, nombre_equipo),
    FOREIGN KEY (grupo, nombre_equipo) REFERENCES cuartos(grupo, nombre_equipo)
);

CREATE TABLE partido_final (
	grupo CHAR(1) NOT NULL,
    nombre_equipo VARCHAR(100) NOT NULL,
	resultado VARCHAR(1) NOT NULL CHECK(resultado IN ('W', 'L', 'P')),

    PRIMARY KEY (grupo, nombre_equipo),
    FOREIGN KEY (grupo, nombre_equipo) REFERENCES semis(grupo, nombre_equipo)
);