CREATE OR REPLACE PROCEDURE comprar
   ( recurso varchar2 , reino varchar2, cantidad float )
IS
    CURSOR cursor_reino is
        SELECT IDReino, IDTesoro, cantidadDeMadera, cantidadDeHierro, cantidadDeOro
        from Reino
        INNER JOIN Tesoro ON Reino.Tesoro_IDTesoro = Tesoro.IDTesoro
        where Reino.nombre = UPPER(reino);
    CURSOR cursor_reservaCentral is
        SELECT IDReserva, precioMadera, precioHierro, cantMadera, cantHierro
        from ReservaCentral;
        
    totalCostoMadera float := 0;
    totalCostoHierro float := 0;
BEGIN
    FOR indice IN cursor_reino
    LOOP
        FOR indice2 IN cursor_reservaCentral
        LOOP
            IF recurso = 'madera' THEN
                totalCostoMadera := cantidad * indice2.precioMadera;
               IF cantidad <= indice2.cantMadera AND totalCostoMadera <= indice.cantidadDeOro THEN 
                    UPDATE Tesoro
                    SET cantidadDeMadera = cantidadDeMadera + cantidad, cantidadDeOro = cantidadDeOro - totalCostoMadera
                    WHERE idTesoro = indice.idTesoro;
                    
                    UPDATE Reino
                    SET cantidadCoronas = cantidadCoronas + 5
                    WHERE idReino = indice.idReino;
                    
                    UPDATE ReservaCentral
                    SET cantOro = cantOro + totalCostoMadera
                    WHERE idReserva = indice2.idReserva;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('No hay suficiente madera en la reserva Central o No tiene suficiente Oro en el reino');
                END IF;
            ELSE
                totalCostoHierro := cantidad * indice2.precioHierro;
                IF cantidad <= indice2.cantHierro AND totalCostoHierro <= indice.cantidadDeOro THEN
                    UPDATE Tesoro
                    SET cantidadDeHierro = cantidadDeHierro + cantidad, cantidadDeOro = cantidadDeOro - totalCostoHierro
                    WHERE idTesoro = indice.idTesoro;
                    
                    UPDATE Reino
                    SET cantidadCoronas = cantidadCoronas + 5
                    WHERE idReino = indice.idReino;
                    
                    UPDATE ReservaCentral
                    SET cantOro = cantOro + totalCostoHierro
                    WHERE idReserva = indice2.idReserva;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('No hay suficiente hierro en la reserva Central o No tiene suficiente Oro en el reino');
                END IF;
            END IF;
            
            INSERT into Bitacora values(bitacora_sequence.nextval, sysdate, indice.cantidadDeOro,indice.cantidadDeHierro,indice.cantidadDeMadera,0,'CMP', indice.IDReino);
            commit;
        END LOOP;
    END LOOP;

END;
/