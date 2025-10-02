-- -------------------------------------------------------------------------------
						-- Stored procedures Altas
-- -------------------------------------------------------------------------------
-- describe concesionaria;
-- Procedimiento para insertar concesionaria
-- drop procedure  altaConcesionaria;
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
END
//DELIMITER 

-- Borrar el procedimiento si ya existe
-- DROP PROCEDURE IF EXISTS AgregarInsumo;

-- Procedimiento para insertar Insumo
DELIMITER //
CREATE PROCEDURE AgregarInsumo(IN p_tipoInsumo VARCHAR(100),IN p_unidadMedida VARCHAR(45),OUT nResultado INT,OUT cMensaje VARCHAR(256))
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = -1;
    SET cMensaje = 'El insumo ya existe.';
    -- Verificar si el insumo ya existe por tipo y unidad
    IF NOT EXISTS (SELECT * FROM insumo WHERE tipoInsumo = p_tipoInsumo AND UnidadDeMedida = p_unidadMedida) THEN
        -- Insertar nuevo insumo (id se auto-genera)
        INSERT INTO insumo (tipoInsumo, UnidadDeMedida) VALUES (p_tipoInsumo, p_unidadMedida);
        SET nResultado = 0;
        SET cMensaje = 'Insumo insertado con éxito.';
    END IF;
END//
DELIMITER ;


