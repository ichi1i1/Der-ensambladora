-- -------------------------------------------------------------------------------
-- Stored procedures 
-- -------------------------------------------------------------------------------
-- describe concesionaria;
-- Procedimiento para insertar concesionaria
-- drop procedure  altaConcesionaria;
-- drop procedure  bajaConcesionaria;
-- drop procedure  AgregarInsumo;
-- drop procedure AltaPedidoConcesionaria;
-- ===============================================================================
								-- ABM
-- ===============================================================================
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
-- Estacion ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //
CREATE PROCEDURE altaEstacion(IN p_actividad VARCHAR(256),IN p_nombreModeloAuto VARCHAR(100),IN p_orden INT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idLineaMontaje INT;
    DECLARE v_idModeloAuto INT;

    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';

    -- Verificar si el modelo de auto existe
    IF NOT EXISTS (SELECT 1 FROM ModeloAuto WHERE modelo = p_nombreModeloAuto) THEN
        SET cMensaje = 'El modelo de auto especificado no existe.';
    ELSE
        -- Obtener el ID del modelo de auto
        SELECT idModeloAuto INTO v_idModeloAuto 
        FROM ModeloAuto 
        WHERE modelo = p_nombreModeloAuto;

        -- Verificar si existe línea de montaje para el modelo
        IF NOT EXISTS (SELECT 1 FROM LineaMontaje WHERE ModeloAuto_idModeloAuto = v_idModeloAuto) THEN
            SET cMensaje = 'No existe línea de montaje para el modelo de auto especificado.';
        ELSE
            -- Obtener el ID de la línea de montaje
            SELECT idLineaMontaje INTO v_idLineaMontaje 
            FROM LineaMontaje 
            WHERE ModeloAuto_idModeloAuto = v_idModeloAuto;

            -- Verificar si ya existe una estación con el mismo nombre en la misma línea de montaje
            IF EXISTS (SELECT 1 FROM Estacion WHERE actividad = p_actividad AND LineaMontaje_idLineaMontaje = v_idLineaMontaje) THEN
                SET cMensaje = 'Ya existe una estación con esta actividad en la misma línea de montaje.';
            ELSE
                -- Insertar la nueva estación
                INSERT INTO Estacion (actividad, LineaMontaje_idLineaMontaje, orden) 
                VALUES (p_actividad, v_idLineaMontaje, p_orden);

                SET nResultado = 0;
                SET cMensaje = 'Estación insertada con éxito.';
            END IF;
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE modificacionEstacion(IN p_idEstacion INT,IN p_actividad VARCHAR(256),IN p_orden INT,OUT nResultado INT,OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'No se encontró la estación con ese ID.';

    IF EXISTS (SELECT 1 FROM Estacion WHERE idEstacion = p_idEstacion) THEN
        UPDATE Estacion
        SET actividad = p_actividad,
            orden = p_orden
        WHERE idEstacion = p_idEstacion;

        SET nResultado = 0;
        SET cMensaje = 'Estación modificada con éxito.';
    END IF;
END//
DELIMITER ;


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
DELIMITER ;
DELIMITER //


-- -------------------------------------------------------------------------------
-- Insumo ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //
CREATE PROCEDURE AltaInsumo(IN p_tipoInsumo VARCHAR(100),IN p_unidadMedida VARCHAR(45),OUT p_idInsumo INT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';
    SET p_idInsumo = NULL;

    -- Verificar si el insumo ya existe
    IF EXISTS (SELECT 1 FROM insumo WHERE tipoInsumo = p_tipoInsumo AND UnidadDeMedida = p_unidadMedida) THEN
        SET nResultado = 1;
        SET cMensaje = 'El insumo ya existe.';
        
        -- Devolver el ID existente
        SELECT idInsumo INTO p_idInsumo
        FROM insumo 
        WHERE tipoInsumo = p_tipoInsumo AND UnidadDeMedida = p_unidadMedida;
    ELSE
        -- Insertar nuevo insumo
        INSERT INTO insumo (tipoInsumo, UnidadDeMedida)
        VALUES (p_tipoInsumo, p_unidadMedida);
        
        SET p_idInsumo = LAST_INSERT_ID();
        SET nResultado = 0;
        SET cMensaje = 'Insumo creado con éxito.';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE BajaInsumo(IN p_tipoInsumo VARCHAR(100),IN p_forzar BOOLEAN,OUT nResultado INT,OUT cMensaje VARCHAR(500))
BEGIN
    DECLARE v_idInsumo INT;
    DECLARE v_cantProveedores INT;
    DECLARE v_cantEstaciones INT;
    DECLARE v_proveedores TEXT;
    DECLARE v_estaciones TEXT;
    -- Inicializar variables
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';
    -- Obtener ID del insumo solo por nombre
    SELECT idInsumo INTO v_idInsumo FROM insumo  WHERE tipoInsumo = p_tipoInsumo;
    -- Verificar si el insumo existe
    IF v_idInsumo IS NULL THEN
        SET nResultado = 1;
        SET cMensaje = CONCAT('El insumo "', p_tipoInsumo, '" no existe.');
    ELSE
        -- Contar relaciones con proveedores
        SELECT COUNT(*), GROUP_CONCAT(DISTINCT pr.nombreProveedor)INTO v_cantProveedores, v_proveedores FROM InsumoProveedor ip
        JOIN Proveedor pr ON ip.Proveedor_idProveedor = pr.idProveedor WHERE ip.Insumo_idInsumo = v_idInsumo;
        -- Contar relaciones con estaciones
        SELECT COUNT(*), GROUP_CONCAT(DISTINCT e.actividad) INTO v_cantEstaciones, v_estaciones FROM InsumoEstacion ie
        JOIN Estacion e ON ie.Estacion_idEstacion = e.idEstacion WHERE ie.Insumo_idInsumo = v_idInsumo;
        -- Verificar si tiene relaciones
        IF v_cantProveedores > 0 OR v_cantEstaciones > 0 THEN
            IF p_forzar = TRUE THEN
                -- MODO FUERZA: Eliminar todo
                -- Eliminar relaciones con proveedores
                DELETE FROM InsumoProveedor
                WHERE Insumo_idInsumo = v_idInsumo;
                -- Eliminar relaciones con estaciones
                DELETE FROM InsumoEstacion
                WHERE Insumo_idInsumo = v_idInsumo;
                -- Eliminar insumo
                DELETE FROM insumo
                WHERE idInsumo = v_idInsumo;
                SET nResultado = 0;
                SET cMensaje = CONCAT('Insumo "', p_tipoInsumo, '" y todas sus relaciones eliminados correctamente. ',
                                     'Se eliminaron: ', 
                                     IF(v_cantProveedores > 0, CONCAT(v_cantProveedores, ' proveedores'), ''),
                                     IF(v_cantProveedores > 0 AND v_cantEstaciones > 0, ' y ', ''),
                                     IF(v_cantEstaciones > 0, CONCAT(v_cantEstaciones, ' estaciones'), ''),
                                     '.');
            ELSE
                -- MODO SEGURO: Informar relaciones y NO eliminar
                SET nResultado = 2;
                SET cMensaje = CONCAT('No se puede eliminar "', p_tipoInsumo, '". Tiene relaciones activas:',
                                     IF(v_cantProveedores > 0, CONCAT(' - ', v_cantProveedores, ' proveedores: ', v_proveedores), ''),
                                     IF(v_cantEstaciones > 0, CONCAT(' - ', v_cantEstaciones, ' estaciones: ', v_estaciones), ''),'. Use p_forzar = 1 para eliminar igualmente.');
            END IF;
        ELSE
            -- No tiene relaciones, eliminar directo
            DELETE FROM insumo
            WHERE idInsumo = v_idInsumo;
            
            SET nResultado = 0;
            SET cMensaje = CONCAT('Insumo "', p_tipoInsumo, '" eliminado correctamente. No tenía relaciones.');
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModificarInsumo(IN p_tipoInsumoActual VARCHAR(100),IN p_tipoInsumoNuevo VARCHAR(100),IN p_unidadMedidaNuevo VARCHAR(45),OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idInsumo INT;
    DECLARE v_insumoExiste INT;
    -- Inicializar variables
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';
    -- Obtener ID del insumo actual
    SELECT idInsumo INTO v_idInsumo FROM insumo WHERE tipoInsumo = p_tipoInsumoActual;
    -- Verificar si el insumo existe
    IF v_idInsumo IS NOT NULL THEN
        -- Verificar si el nuevo nombre ya existe (y no es el mismo insumo)
        SELECT COUNT(*) INTO v_insumoExiste
        FROM insumo WHERE tipoInsumo = p_tipoInsumoNuevo AND UnidadDeMedida = p_unidadMedidaNuevo AND idInsumo != v_idInsumo;
        IF v_insumoExiste = 0 THEN
            -- Actualizar insumo
            UPDATE insumo
            SET tipoInsumo = p_tipoInsumoNuevo,
                UnidadDeMedida = p_unidadMedidaNuevo
            WHERE idInsumo = v_idInsumo;
            -- Las relaciones en InsumoProveedor e InsumoEstacion se mantienen automáticamente
            -- porque usan idInsumo (no el nombre)
            
            SET nResultado = 0;
            SET cMensaje = CONCAT('Insumo "', p_tipoInsumoActual, '" modificado a "', p_tipoInsumoNuevo, '" correctamente. ','Todas las relaciones se mantienen.');
        ELSE
            SET nResultado = 1;
            SET cMensaje = CONCAT('Ya existe un insumo con el nombre "', p_tipoInsumoNuevo, '" y unidad "', p_unidadMedidaNuevo, '".');
        END IF;
    ELSE
        SET nResultado = 2;
        SET cMensaje = CONCAT('El insumo "', p_tipoInsumoActual, '" no existe.');
    END IF;
END//
DELIMITER ;

-- -------------------------------------------------------------------------------
-- InsumoProvedor ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //

CREATE PROCEDURE RelacionarInsumoProveedor(IN p_tipoInsumo VARCHAR(100),IN p_nombreProveedor VARCHAR(45),IN p_precioUnitario FLOAT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_insumoProvedorId INT;
    DECLARE v_idInsumo INT;
    DECLARE v_idProveedor INT;
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';
    -- Obtener ID del insumo por nombre
    SELECT idInsumo INTO v_idInsumo 
    FROM insumo 
    WHERE tipoInsumo = p_tipoInsumo;
    -- Verificar si el insumo existe
    IF v_idInsumo IS NULL THEN
        SET nResultado = 1;
        SET cMensaje = CONCAT('El insumo "', p_tipoInsumo, '" no existe.');
    ELSE
        -- Obtener ID del proveedor por nombre
        SELECT idProveedor INTO v_idProveedor 
        FROM proveedor 
        WHERE nombreProveedor = p_nombreProveedor;
        -- Verificar si el proveedor existe
        IF v_idProveedor IS NULL THEN
            SET nResultado = 2;
            SET cMensaje = CONCAT('El proveedor "', p_nombreProveedor, '" no existe.');
        ELSE
            -- Verificar si ya existe la relación
            IF EXISTS (SELECT 1 FROM insumoproveedor 
                       WHERE Insumo_idInsumo = v_idInsumo 
                       AND Proveedor_idProveedor = v_idProveedor) THEN
                SET nResultado = 3;
                SET cMensaje = CONCAT('El insumo "', p_tipoInsumo, '" ya está relacionado con el proveedor "', p_nombreProveedor, '".');
            ELSE
                -- Obtener el próximo ID para insumoproveedor
                SELECT COALESCE(MAX(InsumoProvedorId), 0) + 1 INTO v_insumoProvedorId 
                FROM insumoproveedor;
                -- Insertar la relación
                INSERT INTO insumoproveedor (InsumoProvedorId, Insumo_idInsumo, Proveedor_idProveedor, PrecioUnitario)
                VALUES (v_insumoProvedorId, v_idInsumo, v_idProveedor, p_precioUnitario);
                SET nResultado = 0;
                SET cMensaje = CONCAT('Relación "', p_tipoInsumo, '" - "', p_nombreProveedor, '" creada con éxito.');
            END IF;
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModificarInsumoProveedor(IN p_tipoInsumo VARCHAR(100),IN p_nombreProveedor VARCHAR(45),IN p_precioUnitario FLOAT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idInsumo INT;
    DECLARE v_idProveedor INT;
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';
    -- Obtener ID del insumo
    SELECT idInsumo INTO v_idInsumo FROM insumo WHERE tipoInsumo = p_tipoInsumo;
    
    IF v_idInsumo IS NULL THEN
        SET nResultado = 1;
        SET cMensaje = CONCAT('El insumo "', p_tipoInsumo, '" no existe.');
    ELSE
        -- Obtener ID del proveedor
        SELECT idProveedor INTO v_idProveedor FROM proveedor WHERE nombreProveedor = p_nombreProveedor;
        
        IF v_idProveedor IS NULL THEN
            SET nResultado = 2;
            SET cMensaje = CONCAT('El proveedor "', p_nombreProveedor, '" no existe.');
        ELSE
            -- Verificar si existe la relación
            IF NOT EXISTS (SELECT 1 FROM insumoproveedor WHERE Insumo_idInsumo = v_idInsumo AND Proveedor_idProveedor = v_idProveedor) THEN
                SET nResultado = 3;
                SET cMensaje = 'La relación no existe.';
            ELSE
                -- Modificar precio
                UPDATE insumoproveedor 
                SET PrecioUnitario = p_precioUnitario 
                WHERE Insumo_idInsumo = v_idInsumo AND Proveedor_idProveedor = v_idProveedor;
                
                SET nResultado = 0;
                SET cMensaje = 'Precio actualizado correctamente.';
            END IF;
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarInsumoProveedor(IN p_tipoInsumo VARCHAR(100),IN p_nombreProveedor VARCHAR(45),OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idInsumo INT;
    DECLARE v_idProveedor INT;
    
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';

    -- Obtener ID del insumo
    SELECT idInsumo INTO v_idInsumo FROM insumo WHERE tipoInsumo = p_tipoInsumo;
    
    IF v_idInsumo IS NULL THEN
        SET nResultado = 1;
        SET cMensaje = CONCAT('El insumo "', p_tipoInsumo, '" no existe.');
    ELSE
        -- Obtener ID del proveedor
        SELECT idProveedor INTO v_idProveedor FROM proveedor WHERE nombreProveedor = p_nombreProveedor;
        
        IF v_idProveedor IS NULL THEN
            SET nResultado = 2;
            SET cMensaje = CONCAT('El proveedor "', p_nombreProveedor, '" no existe.');
        ELSE
            -- Verificar si existe la relación
            IF NOT EXISTS (SELECT 1 FROM insumoproveedor WHERE Insumo_idInsumo = v_idInsumo AND Proveedor_idProveedor = v_idProveedor) THEN
                SET nResultado = 3;
                SET cMensaje = 'La relación no existe.';
            ELSE
                -- Eliminar relación
                DELETE FROM insumoproveedor 
                WHERE Insumo_idInsumo = v_idInsumo AND Proveedor_idProveedor = v_idProveedor;
                
                SET nResultado = 0;
                SET cMensaje = 'Relación eliminada correctamente.';
            END IF;
        END IF;
    END IF;
END//
DELIMITER ;

-- -------------------------------------------------------------------------------
-- InsumoEstacion ABM 
-- -------------------------------------------------------------------------------  
DELIMITER $$

CREATE PROCEDURE `AgregarInsumoAEstacionPorNombre`(IN p_tipoInsumo VARCHAR(45),IN p_actividadEstacion VARCHAR(45),IN p_modeloAuto VARCHAR(45),IN p_Cantidad FLOAT)
BEGIN
    DECLARE v_idInsumo INT;
    DECLARE v_idEstacion INT;

    -- Buscar el id del insumo
    SELECT idInsumo INTO v_idInsumo
    FROM Insumo
    WHERE tipoInsumo = p_tipoInsumo
    LIMIT 1;

    -- Buscar el id de la estación según actividad y modelo
    SELECT e.idEstacion INTO v_idEstacion
    FROM Estacion e
    JOIN LineaMontaje l ON e.LineaMontaje_idLineaMontaje = l.idLineaMontaje
    JOIN ModeloAuto m ON l.ModeloAuto_idModeloAuto = m.idModeloAuto
    WHERE e.actividad = p_actividadEstacion
      AND m.modelo = p_modeloAuto
    LIMIT 1;

    -- Insertar o actualizar la relación
    IF NOT EXISTS (
        SELECT 1
        FROM InsumoEstacion
        WHERE Insumo_idInsumo = v_idInsumo
          AND Estacion_idEstacion = v_idEstacion
    ) THEN
        INSERT INTO InsumoEstacion (Insumo_idInsumo, Estacion_idEstacion, Cantidad)
        VALUES (v_idInsumo, v_idEstacion, p_Cantidad);
    ELSE
        UPDATE InsumoEstacion
        SET Cantidad = p_Cantidad,
            Stock = p_Cantidad
        WHERE Insumo_idInsumo = v_idInsumo
          AND Estacion_idEstacion = v_idEstacion;
    END IF;
END$$

DELIMITER ;


DELIMITER //
CREATE PROCEDURE ModificarInsumoEstacion(IN p_tipoInsumo VARCHAR(100),IN p_modeloAuto VARCHAR(45),IN p_actividadEstacion VARCHAR(45),IN p_cantidad FLOAT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idInsumo INT;
    DECLARE v_idEstacion INT;
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';
    -- Obtener ID del insumo
    SELECT idInsumo INTO v_idInsumo FROM insumo WHERE tipoInsumo = p_tipoInsumo;
    IF v_idInsumo IS NULL THEN
        SET nResultado = 1;
        SET cMensaje = CONCAT('El insumo "', p_tipoInsumo, '" no existe.');
    ELSE
        -- Obtener ID de la estación por modelo y actividad
        SELECT e.idEstacion INTO v_idEstacion 
        FROM estacion e JOIN lineamontaje lm ON e.LineaMontaje_idLineaMontaje = lm.idLineaMontaje JOIN modeloauto m ON lm.ModeloAuto_idModeloAuto = m.idModeloAuto
        WHERE m.modelo = p_modeloAuto AND e.actividad = p_actividadEstacion;
        
        IF v_idEstacion IS NULL THEN
            SET nResultado = 2;
            SET cMensaje = CONCAT('No se encontró la estación "', p_actividadEstacion, '" para el modelo "', p_modeloAuto, '".');
        ELSE
            -- Verificar si existe la relación
            IF NOT EXISTS (SELECT 1 FROM insumoestacion WHERE Insumo_idInsumo = v_idInsumo AND Estacion_idEstacion = v_idEstacion) THEN
                SET nResultado = 3;
                SET cMensaje = 'La relación no existe.';
            ELSE
                -- Modificar cantidad
                UPDATE insumoestacion 
                SET Cantidad = p_cantidad 
                WHERE Insumo_idInsumo = v_idInsumo AND Estacion_idEstacion = v_idEstacion;
                
                SET nResultado = 0;
                SET cMensaje = 'Cantidad actualizada correctamente.';
            END IF;
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarInsumoEstacion(IN p_tipoInsumo VARCHAR(100),IN p_modeloAuto VARCHAR(45),IN p_actividadEstacion VARCHAR(45),OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idInsumo INT;
    DECLARE v_idEstacion INT;
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';
    -- Obtener ID del insumo
    SELECT idInsumo INTO v_idInsumo FROM insumo WHERE tipoInsumo = p_tipoInsumo;
    IF v_idInsumo IS NULL THEN
        SET nResultado = 1;
        SET cMensaje = CONCAT('El insumo "', p_tipoInsumo, '" no existe.');
    ELSE
        -- Obtener ID de la estación por modelo y actividad
        SELECT e.idEstacion INTO v_idEstacion FROM estacion e JOIN lineamontaje lm ON e.LineaMontaje_idLineaMontaje = lm.idLineaMontaje JOIN modeloauto m ON lm.ModeloAuto_idModeloAuto = m.idModeloAuto
        WHERE m.modelo = p_modeloAuto AND e.actividad = p_actividadEstacion;
        
        IF v_idEstacion IS NULL THEN
            SET nResultado = 2;
            SET cMensaje = CONCAT('No se encontró la estación "', p_actividadEstacion, '" para el modelo "', p_modeloAuto, '".');
        ELSE
            -- Verificar si existe la relación
            IF NOT EXISTS (SELECT 1 FROM insumoestacion WHERE Insumo_idInsumo = v_idInsumo AND Estacion_idEstacion = v_idEstacion) THEN
                SET nResultado = 3;
                SET cMensaje = 'La relación no existe.';
            ELSE
                -- Eliminar relación
                DELETE FROM insumoestacion 
                WHERE Insumo_idInsumo = v_idInsumo AND Estacion_idEstacion = v_idEstacion;
                
                SET nResultado = 0;
                SET cMensaje = 'Relación eliminada correctamente.';
            END IF;
        END IF;
    END IF;
END//
DELIMITER ;

-- -------------------------------------------------------------------------------
-- Linea de montaje ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //

CREATE PROCEDURE altaLineaMontaje(IN p_ModeloAuto VARCHAR(100), IN p_capacidadMaximaMes INT, OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    -- Inicializar resultado y mensaje
    SET nResultado = -1;
    SET cMensaje = 'La línea de montaje ya existe para este modelo de auto.';

    -- Verificar si el modelo de auto existe
    IF EXISTS (SELECT 1 FROM ModeloAuto ma WHERE ma.modelo = p_ModeloAuto) THEN

        -- Verificar si ya existe la línea de montaje para ese modelo
        IF NOT EXISTS (SELECT 1 FROM LineaMontaje lm JOIN ModeloAuto ma ON lm.ModeloAuto_idModeloAuto = ma.idModeloAuto WHERE ma.modelo = p_ModeloAuto) THEN
			INSERT INTO LineaMontaje (ModeloAuto_idModeloAuto, capacidadMaximaMes) VALUES ((SELECT ma.idModeloAuto FROM ModeloAuto ma WHERE ma.modelo = p_ModeloAuto), p_capacidadMaximaMes);
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

DELIMITER ;

DELIMITER //
CREATE PROCEDURE modificacionModelo(IN p_ModeloPorModificar VARCHAR(100),IN p_ModeloModificado VARCHAR(100), OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'No se encontró el modelo con ese ID.';
    
    -- Verificar si el modelo existe
    IF EXISTS (SELECT 1 FROM ModeloAuto WHERE Modelo = p_ModeloPorModificar) THEN
        UPDATE ModeloAuto
        SET modelo = p_ModeloModificado
        WHERE Modelo = p_ModeloPorModificar;
        
        SET nResultado = 0;
        SET cMensaje = 'Modelo modificado con éxito.';
    END IF;
END//

DELIMITER ;

-- -------------------------------------------------------------------------------
-- PedidioConcesionaria ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //
CREATE PROCEDURE AltaPedidoConcesionaria(IN p_nombreConsecionaria varchar(40),OUT nResultado INT,OUT cMensaje VARCHAR(256), out idNuevoPedido  int)
BEGIN
	DECLARE v_idConcesionaria int ;
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';
	set idNuevoPedido= -1;
      -- Obtener ID de la concesionaria
    SELECT idConcesionaria 
    INTO v_idConcesionaria
    FROM Concesionaria 
    WHERE nombreConcesionaria = p_nombreConsecionaria;
    IF v_idConcesionaria IS NOT NULL THEN
        -- Insertar pedido
        INSERT INTO PedidoConcesionaria (Concesionaria_idConcesionaria)
        VALUES (v_idConcesionaria);
        -- Devolver el ID del nuevo pedido
        SET idNuevoPedido = LAST_INSERT_ID();
        SET nResultado = 0;
        SET cMensaje = 'Pedido de concesionaria insertado correctamente.';
    ELSE
        SET cMensaje = 'No existe la concesionaria especificada.';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AgregarModeloPedido(IN p_idPedido INT,IN p_nombreModeloAuto VARCHAR(100),IN p_cantidad INT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idModeloAuto INT;

    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';

    -- Obtener ID del modelo
    SELECT idModeloAuto 
    INTO v_idModeloAuto
    FROM ModeloAuto
    WHERE modelo = p_nombreModeloAuto;

    -- Validar que el modelo exista
    IF v_idModeloAuto IS NULL THEN
        SET cMensaje = 'El modelo de auto especificado no existe.';
    ELSE
        -- Verificar que el pedido exista y esté abierto (FechaDeEntregaEstimada IS NULL)
        IF EXISTS (SELECT 1 
                   FROM PedidoConcesionaria 
                   WHERE idPedidoConcesionaria = p_idPedido 
                     AND FechaDeEntregaEstimada IS NULL) THEN

            -- Si el modelo ya está en el pedido, sumar la cantidad
            IF EXISTS (SELECT 1 
                       FROM ModeloAuto_has_PedidoConcesionaria 
                       WHERE PedidoConcesionaria_idPedidoConcesionaria = p_idPedido
                         AND ModeloAuto_idModeloAuto = v_idModeloAuto) THEN

                UPDATE ModeloAuto_has_PedidoConcesionaria
                SET Cantidad = Cantidad + p_cantidad
                WHERE PedidoConcesionaria_idPedidoConcesionaria = p_idPedido
                  AND ModeloAuto_idModeloAuto = v_idModeloAuto;

                SET nResultado = 0;
                SET cMensaje = 'Cantidad agregada al modelo existente en el pedido.';

            ELSE
                -- Insertar nuevo modelo en el pedido
                INSERT INTO ModeloAuto_has_PedidoConcesionaria
                    (PedidoConcesionaria_idPedidoConcesionaria, ModeloAuto_idModeloAuto, Cantidad)
                VALUES
                    (p_idPedido, v_idModeloAuto, p_cantidad);

                SET nResultado = 0;
                SET cMensaje = 'Modelo agregado al pedido correctamente.';
            END IF;

        ELSE
            SET cMensaje = 'El pedido no existe o ya está cerrado.';
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarModeloPedido(IN p_idPedido INT,IN p_nombreModeloAuto VARCHAR(100),IN p_cantidad INT,IN p_todo BOOLEAN,OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idModeloAuto INT;
    DECLARE v_cantidadActual INT;

    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';

    -- Validar cantidad primero
    IF p_cantidad <= 0 AND p_todo = FALSE THEN
        SET cMensaje = 'Cantidad incorrecta.';
    ELSE
        -- Obtener ID del modelo
        SELECT idModeloAuto INTO v_idModeloAuto
        FROM ModeloAuto
        WHERE modelo = p_nombreModeloAuto;

        IF v_idModeloAuto IS NULL THEN
            SET cMensaje = 'El modelo de auto especificado no existe.';
        ELSE
            -- Verificar que el pedido exista y no esté cerrado
            IF EXISTS (SELECT 1 FROM PedidoConcesionaria 
                       WHERE idPedidoConcesionaria = p_idPedido 
                         AND FechaDeEntregaEstimada IS NULL) THEN

                -- Obtener cantidad actual del modelo en el pedido
                SELECT Cantidad INTO v_cantidadActual
                FROM ModeloAuto_has_PedidoConcesionaria
                WHERE PedidoConcesionaria_idPedidoConcesionaria = p_idPedido
                  AND ModeloAuto_idModeloAuto = v_idModeloAuto;

                IF v_cantidadActual IS NULL THEN
                    SET cMensaje = 'El modelo no está en el pedido.';
                ELSE
                    -- Si quiere borrar todo o la cantidad exacta
                    IF p_todo = TRUE OR p_cantidad = v_cantidadActual THEN
                        DELETE FROM ModeloAuto_has_PedidoConcesionaria
                        WHERE PedidoConcesionaria_idPedidoConcesionaria = p_idPedido
                          AND ModeloAuto_idModeloAuto = v_idModeloAuto;
                        SET nResultado = 0;
                        SET cMensaje = 'Modelo eliminado completamente del pedido.';
                    ELSEIF p_cantidad > v_cantidadActual THEN
                        SET cMensaje = 'Cantidad incorrecta.';
                    ELSE
                        -- Reducir la cantidad
                        UPDATE ModeloAuto_has_PedidoConcesionaria
                        SET Cantidad = Cantidad - p_cantidad
                        WHERE PedidoConcesionaria_idPedidoConcesionaria = p_idPedido
                          AND ModeloAuto_idModeloAuto = v_idModeloAuto;
                        SET nResultado = 0;
                        SET cMensaje = CONCAT('Se eliminaron ', p_cantidad, ' unidades del modelo del pedido.');
                    END IF;
                END IF;

            ELSE
                SET cMensaje = 'El pedido no existe o ya está cerrado.';
            END IF;
        END IF;
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CerrarPedido(IN p_idPedido INT, OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';

    -- Verificar que el pedido exista y no esté cerrado
    IF NOT EXISTS (
        SELECT 1
        FROM PedidoConcesionaria
        WHERE idPedidoConcesionaria = p_idPedido
          AND FechaCierrePedido IS NULL
    ) THEN
        SET cMensaje = 'El pedido no existe o ya está cerrado.';
    ELSE
        -- 1. PRIMERO calcular la fecha (con vehículos pendientes)
  
 
        -- 2. LUEGO cerrar pedido (activará el trigger que genera vehículos)
        UPDATE PedidoConcesionaria
        SET FechaCierrePedido = CURDATE()
        WHERE idPedidoConcesionaria = p_idPedido;
		
        SET nResultado = 0;
        SET cMensaje = 'Pedido cerrado correctamente. Los vehículos se generarán automáticamente.';
    END IF;
END//
DELIMITER 

-- =====================================================
-- INFORME: PROCEDIMIENTO CalcularFechaEntregaPedido
-- =====================================================
-- PROPÓSITO:
--   Calcular la fecha estimada de entrega para un pedido específico,
--   considerando la carga actual de TODA la planta (no solo el pedido)
--   y el progreso de vehículos en producción.

-- ESTRATEGIA GLOBAL:
--   Analiza TODOS los vehículos pendientes y en producción del MISMO MODELO
--   que el pedido, independientemente de a qué pedido pertenezcan.

-- MECANISMO POR MODELO:
--   1. IDENTIFICAR modelos en el pedido
--   2. POR CADA modelo:
--      a. Contar TODOS los vehículos PENDIENTES de ese modelo en la planta
--      b. Calcular tiempo base: capacidad mensual de la línea
--      c. Analizar TODOS los vehículos EN PRODUCCIÓN de ese modelo
--      d. Calcular tiempo restante basado en estación actual
--   3. Determinar el modelo con mayor tiempo requerido (cuello de botella)
--   4. Establecer fecha basada en el tiempo máximo

-- FÓRMULAS CLAVE:
--   TiempoPorAuto = 30 días / CapacidadMaximaMes (autos por mes)
--   TiempoPendientes = VehículosPendientes × TiempoPorAuto
--   ProgresoRestante = (TotalEstaciones - EstaciónActual + 1) / TotalEstaciones
--   TiempoProducción = TiempoPorAuto × ProgresoRestante (por cada vehículo en producción)

-- ENTRADA: ID del pedido (p_idPedido)
-- SALIDA: Actualiza FechaDeEntregaEstimada en PedidoConcesionaria
-- IMPACTO: Fecha basada en situación REAL de la planta
-- ESTADO:  FUNCIONAL - Modelo de carga global implementado
-- =====================================================

DELIMITER //
CREATE PROCEDURE CalcularFechaEntregaPedido(IN p_idPedido INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE done_inner INT DEFAULT 0;
    DECLARE v_idModelo INT;
    DECLARE v_idVehiculo INT;
    DECLARE v_idEstacion INT;
    DECLARE v_orden_estacion INT;
    DECLARE v_total_estaciones INT;
    
    -- Cursor para modelos del pedido (pero considerar TODOS los vehículos de esas líneas)
    DECLARE curModelos CURSOR FOR
        SELECT DISTINCT ModeloAuto_idModeloAuto
        FROM ModeloAuto_has_PedidoConcesionaria
        WHERE PedidoConcesionaria_idPedidoConcesionaria = p_idPedido;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    SET @tiempo_maximo = 0;
    
    OPEN curModelos;
    
    read_loop: LOOP
        FETCH curModelos INTO v_idModelo;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        --  Vehículos pendientes de TODOS los pedidos de este modelo
        SELECT COUNT(*) INTO @pendientes_modelo
        FROM Vehiculo v
        WHERE v.fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto = v_idModelo
          AND v.estado = 'Pendiente';  -- ← QUITAMOS filtro de pedido específico
        
        -- Capacidad y estaciones (igual)
        SELECT CapacidadMaximaMes INTO @capacidad
        FROM LineaMontaje WHERE ModeloAuto_idModeloAuto = v_idModelo;
        
        SELECT COUNT(*) INTO v_total_estaciones
        FROM Estacion e
        INNER JOIN LineaMontaje lm ON e.LineaMontaje_idLineaMontaje = lm.idLineaMontaje
        WHERE lm.ModeloAuto_idModeloAuto = v_idModelo;
        
        SET @tiempo_por_auto = 30 / @capacidad;
        SET @tiempo_modelo = @pendientes_modelo * @tiempo_por_auto;
        
        --  CORREGIDO: Vehículos en producción de TODOS los pedidos
        BEGIN
            DECLARE curProduccion CURSOR FOR
                SELECT v.idVehiculo, re.Estacion_idEstacion
                FROM Vehiculo v
                LEFT JOIN RegistroEstacion re ON v.idVehiculo = re.Vehiculo_idVehiculo AND re.FechaFin IS NULL
                WHERE v.fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto = v_idModelo
                  AND v.estado = 'Produccion';  -- ← QUITAMOS filtro de pedido específico
            
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_inner = 1;
            
            SET @tiempo_produccion = 0;
            SET done_inner = 0;
            
            OPEN curProduccion;
            produccion_loop: LOOP
                FETCH curProduccion INTO v_idVehiculo, v_idEstacion;
                IF done_inner THEN
                    LEAVE produccion_loop;
                END IF;
                
                SELECT orden INTO v_orden_estacion FROM Estacion WHERE idEstacion = v_idEstacion;
                SET @progreso_restante = (v_total_estaciones - v_orden_estacion + 1) / v_total_estaciones;
                SET @tiempo_produccion = @tiempo_produccion + (@tiempo_por_auto * @progreso_restante);
                
            END LOOP;
            CLOSE curProduccion;
        END;
        
        SET @tiempo_modelo = @tiempo_modelo + @tiempo_produccion;
        
        IF @tiempo_modelo > @tiempo_maximo THEN
            SET @tiempo_maximo = @tiempo_modelo;
        END IF;
        
    END LOOP;
    
    CLOSE curModelos;
    
    UPDATE PedidoConcesionaria
    SET FechaDeEntregaEstimada = DATE_ADD(CURDATE(), INTERVAL CEIL(@tiempo_maximo) DAY)
    WHERE idPedidoConcesionaria = p_idPedido;
    
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
-- Registro estacion ABM 
-- -------------------------------------------------------------------------------  



-- -------------------------------------------------------------------------------
-- Vehicluo ABM 
-- -------------------------------------------------------------------------------  


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

DELIMITER ;

DELIMITER //
CREATE PROCEDURE modificacionVehiculo(IN p_numeroChasisPorModificar INT,IN p_numeroChasisModificado INT, OUT nResultado INT, OUT cMensaje VARCHAR(256))
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

-- -------------------------------------------------------------------------------
-- Iniciar montaje
-- -------------------------------------------------------------------------------  

DELIMITER $$

CREATE PROCEDURE iniciarMontaje(IN p_NumeroDeChasis INT, OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idVehiculo INT;
    DECLARE v_idModelo INT;
    DECLARE v_idLinea INT;
    DECLARE v_idEstacion INT;
    DECLARE v_idVehiculoOcupante INT;
    DECLARE v_chasisOcupante INT;
    DECLARE nResultado INT DEFAULT 0;
    DECLARE cMensaje VARCHAR(200) DEFAULT '';

    -- 1️ Obtener vehículo y su modelo
    SELECT idVehiculo, fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto
    INTO v_idVehiculo, v_idModelo
    FROM Vehiculo
    WHERE idVehiculo = p_NumeroDeChasis;

    -- 2️ Obtener línea de montaje correspondiente
    SELECT idLineaMontaje
    INTO v_idLinea
    FROM LineaMontaje
    WHERE ModeloAuto_idModeloAuto = v_idModelo;

    -- 3️ Obtener la primera estación de esa línea
    SELECT idEstacion
    INTO v_idEstacion
    FROM Estacion
    WHERE LineaMontaje_idLineaMontaje = v_idLinea
    ORDER BY idEstacion
    LIMIT 1;

    -- 4️ Verificar si está ocupada (registro sin FechaFin)
    SELECT Vehiculo_idVehiculo
    INTO v_idVehiculoOcupante
    FROM RegistroEstacion
    WHERE Estacion_idEstacion = v_idEstacion
      AND FechaFin IS NULL
    LIMIT 1;

    IF v_idVehiculoOcupante IS NOT NULL THEN
        -- Estación ocupada
        SELECT idVehiculo
        INTO v_chasisOcupante
        FROM Vehiculo
        WHERE idVehiculo = v_idVehiculoOcupante;

        SET nResultado = -1;
        SET cMensaje = CONCAT('La primera estación está ocupada por el vehículo con chasis ', v_chasisOcupante);
    ELSE
        -- Insertar registro del vehículo en la estación
        INSERT INTO RegistroEstacion (Vehiculo_idVehiculo, FechaInicio, Estacion_idEstacion)
        VALUES (v_idVehiculo, NOW(), v_idEstacion);

        UPDATE Vehiculo
        SET estado = 'Produccion'
        WHERE idVehiculo = v_idVehiculo;
		
        UPDATE InsumoEstacion
        SET Stock = Stock - Cantidad
        WHERE Estacion_idEstacion = v_idEstacion
          AND Stock >= Cantidad;
		
        CALL AltaPedidoInsumoDetalle(@nResultado,@cMensaje);
        SET nResultado = 0;
        SET cMensaje = 'Inicio la linea';
    END IF;

    -- Devolver resultado
    SELECT nResultado, cMensaje;
END $$

DELIMITER ;


-- -------------------------------------------------------------------------------
-- Avanzar montaje
-- -------------------------------------------------------------------------------  
DELIMITER $$

CREATE PROCEDURE avanzarMontaje(IN p_NumeroDeChasis INT, OUT nResultado INT, OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idVehiculo INT;
    DECLARE v_idEstacionActual INT;
    DECLARE v_idLinea INT;
    DECLARE v_idEstacionSiguiente INT;
    DECLARE v_idVehiculoOcupante INT;
    DECLARE v_chasisOcupante INT;
    DECLARE v_estadoVehiculo VARCHAR(20);

    -- 1️ Obtener vehículo
    SELECT idVehiculo, fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto, estado
    INTO v_idVehiculo, v_idLinea, v_estadoVehiculo
    FROM Vehiculo
    WHERE idVehiculo = p_NumeroDeChasis;

    -- 2️ Obtener estación actual del vehículo
    SELECT Estacion_idEstacion
    INTO v_idEstacionActual
    FROM RegistroEstacion
    WHERE Vehiculo_idVehiculo = v_idVehiculo
      AND FechaFin IS NULL;

    -- 3️ Obtener la siguiente estación de la línea
    SELECT idEstacion
    INTO v_idEstacionSiguiente
    FROM Estacion
    WHERE LineaMontaje_idLineaMontaje = (
        SELECT idLineaMontaje
        FROM LineaMontaje
        WHERE ModeloAuto_idModeloAuto = v_idLinea
    )
    AND idEstacion > v_idEstacionActual
    ORDER BY idEstacion
    LIMIT 1;
    
    IF v_estadoVehiculo != 'Produccion' THEN
        SET nResultado = -1;
        SET cMensaje = 'El vehículo no está en estado de produccion para avanzar';
    ELSE
        IF v_idEstacionSiguiente IS NULL THEN
            -- Última estación → finalizar vehículo
            UPDATE RegistroEstacion
            SET FechaFin = NOW()
            WHERE Vehiculo_idVehiculo = v_idVehiculo
              AND FechaFin IS NULL;

            UPDATE Vehiculo
            SET estado = 'Finalizado'
            WHERE idVehiculo = v_idVehiculo;
            
            UPDATE InsumoEstacion
            SET Stock = Stock - Cantidad
            WHERE Estacion_idEstacion = v_idEstacionActual
              AND Stock >= Cantidad;
            
            CALL AltaPedidoInsumoDetalle(@nResultado,@cMensaje);
            SET nResultado = 0;
            SET cMensaje = 'Ultima estacion finalizo la linea';
        ELSE
            -- Verificar si la estación siguiente está ocupada
            SELECT Vehiculo_idVehiculo
            INTO v_idVehiculoOcupante
            FROM RegistroEstacion
            WHERE Estacion_idEstacion = v_idEstacionSiguiente
              AND FechaFin IS NULL
            LIMIT 1;

            IF v_idVehiculoOcupante IS NOT NULL THEN
                SELECT idVehiculo
                INTO v_chasisOcupante
                FROM Vehiculo
                WHERE idVehiculo = v_idVehiculoOcupante;

                SET nResultado = -1;
                SET cMensaje = CONCAT('La siguiente estación está ocupada por el vehículo con chasis ', v_chasisOcupante);
            ELSE
                -- Finalizar registro actual
                UPDATE RegistroEstacion
                SET FechaFin = NOW()
                WHERE Vehiculo_idVehiculo = v_idVehiculo
                  AND FechaFin IS NULL;

                -- Insertar en la siguiente estación
                INSERT INTO RegistroEstacion (Vehiculo_idVehiculo, FechaInicio, Estacion_idEstacion)
                VALUES (v_idVehiculo, NOW(), v_idEstacionSiguiente);
                
                UPDATE InsumoEstacion
                SET Stock = Stock - Cantidad
                WHERE Estacion_idEstacion = v_idEstacionActual
                  AND Stock >= Cantidad;
                
                CALL AltaPedidoInsumoDetalle(@nResultado,@cMensaje);
                SET nResultado = 0;
                SET cMensaje = 'Termino la estacion';
            END IF;
        END IF;
    END IF;

    SELECT nResultado, cMensaje;
END $$

DELIMITER ;


-- -------------------------------------------------------------------------------
-- PedidoInsumoDetalle ABM 
-- -------------------------------------------------------------------------------  
DELIMITER //

CREATE PROCEDURE AltaPedidoInsumoDetalle(
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    -- 1️⃣ Declaración de variables
    DECLARE done INT DEFAULT 0;
    DECLARE v_idInsumo INT;
    DECLARE v_idProveedor INT;
    DECLARE v_idInsumoProveedor INT;
    DECLARE v_cantidadNecesaria DECIMAL(10,2);
    DECLARE v_stockTotal INT;
    DECLARE v_ultimaFechaPedido DATE;

    -- 2️Declaración del cursor
    DECLARE cur_insumos CURSOR FOR
        SELECT DISTINCT IE.Insumo_idInsumo
        FROM InsumoEstacion IE;

    -- 3️Handler de fin de cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- 4️Inicializar resultados
    SET p_nResultado = 0;
    SET p_cMensaje = '';

    -- 5️Abrir cursor y loop
    OPEN cur_insumos;

    read_loop: LOOP
        FETCH cur_insumos INTO v_idInsumo;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Verificar que el insumo exista
        IF v_idInsumo IS NULL THEN
            SET p_nResultado = -1;
            SET p_cMensaje = CONCAT('Insumo no encontrado.');
            ITERATE read_loop;
        END IF;

        -- 1️Calcular stock total de ese insumo
        SELECT COALESCE(SUM(Stock),0) INTO v_stockTotal
        FROM InsumoEstacion
        WHERE Insumo_idInsumo = v_idInsumo;

        -- 2️Calcular cantidad necesaria total según capacidad y consumo
        SELECT COALESCE(SUM(IE.Cantidad * (LM.CapacidadMaximaMes / 4)/3),0)
        INTO v_cantidadNecesaria
        FROM InsumoEstacion IE
        JOIN Estacion E ON E.idEstacion = IE.Estacion_idEstacion
        JOIN LineaMontaje LM ON LM.idLineaMontaje = E.LineaMontaje_idLineaMontaje
        WHERE IE.Insumo_idInsumo = v_idInsumo;

        -- 3️Solo si el stock es menor a lo necesario
        IF v_stockTotal < v_cantidadNecesaria THEN

            -- 3Elegir un proveedor (ej: el de menor precio)
            SELECT Proveedor_idProveedor, InsumoProvedorId
            INTO v_idProveedor, v_idInsumoProveedor
            FROM InsumoProveedor
            WHERE Insumo_idInsumo = v_idInsumo
            ORDER BY PrecioUnitario ASC
            LIMIT 1;

            IF v_idProveedor IS NULL OR v_idInsumoProveedor IS NULL THEN
                SET p_nResultado = -2;
                SET p_cMensaje = CONCAT('No hay proveedor asignado para el insumo ID ', v_idInsumo);
                ITERATE read_loop;
            END IF;

            -- 3 Revisar último pedido para este insumo-proveedor
            SELECT MAX(FechaPedido) INTO v_ultimaFechaPedido
            FROM PedidoInsumoDetalle
            WHERE InsumoProveedor_InsumoProvedorId = v_idInsumoProveedor;

            -- 3 Generar pedido solo si hace más de 7 días o nunca se pidió
            IF v_ultimaFechaPedido IS NULL OR DATEDIFF(CURDATE(), v_ultimaFechaPedido) >= 7 THEN
                INSERT INTO PedidoInsumoDetalle (InsumoProveedor_InsumoProvedorId, Cantidad, FechaPedido)
                VALUES (v_idInsumoProveedor, v_cantidadNecesaria - v_stockTotal, CURDATE());

                SET p_nResultado = 1;
                SET p_cMensaje = CONCAT('Pedido automático generado para insumo ID ', v_idInsumo,
                                        ', cantidad: ', ROUND(v_cantidadNecesaria - v_stockTotal,2));
            ELSE
                SET p_nResultado = 0;
                SET p_cMensaje = CONCAT('Ya existe un pedido reciente para insumo ID ', v_idInsumo,
                                        ', último pedido: ', v_ultimaFechaPedido);
            END IF;

        ELSE
            -- Stock suficiente, no se necesita pedido
            SET p_nResultado = 0;
            SET p_cMensaje = CONCAT('Stock suficiente para insumo ID ', v_idInsumo,
                                    ', cantidad en stock: ', v_stockTotal);
        END IF;

    END LOOP;

    CLOSE cur_insumos;
END//

DELIMITER ;


-- ===============================================================================
								
-- ===============================================================================