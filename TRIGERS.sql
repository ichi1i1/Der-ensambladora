-- -----------------------------------------------------
-- Índices para optimizar consultas
-- -----------------------------------------------------

CREATE INDEX idx_registro_vehiculo_estacion ON RegistroEstacion(Vehiculo_idVehiculo, Estacion_idEstacion);
CREATE INDEX idx_estacion_linea_orden ON Estacion(LineaMontaje_idLineaMontaje, orden);
CREATE INDEX idx_linea_modelo_capacidad ON LineaMontaje(ModeloAuto_idModeloAuto, CapacidadMaximaMes);
-- CREATE INDEX idx_vehiculo_pedido_modelo ON Vehiculo(fk_PedidoConcesionaria_idPedidoConcesionaria, fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto);


-- -----------------------------------------------------
-- Trigger: GenerarVehiculosAlCerrarPedido
-- -----------------------------------------------------
DELIMITER //

CREATE TRIGGER GenerarVehiculosAlCerrarPedido
AFTER UPDATE ON PedidoConcesionaria
FOR EACH ROW
BEGIN
    DECLARE v_idModelo INT;
    DECLARE v_cantidad INT;
    DECLARE done INT DEFAULT 0;

    DECLARE cur_modelos CURSOR FOR
        SELECT ModeloAuto_idModeloAuto, Cantidad
        FROM ModeloAuto_has_PedidoConcesionaria
        WHERE PedidoConcesionaria_idPedidoConcesionaria = NEW.idPedidoConcesionaria;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Solo se ejecuta si se cargó FechaCierrePedido
    IF OLD.FechaCierrePedido IS NULL AND NEW.FechaCierrePedido IS NOT NULL THEN
        -- GENERAR VEHÍCULOS
        OPEN cur_modelos;

        modelo_loop: LOOP
            FETCH cur_modelos INTO v_idModelo, v_cantidad;
            IF done = 1 THEN
                LEAVE modelo_loop;
            END IF;

            -- Insertar vehículos según cantidad
            WHILE v_cantidad > 0 DO
                INSERT INTO Vehiculo (
                    fk_PedidoConcesionaria_idPedidoConcesionaria,
                    fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto
                )
                VALUES (NEW.idPedidoConcesionaria, v_idModelo);
                SET v_cantidad = v_cantidad - 1;
            END WHILE;
        END LOOP;

        CLOSE cur_modelos;
        
    
       
    END IF;
END//
DELIMITER ;

-- -------------------------------------------------------------------------------
-- Trigger ActualizarStock en InsumoEstacion
-- -------------------------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER ActualizarStock
AFTER INSERT ON PedidoInsumoDetalle
FOR EACH ROW
BEGIN
    DECLARE v_idInsumo INT;

    -- Obtener el ID del insumo asociado al proveedor
    SELECT Insumo_idInsumo
    INTO v_idInsumo
    FROM InsumoProveedor
    WHERE InsumoProvedorId = NEW.InsumoProveedor_InsumoProvedorId;
	
    -- Actualizar el stock en InsumoEstacion sumando la cantidad pedida 
    UPDATE InsumoEstacion 
    SET Stock = COALESCE(Stock, 0) + NEW.Cantidad 
    WHERE Insumo_idInsumo = v_idInsumo;

END $$

DELIMITER ;








 