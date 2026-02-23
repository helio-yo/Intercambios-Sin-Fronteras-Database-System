USE universidad_intercambios;

-- ADVANCED ANALYTICAL QUERIES

-- Query 1: Students eligible for exchange (GPA >= 8.0)
SELECT 
    a.id_alumno,
    a.nombre,
    a.apellido_paterno,
    a.promedio
FROM alumnos a
WHERE a.promedio >= 8.0;

-- Query 2: Number of students by nationality
SELECT 
    n.nacionalidad,
    COUNT(a.id_alumno) AS total_students
FROM alumnos a
JOIN nacionalidades n ON a.id_nacionalidad = n.id_nacionalidad
GROUP BY n.nacionalidad;

-- Query 3: Universities with the highest number of exchanges
SELECT 
    u.nombre AS university,
    COUNT(i.id_intercambio) AS total_exchanges
FROM intercambio i
JOIN universidades u ON i.id_universidad = u.id_universidad
GROUP BY u.nombre
ORDER BY total_exchanges DESC;

-- Query 4: Average GPA of students by university type
SELECT 
    a.tipo,
    AVG(a.promedio) AS avg_gpa
FROM alumnos a
GROUP BY a.tipo;

-- Query 5: Students who speak more than one language
SELECT 
    a.id_alumno,
    a.nombre,
    COUNT(ai.id_idioma) AS languages_spoken
FROM alumnos a
JOIN alumno_idioma ai ON a.id_alumno = ai.id_alumno
GROUP BY a.id_alumno, a.nombre
HAVING COUNT(ai.id_idioma) > 1;

-- Query 6: Exchanges lasting more than 9 months
SELECT 
    i.id_intercambio,
    i.fecha_inicio,
    i.fecha_fin,
    TIMESTAMPDIFF(MONTH, i.fecha_inicio, i.fecha_fin) AS duration_months
FROM intercambio i
WHERE TIMESTAMPDIFF(MONTH, i.fecha_inicio, i.fecha_fin) > 9;

-- Query 7: Requests by status
SELECT 
    estatus,
    COUNT(*) AS total_requests
FROM solicitud
GROUP BY estatus;

-- Query 8: Students without any exchange request
SELECT 
    a.id_alumno,
    a.nombre
FROM alumnos a
LEFT JOIN solicitud s ON a.id_alumno = s.id_alumno
WHERE s.id_solicitud IS NULL;

-- Query 9: Universities by country with exchange count
SELECT 
    u.pais,
    COUNT(i.id_intercambio) AS total_exchanges
FROM universidades u
LEFT JOIN intercambio i ON u.id_universidad = i.id_universidad
GROUP BY u.pais;

-- Query 10: Average exchange duration
SELECT 
    AVG(TIMESTAMPDIFF(MONTH, fecha_inicio, fecha_fin)) AS avg_exchange_duration
FROM intercambio;

-- FUNCTION

-- Function: Check if a student is eligible for exchange
DELIMITER $$

CREATE FUNCTION is_student_eligible(p_id_alumno INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE avg_gpa DECIMAL(3,2);

    SELECT promedio
    INTO avg_gpa
    FROM alumnos
    WHERE id_alumno = p_id_alumno;

    RETURN avg_gpa >= 8.0;
END$$

DELIMITER ;

-- PROCEDURE

-- Procedure: Create a new exchange request
DELIMITER $$

CREATE PROCEDURE create_exchange_request(
    IN p_id_alumno INT,
    IN p_status VARCHAR(50)
)
BEGIN
    INSERT INTO solicitud (id_alumno, estatus, fecha_solicitud)
    VALUES (p_id_alumno, p_status, CURDATE());
END$$

DELIMITER ;

-- TRIGGER

-- Trigger: Prevent exchange creation if GPA is too low
DELIMITER $$

CREATE TRIGGER trg_validate_exchange_gpa
BEFORE INSERT ON intercambio
FOR EACH ROW
BEGIN
    DECLARE student_gpa DECIMAL(3,2);

    SELECT a.promedio
    INTO student_gpa
    FROM solicitud s
    JOIN alumnos a ON s.id_alumno = a.id_alumno
    WHERE s.id_solicitud = NEW.id_solicitud;

    IF student_gpa < 8.0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student GPA is below the minimum required for exchange.';
    END IF;
END$$

DELIMITER ;
