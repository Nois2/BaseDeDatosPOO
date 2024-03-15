use SistemaTelecomunicaciones;
/*Crear sistema*/
CALL sp_JefeDeAreaFuncional_CrearNuevoSistema(1, 'Nuevo Proyecto', 'ruta_documento.pdf', 'Descripción del proyecto', @mensaje);
SELECT @mensaje;
/*Actualizar bitacora requerimiento*/
CALL sp_JefeDeAreaFuncional_ActualizarBitacoraRequerimiento(1, 'Nuevo avance', 50, '2024-03-15', 1, @mensaje);
SELECT @mensaje;
/*Agregar bitacora requerimiento*/
CALL sp_JefeDeAreaFuncional_AgregarBitacoraRequerimiento(1, 'Avance inicial', 25, '2024-03-15', 1, @mensaje);
SELECT @mensaje;
/*Ver Tablas de bitacora por idCaso*/
CALL sp_JefeDeAreaFuncional_VerTablaDeBitacoraPorIdDeCaso(1);

