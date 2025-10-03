DELIMITER //
CREATE PROCEDURE AltaPedidoConcesionaria(IN p_idPedido INT,IN p_idConcesionaria INT,IN p_fechaEntregaEstimada DATE,IN p_fechaEntregaReal DATE,IN p_fechaPedido DATE,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';

    -- Verificar que la concesionaria exista
    IF NOT EXISTS (SELECT 1 FROM Concesionaria WHERE idConcesionaria = p_idConcesionaria) THEN
        SET nResultado = -2;
        SET cMensaje = 'Concesionaria no encontrada.';
    ELSE
        -- Insertar pedido con ID manual
        INSERT INTO PedidoConcesionaria 
            (idPedidoConcesionaria, Concesionaria_idConcesionaria, FechaDeEntregaEstimada, FechaDeEntregaReal, FechaPedido)
        VALUES 
            (p_idPedido, p_idConcesionaria, p_fechaEntregaEstimada, p_fechaEntregaReal, p_fechaPedido);
        
        SET nResultado = 0;
        SET cMensaje = 'Pedido de concesionaria insertado correctamente.';
    END IF;
END//
DELIMITER ;

