-- -------------------------------------------------------------------------------
-- ABM - SOLO ALTAS
-- -------------------------------------------------------------------------------

-- Alta de concesionarias
Call altaConcesionaria('Renault',@resultado,@mensaje);
call altaConcesionaria ('Ford', @alta,@mensaje);
call altaConcesionaria ('Toyota', @alta,@mensaje);
select @alta,@mensaje;

-- Alta de provedores
CALL altaProveedor( 'Michelin', @nResultado, @cMensaje);
CALL altaProveedor( 'Valeo', @nResultado, @cMensaje);
CALL altaProveedor('Bosh', @nResultado, @cMensaje);
select@nResultado, @cMensaje;

-- Insertar insumos 
-- INSUMOS GENERALES PARA MECÁNICA
CALL AltaInsumo('Kit motor completo', 'unidad', @id1, @resultado, @mensaje);
CALL AltaInsumo('Kit transmisión', 'unidad', @id2, @resultado, @mensaje);
CALL AltaInsumo('Kit dirección', 'unidad', @id3, @resultado, @mensaje);
CALL AltaInsumo('Kit ejes y suspensión', 'unidad', @id4, @resultado, @mensaje);
CALL AltaInsumo('Kit frenos', 'unidad', @id5, @resultado, @mensaje);


-- INSUMOS GENERALES PARA ELECTRICIDAD
CALL AltaInsumo('Kit eléctrico principal', 'unidad', @id6, @resultado, @mensaje);
CALL AltaInsumo('Kit iluminación', 'unidad', @id7, @resultado, @mensaje);
CALL AltaInsumo('Kit tablero instrumentos', 'unidad', @id8, @resultado, @mensaje);

-- INSUMOS GENERALES PARA CHAPA Y PINTURA
CALL AltaInsumo('Kit carrocería', 'unidad', @id9, @resultado, @mensaje);
CALL AltaInsumo('Kit pintura completa', 'unidad', @id10, @resultado, @mensaje);
CALL AltaInsumo('Kit vidrios', 'unidad', @id11, @resultado, @mensaje);
SELECT @id11, @resultado, @mensaje;

-- CALL AltaPedidoConcesionaria(1, 1, DATE_ADD('2025-09-16', INTERVAL 7 DAY), '2025-09-16', CURDATE(), @nResultado, @cMensaje);
-- CALL AltaPedidoConcesionaria(2, 2, DATE_ADD('2025-09-17', INTERVAL 7 DAY), '2025-09-17', CURDATE(), @nResultado, @cMensaje);
-- CALL AltaPedidoConcesionaria(3, 3, DATE_ADD('2025-09-18', INTERVAL 7 DAY), '2025-09-18', CURDATE(), @nResultado, @cMensaje);
-- SELECT @nResultado, @cMensaje;

-- Alta Modelo
CALL altaModelo('Renault clio', @nresultado,@cmensaje);
CALL altaModelo('Ford focus', @nresultado,@cmensaje);
CALL altaModelo('Toyota corolla', @nresultado,@cmensaje);

-- Alta linea de montaje
CALL altaLineaMontaje('Renault clio', 35, @nresultado,@cmensaje);
CALL altaLineaMontaje('Ford focus', 35, @nresultado,@cmensaje);
CALL altaLineaMontaje('Toyota corolla', 35, @nresultado,@cmensaje);
SELECT @nResultado, @cMensaje;
select * from ModeloAuto;





-- Alta Vehiculo     PROVICIONAL
CALL altaVehiculo(3891, @nresultado,@cmensaje);
CALL altaVehiculo(0178, @nresultado,@cmensaje);
CALL altaVehiculo(3018, @nresultado,@cmensaje);
CALL altaVehiculo(7107, @nresultado,@cmensaje);
CALL altaVehiculo(6051, @nresultado,@cmensaje);
SELECT @nresultado, @cmensaje;







-- Alta Estacion
-- Para Renault Clio
CALL altaEstacion('Mecanica', 'Renault clio', @resultado, @mensaje);
SELECT @resultado, @mensaje;
CALL altaEstacion('Chapa y pintura', 'Renault clio', @resultado, @mensaje);
SELECT @resultado, @mensaje;
CALL altaEstacion('Electricidad', 'Renault clio', @resultado, @mensaje);
SELECT @resultado, @mensaje;

-- Para Ford Focus
CALL altaEstacion('Mecanica', 'Ford focus', @resultado, @mensaje);
SELECT @resultado, @mensaje;
CALL altaEstacion('Chapa y pintura', 'Ford focus', @resultado, @mensaje);
SELECT @resultado, @mensaje;
CALL altaEstacion('Electricidad', 'Ford focus', @resultado, @mensaje);
SELECT @resultado, @mensaje;

-- Para Toyota Corolla
CALL altaEstacion('Mecanica', 'Toyota corolla', @resultado, @mensaje);
SELECT @resultado, @mensaje;
CALL altaEstacion('Chapa y pintura', 'Toyota corolla', @resultado, @mensaje);
SELECT @resultado, @mensaje;
CALL altaEstacion('Electricidad', 'Toyota corolla', @resultado, @mensaje);
SELECT @resultado, @mensaje;
-- SELECT @nResultado, @cMensaje;

select *from LineaMontaje;
