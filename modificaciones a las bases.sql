-- -------------------------------------------------------------------------------
-- Modificaciones a la base --
-- -------------------------------------------------------------------------------
-- hacer concesionario con id autogenerable
-- 1. Primero eliminar la restricción de clave foránea
ALTER TABLE PedidoConcesionaria DROP FOREIGN KEY fk_PedidoConcesionaria_Concesionaria1;

-- 2. Ahora modificar la columna para que sea AUTO_INCREMENT
ALTER TABLE Concesionaria MODIFY idConcesionaria INT AUTO_INCREMENT;

-- 3. Volver a agregar la restricción de clave foránea
ALTER TABLE PedidoConcesionaria 
ADD CONSTRAINT fk_PedidoConcesionaria_Concesionaria1
FOREIGN KEY (Concesionaria_idConcesionaria) 
REFERENCES Concesionaria(idConcesionaria)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

-- hacer proveedor con id autogenerable
-- 1. Primero eliminar las restricciones de clave foránea que referencian a Proveedor
ALTER TABLE InsumoProveedor DROP FOREIGN KEY fk_Insumo_has_Proveedor_Proveedor1;
ALTER TABLE ProveedorAutoParte DROP FOREIGN KEY fk_Proveedor_has_AutoParte_Proveedor1;

-- 2. Ahora modificar la columna para que sea AUTO_INCREMENT
ALTER TABLE Proveedor MODIFY idProveedor INT AUTO_INCREMENT;

-- 3. Volver a agregar las restricciones de clave foránea
ALTER TABLE InsumoProveedor 
ADD CONSTRAINT fk_Insumo_has_Proveedor_Proveedor1
FOREIGN KEY (Proveedor_idProveedor) 
REFERENCES Proveedor(idProveedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE ProveedorAutoParte 
ADD CONSTRAINT fk_Proveedor_has_AutoParte_Proveedor1
FOREIGN KEY (Proveedor_idProveedor) 
REFERENCES Proveedor(idProveedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
-- describe Proveedor;

-- -------------------------------------------------------------------------------
-- Hacer insumo con id autogenerable
-- -------------------------------------------------------------------------------

-- 1. Primero eliminar las restricciones de clave foránea que referencian a Insumo
ALTER TABLE InsumoEstacion DROP FOREIGN KEY fk_Insumo_has_Estacion_Insumo1;
ALTER TABLE InsumoProveedor DROP FOREIGN KEY fk_Insumo_has_Proveedor_Insumo1;

-- 2. Ahora modificar la columna para que sea AUTO_INCREMENT
ALTER TABLE Insumo MODIFY idInsumo INT AUTO_INCREMENT;

-- 3. Volver a agregar las restricciones de clave foránea
ALTER TABLE InsumoEstacion 
ADD CONSTRAINT fk_Insumo_has_Estacion_Insumo1
FOREIGN KEY (Insumo_idInsumo) 
REFERENCES Insumo(idInsumo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE InsumoProveedor 
ADD CONSTRAINT fk_Insumo_has_Proveedor_Insumo1
FOREIGN KEY (Insumo_idInsumo) 
REFERENCES Insumo(idInsumo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

-- -------------------------------------------------------------------------------
-- Eliminar completamente las tablas de AutoParte
-- -------------------------------------------------------------------------------
-- 1. Primero eliminar tablas que referencian a ProveedorAutoParte
DROP TABLE IF EXISTS PedidoAutoParteDetalle;
-- 2. Luego eliminar tablas que referencian a AutoParte
DROP TABLE IF EXISTS ProveedorAutoParte;
DROP TABLE IF EXISTS Estacion_has_AutoParte;
-- 3. Finalmente eliminar la tabla principal
DROP TABLE IF EXISTS AutoParte; 

-- ===============================================================================
-- AGREGAR ESTO AL FINAL - LO QUE FALTABA DEL SEGUNDO SCRIPT
-- ===============================================================================

-- LINEA DE MONTAJE --
ALTER TABLE PlantaAutomotrizEnsambladora.LineaMontajeEstacion
DROP FOREIGN KEY fk_LineaMontaje_has_Estacion_LineaMontaje1;

ALTER TABLE PlantaAutomotrizEnsambladora.LineaMontaje
DROP PRIMARY KEY,
MODIFY COLUMN idLineaMontaje INT NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (idLineaMontaje);

ALTER TABLE PlantaAutomotrizEnsambladora.LineaMontajeEstacion
ADD CONSTRAINT fk_LineaMontaje_has_Estacion_LineaMontaje1
FOREIGN KEY (LineaMontaje_idLineaMontaje)
REFERENCES PlantaAutomotrizEnsambladora.LineaMontaje(idLineaMontaje)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

-- MODELO --
ALTER TABLE PlantaAutomotrizEnsambladora.LineaMontaje
DROP FOREIGN KEY fk_LineaMontaje_ModeloAuto;

ALTER TABLE PlantaAutomotrizEnsambladora.Vehiculo
DROP FOREIGN KEY fk_Vehiculo_ModeloAuto1;

ALTER TABLE PlantaAutomotrizEnsambladora.ModeloAuto_has_PedidoConcesionaria
DROP FOREIGN KEY fk_ModeloAuto_has_PedidoConcesionaria_ModeloAuto1;

ALTER TABLE PlantaAutomotrizEnsambladora.ModeloAuto
MODIFY COLUMN idModeloAuto INT NOT NULL AUTO_INCREMENT;

ALTER TABLE PlantaAutomotrizEnsambladora.LineaMontaje
ADD CONSTRAINT fk_LineaMontaje_ModeloAuto
FOREIGN KEY (ModeloAuto_idModeloAuto)
REFERENCES PlantaAutomotrizEnsambladora.ModeloAuto(idModeloAuto)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE PlantaAutomotrizEnsambladora.Vehiculo
ADD CONSTRAINT fk_Vehiculo_ModeloAuto1
FOREIGN KEY (ModeloAuto_idModeloAuto)
REFERENCES PlantaAutomotrizEnsambladora.ModeloAuto(idModeloAuto)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE PlantaAutomotrizEnsambladora.ModeloAuto_has_PedidoConcesionaria
ADD CONSTRAINT fk_ModeloAuto_has_PedidoConcesionaria_ModeloAuto1
FOREIGN KEY (ModeloAuto_idModeloAuto)
REFERENCES PlantaAutomotrizEnsambladora.ModeloAuto(idModeloAuto)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

-- VEHICULO --
ALTER TABLE PlantaAutomotrizEnsambladora.RegistroEstacion
DROP FOREIGN KEY fk_RegistroEstacion_Vehiculo1;

ALTER TABLE PlantaAutomotrizEnsambladora.Vehiculo
MODIFY COLUMN idVehiculo INT NOT NULL AUTO_INCREMENT;

ALTER TABLE PlantaAutomotrizEnsambladora.RegistroEstacion
ADD CONSTRAINT fk_RegistroEstacion_Vehiculo1
FOREIGN KEY (Vehiculo_idVehiculo)
REFERENCES PlantaAutomotrizEnsambladora.Vehiculo(idVehiculo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

-- ESTACION --
-- Primero eliminar TODAS las foreign keys que apunten a Estacion
ALTER TABLE PlantaAutomotrizEnsambladora.LineaMontajeEstacion
DROP FOREIGN KEY fk_LineaMontaje_has_Estacion_Estacion1;

ALTER TABLE PlantaAutomotrizEnsambladora.InsumoEstacion
DROP FOREIGN KEY fk_Insumo_has_Estacion_Estacion1;

-- Ahora SÍ modificar Estacion
ALTER TABLE PlantaAutomotrizEnsambladora.Estacion
MODIFY COLUMN idEstacion INT NOT NULL AUTO_INCREMENT;

-- Recuperar las foreign keys
ALTER TABLE PlantaAutomotrizEnsambladora.LineaMontajeEstacion
ADD CONSTRAINT fk_LineaMontaje_has_Estacion_Estacion1
FOREIGN KEY (Estacion_idEstacion)
REFERENCES PlantaAutomotrizEnsambladora.Estacion(idEstacion)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE PlantaAutomotrizEnsambladora.InsumoEstacion
ADD CONSTRAINT fk_Insumo_has_Estacion_Estacion1
FOREIGN KEY (Estacion_idEstacion)
REFERENCES PlantaAutomotrizEnsambladora.Estacion(idEstacion)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

-- ---------------------------------------------------------------------
						-- MODIFICACION A VEHICULO
-- ---------------------------------------------------------------------
ALTER TABLE Vehiculo 
ADD COLUMN estado ENUM(
    'NO_INGRESADO',       -- Aún no entró a la línea de producción
    'EN_PRODUCCION',      -- Está en alguna estación de la línea
    'ENSAMBLADO',         -- Terminó toda la línea de montaje
    'ENTREGADO',          -- Entregado a la concesionaria
    'CANCELADO'           -- Pedido cancelado
) DEFAULT 'NO_INGRESADO';