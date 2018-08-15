CREATE OR REPLACE PROCEDURE entrenarEjercitos
   ( tropa varchar2 , reino varchar2, cantidad float )
IS
    CURSOR cursor_reino is
        SELECT IDReino, IDTesoro, cantMadera, cantHierro, cantOro, cantCoronas
        from Reino
        INNER JOIN Tesoro ON Reino.Tesoro_IDTesoro = Tesoro.IDTesoro
        where UPPER(Reino.nombre) = UPPER(reino);
        
    CURSOR cursor_reservaCentral is
        SELECT IDReserva, precioMadera, precioHierro, cantMadera, cantHierro, cantOro
        from ReservaCentral;
    
    CURSOR cursor_tropas is
        SELECT IDTROPA,TIPOTROPA,NOMBRETROPA,COSTOORO,COSTOMADERA,COSTOHIERRO,SUMACORONAS,PUNTOSATAQUE
        from Tropas
        where UPPER(Tropas.nombreTropa) = UPPER(tropa);
        
    calculoProporcionMadera float := 0;
    calculoProporcionHierro float := 0;
    nuevoOroReserva number := 0;
    nuevoHierroReserva number := 0;
    nuevoMaderaReserva number := 0;
    nuevoPrecioMadera float := 0;
    nuevoPrecioHierro float := 0;
    
BEGIN
    FOR indice IN cursor_reino
    LOOP
       FOR indice2 IN cursor_tropas
       LOOP
            IF ((indice2.costoOro * cantidad) <= indice.cantOro) and ( (indice2.costoMadera * cantidad) <= indice.cantMadera ) and ( (indice2.costoHierro * cantidad) <= indice.cantHierro )  THEN
                UPDATE Tesoro
                SET cantHierro = cantHierro - (indice2.costoHierro * cantidad), cantOro = cantOro - (indice2.costoOro * cantidad), cantMadera = cantMadera - (indice2.costoMadera * cantidad)
                WHERE idTesoro = indice.idTesoro;
                
                CASE UPPER(tropa)
                    WHEN 'ARQUERAS' then
                        UPDATE Reino
                        SET cantArqueras = cantArqueras + cantidad, cantCoronas = cantCoronas + (indice2.sumaCoronas * cantidad), puntosAtaque = puntosAtaque + (indice2.puntosAtaque * cantidad)
                        WHERE idReino = indice.idReino;
                    WHEN 'PIQUEROS' then
                        UPDATE Reino
                        SET cantPiqueros = cantPiqueros + cantidad, cantCoronas = cantCoronas + (indice2.sumaCoronas * cantidad), puntosAtaque = puntosAtaque + (indice2.puntosAtaque * cantidad)
                        WHERE idReino = indice.idReino;
                    WHEN 'CABALLEROS' then
                        UPDATE Reino
                        SET cantCaballeros = cantCaballeros + cantidad, cantCoronas = cantCoronas + (indice2.sumaCoronas * cantidad), puntosAtaque = puntosAtaque + (indice2.puntosAtaque * cantidad)
                        WHERE idReino = indice.idReino;
                    WHEN 'MAGOS' then
                        UPDATE Reino
                        SET cantMagos = cantMagos + cantidad, cantCoronas = cantCoronas + (indice2.sumaCoronas * cantidad), puntosAtaque = puntosAtaque + (indice2.puntosAtaque * cantidad)
                        WHERE idReino = indice.idReino;
                END CASE;
                
                FOR indice3 IN cursor_reservaCentral
                LOOP
                    calculoProporcionMadera := (cantidad * 100) / indice3.cantMadera;
                    calculoProporcionHierro := (cantidad * 100) / indice3.cantHierro;
                    nuevoOroReserva :=  indice3.cantOro + (indice2.costoOro * cantidad);
                    nuevoHierroReserva := indice3.cantHierro + (indice2.costoHierro * cantidad);
                    nuevoMaderaReserva := indice3.cantMadera + (indice2.costoMadera * cantidad);
                    nuevoPrecioMadera := indice3.precioMadera - ((indice3.precioMadera * calculoProporcionMadera) / 100);
                    nuevoPrecioHierro := indice3.precioHierro - ((indice3.precioHierro * calculoProporcionHierro) / 100);
                    
                    UPDATE ReservaCentral
                    SET cantHierro = nuevoHierroReserva, cantOro = nuevoOroReserva, cantMadera = nuevoMaderaReserva, precioMadera = nuevoPrecioMadera, precioHierro = nuevoPrecioHierro  
                    WHERE idReserva = indice3.IDReserva;
                END LOOP;
                
            ELSE
                DBMS_OUTPUT.PUT_LINE('No hay suficiente oro, hiero o madera en el reino');
            END IF;
            INSERT into Bitacora values(bitacora_sequence.nextval, sysdate, indice.cantOro,indice.cantHierro,indice.cantMadera,indice.cantCoronas,'TRP', indice.IDReino);
            
        END LOOP;
    END LOOP;
commit;
END;
/