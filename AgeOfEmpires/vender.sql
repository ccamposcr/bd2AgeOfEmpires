CREATE OR REPLACE PROCEDURE vender
   ( recurso varchar2 , reino varchar2, cantidad float )
IS
    CURSOR cursor_reino is
        SELECT IDReino, IDTesoro, cantMadera, cantHierro, cantOro, cantCoronas
        from Reino
        INNER JOIN Tesoro ON Reino.Tesoro_IDTesoro = Tesoro.IDTesoro
        where UPPER(Reino.nombre) = UPPER(reino);
        
    CURSOR cursor_reservaCentral is
        SELECT IDReserva, precioMadera, precioHierro, cantMadera, cantHierro, cantOro
        from ReservaCentral;
        
    totalCostoMadera float := 0;
    totalCostoHierro float := 0;
    calculoProporcion float := 0;
    
BEGIN
    FOR indice IN cursor_reino
    LOOP
        FOR indice2 IN cursor_reservaCentral
        LOOP
            IF recurso = 'madera' THEN
                totalCostoMadera := cantidad * indice2.precioMadera;
               IF cantidad <= indice.cantMadera AND totalCostoMadera <= indice2.cantOro THEN 
                    UPDATE Tesoro
                    SET cantMadera = cantMadera - cantidad, cantOro = cantOro + totalCostoMadera
                    WHERE idTesoro = indice.idTesoro;
                    
                    UPDATE Reino
                    SET cantCoronas = cantCoronas + 10
                    WHERE idReino = indice.idReino;
                    
                    calculoProporcion := (cantidad * 100) / indice2.cantMadera;
                    
                    UPDATE ReservaCentral
                    SET cantOro = cantOro - totalCostoMadera, precioMadera = (precioMadera - (precioMadera * calculoProporcion) / 100), cantMadera = cantMadera + cantidad 
                    WHERE idReserva = indice2.idReserva;
                    
                ELSE
                    DBMS_OUTPUT.PUT_LINE('No hay suficiente oro en la reserva Central o No tiene suficiente madera en el reino');
                END IF;
            ELSE
                totalCostoHierro := cantidad * indice2.precioHierro;
                IF cantidad <= indice.cantHierro AND totalCostoHierro <= indice2.cantOro THEN
                    UPDATE Tesoro
                    SET cantHierro = cantHierro - cantidad, cantOro = cantOro + totalCostoHierro
                    WHERE idTesoro = indice.idTesoro;
                    
                    UPDATE Reino
                    SET cantCoronas = cantCoronas + 10
                    WHERE idReino = indice.idReino;
                    
                    calculoProporcion := (cantidad * 100) / indice2.cantHierro;
                    
                    UPDATE ReservaCentral
                    SET cantOro = cantOro - totalCostoHierro, precioHierro = (precioHierro - (precioHierro * calculoProporcion) / 100), cantHierro = cantHierro + cantidad
                    WHERE idReserva = indice2.idReserva;
                    
                ELSE
                    DBMS_OUTPUT.PUT_LINE('No hay suficiente oro en la reserva Central o No tiene suficiente hierro en el reino');
                END IF;
            END IF;
            
            INSERT into Bitacora values(bitacora_sequence.nextval, sysdate, indice.cantOro,indice.cantHierro,indice.cantMadera,indice.cantCoronas,'VTA', indice.IDReino);
            
        END LOOP;
    END LOOP;
commit;
END;
/