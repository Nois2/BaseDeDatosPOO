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
    DECLARE porcentajeAvance INT;
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE nivelAcceso VARCHAR(50);

    -- Verificar que ningun parametro vaya vacIo
    IF sp_idEmpleado IS NULL OR sp_nombreProyecto = '' OR sp_URL_requerimiento_documentoPDF = '' OR sp_descripcionProyecto = '' THEN
        SET mensaje = 'Uno o dos parametros estan vacios.';
        SET error_occurred = TRUE;
    ELSE
        -- Obtener el nivel de acceso del empleado
        SET nivelAcceso = obtenerNivelDeAccesoDeEmpleado(idEmpleado);

        -- Verificar si el nivel de acceso permite crear casos sin adjunto
        IF nivelAcceso = 'Jefes de areas funcionales' THEN
            SET error_occurred = FALSE;
        ELSE
            SET mensaje = 'No tienes permiso para crear casos sin adjunto.';
            SET error_occurred = TRUE;
        END IF;
    END IF;

    IF error_occurred THEN
        SET porcentajeAvance = 0; 
    ELSE
        -- Si no hay errores hazlo
        -- Declara el porcentaje de avance en 10
        SET porcentajeAvance = 0;
        
        -- Se crea el Proyecto
        INSERT INTO proyectos (nombreProyecto, URL_requerimiento_documentoPDF, FK_idEmpleado)
        VALUES (sp_nombreProyecto, sp_URL_requerimiento_documentoPDF, sp_idEmpleadoidEmpleado);
        -- Se crea su casoRequerimiento inicializado

        INSERT INTO casorequerimiento (TituloCasoRequerimiento,porcentajeAvance,FK_idEstadoRequerimiento,FK_idBitacoraRequerimiento,FK_)
        -- Se asume que no hubo errores (Mensaje de Salida)
        SET mensaje = 'Proyecto creado correctamente.';
    END IF;
END;
//

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
