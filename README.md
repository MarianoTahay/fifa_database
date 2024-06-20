##### Mariano Tahay
## Sistema de Información para el Mundial FIFA Catar 2022

### Estructura General del Torneo

- **8 Estadios:** Con diferentes capacidades de espectadores y localidades.
- **32 Equipos Nacionales:** Con datos históricos como número de participaciones previas, mundiales ganados y fecha de afiliación.
- **26 Jugadores por Equipo:** Registrando posición, número de dorsal y pierna habilidosa/preferencia.
- **3 Entrenadores por Equipo:** 1 director técnico principal y 2 secundarios.
- **129 Árbitros en Total:**
  - 36 Árbitros Principales.
  - 69 Asistentes.
  - 24 para el VAR.

### Detalles de los Individuos

- Fecha de nacimiento y país de origen para todos los jugadores, entrenadores y árbitros.

### Detalles de los Partidos

- **Alineación Inicial:** 11 jugadores y 1 director técnico por equipo.
- **Árbitros:** 1 principal, 3 asistentes y 1 VAR por partido.

### Estadísticas de Interés

- Cambios de jugador (máximo 3 por partido).
- Goles (con registro del jugador que asistió, si aplica).
- Tiros libres.
- Tiros de esquina.
- Penales.
- Tarjetas Amarillas (suspensión con 2 amarillas acumuladas en diferentes partidos).
- Tarjetas Rojas (por acumulación de amarillas en el mismo partido o tarjeta roja directa).

### Fases del Torneo

- **Fase de Grupos (8 Grupos A-H):**
  - Cada equipo se enfrenta a los otros del grupo una vez.
  - Puntuación: 3 puntos por victoria, 1 punto por empate, 0 puntos por derrota.

- **Eliminatorias:**
  - **Octavos de Final:** Los dos primeros lugares de cada grupo avanzan.
    - Criterios de desempate: Puntos, diferencia de goles, cantidad de goles, desempate adicional según reglamento.
  
  - **Cuartos de Final:** Ganadores de octavos de final.

  - **Semifinales:** Ganadores de cuartos de final.

  - **Partido por el Tercer Puesto:** Perdedores de las semifinales.

  - **Final:** Ganadores de las semifinales.

### Bota de Oro

Al finalizar el torneo se le otorga un premio al jugador que más goles anotó (no se cuentan tandas de penales). En caso de desempate se considera:
- Menor cantidad de goles por penal.
- Más asistencias.
- Menor tiempo jugado.

### Modelo E/R
Desarrollar el modelo Entidad-Relación (E/R) para el sistema de información del Mundial FIFA Catar 2022. Puede incluir supuestos adicionales según sea necesario, especificando cada uno.

### Pseudocódigo para Consultas SQL

- Reporte de Clasificación Final de Grupos
- Registrar la información inicial de un partido
- Según los resultados de la última etapa avanzar el torneo una etapa
- Resultados bota de Oro