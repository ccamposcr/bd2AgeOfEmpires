CREATE OR REPLACE PROCEDURE comprarDefensas
   ( defensa varchar2 , reino varchar2, cantidad float )
IS
    CURSOR cursor_reino is
        SELECT IDReino, IDTesoro, cantMadera, cantHierro, cantOro, cantCoronas
        from Reino
        INNER JOIN Tesoro ON Reino.Tesoro_IDTesoro = Tesoro.IDTesoro
        where UPPER(Reino.nombre) = UPPER(reino);
        
    CURSOR cursor_reservaCentral is
        SELECT IDReserva, precioMadera, precioHierro, cantMadera, cantHierro, cantOro
        from ReservaCentral;
    
    CURSOR cursor_defensas is
        SELECT IDDEFENSA,TIPODEFENSA,NOMBREDEFENSA,COSTOENORO,COSTOENMADERA,COSTOENHIERRO,SUMADECORONAS,PUNTOSDEDEFENSA
        from DEFENSAS
        where UPPER(Defensas.nombreDefensa) = UPPER(defensa);
        
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
       FOR indice2 IN cursor_defensas
       LOOP
            IF ((indice2.costoEnOro * cantidad) <= indice.cantOro) and ( (indice2.costoEnMadera * cantidad) <= indice.cantMadera ) and ( (indice2.costoEnHierro * cantidad) <= indice.cantHierro )  THEN
                UPDATE Tesoro
                SET cantHierro = cantHierro - (indice2.costoEnHierro * cantidad), cantOro = cantOro - (indice2.costoEnOro * cantidad), cantMadera = cantMadera - (indice2.costoEnMadera * cantidad)
                WHERE idTesoro = indice.idTesoro;
                
                CASE UPPER(defensa)
                    WHEN 'CANONES' then
                        UPDATE Reino
                        SET cantCanones = cantCanones + cantidad, cantCoronas = cantCoronas + (indice2.sumaDeCoronas * cantidad), puntosDefensa = puntosDefensa + (indice2.puntosDeDefensa * cantidad)
                        WHERE idReino = indice.idReino;
                    WHEN 'TORRES' then
                        UPDATE Reino
                        SET cantTorres = cantTorres + cantidad, cantCoronas = cantCoronas + (indice2.sumaDeCoronas * cantidad), puntosDefensa = puntosDefensa + (indice2.puntosDeDefensa * cantidad)
                        WHERE idReino = indice.idReino;
                END CASE;
                
                FOR indice3 IN cursor_reservaCentral
                LOOP
                    calculoProporcionMadera := (cantidad * 100) / indice3.cantMadera;
                    calculoProporcionHierro := (cantidad * 100) / indice3.cantHierro;
                    nuevoOroReserva :=  indice3.cantOro + (indice2.costoEnOro * cantidad);
                    nuevoHierroReserva := indice3.cantHierro + (indice2.costoEnHierro * cantidad);
                    nuevoMaderaReserva := indice3.cantMadera + (indice2.costoEnMadera * cantidad);
                    nuevoPrecioMadera := indice3.precioMadera - (indice3.precioMadera * calculoProporcionMadera);
                    nuevoPrecioHierro := indice3.precioHierro - (indice3.precioHierro * calculoProporcionHierro);
                    
                    UPDATE ReservaCentral
                    SET cantHierro = nuevoHierroReserva, cantOro = nuevoOroReserva, cantMadera = nuevoMaderaReserva, precioMadera = nuevoPrecioMadera, precioHierro = nuevoPrecioHierro  
                    WHERE idReserva = indice3.idReserva;
                END LOOP;
                
            ELSE
                DBMS_OUTPUT.PUT_LINE('No hay suficiente oro, hiero o madera en el reino');
            END IF;
            INSERT into Bitacora values(bitacora_sequence.nextval, sysdate, indice.cantOro,indice.cantHierro,indice.cantMadera,indice.cantCoronas,'DEF', indice.IDReino);
            
        END LOOP;
    END LOOP;
commit;
END;
/