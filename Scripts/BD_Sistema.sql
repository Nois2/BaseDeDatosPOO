/*Creacion de la base de datos*/
DROP DATABASE IF EXISTS Sistema;
CREATE DATABASE IF NOT EXISTS Sistema;
USE Sistema;
/*Creacion de tablas*/

DROP TABLE IF EXISTS `NivelDeAcceso`;
CREATE TABLE IF NOT EXISTS `NivelDeAcceso` (
    `PK_idNivelDeAcceso` INT AUTO_INCREMENT PRIMARY KEY,
    `nombreNivelDeAcceso` VARCHAR(50) NOT NULL,
    `funcionalidadDeNivelDeAcceso` VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

DROP TABLE IF EXISTS `Empleados`;
CREATE TABLE IF NOT EXISTS `Empleados` (
    `PK_idEmpleado` INT AUTO_INCREMENT PRIMARY KEY,
    `nombres` VARCHAR(50) NOT NULL,
    `apellidos` VARCHAR(50) NOT NULL,
    `FK_empleadoEncargado` INT,
     KEY `FK_empleadoEncargado` (`FK_empleadoEncargado`),
    `FK_idNivelDeAcceso` INT NOT NULL,
     KEY `FK_idNivelDeAcceso` (`FK_idNivelDeAcceso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

DROP TABLE IF EXISTS `Departamentos`;
CREATE TABLE IF NOT EXISTS `Departamentos` (
    `PK_idDepartamento` INT AUTO_INCREMENT PRIMARY KEY,
    `nombreDepartamento` VARCHAR(50) NOT NULL,
    `FK_idEmpleado` INT,
     KEY `FK_idEmpleado` (`FK_idEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

DROP TABLE IF EXISTS `Proyectos`;
CREATE TABLE IF NOT EXISTS `Proyectos` (
    `PK_idProyecto` INT AUTO_INCREMENT PRIMARY KEY,
    `nombreProyecto` VARCHAR(100) NOT NULL,
    `URL_requerimiento_documentoPDF` VARCHAR(100) NULL,
    `FK_idEmpleado` INT NOT NULL,
    KEY `FK_idEmpleado` (`FK_idEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

DROP TABLE IF EXISTS `EstadoRequerimiento`;
CREATE TABLE IF NOT EXISTS `EstadoRequerimiento` (
    `PK_idEstadoRequerimiento` INT AUTO_INCREMENT PRIMARY KEY,
    `nombreRequerimiento` VARCHAR(50) NOT NULL,
    `descripcionDeEstadoRequerimiento` VARCHAR(100) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

DROP TABLE IF EXISTS `EstadoBitacora`;
CREATE TABLE IF NOT EXISTS `EstadoBitacora` (
    `PK_idEstadoBitacora` INT AUTO_INCREMENT PRIMARY KEY,
    `nombreEstadoBitacora` VARCHAR(50) NOT NULL,
    `descripcionEstadoBitacora` VARCHAR(100) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;


DROP TABLE IF EXISTS `BitacoraRequerimiento`;
CREATE TABLE IF NOT EXISTS `BitacoraRequerimiento` (
    `PK_idBitacoraRequerimiento` INT AUTO_INCREMENT PRIMARY KEY,
    `DescripcionDeAvanceEnRequerimiento` VARCHAR(250) NOT NULL,
    `PorcentajeDeAvanceRealizadoEnBitacora` INT NOT NULL,
    `fechaActualizacionRequerimiento` DATETIME NOT NULL,
    `FK_idEstadoBitacora` INT NOT NULL,
    `FK_idCasoRequerimiento` INT NOT NULL,
    KEY `FK_idEstadoBitacora` (`FK_idEstadoBitacora`),
    KEY `FK_idCasoRequerimiento` (`FK_idCasoRequerimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;


DROP TABLE IF EXISTS `CasoRequerimiento`;
CREATE TABLE IF NOT EXISTS `CasoRequerimiento` (
    `PK_idCasoRequerimiento` INT AUTO_INCREMENT PRIMARY KEY,
    `TituloCasoRequerimiento` VARCHAR(250) NOT NULL,
    `porcentajeAvance` INT NOT NULL, /*Este es un campo calculado*/
    `FK_idEstadoRequerimiento` INT NOT NULL,
    `FK_idEmpleado` INT NOT NULL,
    `FK_idProyecto` INT NOT NULL,
     KEY `FK_idEstadoRequerimiento` (`FK_idEstadoRequerimiento`),
     KEY `FK_idEmpleado` (`FK_idEmpleado`),
     KEY `FK_idProyecto` (`FK_idProyecto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

ALTER TABLE `Empleados`
ADD CONSTRAINT `fk_empleadosEmpleados`
FOREIGN KEY (`FK_empleadoEncargado`) REFERENCES `Empleados` (`PK_idEmpleado`)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `Empleados`
ADD CONSTRAINT `fk_NivelDeAcceso_Empleados`
FOREIGN KEY (`FK_idNivelDeAcceso`) REFERENCES `NivelDeAcceso` (`PK_idNivelDeAcceso`)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `Departamentos`
ADD CONSTRAINT `fk_Empleados_Departamentos`
FOREIGN KEY (`FK_idEmpleado`) REFERENCES `Empleados` (`PK_idEmpleado`)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `Proyectos`
ADD CONSTRAINT `FK_Empleados_Proyectos`
FOREIGN KEY (`FK_idEmpleado`) REFERENCES `Empleados` (`PK_idEmpleado`)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `BitacoraRequerimiento`
ADD CONSTRAINT `FK_EstadoBitacora_BitacoraCaso`
FOREIGN KEY (`FK_idEstadoBitacora`) REFERENCES `EstadoBitacora` (`PK_idEstadoBitacora`)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `CasoRequerimiento`
ADD CONSTRAINT `fk_Proyecto_CasoProyecto`
FOREIGN KEY (`FK_idProyecto`) REFERENCES `Proyectos` (`PK_idProyecto`)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `CasoRequerimiento`
ADD CONSTRAINT `fk_EstadoCaso_CasoProyecto`
FOREIGN KEY (`FK_idEstadoRequerimiento`) REFERENCES `EstadoRequerimiento` (`PK_idEstadoRequerimiento`)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `BitacoraRequerimiento`
ADD CONSTRAINT `fk_BitacoraCaso_CasoProyecto`
FOREIGN KEY (`FK_idCasoRequerimiento`) REFERENCES `casorequerimiento` (`PK_idCasoRequerimiento`)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `CasoRequerimiento`
ADD CONSTRAINT `fk_Empleados_CasoProyecto`
FOREIGN KEY (`FK_idEmpleado`) REFERENCES `Empleados` (`PK_idEmpleado`)
ON DELETE CASCADE
ON UPDATE CASCADE;
