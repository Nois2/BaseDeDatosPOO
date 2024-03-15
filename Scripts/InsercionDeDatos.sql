
USE sistemaparacrearsistemas;

/*Insercion de datos para niveldeacceso*/
INSERT INTO niveldeacceso(nombreNivelDeAcceso, funcionalidadDeNivelDeAcceso) 
VALUES 
('Administrador', 'Con la capacidad de registrar y gestionar áreas funcionales de la empresa (departamentos), jefes de áreas funcionales y jefes de desarrollo.'),
('Jefes de areas funcionales', 'Con la capacidad de solicitar la apertura de casos y monitorear el porcentaje de progreso y bitácora de los casos aperturados.'),
('Empleados de las areas funcionales', 'Pueden ser asignados como "probadores" de un caso, en tal situación deben monitorear el porcentaje de progreso y bitácoras de trabajo de dicho caso y aprobarlo o rechazarlo una vez que este haya sido entregado por el programador asignado.'),
('Jefe de desarrollo', 'Tiene la capacidad de aceptar o rechazar las solicitudes de casos realizadas por los jefes de las áreas funcionales que tiene a su cargo. Además, debe tener la capacidad de monitorear el trabajo de los programadores que tiene a su cargo.'),
('Programadores', 'Debe actualizar los porcentajes de progreso y bitácoras de trabajo de los casos a los que ha sido asignado.');
/*Insercion de datos en tabla empleados*/
INSERT INTO empleados (nombres, apellidos, FK_empleadoEncargado, FK_idNivelDeAcceso)
VALUES
('Juan', 'Perez', NULL, 1), -- Ejemplo de un empleado sin encargado y con nivel de acceso 1
('María', 'López', 1, 2),  -- Ejemplo de un empleado con encargado y con nivel de acceso 2
('Pedro', 'Gómez', NULL, 3), -- Ejemplo de un empleado sin encargado y con nivel de acceso 3
('Noel', 'Guevara', NULL, 5); -- Ejemplo de un empleado sin encargado y con nivel de acceso 5

INSERT INTO Departamentos (nombreDepartamento, FK_idEmpleado)
VALUES
    ('Departamento de Finanzas', 3),
    ('Departamento de Ventas', 3),
    ('Departamento de Facturacion Fija', 3),
    ('Departamento de Facturacion Móvil', 3);

INSERT INTO estadorequerimiento (nombreRequerimiento,descripcionDeEstadoRequerimiento)
VALUES
('En espera de respuesta','Parrafo1UDB'),
('Fase Inicial','Fuentes de ortiz'),
('Finalizado', 'Fuentes de ortiz');


INSERT INTO estadoBitacora(nombreEstadoBitacora,descripcionEstadoBitacora)
VALUES 
('Prueba','Prueba realizada por Noel'),
('En espera de respuesta', 'Parrafo1'),
('Solicitud rechazada');