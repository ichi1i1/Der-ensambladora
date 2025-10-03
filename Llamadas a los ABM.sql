-- -------------------------------------------------------------------------------
-- ABM - SOLO ALTAS
-- -------------------------------------------------------------------------------

-- Alta de concesionarias
Call altaConcesionaria('Fiat',@resultado,@mensaje);
call altaConcesionaria ('Ford', @alta,@mensaje);
call altaConcesionaria ('Toyota', @alta,@mensaje);
select @alta,@mensaje;

-- Alta de provedores
CALL altaProveedor( 'Michelin', @nResultado, @cMensaje);
CALL altaProveedor( 'Valeo', @nResultado, @cMensaje);
CALL altaProveedor('Bosh', @nResultado, @cMensaje);
select@nResultado, @cMensaje;

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

-- Alta PedidoConcesionaria
CALL AltaPedidoConcesionaria(1, 1, DATE_ADD('2025-09-16', INTERVAL 7 DAY), '2025-09-16', CURDATE(), @nResultado, @cMensaje);
CALL AltaPedidoConcesionaria(2, 2, DATE_ADD('2025-09-17', INTERVAL 7 DAY), '2025-09-17', CURDATE(), @nResultado, @cMensaje);
CALL AltaPedidoConcesionaria(3, 3, DATE_ADD('2025-09-18', INTERVAL 7 DAY), '2025-09-18', CURDATE(), @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;

-- Alta Modelo
CALL altaModelo('Renault clio', @nresultado,@cmensaje);
CALL altaModelo('Ford focus', @nresultado,@cmensaje);
CALL altaModelo('Dodge ram', @nresultado,@cmensaje);
CALL altaModelo('Toyota hilux', @nresultado,@cmensaje);
CALL altaModelo('Toyota corolla', @nresultado,@cmensaje);

-- Alta linea de montaje
CALL altaLineaMontaje('Renault clio', 1, @nresultado,@cmensaje);
CALL altaLineaMontaje('Ford focus', 3, @nresultado,@cmensaje);
CALL altaLineaMontaje('Dodge ram', 8, @nresultado,@cmensaje);
CALL altaLineaMontaje('Toyota hilux', 6, @nresultado,@cmensaje);
CALL altaLineaMontaje('Toyota corolla', 6, @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;
select * from ModeloAuto;
-- Alta Vehiculo
CALL altaVehiculo(3891, @nresultado,@cmensaje);
CALL altaVehiculo(0178, @nresultado,@cmensaje);
CALL altaVehiculo(3018, @nresultado,@cmensaje);
CALL altaVehiculo(7107, @nresultado,@cmensaje);
CALL altaVehiculo(6051, @nresultado,@cmensaje);
SELECT @nresultado, @cmensaje;

-- Alta Estacion
CALL altaEstacion('Mecanica', @nresultado,@cmensaje);
CALL altaEstacion('Chapa y pintura', @nresultado,@cmensaje);
CALL altaEstacion('electricidad', @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;