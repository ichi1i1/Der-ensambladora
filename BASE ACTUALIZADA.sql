-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema PlantaAutomotrizEnsambladora
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `PlantaAutomotrizEnsambladora` ;

-- -----------------------------------------------------
-- Schema PlantaAutomotrizEnsambladora
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `PlantaAutomotrizEnsambladora` DEFAULT CHARACTER SET utf8 ;
USE `PlantaAutomotrizEnsambladora` ;

-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`ModeloAuto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`ModeloAuto` (
  `idModeloAuto` INT NOT NULL AUTO_INCREMENT,
  `modelo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idModeloAuto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`LineaMontaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`LineaMontaje` (
  `idLineaMontaje` INT NOT NULL auto_increment,
  `ModeloAuto_idModeloAuto` INT NOT NULL,
  `CapacidadMaximaMes` INT NULL,
  PRIMARY KEY (`idLineaMontaje`),
  INDEX `fk_LineaMontaje_ModeloAuto_idx` (`ModeloAuto_idModeloAuto` ASC) VISIBLE,
  CONSTRAINT `fk_LineaMontaje_ModeloAuto`
    FOREIGN KEY (`ModeloAuto_idModeloAuto`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`ModeloAuto` (`idModeloAuto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Estacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Estacion` (
  `idEstacion` INT NOT NULL AUTO_INCREMENT,
  `actividad` VARCHAR(45) NULL,
  `LineaMontaje_idLineaMontaje` INT NOT NULL,
  `orden` INT NULL,
  PRIMARY KEY (`idEstacion`),
  INDEX `fk_Estacion_LineaMontaje1_idx` (`LineaMontaje_idLineaMontaje` ASC) VISIBLE,
  CONSTRAINT `fk_Estacion_LineaMontaje1`
    FOREIGN KEY (`LineaMontaje_idLineaMontaje`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`LineaMontaje` (`idLineaMontaje`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Insumo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Insumo` (
  `idInsumo` INT NOT NULL AUTO_INCREMENT,
  `tipoInsumo` VARCHAR(45) NOT NULL,
  `UnidadDeMedida` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idInsumo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Concesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Concesionaria` (
  `idConcesionaria` INT NOT NULL AUTO_INCREMENT,
  `nombreConcesionaria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idConcesionaria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`PedidoConcesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`PedidoConcesionaria` (
  `idPedidoConcesionaria` INT NOT NULL AUTO_INCREMENT,
  `Concesionaria_idConcesionaria` INT NOT NULL,
  `FechaDeEntregaEstimada` DATE NULL,
  `FechaCierrePedido` DATE  NULL,
  PRIMARY KEY (`idPedidoConcesionaria`),
  INDEX `fk_PedidoConsesinaria_Consecionaria1_idx` (`Concesionaria_idConcesionaria` ASC) VISIBLE,
  CONSTRAINT `fk_PedidoConsesinaria_Consecionaria1`
    FOREIGN KEY (`Concesionaria_idConcesionaria`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Concesionaria` (`idConcesionaria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Proveedor` (
  `idProveedor` INT NOT NULL AUTO_INCREMENT,
  `nombreProveedor` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idProveedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table InsumoEstacion
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS InsumoEstacion (
    Insumo_idInsumo INT NOT NULL,
    Estacion_idEstacion INT NOT NULL,
    Cantidad FLOAT NOT NULL,
    Stock INT DEFAULT 0,
    PRIMARY KEY (Insumo_idInsumo, Estacion_idEstacion),
    INDEX fk_Insumo_has_Estacion_Estacion1_idx (Estacion_idEstacion ASC) VISIBLE,
    INDEX fk_Insumo_has_Estacion_Insumo1_idx (Insumo_idInsumo ASC) VISIBLE,
    CONSTRAINT fk_Insumo_has_Estacion_Insumo1 FOREIGN KEY (Insumo_idInsumo)
        REFERENCES Insumo (idInsumo) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Insumo_has_Estacion_Estacion1 FOREIGN KEY (Estacion_idEstacion)
        REFERENCES Estacion (idEstacion) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`InsumoProveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`InsumoProveedor` (
  `InsumoProvedorId` INT NOT NULL,
  `Insumo_idInsumo` INT NOT NULL,
  `Proveedor_idProveedor` INT NOT NULL,
  `PrecioUnitario` FLOAT NOT NULL,
  PRIMARY KEY (`InsumoProvedorId`),
  INDEX `fk_Insumo_has_Proveedor_Proveedor1_idx` (`Proveedor_idProveedor` ASC) VISIBLE,
  INDEX `fk_Insumo_has_Proveedor_Insumo1_idx` (`Insumo_idInsumo` ASC) VISIBLE,
  CONSTRAINT `fk_Insumo_has_Proveedor_Insumo1`
    FOREIGN KEY (`Insumo_idInsumo`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Insumo` (`idInsumo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Insumo_has_Proveedor_Proveedor1`
    FOREIGN KEY (`Proveedor_idProveedor`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Proveedor` (`idProveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`ModeloAuto_has_PedidoConcesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`ModeloAuto_has_PedidoConcesionaria` (
  `PedidoConcesionaria_idPedidoConcesionaria` INT NOT NULL,
  `ModeloAuto_idModeloAuto` INT NOT NULL,
  `Cantidad` INT NOT NULL,
  PRIMARY KEY (`PedidoConcesionaria_idPedidoConcesionaria`, `ModeloAuto_idModeloAuto`),
  INDEX `fk_ModeloAuto_has_PedidoConsesinaria_PedidoConsesinaria1_idx` (`PedidoConcesionaria_idPedidoConcesionaria` ASC) VISIBLE,
  INDEX `fk_ModeloAuto_has_PedidoConsesinaria_ModeloAuto1_idx` (`ModeloAuto_idModeloAuto` ASC) VISIBLE,
  CONSTRAINT `fk_ModeloAuto_has_PedidoConsesinaria_ModeloAuto1`
    FOREIGN KEY (`ModeloAuto_idModeloAuto`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`ModeloAuto` (`idModeloAuto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ModeloAuto_has_PedidoConsesinaria_PedidoConsesinaria1`
    FOREIGN KEY (`PedidoConcesionaria_idPedidoConcesionaria`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`PedidoConcesionaria` (`idPedidoConcesionaria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Vehiculo` con estado
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Vehiculo` (
  `idVehiculo` INT NOT NULL AUTO_INCREMENT,
  `fk_PedidoConcesionaria_idPedidoConcesionaria` INT NOT NULL,
  `fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto` INT NOT NULL,
  `estado` ENUM('Pendiente', 'Produccion', 'Finalizado') NOT NULL DEFAULT 'Pendiente',
  PRIMARY KEY (`idVehiculo`),
  INDEX `fk_Vehiculo_ModeloAuto_has_PedidoConcesionaria1_idx` (`fk_PedidoConcesionaria_idPedidoConcesionaria` ASC, `fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto` ASC) VISIBLE,
  CONSTRAINT `fk_Vehiculo_ModeloAuto_has_PedidoConcesionaria1`
    FOREIGN KEY (`fk_PedidoConcesionaria_idPedidoConcesionaria`, `fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`ModeloAuto_has_PedidoConcesionaria` (`PedidoConcesionaria_idPedidoConcesionaria`, `ModeloAuto_idModeloAuto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`RegistroEstacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`RegistroEstacion` (
  `idRegistroEstacion` INT NOT NULL AUTO_INCREMENT,
  `Vehiculo_idVehiculo` INT NOT NULL,
  `FechaInicio` DATETIME NOT NULL,
  `FechaFin` DATETIME NULL,
  `Estacion_idEstacion` INT NOT NULL,
  PRIMARY KEY (`idRegistroEstacion`),
  INDEX `fk_RegistoEstacion_Vehiculo1_idx` (`Vehiculo_idVehiculo` ASC) VISIBLE,
  INDEX `fk_RegistroEstacion_Estacion1_idx` (`Estacion_idEstacion` ASC) VISIBLE,
  CONSTRAINT `fk_RegistoEstacion_Vehiculo1`
    FOREIGN KEY (`Vehiculo_idVehiculo`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Vehiculo` (`idVehiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RegistroEstacion_Estacion1`
    FOREIGN KEY (`Estacion_idEstacion`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Estacion` (`idEstacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PedidoInsumoDetalle (nombre corregido)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PedidoInsumoDetalle (
    idPedidoInsumoDetalle INT NOT NULL AUTO_INCREMENT,
    InsumoProveedor_InsumoProvedorId INT NOT NULL,
    Cantidad INT NOT NULL,
    FechaPedido DATE NULL,
    PRIMARY KEY (idPedidoInsumoDetalle),
    INDEX fk_PedidoInsumoDetalle_InsumoProveedor1_idx (InsumoProveedor_InsumoProvedorId ASC) VISIBLE,
    CONSTRAINT fk_PedidoInsumoDetalle_InsumoProveedor1 FOREIGN KEY (InsumoProveedor_InsumoProvedorId)
        REFERENCES InsumoProveedor (InsumoProvedorId) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
