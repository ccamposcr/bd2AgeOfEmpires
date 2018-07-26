CREATE OR REPLACE PROCEDURE inicializar
  ( idReino int, cantOro int, cantMadera int, cantHierro int, cantCoronas int)
IS
  CURSOR curReino(identReino int) is
   SELECT tesoro_idtesoro FROM reino where idreino = identReino;
   tesoro_idtesoro reino.tesoro_idtesoro%type;
BEGIN
  open curReino(idReino);
    LOOP
     fetch curReino into tesoro_idtesoro;
     UPDATE tesoro 
     SET cantoro = cantOro , cantmadera = cantMadera, canthierro = cantHierro, puntosdecoronas = cantCoronas 
     WHERE idtesoro = idReino;
     dbms_output.put_line( 'La informacion ingreso con exito ');
     exit when curReino%notfound;
    END LOOP;
  close curReino;
END inicializar;
/
