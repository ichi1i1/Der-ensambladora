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
CREATE PROCEDURE altaEstacion(IN p_actividad VARCHAR(256),IN p_nombreModeloAuto VARCHAR(100),OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    DECLARE v_idLineaMontaje INT;
    DECLARE v_idModeloAuto INT;
    -- Inicializar el resultado y mensaje
    SET nResultado = -1;
    SET cMensaje = 'Error desconocido.';
    -- Verificar si la estación ya existe
    IF EXISTS (SELECT 1 FROM Estacion WHERE actividad = p_actividad) THEN
        SET cMensaje = 'La estación ya existe con esa actividad.';
    ELSE
        -- Verificar si el modelo de auto existe
        IF NOT EXISTS (SELECT 1 FROM ModeloAuto WHERE modelo = p_nombreModeloAuto) THEN
            SET cMensaje = 'El modelo de auto especificado no existe.';
        ELSE
            -- Obtener el ID del modelo de auto
            SELECT idModeloAuto INTO v_idModeloAuto 
            FROM ModeloAuto 
            WHERE modelo = p_nombreModeloAuto;
            -- Verificar si existe línea de montaje para ese modelo
            IF NOT EXISTS (SELECT 1 FROM LineaMontaje WHERE ModeloAuto_idModeloAuto = v_idModeloAuto) THEN
                SET cMensaje = 'No existe línea de montaje para el modelo de auto especificado.';
            ELSE
                -- Obtener el ID de la línea de montaje
                SELECT idLineaMontaje INTO v_idLineaMontaje 
                FROM LineaMontaje 
                WHERE ModeloAuto_idModeloAuto = v_idModeloAuto;
                -- Insertar la estación
                INSERT INTO Estacion (actividad, LineaMontaje_idLineaMontaje) 
                VALUES (p_actividad, v_idLineaMontaje);
                
                SET nResultado = 0;
                SET cMensaje = 'Estación insertada con éxito.';
            END IF;
        END IF;
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
CREATE PROCEDURE modificacionEstacion(IN p_idEstacion INT, IN p_actividad VARCHAR(256), OUT nResultado INT, OUT cMensaje VARCHAR(256))
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
DELIMITER //
CREATE PROCEDURE RelacionarInsumoEstacion(IN p_tipoInsumo VARCHAR(100),IN p_modeloAuto VARCHAR(45),IN p_actividadEstacion VARCHAR(45),IN p_cantidad FLOAT,OUT nResultado INT,OUT cMensaje VARCHAR(256))
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
        SELECT e.idEstacion INTO v_idEstacion FROM estacion e JOIN lineamontaje lm ON e.LineaMontaje_idLineaMontaje = lm.idLineaMontaje 
        JOIN modeloauto m ON lm.ModeloAuto_idModeloAuto = m.idModeloAuto WHERE m.modelo = p_modeloAuto AND e.actividad = p_actividadEstacion;
        IF v_idEstacion IS NULL THEN
            SET nResultado = 2;
            SET cMensaje = CONCAT('No se encontró la estación "', p_actividadEstacion, '" para el modelo "', p_modeloAuto, '".');
        ELSE
            -- Verificar si ya existe la relación
            IF EXISTS (SELECT 1 FROM insumoestacion WHERE Insumo_idInsumo = v_idInsumo AND Estacion_idEstacion = v_idEstacion) THEN
                SET nResultado = 3;
                SET cMensaje = 'La relación ya existe.';
            ELSE
                -- Crear relación
                INSERT INTO insumoestacion (Insumo_idInsumo, Estacion_idEstacion, Cantidad)
                VALUES (v_idInsumo, v_idEstacion, p_cantidad);
                
                SET nResultado = 0;
                SET cMensaje = 'Relación insumo-estación creada correctamente.';
            END IF;
        END IF;
    END IF;
END//
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