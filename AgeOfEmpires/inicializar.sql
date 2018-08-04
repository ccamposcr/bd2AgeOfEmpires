CREATE OR REPLACE PROCEDURE inicializar
  ( idReino int, oro int, madera int, hierro int, coronas int)
IS
  CURSOR curReino(identReino int) is
   SELECT tesoro_idtesoro FROM reino where idreino = identReino;
   tesoro_idtesoro reino.tesoro_idtesoro%type;
BEGIN
     UPDATE tesoro 
     SET cantOro = oro, cantMadera = madera, cantHierro = hierro, puntosdecoronas = coronas
     WHERE idtesoro = idReino;
     dbms_output.put_line( 'La informacion ingreso con exito ' );
END;
/
