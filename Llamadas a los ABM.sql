-- -------------------------------------------------------------------------------
									-- ABM --
-- -------------------------------------------------------------------------------
-- alta de consecionarios
Call altaConcesionaria('Fiat',@resultado,@mensaje);
call altaConcesionaria ('Ford', @alta,@mensaje);
call altaConcesionaria ('Toyota', @alta,@mensaje);
select @alta,@mensaje;
SELECT * from concesionaria;
-- Baja de concesionarias (por id)
CALL bajaConcesionaria('1', @resultado, @mensaje);
CALL bajaConcesionaria(2, @resultado, @mensaje);
CALL bajaConcesionaria(3, @resultado, @mensaje);
SELECT @resultado, @mensaje;
-- Modificar nombre de concesionarias
CALL modificarNombreConcesionaria(1, 'Fiat Argentina', @resultado, @mensaje);
CALL modificarNombreConcesionaria(2, 'Ford Motors', @resultado, @mensaje);
CALL modificarNombreConcesionaria(3, 'Toyota SA', @resultado, @mensaje);
SELECT @resultado, @mensaje;
-- SELECT * from concesionaria;
-- alta de provedores
CALL altaProveedor( 'Michelin', @nResultado, @cMensaje);
CALL altaProveedor( 'Valeo', @nResultado, @cMensaje);
CALL altaProveedor('Bosh', @nResultado, @cMensaje);
select@nResultado, @cMensaje;
select * from proveedor;
-- Baja de proveedores (por id)
CALL BajaProveedor(1, @nResultado, @cMensaje);
CALL BajaProveedor(2, @nResultado, @cMensaje);
CALL BajaProveedor(3, @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- Modificar nombre de proveedores
CALL ModificarNombreProveedor(1, 'Michelin SA', @nResultado, @cMensaje);
CALL ModificarNombreProveedor(2, 'Valeo Group', @nResultado, @cMensaje);
CALL ModificarNombreProveedor(3, 'Bosch GmbH', @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- SELECT * from Proveedor;
 
-- Insertar insumos 
CALL AgregarInsumo('Carrocería', 'Unidades', 2, 500, @result1, @msg1);
CALL AgregarInsumo('Transmisión', 'Unidades', 2, 1000, @result3, @msg3);
CALL AgregarInsumo('Ruedas', 'Unidades', 1, 700, @result4, @msg4);
CALL AgregarInsumo('Volante', 'Unidades', 2, 200, @result6, @msg6);
CALL AgregarInsumo('Parabrisas', 'Unidades', 2, 500, @result8, @msg8);
CALL AgregarInsumo('Luces', 'Unidades', 2, 300, @result9, @msg9);
CALL AgregarInsumo('Sistema eléctrico', 'Unidades', 2, 700, @result10, @msg10);
CALL AgregarInsumo('Frenos', 'Unidades', 2, 400, @result11, @msg11);
CALL AgregarInsumo('Suspensión', 'Unidades', 2, 300, @result12, @msg12);

-- Ver resultados
SELECT @result1, @msg1;
SELECT @result3, @msg3;
SELECT @result4, @msg4;
SELECT @result6, @msg6;
SELECT @result8, @msg8;
SELECT @result9, @msg9;
SELECT @result10, @msg10;
SELECT @result11, @msg11;
SELECT @result12, @msg12;

-- Ver todos los insumos insertados
SELECT * FROM insumo;

-- Baja de insumos 
CALL BajaInsumo(1, @res, @msg);
CALL BajaInsumo(2, @res, @msg);
CALL BajaInsumo(3, @res, @msg);
CALL BajaInsumo(4, @res, @msg);
CALL BajaInsumo(5, @res, @msg);
CALL BajaInsumo(6, @res, @msg);
CALL BajaInsumo(7, @res, @msg);
CALL BajaInsumo(8, @res, @msg);
CALL BajaInsumo(9, @res, @msg);
SELECT @res, @msg;

-- Modificar insumo 
CALL ModificarInsumo(1, 'Carrocería', 'Unidades', 2, 550, @res, @msg);
CALL ModificarInsumo(2, 'Transmisión', 'Unidades', 2, 1100, @res, @msg);
CALL ModificarInsumo(3, 'Ruedas', 'Unidades', 1, 750, @res, @msg);
CALL ModificarInsumo(4, 'Volante', 'Unidades', 2, 250, @res, @msg);
CALL ModificarInsumo(5, 'Parabrisas', 'Unidades', 2, 550, @res, @msg);
CALL ModificarInsumo(6, 'Luces', 'Unidades', 2, 350, @res, @msg);
CALL ModificarInsumo(7, 'Sistema eléctrico', 'Unidades', 2, 750, @res, @msg);
CALL ModificarInsumo(8, 'Frenos', 'Unidades', 2, 450, @res, @msg);
CALL ModificarInsumo(9, 'Suspensión', 'Unidades', 2, 350, @res, @msg);
SELECT @res, @msg;

-- -------------------------------------------------------------------------------
-- ABM PedidoConcesionaria con fechas dentro del CALL
-- -------------------------------------------------------------------------------

-- Alta PedidoConcesionaria


-- --- ALTA ---
CALL AltaPedidoConcesionaria(1, 1, DATE_ADD('2025-09-16', INTERVAL 7 DAY), '2025-09-16', CURDATE(), @nResultado, @cMensaje);
CALL AltaPedidoConcesionaria(2, 2, DATE_ADD('2025-09-17', INTERVAL 7 DAY), '2025-09-17', CURDATE(), @nResultado, @cMensaje);
CALL AltaPedidoConcesionaria(3, 3, DATE_ADD('2025-09-18', INTERVAL 7 DAY), '2025-09-18', CURDATE(), @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- Ver pedidos insertados
SELECT * FROM PedidoConcesionaria;
-- --- MODIFICAR ---
CALL ModificarPedidoConcesionaria(1, 2, DATE_ADD('2025-09-17', INTERVAL 7 DAY), '2025-09-17', CURDATE(), @nResultado, @cMensaje);
CALL ModificarPedidoConcesionaria(2, 3, DATE_ADD('2025-09-18', INTERVAL 7 DAY), '2025-09-18', CURDATE(), @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- Ver pedidos modificados
SELECT * FROM PedidoConcesionaria;
-- --- BAJA ---
CALL BajaPedidoConcesionaria(1, @nResultado, @cMensaje);
CALL BajaPedidoConcesionaria(2, @nResultado, @cMensaje);
CALL BajaPedidoConcesionaria(3, @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- Ver pedidos restantes
SELECT * FROM PedidoConcesionaria;

-- -------------------------------------------------------------------------------
-- ABM Moedelo
-- -------------------------------------------------------------------------------

-- Alta Modelo
CALL altaModelo('Renault clio', @nresultado,@cmensaje);
CALL altaModelo('Ford focus', @nresultado,@cmensaje);
CALL altaModelo('Dodge ram', @nresultado,@cmensaje);
CALL altaModelo('Toyota hilux', @nresultado,@cmensaje);
CALL altaModelo('Toyota corolla', @nresultado,@cmensaje);
-- Baja Modelo
CALL bajaModelo('Renault clio', @nresultado,@cmensaje);
CALL BajaModelo('Ford focus', @nresultado,@cmensaje);
CALL bajaModelo('Dodge ram', @nresultado,@cmensaje);
CALL bajaModelo('Toyota hilux', @nresultado,@cmensaje);
CALL bajaModelo('Toyota corolla', @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;


-- -------------------------------------------------------------------------------
-- ABM Linea de montaje
-- -------------------------------------------------------------------------------

-- Alta linea de montaje
CALL altaLineaMontaje('Renault clio', 1, @nresultado,@cmensaje);
CALL altaLineaMontaje('Ford focus', 3, @nresultado,@cmensaje);
CALL altaLineaMontaje('Dodge ram', 8, @nresultado,@cmensaje);
CALL altaLineaMontaje('Toyota hilux', 6, @nresultado,@cmensaje);
CALL altaLineaMontaje('Toyota corolla', 6, @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;
select * from ModeloAuto;
select * from LineaMontaje;

-- Baja linea de montaje
CALL bajaLineaMontaje('Renault clio', @nresultado,@cmensaje);
CALL bajaLineaMontaje('Ford focus', @nresultado,@cmensaje);
CALL bajaLineaMontaje('Dodge ram', @nresultado,@cmensaje);
CALL bajaLineaMontaje('Toyota hilux', @nresultado,@cmensaje);
CALL bajaLineaMontaje('Toyota corolla', @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;

-- Modificacion linea de montaje
CALL modificacionLineaMontaje('Renault clio', 2, @nresultado,@cmensaje);
CALL modificacionMontaje('Ford focus', 4, @nresultado,@cmensaje);
CALL modificacionMontaje('Dodge ram', 10, @nresultado,@cmensaje);
CALL modificacionMontaje('Toyota hilux', 7, @nresultado,@cmensaje);
CALL modificacionLineaMontaje('Toyota corolla', 5, @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;

-- -------------------------------------------------------------------------------
-- ABM Vehiculo
-- -------------------------------------------------------------------------------

-- Alta Vehiculo
CALL altaVehiculo(3891, @nresultado,@cmensaje);
CALL altaVehiculo(0178, @nresultado,@cmensaje);
CALL altaVehiculo(3018, @nresultado,@cmensaje);
CALL altaVehiculo(7107, @nresultado,@cmensaje);
CALL altaVehiculo(6051, @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;
select * from Vehiculo;

-- Baja Vehiculo
SET SQL_SAFE_UPDATES = 0;
CALL bajaVehiculo(3891, @nresultado,@cmensaje);
CALL bajaVehiculo(0178, @nresultado,@cmensaje);
CALL bajaVehiculo(3018, @nresultado,@cmensaje);
CALL bajaVehiculo(7107, @nresultado,@cmensaje);
CALL bajaVehiculo(6051, @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;
SET SQL_SAFE_UPDATES = 1;

-- -------------------------------------------------------------------------------
-- ABM Estacion
-- -------------------------------------------------------------------------------

-- Alta Estacion
CALL altaEstacion('Mecanica', @nresultado,@cmensaje);
CALL altaEstacion('Chapa y pintura', @nresultado,@cmensaje);
CALL altaEstacion('electricidad', @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;
select * from Estacion;

-- Baja Estacion
SET SQL_SAFE_UPDATES = 0;
CALL bajaEstacion('Mecanica', @nresultado,@cmensaje);
CALL bajaEstacion('Chapa y pintura', @nresultado,@cmensaje);
CALL bajaEstacion('electricidad', @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;
SET SQL_SAFE_UPDATES = 1;



