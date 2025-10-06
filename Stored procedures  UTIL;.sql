-- ---------------------------------------------------------------------------------------------------------------
									            -- UTIL
-- ---------------------------------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE ObtenerIdLineaMontajePorModelo(
    IN p_nombreModeloAuto VARCHAR(100),
    OUT p_idLineaMontaje INT
)
BEGIN
    SELECT lm.idLineaMontaje INTO p_idLineaMontaje
    FROM LineaMontaje lm
    INNER JOIN ModeloAuto ma ON lm.ModeloAuto_idModeloAuto = ma.idModeloAuto
    WHERE ma.modelo = p_nombreModeloAuto;
END//
DELIMITER ;

