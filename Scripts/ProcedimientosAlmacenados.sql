USE sistemaparacrearsistemas;




/*1*/

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

    -- Verificar que ningún parámetro vaya vacío
    IF sp_idEmpleado IS NULL OR sp_nombreProyecto = '' OR sp_URL_requerimiento_documentoPDF = '' OR descripcionProyecto = '' THEN
        SET mensaje = 'Uno o más parámetros están vacíos.';
        SET error_occurred = TRUE;
    ELSE
        -- Obtener el nivel de acceso del empleado
        SET nivelAcceso = obtenerNivelDeAccesoDeEmpleado(sp_idEmpleado);

        -- Verificar si el nivel de acceso permite crear casos sin adjunto
        IF nivelAcceso = 'Jefes de áreas funcionales' THEN
            -- Si no hay errores, crear proyecto, caso y bitácora
            BEGIN
                -- Se crea el Proyecto
                INSERT INTO proyectos (nombreProyecto, URL_requerimiento_documentoPDF, FK_idEmpleado)
                VALUES (sp_nombreProyecto, sp_URL_requerimiento_documentoPDF, sp_idEmpleado);
                -- Se obtiene el ID del proyecto recién creado
                SET idProyectoPorSelect = LAST_INSERT_ID();
                -- Se inicializa el casoRequerimiento
                INSERT INTO casorequerimiento (TituloCasoRequerimiento, porcentajeAvance, FK_idEstadoRequerimiento, FK_idEmpleado, FK_idProyecto)
                VALUES ('Inicialización', 0, 1, sp_idEmpleado, idProyectoPorSelect);
                -- Se obtiene el ID del casoRequerimiento recién creado
                SET idCasoRequerimientoPorID = LAST_INSERT_ID();
                -- Se inicializa su primera bitácora
                INSERT INTO bitacorarequerimiento (DescripcionDeAvanceEnRequerimiento, PorcentajeDeAvanceRealizadoEnBitacora, fechaActualizacionRequerimiento, FK_idEstadoBitacora, FK_idCasoRequerimiento)
                VALUES ('Inicio De Proyecto', 0, NOW(), 1, idCasoRequerimientoPorID);
                -- Se asume que no hubo errores (Mensaje de Salida)
                SET mensaje = 'Proyecto creado correctamente.';
            END;
        ELSE
            SET mensaje = 'No tienes permiso para crear casos sin adjunto.';
            SET error_occurred = TRUE;
        END IF;
    END IF;

    -- Si hay errores, establecer el porcentaje de avance en 0
    IF error_occurred THEN
        SET mensaje = 'Error al crear el proyecto.';
    END IF;
END//

DELIMITER ;



/*EJEMPLO DE EJECUCION

*/


DELIMITER //

CREATE PROCEDURE insertarNuevoProyecto(
    IN nombreProyecto VARCHAR(50),
    IN EncargadoProyecto VARCHAR(50),
    IN DescripcionCasoProyecto INT,
    IN EstadoCaso VARCHAR(50),
    IN BitacoraCaso VARCHAR(50),
)
BEGIN
    INSERT INTO empleados (nombre, apellido, edad, cargo)
    VALUES (p_nombre, p_apellido, p_edad, p_cargo);
END;
//

DELIMITER ;

/*Extras*/

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
