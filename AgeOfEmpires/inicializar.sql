CREATE OR REPLACE PROCEDURE INICIALIZAR 
  ( idReino int, cantOro float, cantMadera float, cantHierro float)
IS
  CURSOR curReino(identReino int) is
   SELECT tesoro_idtesoro FROM reino where idreino = identReino;
   tesoro_idtesoro reino.tesoro_idtesoro%type;
BEGIN
  open curReino(idReino);
    LOOP
     fetch curReino into tesoro_idtesoro;
     UPDATE Tesoro 
     SET cantidaddeoro = cantOro , cantidaddemadera = cantMadera, cantidaddehierro = cantHierro
     WHERE idTesoro = tesoro_idtesoro;
    END LOOP;
  close curReino;
END;
/