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
  `idModeloAuto` INT NOT NULL,
  `modelo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idModeloAuto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`LineaMontaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`LineaMontaje` (
  `idLineaMontaje` INT NOT NULL,
  `ModeloAuto_idModeloAuto` INT NOT NULL,
  `capacidadMaximaPorMes` INT NOT NULL,
  `maquina` VARCHAR(45) NULL,
  PRIMARY KEY (`idLineaMontaje`, `ModeloAuto_idModeloAuto`),
  CONSTRAINT `fk_LineaMontaje_ModeloAuto`
    FOREIGN KEY (`ModeloAuto_idModeloAuto`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`ModeloAuto` (`idModeloAuto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_LineaMontaje_ModeloAuto_idx` ON `PlantaAutomotrizEnsambladora`.`LineaMontaje` (`ModeloAuto_idModeloAuto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Estacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Estacion` (
  `idEstacion` INT NOT NULL,
  `actividad` VARCHAR(45) NULL,
  PRIMARY KEY (`idEstacion`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Insumo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Insumo` (
  `idInsumo` INT NOT NULL,
  `tipoInsumo` VARCHAR(45) NOT NULL,
  `UnidadDeMedida` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idInsumo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Concesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Concesionaria` (
  `idConcesionaria` INT NOT NULL,
  `nombreConcesionaria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idConcesionaria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`PedidoConcesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`PedidoConcesionaria` (
  `idPedidoConcesionaria` INT NOT NULL,
  `Concesionaria_idConcesionaria` INT NOT NULL,
  `FechaDeEntregaEstimada` DATE NOT NULL,
  `FechaDeEntregaReal` DATE NOT NULL,
  `FechaPedido` DATE NOT NULL,
  PRIMARY KEY (`idPedidoConcesionaria`, `Concesionaria_idConcesionaria`),
  CONSTRAINT `fk_PedidoConcesionaria_Concesionaria1`
    FOREIGN KEY (`Concesionaria_idConcesionaria`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Concesionaria` (`idConcesionaria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_PedidoConcesionaria_Concesionaria1_idx` ON `PlantaAutomotrizEnsambladora`.`PedidoConcesionaria` (`Concesionaria_idConcesionaria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Proveedor` (
  `idProveedor` INT NOT NULL,
  `nombreProveedor` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idProveedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`AutoParte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`AutoParte` (
  `idAutoParte` INT NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAutoParte`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`LineaMontajeEstacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`LineaMontajeEstacion` (
  `idLineaMontajeHasEstacion` INT NOT NULL,
  `LineaMontaje_idLineaMontaje` INT NOT NULL,
  `Estacion_idEstacion` INT NOT NULL,
  PRIMARY KEY (`idLineaMontajeHasEstacion`, `LineaMontaje_idLineaMontaje`, `Estacion_idEstacion`),
  CONSTRAINT `fk_LineaMontaje_has_Estacion_LineaMontaje1`
    FOREIGN KEY (`LineaMontaje_idLineaMontaje`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`LineaMontaje` (`idLineaMontaje`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LineaMontaje_has_Estacion_Estacion1`
    FOREIGN KEY (`Estacion_idEstacion`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Estacion` (`idEstacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_LineaMontaje_has_Estacion_Estacion1_idx` ON `PlantaAutomotrizEnsambladora`.`LineaMontajeEstacion` (`Estacion_idEstacion` ASC) VISIBLE;

CREATE INDEX `fk_LineaMontaje_has_Estacion_LineaMontaje1_idx` ON `PlantaAutomotrizEnsambladora`.`LineaMontajeEstacion` (`LineaMontaje_idLineaMontaje` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`InsumoEstacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`InsumoEstacion` (
  `Insumo_idInsumo` INT NOT NULL,
  `Estacion_idEstacion` INT NOT NULL,
  `Cantidad` FLOAT NOT NULL,
  PRIMARY KEY (`Insumo_idInsumo`, `Estacion_idEstacion`),
  CONSTRAINT `fk_Insumo_has_Estacion_Insumo1`
    FOREIGN KEY (`Insumo_idInsumo`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Insumo` (`idInsumo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Insumo_has_Estacion_Estacion1`
    FOREIGN KEY (`Estacion_idEstacion`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Estacion` (`idEstacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Insumo_has_Estacion_Estacion1_idx` ON `PlantaAutomotrizEnsambladora`.`InsumoEstacion` (`Estacion_idEstacion` ASC) VISIBLE;

CREATE INDEX `fk_Insumo_has_Estacion_Insumo1_idx` ON `PlantaAutomotrizEnsambladora`.`InsumoEstacion` (`Insumo_idInsumo` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`ProveedorAutoParte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`ProveedorAutoParte` (
  `ProveedorAutoParteId` VARCHAR(45) NOT NULL,
  `Proveedor_idProveedor` INT NOT NULL,
  `AutoParte_idAutoParte` INT NOT NULL,
  PRIMARY KEY (`ProveedorAutoParteId`, `Proveedor_idProveedor`, `AutoParte_idAutoParte`),
  CONSTRAINT `fk_Proveedor_has_AutoParte_Proveedor1`
    FOREIGN KEY (`Proveedor_idProveedor`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Proveedor` (`idProveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ProveedorAutoParte_AutoParte1`
    FOREIGN KEY (`AutoParte_idAutoParte`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`AutoParte` (`idAutoParte`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Proveedor_has_AutoParte_Proveedor1_idx` ON `PlantaAutomotrizEnsambladora`.`ProveedorAutoParte` (`Proveedor_idProveedor` ASC) VISIBLE;

CREATE INDEX `fk_ProveedorAutoParte_AutoParte1_idx` ON `PlantaAutomotrizEnsambladora`.`ProveedorAutoParte` (`AutoParte_idAutoParte` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`InsumoProveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`InsumoProveedor` (
  `InsumoProvedorId` INT NOT NULL,
  `Insumo_idInsumo` INT NOT NULL,
  `Proveedor_idProveedor` INT NOT NULL,
  `PrecioUnitario` FLOAT NOT NULL,
  PRIMARY KEY (`InsumoProvedorId`, `Insumo_idInsumo`, `Proveedor_idProveedor`),
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

CREATE INDEX `fk_Insumo_has_Proveedor_Proveedor1_idx` ON `PlantaAutomotrizEnsambladora`.`InsumoProveedor` (`Proveedor_idProveedor` ASC) VISIBLE;

CREATE INDEX `fk_Insumo_has_Proveedor_Insumo1_idx` ON `PlantaAutomotrizEnsambladora`.`InsumoProveedor` (`Insumo_idInsumo` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Estacion_has_AutoParte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Estacion_has_AutoParte` (
  `Estacion_idEstacion` INT NOT NULL,
  `AutoParte_idAutoParte` INT NOT NULL,
  PRIMARY KEY (`Estacion_idEstacion`, `AutoParte_idAutoParte`),
  CONSTRAINT `fk_Estacion_has_AutoParte_Estacion1`
    FOREIGN KEY (`Estacion_idEstacion`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Estacion` (`idEstacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estacion_has_AutoParte_AutoParte1`
    FOREIGN KEY (`AutoParte_idAutoParte`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`AutoParte` (`idAutoParte`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Estacion_has_AutoParte_AutoParte1_idx` ON `PlantaAutomotrizEnsambladora`.`Estacion_has_AutoParte` (`AutoParte_idAutoParte` ASC) VISIBLE;

CREATE INDEX `fk_Estacion_has_AutoParte_Estacion1_idx` ON `PlantaAutomotrizEnsambladora`.`Estacion_has_AutoParte` (`Estacion_idEstacion` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`Vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`Vehiculo` (
  `idVehiculo` INT NOT NULL,
  `NumeroDeChasis` INT NOT NULL,
  `ModeloAuto_idModeloAuto` INT NOT NULL,
  PRIMARY KEY (`idVehiculo`),
  CONSTRAINT `fk_Vehiculo_ModeloAuto1`
    FOREIGN KEY (`ModeloAuto_idModeloAuto`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`ModeloAuto` (`idModeloAuto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Vehiculo_ModeloAuto1_idx` ON `PlantaAutomotrizEnsambladora`.`Vehiculo` (`ModeloAuto_idModeloAuto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`RegistoEstacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`RegistroEstacion` (
  `idRegistroEstacion` INT NOT NULL,
  `Vehiculo_idVehiculo` INT NOT NULL,
  `FechaInicio` DATETIME NOT NULL,
  `FechaFin` DATETIME NULL,
  `LineaMontajeEstacion_idLineaMontajeHasEstacion` INT NOT NULL,
  PRIMARY KEY (`idRegistroEstacion`, `Vehiculo_idVehiculo`, `LineaMontajeEstacion_idLineaMontajeHasEstacion`),
  CONSTRAINT `fk_RegistroEstacion_Vehiculo1`
    FOREIGN KEY (`Vehiculo_idVehiculo`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`Vehiculo` (`idVehiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RegistroEstacion_LineaMontajeEstacion1`
    FOREIGN KEY (`LineaMontajeEstacion_idLineaMontajeHasEstacion`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`LineaMontajeEstacion` (`idLineaMontajeHasEstacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_RegistroEstacion_Vehiculo1_idx` ON `PlantaAutomotrizEnsambladora`.`RegistroEstacion` (`Vehiculo_idVehiculo` ASC) VISIBLE;

CREATE INDEX `fk_RegistroEstacion_LineaMontajeEstacion1_idx` ON `PlantaAutomotrizEnsambladora`.`RegistroEstacion` (`LineaMontajeEstacion_idLineaMontajeHasEstacion` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`ModeloAuto_has_PedidoConcesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`ModeloAuto_has_PedidoConcesionaria` (
  `ModeloAuto_idModeloAuto` INT NOT NULL,
  `PedidoConcesionaria_idPedidoConcesionaria` INT NOT NULL,
  `Cantidad` INT NOT NULL,
  PRIMARY KEY (`ModeloAuto_idModeloAuto`, `PedidoConcesionaria_idPedidoConcesionaria`),
  CONSTRAINT `fk_ModeloAuto_has_PedidoConcesionaria_ModeloAuto1`
    FOREIGN KEY (`ModeloAuto_idModeloAuto`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`ModeloAuto` (`idModeloAuto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ModeloAuto_has_PedidoConcesionaria_PedidoConcesionaria1`
    FOREIGN KEY (`PedidoConcesionaria_idPedidoConcesionaria`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`PedidoConcesionaria` (`idPedidoConcesionaria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_ModeloAuto_has_PedidoConcesionaria_PedidoConcesionaria1_idx` ON `PlantaAutomotrizEnsambladora`.`ModeloAuto_has_PedidoConcesionaria` (`PedidoConcesionaria_idPedidoConcesionaria` ASC) VISIBLE;

CREATE INDEX `fk_ModeloAuto_has_PedidoConcesionaria_ModeloAuto1_idx` ON `PlantaAutomotrizEnsambladora`.`ModeloAuto_has_PedidoConcesionaria` (`ModeloAuto_idModeloAuto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`PedidoInsumo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`PedidoInsumo` (
  `idPedidoInsumo` INT NOT NULL,
  `FechaPedido` DATE NOT NULL,
  PRIMARY KEY (`idPedidoInsumo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`PedidioInsumoDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`PedidioInsumoDetalle` (
  `idPedidioInsumoDetalle` INT NOT NULL,
  `PedidoInsumo_idPedidoInsumo` INT NOT NULL,
  `InsumoProveedor_InsumoProvedorId` INT NOT NULL,
  `Cantidad` INT NOT NULL,
  PRIMARY KEY (`idPedidioInsumoDetalle`, `PedidoInsumo_idPedidoInsumo`, `InsumoProveedor_InsumoProvedorId`),
  CONSTRAINT `fk_PedidioInsumoDetalle_PedidoInsumo1`
    FOREIGN KEY (`PedidoInsumo_idPedidoInsumo`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`PedidoInsumo` (`idPedidoInsumo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PedidioInsumoDetalle_InsumoProveedor1`
    FOREIGN KEY (`InsumoProveedor_InsumoProvedorId`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`InsumoProveedor` (`InsumoProvedorId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_PedidioInsumoDetalle_PedidoInsumo1_idx` ON `PlantaAutomotrizEnsambladora`.`PedidioInsumoDetalle` (`PedidoInsumo_idPedidoInsumo` ASC) VISIBLE;

CREATE INDEX `fk_PedidioInsumoDetalle_InsumoProveedor1_idx` ON `PlantaAutomotrizEnsambladora`.`PedidioInsumoDetalle` (`InsumoProveedor_InsumoProvedorId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`PedidoAutoParte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`PedidoAutoParte` (
  `idPedidoAutoParte` INT NOT NULL,
  `fechaDePedido` DATE NOT NULL,
  PRIMARY KEY (`idPedidoAutoParte`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PlantaAutomotrizEnsambladora`.`PedidoAutoParteDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PlantaAutomotrizEnsambladora`.`PedidoAutoParteDetalle` (
  `idPedidoAutoParteDetalle` INT NOT NULL,
  `ProveedorAutoParte_Proveedor_idProveedor` INT NOT NULL,
  `PedidoAutoParte_idPedidoAutoParte` INT NOT NULL,
  `Cantidad` INT NOT NULL,
  PRIMARY KEY (`idPedidoAutoParteDetalle`, `ProveedorAutoParte_Proveedor_idProveedor`, `PedidoAutoParte_idPedidoAutoParte`),
  CONSTRAINT `fk_PedidoAutoParteDetalle_ProveedorAutoParte1`
    FOREIGN KEY (`ProveedorAutoParte_Proveedor_idProveedor`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`ProveedorAutoParte` (`Proveedor_idProveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PedidoAutoParteDetalle_PedidoAutoParte1`
    FOREIGN KEY (`PedidoAutoParte_idPedidoAutoParte`)
    REFERENCES `PlantaAutomotrizEnsambladora`.`PedidoAutoParte` (`idPedidoAutoParte`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_PedidoAutoParteDetalle_ProveedorAutoParte1_idx` ON `PlantaAutomotrizEnsambladora`.`PedidoAutoParteDetalle` (`ProveedorAutoParte_Proveedor_idProveedor` ASC) VISIBLE;

CREATE INDEX `fk_PedidoAutoParteDetalle_PedidoAutoParte1_idx` ON `PlantaAutomotrizEnsambladora`.`PedidoAutoParteDetalle` (`PedidoAutoParte_idPedidoAutoParte` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;