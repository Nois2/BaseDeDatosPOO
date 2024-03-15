USE SistemaTelecomunicaciones;

/*Extras necesarios*/

DELIMITER //

CREATE TRIGGER tr_actualizar_porcentajeAvance
AFTER INSERT ON bitacorarequerimiento
FOR EACH ROW
BEGIN
    DECLARE totalPorcentajeAvance INT;

    /* Calcular la suma de todos los porcentajes de avance para el caso requerido*/
    SELECT SUM(PorcentajeDeAvanceRealizadoEnBitacora) INTO totalPorcentajeAvance
    FROM bitacorarequerimiento
    WHERE FK_idCasoRequerimiento = NEW.FK_idCasoRequerimiento;

    /*Actualizar el porcentajeAvance en CasoRequerimiento*/
    UPDATE CasoRequerimiento
    SET porcentajeAvance = totalPorcentajeAvance
    WHERE PK_idCasoRequerimiento = NEW.FK_idCasoRequerimiento;
END//

DELIMITER ;


/*Retorna un string con el nivel de acceso de un empleado
-Su utilidad puede ser mostrar diferentes interfaces graficas,
validar que de veras es un programador o etc*/
/*Funcional*/


DELIMITER //

CREATE FUNCTION sp_obtenerNivelDeAccesoDeEmpleado(IdEmpleado INT)
RETURNS VARCHAR(50)
BEGIN
    DECLARE nivelAcceso VARCHAR(50);
    
    SELECT n.nombreNivelDeAcceso INTO nivelAcceso
    FROM empleados AS e
    INNER JOIN niveldeacceso AS n 
    ON n.PK_idNivelDeAcceso = e.FK_idNivelDeAcceso 
    WHERE e.PK_idEmpleado = IdEmpleado
    LIMIT 1;

    RETURN nivelAcceso;
END;
//

DELIMITER ;



/*1*/

/*--Creacion de proyecto, se inicializa el caso y una bitacora*/
DELIMITER //

CREATE PROCEDURE sp_JefeDeAreaFuncional_CrearNuevoSistema(
    IN sp_idEmpleado INT,
    IN sp_nombreProyecto VARCHAR(255),
    IN sp_URL_requerimiento_documentoPDF VARCHAR(100),
    IN descripcionProyecto VARCHAR(250),
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE nivelAcceso VARCHAR(50);
    DECLARE idProyectoPorSelect INT;
    DECLARE idCasoRequerimientoPorID INT;

   /* -- Verificar que ningún parámetro vaya vacío*/
    IF sp_idEmpleado IS NULL OR sp_nombreProyecto = '' OR sp_URL_requerimiento_documentoPDF = '' OR descripcionProyecto = '' THEN
        SET mensaje = 'Uno o más parámetros están vacíos.';
        SET error_occurred = TRUE;
    ELSE
      /*  -- Obtener el nivel de acceso del empleado*/
        SET nivelAcceso = obtenerNivelDeAccesoDeEmpleado(sp_idEmpleado);

       /* -- Verificar si el nivel de acceso permite crear casos sin adjunto */
        IF nivelAcceso = 'Jefes de áreas funcionales' THEN
         /*   -- Si no hay errores, crear proyecto, caso y bitácora */
            BEGIN
              /*  -- Se crea el Proyecto*/
                INSERT INTO proyectos (nombreProyecto, URL_requerimiento_documentoPDF, FK_idEmpleado)
                VALUES (sp_nombreProyecto, sp_URL_requerimiento_documentoPDF, sp_idEmpleado);
              /*  -- Se obtiene el ID del proyecto recién creado */
                SET idProyectoPorSelect = LAST_INSERT_ID();
                -- Se inicializa el casoRequerimiento */
                INSERT INTO casorequerimiento (TituloCasoRequerimiento, porcentajeAvance, FK_idEstadoRequerimiento, FK_idEmpleado, FK_idProyecto)
                VALUES ('Inicialización', 0, 1, sp_idEmpleado, idProyectoPorSelect);
               /* -- Se obtiene el ID del casoRequerimiento recién creado */
                SET idCasoRequerimientoPorID = LAST_INSERT_ID();
               /* -- Se inicializa su primera bitácora */
                INSERT INTO bitacorarequerimiento (DescripcionDeAvanceEnRequerimiento, PorcentajeDeAvanceRealizadoEnBitacora, fechaActualizacionRequerimiento, FK_idEstadoBitacora, FK_idCasoRequerimiento)
                VALUES ('Inicio De Proyecto', 0, NOW(), 2, idCasoRequerimientoPorID);
               /* -- Se asume que no hubo errores (Mensaje de Salida) */
                SET mensaje = 'Proyecto creado correctamente.';
            END;
        ELSE
            SET mensaje = 'No tienes permiso para crear casos sin adjunto.';
            SET error_occurred = TRUE;
        END IF;
    END IF;

    /*-- Si hay errores, establecer el porcentaje de avance en 0 */
    IF error_occurred THEN
        SET mensaje = 'Error al crear el proyecto.';
    END IF;
END//

DELIMITER ;
/* --1 Ya que ya se inicializo el proyecto y el caso, los cambios ahora se hacen en la bitacora
--1 Esto es para actualizar los datos de una bitacoraX */
DELIMITER //

CREATE PROCEDURE sp_JefeDeAreaFuncional_ActualizarBitacoraRequerimiento(
    IN sp_idBitacoraRequerimiento INT,
    IN sp_descripcionAvance VARCHAR(255),
    IN sp_porcentajeAvance INT,
    IN sp_fechaActualizacion DATE,
    IN sp_idEstadoBitacora INT,
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;

    /* Verificar que la bitácora de requerimiento exista */
    IF NOT EXISTS (SELECT * FROM bitacorarequerimiento WHERE idBitacoraRequerimiento = sp_idBitacoraRequerimiento) THEN
        SET mensaje = 'La bitácora de requerimiento especificada no existe.';
        SET error_occurred = TRUE;
    ELSE
        /* Actualizar la bitácora de requerimiento */
        BEGIN
            UPDATE bitacorarequerimiento
            SET DescripcionDeAvanceEnRequerimiento = sp_descripcionAvance,
                PorcentajeDeAvanceRealizadoEnBitacora = sp_porcentajeAvance,
                fechaActualizacionRequerimiento = sp_fechaActualizacion,
                FK_idEstadoBitacora = sp_idEstadoBitacora
            WHERE idBitacoraRequerimiento = sp_idBitacoraRequerimiento;
            SET mensaje = 'Bitácora de requerimiento actualizada correctamente.';
        END;
    END IF;

   /*  Si hay errores, establecer mensaje de error */
    IF error_occurred THEN
        SET mensaje = 'Error al actualizar la bitácora de requerimiento.';
    END IF;
END//

DELIMITER ;


/* 1- Insetar bitacorarequerimiento: */
DELIMITER //

CREATE PROCEDURE sp_JefeDeAreaFuncional_AgregarBitacoraRequerimiento(
    IN sp_idCasoRequerimiento INT,
    IN sp_descripcionAvance VARCHAR(255),
    IN sp_porcentajeAvance INT,
    IN sp_fechaActualizacion DATE,
    IN sp_idEstadoBitacora INT,
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;

    /* Verificar que el caso de requerimiento exista */
    IF NOT EXISTS (SELECT * FROM casorequerimiento WHERE idCasoRequerimiento = sp_idCasoRequerimiento) THEN
        SET mensaje = 'El caso de requerimiento especificado no existe.';
        SET error_occurred = TRUE;
    ELSE
        /* Insertar nueva bitácora de requerimiento */
        BEGIN
            INSERT INTO bitacorarequerimiento (DescripcionDeAvanceEnRequerimiento, PorcentajeDeAvanceRealizadoEnBitacora, fechaActualizacionRequerimiento, FK_idEstadoBitacora, FK_idCasoRequerimiento)
            VALUES (sp_descripcionAvance, sp_porcentajeAvance, sp_fechaActualizacion, sp_idEstadoBitacora, sp_idCasoRequerimiento);
            SET mensaje = 'Nueva bitácora de requerimiento agregada correctamente.';
        END;
    END IF;

    /* Si hay errores, establecer mensaje de error */
    IF error_occurred THEN
        SET mensaje = 'Error al agregar la bitácora de requerimiento.';
    END IF;
END//

DELIMITER ;

/* Mostrar las bitacoras de un caso. */

DELIMITER //

CREATE PROCEDURE sp_JefeDeAreaFuncional_VerTablaDeBitacoraPorIdDeCaso(
    IN idCasoRequerimiento INT
)
BEGIN
    DECLARE row_count INT;

    /* Variable para contar filas encontradas en el INNER JOIN */
    SELECT COUNT(*) INTO row_count
    FROM casorequerimiento t1
    INNER JOIN bitacorarequerimiento t2 ON t1.PK_idCasoRequerimiento = t2.FK_idCasoRequerimiento
    WHERE t2.FK_idCasoRequerimiento = idCasoRequerimiento;

    /* Si no hay filas encontradas en el INNER JOIN, mostrar las bitácoras del caso de requerimiento*/
    IF row_count = 0 THEN
       SELECT 'No hay datos' AS 'Mensaje';
    ELSE
        /* Si hay filas encontradas en el INNER JOIN, mostrar el resultado del INNER JOIN */
        SELECT t1.*, t2.*
        FROM casorequerimiento t1
        INNER JOIN bitacorarequerimiento t2 ON t1.PK_idCasoRequerimiento = t2.FK_idCasoRequerimiento
        WHERE t2.FK_idCasoRequerimiento = idCasoRequerimiento;
    END IF;
END//

DELIMITER ;


/*EJEMPLO DE EJECUCION */


