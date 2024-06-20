-- Reporte de clasificación final de grupos --

SELECT * FROM equipos;

-- Cantidad de partidos jugados --
SELECT COUNT(*) as "Cantidad de partidos" FROM partidos WHERE nombre_equipo_uno = 'Argentina' OR nombre_equipo_dos = 'Argentina' AND fase = 'grupos';

-- Diferencia de goles --
WITH goles_favor AS (
	SELECT COUNT(*) AS cantidad FROM goles WHERE id_partido = 1 AND nombre_equipo = 'Argentina'
),
goles_contra AS (
	SELECT COUNT(*) AS cantidad FROM goles WHERE id_partido = 1 AND nombre_equipo != 'Argentina'
),
diferencia_de_goles AS (
	SELECT goles_favor.cantidad - goles_contra.cantidad AS cantidad FROM goles_favor, goles_contra	
)

UPDATE fase_grupos SET diferencia_goles = diferencia_goles + (SELECT cantidad FROM diferencia_de_goles) WHERE nombre_equipo = 'Argentina';

-- Cantidad de puntos --
WITH goles_favor AS (
	SELECT COUNT(*) AS cantidad FROM goles WHERE id_partido = 1 AND nombre_equipo = 'Argentina'
),
goles_contra AS (
	SELECT COUNT(*) AS cantidad FROM goles WHERE id_partido = 1 AND nombre_equipo != 'Argentina'
),
puntos AS (
	SELECT 
		CASE
			WHEN goles_favor.cantidad - goles_contra.cantidad > 0 THEN 3
			WHEN goles_favor.cantidad - goles_contra.cantidad < 0 THEN 0
			ELSE 1
		END AS cantidad
		FROM goles_favor, goles_contra
)

UPDATE fase_grupos SET puntos = puntos + (SELECT cantidad FROM puntos) WHERE nombre_equipo = 'Argentina';

-- Desplegamos el reporte de como quedo la fase de grupos (UTILIZANDO LOS PRIMEROS 3 CRITRERIOS) --
SELECT 
	grupo, 
	nombre_equipo, 
	partidos, 
	diferencia_goles, 
	puntos
	FROM fase_grupos
	ORDER BY grupo ASC, puntos DESC, diferencia_goles DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registrar la información inicial de un partido --

INSERT INTO partidos (fase, nombre_equipo_uno, nombre_equipo_dos, director_tecnico_equipo_uno, director_tecnico_equipo_dos, fecha, nombre_estadio, tiempo_inicial, timpo_final, arbitro, asistente_uno, asistente_dos, asistente_tres, var) VALUES
('grupos', 'Argentina', 'Brasil', 1, 2, '2022-11-21', 'Estadio Lusail', '18:00', '20:00', 1, 2, 3, 4, 5);

------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Según los resultados de la última etapa avanzar el torneo una etapa --

-- Grupos a octavos
WITH ranked_teams AS (
    SELECT 
	grupo, 
	nombre_equipo, 
	partidos, 
	diferencia_goles, 
	puntos,
	'P' as resultado,
	ROW_NUMBER() OVER (PARTITION BY grupo ORDER BY puntos DESC, diferencia_goles DESC) AS rank
	FROM fase_grupos

)
INSERT INTO octavos (grupo, nombre_equipo, resultado)
SELECT grupo, nombre_equipo, resultado
FROM ranked_teams
WHERE rank <= 2;

-- Octavos a Cuartos 
WITH ganadores AS (
    SELECT grupo, nombre_equipo, 'P' as resultado
    FROM octavos
    WHERE resultado = 'W' 
)
INSERT INTO cuartos (grupo, nombre_equipo, resultado)
SELECT grupo, nombre_equipo, resultado
FROM ganadores;

-- Cuartos a Semis
WITH ganadores AS (
    SELECT grupo, nombre_equipo, 'P' as resultado
    FROM cuartos
    WHERE resultado = 'W'
)
INSERT INTO semis (grupo, nombre_equipo, resultado)
SELECT grupo, nombre_equipo, resultado
FROM ganadores;

-- Semis a partido_final
WITH ganadores AS (
    SELECT grupo, nombre_equipo, 'P' as resultado
    FROM semis
    WHERE resultado = 'W'
)
INSERT INTO partido_final (grupo, nombre_equipo, resultado)
SELECT grupo, nombre_equipo, resultado
FROM ganadores;

------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Resultados bota de Oro --

-- Mayor cantidad de goles
WITH max_goles AS (
    SELECT 
        nombre_equipo, 
        dorsal_jugador_anotador, 
        COUNT(*) AS cantidad_goles
    FROM goles
    WHERE tipo_gol = 'partido'
    GROUP BY 
        nombre_equipo, 
        dorsal_jugador_anotador
    ORDER BY cantidad_goles DESC
),

-- Menor cantidad de penales
min_penales AS (
    SELECT 
        nombre_equipo, 
        dorsal_jugador_anotador, 
        COUNT(*) AS cantidad_penales
    FROM goles
    WHERE tipo_gol = 'penal'
    GROUP BY 
        nombre_equipo, 
        dorsal_jugador_anotador
    ORDER BY cantidad_penales ASC
)

-- JOIN
SELECT 
    max_goles.nombre_equipo, 
    max_goles.dorsal_jugador_anotador, 
    max_goles.cantidad_goles, 
    min_penales.cantidad_penales
FROM max_goles
JOIN min_penales 
    ON max_goles.nombre_equipo = min_penales.nombre_equipo
    AND max_goles.dorsal_jugador_anotador = min_penales.dorsal_jugador_anotador;