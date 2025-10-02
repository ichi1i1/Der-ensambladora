-- -------------------------------------------------------------------------------
									-- ABM --
-- -------------------------------------------------------------------------------
-- alta de consecionarios
Call altaConcesionaria('Fiat',@resultado,@mensaje);
call altaConcesionaria ('Ford', @alta,@mensaje);
call altaConcesionaria ('Toyota', @alta,@mensaje);
select @alta,@mensaje;
-- SELECT * from concesionaria;
-- alta de provedores
CALL altaProveedor( 'Michelin', @nResultado, @cMensaje);
CALL altaProveedor( 'Valeo', @nResultado, @cMensaje);
CALL altaProveedor('Bosh', @nResultado, @cMensaje);
select@nResultado, @cMensaje;
-- SELECT * from Proveedor;
 
-- Insertar insumos básicos para ensamblar un auto
CALL AgregarInsumo('Carrocería', 'Unidades', @result1, @msg1);
CALL AgregarInsumo('Motor', 'Unidades', @result2, @msg2);
CALL AgregarInsumo('Transmisión', 'Unidades', @result3, @msg3);
CALL AgregarInsumo('Ruedas', 'Unidades', @result4, @msg4);
CALL AgregarInsumo('Asientos', 'Unidades', @result5, @msg5);
CALL AgregarInsumo('Volante', 'Unidades', @result6, @msg6);
CALL AgregarInsumo('Pintura', 'Litros', @result7, @msg7);
CALL AgregarInsumo('Parabrisas', 'Unidades', @result8, @msg8);
CALL AgregarInsumo('Luces', 'Unidades', @result9, @msg9);
CALL AgregarInsumo('Sistema eléctrico', 'Unidades', @result10, @msg10);
CALL AgregarInsumo('Frenos', 'Unidades', @result11, @msg11);
CALL AgregarInsumo('Suspensión', 'Unidades', @result12, @msg12);

-- Ver resultados
SELECT @result1, @msg1;
SELECT @result2, @msg2;
SELECT @result3, @msg3;
SELECT @result4, @msg4;
SELECT @result5, @msg5;
SELECT @result6, @msg6;
SELECT @result7, @msg7;
SELECT @result8, @msg8;
SELECT @result9, @msg9;
SELECT @result10, @msg10;
SELECT @result11, @msg11;
SELECT @result12, @msg12;

-- Ver todos los insumos insertados
SELECT * FROM insumo;


