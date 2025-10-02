-- -------------------------------------------------------------------------------
						-- Stored procedures 
-- -------------------------------------------------------------------------------
-- describe concesionaria;
-- Procedimiento para insertar concesionaria
-- drop procedure  altaConcesionaria;
-- drop procedure  bajaConcesionaria;
-- drop procedure  AgregarInsumo;
-- drop procedure AltaPedidoConcesionaria;
-- -------------------------------------------------------------------------------
						-- Concesionaria ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //
CREATE PROCEDURE altaConcesionaria(IN p_nombre VARCHAR(100),OUT nResultado INT,OUT cMensaje VARCHAR(256))
	BEGIN
    -- Inicializar el resultado y mensaje
		SET nResultado = -1;
		SET cMensaje = 'El concesionario ya existe con esa clave primaria.';
		-- Verificar si el concesionario ya existe
		IF NOT EXISTS (SELECT * FROM concesionaria WHERE nombreConcesionaria = p_nombre) THEN
			INSERT INTO concesionaria (nombreConcesionaria) VALUES (p_nombre);
			SET nResultado = 0;
			SET cMensaje = 'Concesionario insertado con éxito.';
        -- Confirmar la inserción exitosa
		END IF;
	END//
    
-- Procedimiento para insertar Proveedor
-- drop procedure  AltaProveedor;
DELIMITER //

DELIMITER //

CREATE PROCEDURE bajaConcesionaria(
    IN p_id INT, 
    OUT nResultado INT, 
    OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar resultado y mensaje
    SET nResultado = -1;
    SET cMensaje = 'No se encontró la concesionaria.';

    -- Verificar existencia
    IF EXISTS (SELECT 1 FROM concesionaria WHERE idConcesionaria = p_id) THEN

        -- Verificar si tiene pedidos asociados
        IF EXISTS (SELECT 1 FROM PedidoConcesionaria WHERE Concesionaria_idConcesionaria = p_id) THEN
            SET nResultado = 1;
            SET cMensaje = 'La concesionaria no se puede dar de baja ya que realizó algún pedido.';
        ELSE
            DELETE FROM concesionaria WHERE idConcesionaria = p_id;
            SET nResultado = 0;
            SET cMensaje = 'Concesionaria eliminada con éxito.';
        END IF;

    END IF;
END//

DELIMITER ;


DELIMITER //
CREATE PROCEDURE modificarNombreConcesionaria(IN p_id INT,IN p_nombre VARCHAR(100),OUT nResultado INT,OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'No se encontró la concesionaria.';

    IF EXISTS (SELECT 1 FROM concesionaria WHERE idConcesionaria = p_id) THEN
        UPDATE concesionaria
        SET nombreConcesionaria = p_nombre
        WHERE idConcesionaria = p_id;
        SET nResultado = 0;
        SET cMensaje = 'Nombre de concesionaria modificado con éxito.';
    END IF;
END//
DELIMITER ;

-- -------------------------------------------------------------------------------
						-- Proveedor ABM 
-- -------------------------------------------------------------------------------  
DELIMITER // 
CREATE PROCEDURE AltaProveedor(IN p_nombre VARCHAR(100),OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = -1;
    SET cMensaje = 'El proveedor ya existe.';
    
    -- Verificar si el proveedor ya existe por nombre
    IF NOT EXISTS (SELECT * FROM proveedor WHERE nombreProveedor = p_nombre) THEN
        -- Insertar nuevo proveedor (id se auto-genera)
        INSERT INTO proveedor (nombreProveedor) VALUES (p_nombre);
        SET nResultado = 0;
        SET cMensaje = 'Proveedor insertado con éxito.';
    END IF;
END//
DELIMITER ; 

-- Borrar el procedimiento si ya existe
-- DROP PROCEDURE IF EXISTS AgregarInsumo;

DELIMITER //
CREATE PROCEDURE BajaProveedor(IN p_id INT,OUT nResultado INT,OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar valores
    SET nResultado = -1;
    SET cMensaje = 'No se encontró el proveedor.';

    -- Verificar existencia
    IF EXISTS (SELECT 1 FROM proveedor WHERE idProveedor = p_id) THEN
        DELETE FROM proveedor WHERE idProveedor = p_id;
        SET nResultado = 0;
        SET cMensaje = 'Proveedor eliminado con éxito.';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModificarNombreProveedor(IN p_id INT,IN p_nombre VARCHAR(100),OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    -- Inicializar valores
    SET nResultado = -1;
    SET cMensaje = 'No se encontró el proveedor.';

    -- Verificar existencia
    IF EXISTS (SELECT 1 FROM proveedor WHERE idProveedor = p_id) THEN
        UPDATE proveedor
        SET nombreProveedor = p_nombre
        WHERE idProveedor = p_id;
        SET nResultado = 0;
        SET cMensaje = 'Nombre de proveedor modificado con éxito.';
    END IF;
END//
DELIMITER ;

-- -------------------------------------------------------------------------------
						-- Insumo ABM 
-- -------------------------------------------------------------------------------  

DELIMITER //
CREATE PROCEDURE AgregarInsumo(IN p_tipoInsumo VARCHAR(100),IN p_unidadMedida VARCHAR(45),IN p_idProveedor INT,IN p_precioUnitario FLOAT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idInsumo INT;
    DECLARE v_idInsumoProveedor INT;

    -- Inicializar variables de salida
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';

    -- Verificar si el proveedor existe
    IF NOT EXISTS (SELECT 1 FROM proveedor WHERE idProveedor = p_idProveedor) THEN
        SET cMensaje = 'El proveedor indicado no existe.';
    ELSE
        -- Verificar si el insumo ya existe
        IF NOT EXISTS (
            SELECT 1 FROM insumo 
            WHERE tipoInsumo = p_tipoInsumo AND UnidadDeMedida = p_unidadMedida
        ) THEN
            -- Insertar insumo nuevo
            INSERT INTO insumo (tipoInsumo, UnidadDeMedida)
            VALUES (p_tipoInsumo, p_unidadMedida);

            -- Obtener id auto_increment del insumo recién insertado
            SET v_idInsumo = LAST_INSERT_ID();

        ELSE
            -- Si el insumo ya existe, obtener su id
            SELECT idInsumo INTO v_idInsumo
            FROM insumo
            WHERE tipoInsumo = p_tipoInsumo AND UnidadDeMedida = p_unidadMedida
            LIMIT 1;
        END IF;

        -- Generar manualmente un ID para InsumoProveedor
        SELECT IFNULL(MAX(InsumoProvedorId),0) + 1 INTO v_idInsumoProveedor
        FROM InsumoProveedor;

        -- Verificar si ya existe la relación con el proveedor
        IF NOT EXISTS (
            SELECT 1 FROM InsumoProveedor
            WHERE Insumo_idInsumo = v_idInsumo 
              AND Proveedor_idProveedor = p_idProveedor
        ) THEN
            INSERT INTO InsumoProveedor 
                (InsumoProvedorId, Insumo_idInsumo, Proveedor_idProveedor, PrecioUnitario)
            VALUES 
                (v_idInsumoProveedor, v_idInsumo, p_idProveedor, p_precioUnitario);

            IF v_idInsumoProveedor = 1 THEN
                SET nResultado = 0;
                SET cMensaje = 'Insumo insertado y vinculado al proveedor con éxito.';
            ELSE
                SET nResultado = 1;
                SET cMensaje = 'Insumo ya existía, vinculado al proveedor con éxito.';
            END IF;
        ELSE
            SET nResultado = 2;
            SET cMensaje = 'El insumo ya existe y ya está vinculado con este proveedor.';
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE BajaInsumo(
    IN p_idInsumo INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar variables
    SET nResultado = -1;
    SET cMensaje = 'Insumo no encontrado.';

    -- Verificar si el insumo existe
    IF EXISTS (SELECT 1 FROM insumo WHERE idInsumo = p_idInsumo) THEN
        
        -- Eliminar relaciones con proveedores
        DELETE FROM InsumoProveedor
        WHERE Insumo_idInsumo = p_idInsumo;

        -- Eliminar insumo
        DELETE FROM insumo
        WHERE idInsumo = p_idInsumo;

        SET nResultado = 0;
        SET cMensaje = 'Insumo y relaciones con proveedores eliminados correctamente.';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModificarInsumo(IN p_idInsumo INT,IN p_tipoInsumo VARCHAR(100),IN p_unidadMedida VARCHAR(45),IN p_idProveedor INT,IN p_precioUnitario FLOAT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_count INT;
    -- Inicializar variables
    SET nResultado = -1;
    SET cMensaje = 'Insumo o proveedor no encontrado.';

    -- Verificar que insumo exista
    IF EXISTS (SELECT 1 FROM insumo WHERE idInsumo = p_idInsumo) THEN
        -- Actualizar columnas del insumo
        UPDATE insumo
        SET tipoInsumo = p_tipoInsumo,
            UnidadDeMedida = p_unidadMedida
        WHERE idInsumo = p_idInsumo;

        -- Verificar que exista relación con proveedor
        SELECT COUNT(*) INTO v_count 
        FROM InsumoProveedor 
        WHERE Insumo_idInsumo = p_idInsumo 
          AND Proveedor_idProveedor = p_idProveedor;

        IF v_count > 0 THEN
            -- Modificar precio de la relación
            UPDATE InsumoProveedor
            SET PrecioUnitario = p_precioUnitario
            WHERE Insumo_idInsumo = p_idInsumo 
              AND Proveedor_idProveedor = p_idProveedor;
            SET nResultado = 0;
            SET cMensaje = 'Insumo y precio actualizado correctamente.';
        ELSE
            SET nResultado = 1;
            SET cMensaje = 'Insumo actualizado, pero no existe relación con ese proveedor.';
        END IF;
    END IF;
END//
DELIMITER ;

-- -------------------------------------------------------------------------------
						-- PedidioConcesionaria ABM 
-- -------------------------------------------------------------------------------  
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


DELIMITER //
CREATE PROCEDURE BajaPedidoConcesionaria(IN p_idPedido INT,OUT nResultado INT,OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'Pedido no encontrado.';

    -- Verificar existencia
    IF EXISTS (SELECT 1 FROM PedidoConcesionaria WHERE idPedidoConsesinaria = p_idPedido) THEN
        -- Primero borrar relaciones en ModeloAuto_has_PedidoConcesionaria
        DELETE FROM ModeloAuto_has_PedidoConcesionaria
        WHERE PedidoConcesionaria_idPedidoConcesionaria = p_idPedido;

        -- Luego borrar el pedido
        DELETE FROM PedidoConcesionaria
        WHERE idPedidoConsesinaria = p_idPedido;

        SET nResultado = 0;
        SET cMensaje = 'Pedido eliminado correctamente.';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModificarPedidoConcesionaria(IN p_idPedido INT,IN p_idConcesionaria INT,IN p_fechaEntregaEstimada DATE,IN p_fechaEntregaReal DATE,IN p_fechaPedido DATE,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'Pedido o concesionaria no encontrado.';

    -- Verificar existencia
    IF EXISTS (SELECT 1 FROM PedidoConcesionaria WHERE idPedidoConsesinaria = p_idPedido) AND
       EXISTS (SELECT 1 FROM Concesionaria WHERE idConcesionaria = p_idConcesionaria) THEN

        UPDATE PedidoConcesionaria
        SET Concesionaria_idConcesionaria = p_idConcesionaria,
            FechaDeEntregaEstimada = p_fechaEntregaEstimada,
            FechaDeEntregaReal = p_fechaEntregaReal,
            FechaPedido = p_fechaPedido
        WHERE idPedidoConsesinaria = p_idPedido;

        SET nResultado = 0;
        SET cMensaje = 'Pedido modificado correctamente.';
    END IF;
END//
DELIMITER ;
-- -------------------------------------------------------------------------------
						-- Linea de montaje ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //

CREATE PROCEDURE altaLineaMontaje(IN p_ModeloAuto VARCHAR(100), IN p_capacidadMaximaMes INT, OUT nResultado INT,OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar resultado y mensaje
    SET nResultado = -1;
    SET cMensaje = 'La línea de montaje ya existe para este modelo de auto.';

    -- Verificar si el modelo de auto existe
    IF EXISTS (SELECT 1 FROM ModeloAuto ma WHERE ma.modelo = p_ModeloAuto) THEN

        -- Verificar si ya existe la línea de montaje para ese modelo
        IF NOT EXISTS (SELECT 1 FROM LineaMontaje lm JOIN ModeloAuto ma ON lm.ModeloAuto_idModeloAuto = ma.idModeloAuto WHERE ma.modelo = p_ModeloAuto) THEN
			INSERT INTO LineaMontaje (ModeloAuto_idModeloAuto, capacidadMaximaPorMes) VALUES ((SELECT ma.idModeloAuto FROM ModeloAuto ma WHERE ma.modelo = p_ModeloAuto), p_capacidadMaximaMes);
			SET nResultado = 0;
            SET cMensaje = 'Línea de montaje insertada con éxito.';
        END IF;

    ELSE
		SET nResultado = 1;
        SET cMensaje = 'El modelo de auto especificado no existe.';
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE bajaLineaMontaje(IN p_ModeloAuto VARCHAR(100),OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    -- Inicializar valores por defecto
    SET nResultado = -1;
    SET cMensaje = 'No existe línea de montaje para el modelo especificado.';

    -- Verificar si existe la línea de montaje para ese modelo
    IF EXISTS (SELECT 1 FROM LineaMontaje lm JOIN ModeloAuto ma ON lm.ModeloAuto_idModeloAuto = ma.idModeloAuto WHERE ma.modelo = p_ModeloAuto) THEN
        DELETE lm FROM LineaMontaje lm JOIN ModeloAuto ma ON lm.ModeloAuto_idModeloAuto = ma.idModeloAuto WHERE ma.modelo = p_ModeloAuto;

        SET nResultado = 0;
        SET cMensaje = 'Línea de montaje eliminada con éxito.';
    END IF;
END//
DELIMITER ;

DELIMITER //

CREATE PROCEDURE modificarLineaMontaje(IN p_ModeloAuto VARCHAR(100),IN p_nuevaCapacidadMaximaMes INT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    -- Inicializar valores por defecto
    SET nResultado = -1;
    SET cMensaje = 'No existe línea de montaje para el modelo especificado.';

    -- Verificar si existe la línea de montaje para ese modelo
    IF EXISTS (SELECT 1 FROM LineaMontaje lm JOIN ModeloAuto ma ON lm.ModeloAuto_idModeloAuto = ma.idModeloAuto WHERE ma.modelo = p_ModeloAuto) THEN
        UPDATE LineaMontaje lm JOIN ModeloAuto ma ON lm.ModeloAuto_idModeloAuto = ma.idModeloAuto SET lm.capacidadMaximaPorMes = p_nuevaCapacidadMaximaMes WHERE ma.modelo = p_ModeloAuto;

        SET nResultado = 0;
        SET cMensaje = 'Línea de montaje actualizada con éxito.';
    END IF;
END//

DELIMITER ;





-- drop procedure altaLineaMontaje;
-- -------------------------------------------------------------------------------
						-- Modelo ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //
CREATE PROCEDURE altaModelo(IN p_Modelo VARCHAR(100),OUT nResultado INT,OUT cMensaje VARCHAR(256))
	BEGIN
    -- Inicializar el resultado y mensaje
		SET nResultado = -1;
		SET cMensaje = 'El modelo ya existe con esa clave primaria.';
		-- Verificar si el concesionario ya existe
		IF NOT EXISTS (SELECT 1 FROM ModeloAuto WHERE modelo = p_Modelo) THEN
			INSERT INTO ModeloAuto(modelo) VALUES (p_Modelo);
			SET nResultado = 0;
			SET cMensaje = 'Modelo insertado con éxito.';
        -- Confirmar la inserción exitosa
		END IF;
	END//
    

DELIMITER //

DELIMITER //


CREATE PROCEDURE bajaModelo(IN p_ModeloAuto INT, OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'No se encontró el modelo con ese ID.';
    
    -- Verificar si el modelo existe
    IF EXISTS (SELECT 1 FROM ModeloAuto WHERE Modelo = p_IdModeloAuto) THEN
        DELETE FROM ModeloAuto WHERE Modelo = p_ModeloAuto;
        SET nResultado = 0;
        SET cMensaje = 'Modelo eliminado con éxito.';
    END IF;
END//


/*CREATE PROCEDURE modificacionModelo(IN p_ModeloPorModificar VARCHAR(100),IN p_ModeloModificado VARCHAR(100), OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'No se encontró el modelo con ese ID.';
    
    -- Verificar si el modelo existe
    IF EXISTS (SELECT 1 FROM ModeloAuto WHERE Modelo = p_ModeloPorModificar) THEN
        UPDATE ModeloAuto
        SET modelo = p_ModeloModificacio
        WHERE Modelo = p_ModeloPorModificar;
        
        SET nResultado = 0;
        SET cMensaje = 'Modelo modificado con éxito.';
    END IF;
END//

DELIMITER ;
*/

-- -------------------------------------------------------------------------------
						-- Vehicluo ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //
CREATE PROCEDURE altaVehiculo(IN p_numeroChasis INT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
	BEGIN
    -- Inicializar el resultado y mensaje
		SET nResultado = -1;
		SET cMensaje = 'El vehiculo ya existe con esa clave primaria.';
		-- Verificar si el concesionario ya existe
		IF NOT EXISTS (SELECT 1 FROM Vehiculo WHERE NumeroDeChasis = p_numeroChasis) THEN
			INSERT INTO Vehiculo (NumeroDeChasis) VALUES (p_numeroChasis);
			SET nResultado = 0;
			SET cMensaje = 'Vehiculo insertado con éxito.';
        -- Confirmar la inserción exitosa
		END IF;
	END//
DELIMITER //

DELIMITER //


CREATE PROCEDURE bajaVehiculo(IN p_numeroChasis INT, OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'No se encontró el vehículo con ese numero de chasis.';
    
    -- Verificar si el vehículo existe
    IF EXISTS (SELECT 1 FROM Vehiculo WHERE NumeroDeChasis = p_numeroChasis) THEN
        DELETE FROM Vehiculo WHERE NumeroDeChasis = p_numeroChasis;
        SET nResultado = 0;
        SET cMensaje = 'Vehículo eliminado con éxito.';
    END IF;
END//


/*CREATE PROCEDURE modificacionVehiculo(IN p_numeroChasisPorModificar INT,IN p_numeroChasisModificado INT, OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'No se encontró el vehículo con ese ID.';
    
    -- Verificar si el vehículo existe
    IF EXISTS (SELECT 1 FROM Vehiculo WHERE NumeroDeChasis = p_numeroChasisPorModificar) THEN
        UPDATE Vehiculo
        SET NumeroDeChasis = p_numeroChasisModificado
        WHERE NumeroDeChasis = p_numeroChasisPorModificar;
        
        SET nResultado = 0;
        SET cMensaje = 'Vehículo modificado con éxito.';
    END IF;
END//

DELIMITER ;
*/

-- -------------------------------------------------------------------------------
						-- Estacion ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //
CREATE PROCEDURE altaEstacion(IN p_actividad VARCHAR(256),OUT nResultado INT,OUT cMensaje VARCHAR(256))
	BEGIN
    -- Inicializar el resultado y mensaje
		SET nResultado = -1;
		SET cMensaje = 'La estacion ya existe con esa clave primaria.';
		-- Verificar si el concesionario ya existe
		IF NOT EXISTS (SELECT 1 FROM Estacion WHERE actividad = p_actividad) THEN
			INSERT INTO Estacion (actividad) VALUES (p_actividad);
			SET nResultado = 0;
			SET cMensaje = 'Estacion insertada con éxito.';
        -- Confirmar la inserción exitosa
		END IF;
	END//
DELIMITER //

DELIMITER //

-- Baja de estación
CREATE PROCEDURE bajaEstacion(IN p_actividad VARCHAR(256), OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'No se encontró la estación con ese ID.';
    
    -- Verificar si la estación existe
    IF EXISTS (SELECT 1 FROM Estacion WHERE actividad = p_actividad) THEN
        DELETE FROM Estacion WHERE actividad = p_actividad;
        SET nResultado = 0;
        SET cMensaje = 'Estación eliminada con éxito.';
    END IF;
END//

/*CREATE PROCEDURE modificacionEstacion(IN p_idEstacion INT, IN p_actividad VARCHAR(256), OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'No se encontró la estación con ese ID.';
    
    -- Verificar si la estación existe
    IF EXISTS (SELECT 1 FROM Estacion WHERE idEstacion = p_idEstacion) THEN
        UPDATE Estacion
        SET actividad = p_actividad
        WHERE idEstacion = p_idEstacion;
        
        SET nResultado = 0;
        SET cMensaje = 'Estación modificada con éxito.';
    END IF;
END//

DELIMITER ;
*/
/*
-- -------------------------------------------------------------------------------
						-- Registro estacion ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //
CREATE PROCEDURE altaRegestrioEstacion(IN p_actividad VARCHAR(256), IN p_numeroChasis INT, IN p_fechaInicio DATETIME, OUT nResultado INT,OUT cMensaje VARCHAR(256))
	BEGIN
    -- Inicializar el resultado y mensaje
		SET nResultado = -1;
		SET cMensaje = 'El registro ya existe con esa clave primaria.';
		-- Verificar si el registro ya existe
		IF NOT EXISTS (SELECT 1 FROM RegistroEstacion re JOIN Vehiculo v on re.Vehiculo_idVehiculo = v.idVehiculo WHERE NumeroDeChasis = p_numeroChasis) THEN
			INSERT INTO Estacion (actividad) VALUES (p_actividad);
			SET nResultado = 0;
			SET cMensaje = 'Estacion insertada con éxito.';
        -- Confirmar la inserción exitosa
		END IF;
	END//
DELIMITER //
(SELECT 1 FROM LineaMontaje lm JOIN ModeloAuto ma ON lm.ModeloAuto_idModeloAuto = ma.idModeloAuto WHERE ma.modelo = p_ModeloAuto)
*/
