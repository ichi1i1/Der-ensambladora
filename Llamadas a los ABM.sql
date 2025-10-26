-- =============================================================================
-- SISTEMA DE PLANTA AUTOMOTRIZ - INICIALIZACIÓN COMPLETA
-- =============================================================================
-- =============================================================================
-- ÍNDICES ESPECÍFICOS PARA LAS CONSULTAS DEL TP
-- =============================================================================

-- -------------------------------------------------------------------------------
-- ÍNDICE PARA CONSULTA 8.1: REPORTE DE PEDIDOS POR CONCESIONARIA
-- -------------------------------------------------------------------------------
CREATE INDEX idx_Pedido_Reporte 
ON PedidoConcesionaria(Concesionaria_idConcesionaria, FechaCierrePedido, FechaDeEntregaEstimada);

-- -------------------------------------------------------------------------------
-- ÍNDICE PARA CONSULTA 8.2: INVENTARIO DE VEHÍCULOS EN PRODUCCIÓN
-- -------------------------------------------------------------------------------
CREATE INDEX idx_Vehiculo_Produccion 
ON Vehiculo(fk_PedidoConcesionaria_idPedidoConcesionaria, fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto, estado);

-- -------------------------------------------------------------------------------
-- ÍNDICE PARA CONSULTA 10.1: ESTADO DE VEHÍCULOS POR PEDIDO
-- -------------------------------------------------------------------------------
CREATE INDEX idx_Registro_Activos 
ON RegistroEstacion(Vehiculo_idVehiculo, FechaFin, Estacion_idEstacion);

-- -------------------------------------------------------------------------------
-- ÍNDICE PARA CONSULTA 10.2: INSUMOS REQUERIDOS POR PEDIDO
-- -------------------------------------------------------------------------------
CREATE INDEX idx_ModeloPedido_Insumos 
ON ModeloAuto_has_PedidoConcesionaria(PedidoConcesionaria_idPedidoConcesionaria, ModeloAuto_idModeloAuto, Cantidad);

-- -------------------------------------------------------------------------------
-- VERIFICACIÓN
-- -------------------------------------------------------------------------------
SELECT 
    TABLE_NAME,
    INDEX_NAME, 
    COLUMN_NAME
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'PlantaAutomotrizEnsambladora'
AND INDEX_NAME LIKE 'idx_%';
-- ======================
-- 2.1 CONCESIONARIAS CLIENTES
-- ======================
-- Las concesionarias son nuestros clientes que realizan pedidos de vehículos
Call altaConcesionaria('CAB Motors', @resultado, @mensaje);
call altaConcesionaria('Car one', @alta, @mensaje);
call altaConcesionaria('Sur cars', @alta, @mensaje);

-- ======================
-- 2.2 PROVEEDORES DE INSUMOS
-- ======================
-- Los proveedores nos suministran los componentes para la producción
CALL altaProveedor('Michelin', @nResultado, @cMensaje);
CALL altaProveedor('Valeo', @nResultado, @cMensaje);
CALL altaProveedor('Bosh', @nResultado, @cMensaje);

-- ======================
-- 2.3 CATÁLOGO DE INSUMOS
-- ======================
-- Definición de los kits de componentes necesarios para el ensamblaje
CALL AltaInsumo('Kit mecanica completo', 'unidad', @id1, @resultado, @mensaje);
CALL AltaInsumo('Kit eléctrico principal', 'unidad', @id6, @resultado, @mensaje);
CALL AltaInsumo('Kit carrocería', 'unidad', @id9, @resultado, @mensaje);

-- -------------------------------------------------------------------------------
-- SECCIÓN 3: CONFIGURACIÓN DE MODELOS Y LÍNEAS DE PRODUCCIÓN
-- -------------------------------------------------------------------------------

-- ======================
-- 3.1 MODELOS DE VEHÍCULOS
-- ======================
-- Catálogo de modelos de autos que producimos en la planta
CALL altaModelo('Renault clio', @nresultado, @cmensaje);
CALL altaModelo('Ford focus', @nresultado, @cmensaje);
CALL altaModelo('Toyota corolla', @nresultado, @cmensaje);

-- ======================
-- 3.2 LÍNEAS DE MONTAJE
-- ======================
-- Cada modelo tiene su propia línea de montaje con capacidad definida
CALL altaLineaMontaje('Renault clio', 35, @nresultado, @cmensaje);
CALL altaLineaMontaje('Ford focus', 35, @nresultado, @cmensaje);
CALL altaLineaMontaje('Toyota corolla', 35, @nresultado, @cmensaje);

-- Verificación de modelos creados
SELECT * FROM ModeloAuto;

-- ======================
-- 3.3 ESTACIONES DE TRABAJO
-- ======================
-- Configuración de las 3 estaciones por cada línea de montaje

-- CONFIGURACIÓN PARA RENAULT CLIO
CALL altaEstacion('Mecanica', 'Renault clio', 1, @resultado, @mensaje);
SELECT @resultado, @mensaje;
CALL altaEstacion('Chapa y pintura', 'Renault clio', 2, @resultado, @mensaje);
SELECT @resultado, @mensaje;
CALL altaEstacion('Electricidad', 'Renault clio', 3, @resultado, @mensaje);
SELECT @resultado, @mensaje;

-- CONFIGURACIÓN PARA FORD FOCUS
CALL altaEstacion('Mecanica', 'Ford focus', 1, @resultado, @mensaje);
CALL altaEstacion('Chapa y pintura', 'Ford focus', 2, @resultado, @mensaje);
CALL altaEstacion('Electricidad', 'Ford focus', 3, @resultado, @mensaje);

-- CONFIGURACIÓN PARA TOYOTA COROLLA
CALL altaEstacion('Mecanica', 'Toyota corolla', 1, @resultado, @mensaje);
CALL altaEstacion('Chapa y pintura', 'Toyota corolla', 2, @resultado, @mensaje);
CALL altaEstacion('Electricidad', 'Toyota corolla', 3, @resultado, @mensaje);

-- -------------------------------------------------------------------------------
-- SECCIÓN 4: ASIGNACIÓN DE INSUMOS A ESTACIONES
-- -------------------------------------------------------------------------------

-- RENAULT CLIO: Asignación de kits a cada estación
CALL AgregarInsumoAEstacionPorNombre('Kit mecanica completo', 'Mecanica', 'Renault clio', 1);
CALL AgregarInsumoAEstacionPorNombre('Kit carrocería', 'Chapa y pintura', 'Renault clio', 1);
CALL AgregarInsumoAEstacionPorNombre('Kit eléctrico principal', 'Electricidad', 'Renault clio', 1);

-- FORD FOCUS: Asignación de kits a cada estación
CALL AgregarInsumoAEstacionPorNombre('Kit mecanica completo', 'Mecanica', 'Ford focus', 1);
CALL AgregarInsumoAEstacionPorNombre('Kit carrocería', 'Chapa y pintura', 'Ford focus', 1);
CALL AgregarInsumoAEstacionPorNombre('Kit eléctrico principal', 'Electricidad', 'Ford focus', 1);

-- TOYOTA COROLLA: Asignación de kits a cada estación
CALL AgregarInsumoAEstacionPorNombre('Kit mecanica completo', 'Mecanica', 'Toyota corolla', 1);
CALL AgregarInsumoAEstacionPorNombre('Kit carrocería', 'Chapa y pintura', 'Toyota corolla', 1);
CALL AgregarInsumoAEstacionPorNombre('Kit eléctrico principal', 'Electricidad', 'Toyota corolla', 1);

-- -------------------------------------------------------------------------------
-- SECCIÓN 5: RELACIÓN PROVEEDORES - INSUMOS
-- -------------------------------------------------------------------------------

-- Establecimiento de proveedores para cada tipo de insumo con precios unitarios
CALL RelacionarInsumoProveedor('Kit mecanica completo', 'Valeo', 30000, @nresultado, @cmensaje);
CALL RelacionarInsumoProveedor('Kit carroceria', 'Valeo', 100000, @nresultado, @cmensaje);
CALL RelacionarInsumoProveedor('Kit electrico principal', 'Bosh', 30000, @nresultado, @cmensaje);

-- -------------------------------------------------------------------------------
-- SECCIÓN 6: GESTIÓN DE INVENTARIO Y PEDIDOS DE INSUMOS
-- -------------------------------------------------------------------------------

-- Generación de pedido inicial de insumos basado en stock mínimo
CALL AltaPedidoInsumoDetalle(@nResultado, @cMensaje);

-- Verificación del stock actual en estaciones
SELECT * FROM insumoEstacion;

-- -------------------------------------------------------------------------------
-- SECCIÓN 7: PROCESAMIENTO DE PEDIDOS DE CLIENTES
-- -------------------------------------------------------------------------------

-- ======================
-- 7.1 PEDIDO PARA CAB MOTORS
-- ======================
call AltaPedidoConcesionaria('CAB Motors', @resultado, @mensaje, @idPedido1);
SELECT @resultado, @mensaje, @idPedido1;

-- Agregar modelos al pedido (2 unidades de cada modelo)
call AgregarModeloPedido(@idPedido1, 'Toyota corolla', 2, @Resultado, @mensaje);
call AgregarModeloPedido(@idPedido1, 'Renault clio', 2, @Resultado, @mensaje);
call AgregarModeloPedido(@idPedido1, 'Ford focus', 2, @Resultado, @mensaje);

-- Cierre del pedido y cálculo de fecha de entrega
CALL CerrarPedido(@idPedido1, @nResultado, @cMensaje);
call CalcularFechaEntregaPedido(@idPedido1);

-- ======================
-- 7.2 PEDIDO PARA CAR ONE
-- ======================
call AltaPedidoConcesionaria('Car one', @resultado, @mensaje, @idPedido2);

-- Agregar modelos al pedido (2 unidades de cada modelo)
call AgregarModeloPedido(@idPedido2, 'Toyota corolla', 2, @Resultado, @mensaje);
call AgregarModeloPedido(@idPedido2, 'Renault clio', 2, @Resultado, @mensaje);
call AgregarModeloPedido(@idPedido2, 'Ford focus', 2, @Resultado, @mensaje);

-- Cierre del pedido y cálculo de fecha de entrega
CALL CerrarPedido(@idPedido2, @nResultado, @cMensaje);
call CalcularFechaEntregaPedido(@idPedido2);

-- ======================
-- 7.3 PEDIDO PARA SUR CARS
-- ======================
call AltaPedidoConcesionaria('Sur cars', @resultado, @mensaje, @idPedido3);

-- Agregar modelos al pedido (2 unidades de cada modelo)
call AgregarModeloPedido(@idPedido3, 'Toyota corolla', 2, @Resultado, @mensaje);
call AgregarModeloPedido(@idPedido3, 'Renault clio', 2, @Resultado, @mensaje);
call AgregarModeloPedido(@idPedido3, 'Ford focus', 2, @Resultado, @mensaje);

-- Cierre del pedido y cálculo de fecha de entrega
CALL CerrarPedido(@idPedido3, @nResultado, @cMensaje);
call CalcularFechaEntregaPedido(@idPedido3);

-- -------------------------------------------------------------------------------
-- SECCIÓN 8: REPORTES Y CONSULTAS DEL SISTEMA
-- -------------------------------------------------------------------------------

-- ======================
-- 8.1 REPORTE DE PEDIDOS POR CONCESIONARIA
-- ======================
-- Muestra un resumen ejecutivo de todos los pedidos activos
SELECT 
    pc.idPedidoConcesionaria AS 'N° Pedido',
    c.nombreConcesionaria AS 'Concesionaria',
    COUNT(DISTINCT mp.ModeloAuto_idModeloAuto) AS 'Cantidad de Modelos',
    SUM(mp.Cantidad) AS 'Total Vehículos Pedidos',
    pc.FechaCierrePedido AS 'Fecha Cierre',
    pc.FechaDeEntregaEstimada AS 'Fecha Entrega Estimada',
    CASE 
        WHEN pc.FechaDeEntregaEstimada IS NULL THEN 'Sin fecha estimada'
        WHEN pc.FechaDeEntregaEstimada > CURDATE() THEN 
            CONCAT('Faltan ', DATEDIFF(pc.FechaDeEntregaEstimada, CURDATE()), ' días')
        ELSE 'Entregado/En proceso'
    END AS 'Estado Entrega'
FROM PedidoConcesionaria pc
INNER JOIN Concesionaria c ON pc.Concesionaria_idConcesionaria = c.idConcesionaria
INNER JOIN ModeloAuto_has_PedidoConcesionaria mp ON pc.idPedidoConcesionaria = mp.PedidoConcesionaria_idPedidoConcesionaria
GROUP BY pc.idPedidoConcesionaria, c.nombreConcesionaria, pc.FechaCierrePedido, pc.FechaDeEntregaEstimada
ORDER BY pc.idPedidoConcesionaria;

-- ======================
-- 8.2 INVENTARIO DE VEHÍCULOS EN PRODUCCIÓN
-- ======================
-- Estado actual de todos los vehículos en el sistema
SELECT 
    v.idVehiculo AS 'ID Vehículo',
    ma.modelo AS 'Modelo',
    lm.idLineaMontaje AS 'ID Línea Montaje',
    v.estado AS 'Estado'
FROM Vehiculo v
INNER JOIN ModeloAuto_has_PedidoConcesionaria mp 
    ON v.fk_PedidoConcesionaria_idPedidoConcesionaria = mp.PedidoConcesionaria_idPedidoConcesionaria 
    AND v.fk_has_PedidoConcesionaria_ModeloAuto_idModeloAuto = mp.ModeloAuto_idModeloAuto
INNER JOIN ModeloAuto ma ON mp.ModeloAuto_idModeloAuto = ma.idModeloAuto
INNER JOIN LineaMontaje lm ON ma.idModeloAuto = lm.ModeloAuto_idModeloAuto
ORDER BY v.idVehiculo;

-- -------------------------------------------------------------------------------
-- SECCIÓN 9: SIMULACIÓN DE PROCESO PRODUCTIVO
-- -------------------------------------------------------------------------------

-- ======================
-- 9.1 INICIO DE PRODUCCIÓN
-- ======================
-- Poner en producción los primeros vehículos
call iniciarMontaje(1, @nResultado1, @cMensaje1);
call iniciarMontaje(4, @nResultado2, @cMensaje2);

-- ======================
-- 9.2 AVANCE EN LÍNEA DE MONTAJE - VEHÍCULO 1
-- ======================
-- Simulación del proceso completo para el vehículo 1 (Renault Clio)
call avanzarMontaje(1, @av1_1, @msg1_1);  -- Estación 1 (Mecánica) → Estación 2 (Chapa y Pintura)
call avanzarMontaje(1, @av1_2, @msg1_2);  -- Estación 2 (Chapa y Pintura) → Estación 3 (Electricidad)
call avanzarMontaje(1, @av1_3, @msg1_3);  -- Estación 3 (Electricidad) → FINALIZADO

-- ======================
-- 9.3 AVANCE EN LÍNEA DE MONTAJE - VEHÍCULO 4
-- ======================
-- Simulación del proceso completo para el vehículo 4 (Ford Focus)
call avanzarMontaje(4, @av2_1, @msg2_1);  -- Estación 1 → Estación 2
call avanzarMontaje(4, @av2_2, @msg2_2);  -- Estación 2 → Estación 3
call avanzarMontaje(4, @av2_3, @msg2_3);  -- Estación 3 → FINALIZADO

-- ======================
-- 9.4 LLENANDO LÍNEAS DE MONTAJE
-- ======================
-- Proceso para ocupar todas las líneas de montaje con vehículos en diferentes estados

-- Línea Renault Clio
call iniciarMontaje(2, @nResultado2, @cMensaje2);
call avanzarMontaje(2, @nResultado2, @cMensaje2);  -- Avanzar a estación 2
call avanzarMontaje(2, @nResultado2, @cMensaje2);  -- Avanzar a estación 3
call iniciarMontaje(3, @nResultado3, @cMensaje3);
call avanzarMontaje(3, @nResultado3, @cMensaje3);  -- Avanzar a estación 2
call avanzarMontaje(3, @nResultado3, @cMensaje3);  -- Avanzar a estación 3

-- Línea Toyota Corolla
call iniciarMontaje(7, @nResultado7, @cMensaje7);
call avanzarMontaje(7, @nResultado7, @cMensaje7);  -- Avanzar a estación 2
call iniciarMontaje(8, @nResultado8, @cMensaje8);
call iniciarMontaje(9, @nResultado9, @cMensaje9);
call avanzarMontaje(9, @nResultado9, @cMensaje9);  -- Avanzar a estación 2
call iniciarMontaje(10, @nResultado9, @cMensaje9);

-- Línea Ford Focus
call iniciarMontaje(5, @nResultado5, @cMensaje5);
call avanzarMontaje(5, @nResultado5, @cMensaje5);  -- Avanzar a estación 2
call avanzarMontaje(5, @nResultado5, @cMensaje5);  -- Avanzar a estación 3
call iniciarMontaje(6, @nResultado6, @cMensaje6);
call avanzarMontaje(6, @nResultado6, @cMensaje6);  -- Avanzar a estación 2
call iniciarMontaje(11, @nResultado6, @cMensaje6);

-- -------------------------------------------------------------------------------
-- SECCIÓN 10: CONSULTAS DE MONITOREO DEL SISTEMA
-- -------------------------------------------------------------------------------

-- ======================
-- 10.1 ESTADO DE VEHÍCULOS POR PEDIDO
-- ======================
-- Consulta para ver el estado de producción de todos los vehículos de un pedido específico
SET @pedidoId := 1;

SELECT 
    v.idVehiculo AS chasis, 
    CASE 
        WHEN v.estado = 'Finalizado' THEN 'Sí' 
        ELSE 'No' 
    END AS esta_finalizado,
    CASE 
        WHEN v.estado = 'Finalizado' THEN NULL 
        WHEN cur.Estacion_idEstacion IS NULL THEN 'Sin iniciar' 
        ELSE CONCAT('Estación ', cur.Estacion_idEstacion, ' - ', e.actividad) 
    END AS estacion_actual
FROM PlantaAutomotrizEnsambladora.Vehiculo v
LEFT JOIN (
    -- Estación abierta (sin FechaFin) más reciente por vehículo
    SELECT r1.Vehiculo_idVehiculo, r1.Estacion_idEstacion
    FROM PlantaAutomotrizEnsambladora.RegistroEstacion r1
    JOIN (
        SELECT Vehiculo_idVehiculo, MAX(FechaInicio) AS max_inicio
        FROM PlantaAutomotrizEnsambladora.RegistroEstacion
        WHERE FechaFin IS NULL
        GROUP BY Vehiculo_idVehiculo
    ) t ON t.Vehiculo_idVehiculo = r1.Vehiculo_idVehiculo AND t.max_inicio = r1.FechaInicio
) cur ON cur.Vehiculo_idVehiculo = v.idVehiculo
LEFT JOIN PlantaAutomotrizEnsambladora.Estacion e ON e.idEstacion = cur.Estacion_idEstacion
WHERE v.fk_PedidoConcesionaria_idPedidoConcesionaria = @pedidoId
ORDER BY v.idVehiculo;

-- ======================
-- 10.2 INSUMOS REQUERIDOS POR PEDIDO
-- ======================
-- Consulta para calcular los insumos necesarios para completar un pedido
SET @pedidoId := 1;

SELECT 
    i.idInsumo AS codigo_insumo, 
    i.tipoInsumo AS insumo, 
    i.UnidadDeMedida AS unidad, 
    SUM(ie.Cantidad * mp.Cantidad) AS cantidad_requerida
FROM PlantaAutomotrizEnsambladora.ModeloAuto_has_PedidoConcesionaria mp
JOIN PlantaAutomotrizEnsambladora.LineaMontaje lm ON lm.ModeloAuto_idModeloAuto = mp.ModeloAuto_idModeloAuto
JOIN PlantaAutomotrizEnsambladora.Estacion e ON e.LineaMontaje_idLineaMontaje = lm.idLineaMontaje
JOIN PlantaAutomotrizEnsambladora.InsumoEstacion ie ON ie.Estacion_idEstacion = e.idEstacion
JOIN PlantaAutomotrizEnsambladora.Insumo i ON i.idInsumo = ie.Insumo_idInsumo
WHERE mp.PedidoConcesionaria_idPedidoConcesionaria = @pedidoId
GROUP BY i.idInsumo, i.tipoInsumo, i.UnidadDeMedida
ORDER BY i.idInsumo;

-- ======================
-- 10.3 TIEMPO PROMEDIO DE ENSAMBLAJE POR LÍNEA
-- ======================
-- Consulta para analizar la eficiencia de cada línea de producción
SET @linea := 1;

WITH tiempos AS (
    SELECT 
        r.Vehiculo_idVehiculo, 
        TIMESTAMPDIFF(HOUR, MIN(r.FechaInicio), MAX(r.FechaFin)) AS horasConstruccion
    FROM RegistroEstacion r
    JOIN Estacion e ON r.Estacion_idEstacion = e.idEstacion
    JOIN Vehiculo v ON v.idVehiculo = r.Vehiculo_idVehiculo
    WHERE e.LineaMontaje_idLineaMontaje = @linea 
      AND v.estado = 'Finalizado' 
      AND r.FechaFin IS NOT NULL
    GROUP BY r.Vehiculo_idVehiculo
)
SELECT 
    ROUND(AVG(horasConstruccion), 2) AS PromedioHorasConstruccion,
    ROUND(AVG(horasConstruccion) / 24, 2) AS PromedioDiasConstruccion
FROM tiempos;

-- ======================
-- 10.4 ESTADO ACTUAL DE LAS LÍNEAS DE MONTAJE
-- ======================
-- Consultas para verificar qué vehículos están ocupando cada estación de las líneas

-- Línea 1 (Renault Clio)
SET @linea := 1;
SELECT 
    e.idEstacion, 
    e.actividad, 
    r.Vehiculo_idVehiculo AS VehiculoEnEstacion
FROM Estacion e
LEFT JOIN RegistroEstacion r ON r.Estacion_idEstacion = e.idEstacion AND r.FechaFin IS NULL
WHERE e.LineaMontaje_idLineaMontaje = @linea
ORDER BY e.orden;

-- Línea 2 (Ford Focus)
SET @linea := 2;
SELECT 
    e.idEstacion, 
    e.actividad, 
    r.Vehiculo_idVehiculo AS VehiculoEnEstacion
FROM Estacion e
LEFT JOIN RegistroEstacion r ON r.Estacion_idEstacion = e.idEstacion AND r.FechaFin IS NULL
WHERE e.LineaMontaje_idLineaMontaje = @linea
ORDER BY e.orden;

-- Línea 3 (Toyota Corolla)
SET @linea := 3;
SELECT 
    e.idEstacion, 
    e.actividad, 
    r.Vehiculo_idVehiculo AS VehiculoEnEstacion
FROM Estacion e
LEFT JOIN RegistroEstacion r ON r.Estacion_idEstacion = e.idEstacion AND r.FechaFin IS NULL
WHERE e.LineaMontaje_idLineaMontaje = @linea
ORDER BY e.orden;

-- ======================
-- 10.5 REGISTRO COMPLETO DE PRODUCCIÓN
-- ======================
-- Consulta para ver todo el historial de producción


-- =============================================================================
-- FIN DEL SCRIPT DE INICIALIZACIÓN DEL SISTEMA
-- =============================================================================