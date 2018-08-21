    CREATE OR REPLACE PACKAGE BODY AOE IS
        PROCEDURE inicializar
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
        
        PROCEDURE comprar
           ( recurso varchar2 , reino varchar2, cantidad float )
            IS
            CURSOR cursor_reino is
                SELECT IDReino, IDTesoro, cantMadera, cantHierro, cantOro, cantCoronas
                from Reino
                INNER JOIN Tesoro ON Reino.Tesoro_IDTesoro = Tesoro.IDTesoro
                where UPPER(Reino.nombre) = UPPER(reino);
                
            CURSOR cursor_reservaCentral is
                SELECT IDReserva, precioMadera, precioHierro, cantMadera, cantHierro
                from ReservaCentral;
                
            totalCostoMadera float := 0;
            totalCostoHierro float := 0;
            calculoProporcion float := 0;
            
        BEGIN
            FOR indice IN cursor_reino
            LOOP
                FOR indice2 IN cursor_reservaCentral
                LOOP
                    IF UPPER(recurso) = 'MADERA' THEN
                        totalCostoMadera := cantidad * indice2.precioMadera;
                       IF cantidad <= indice2.cantMadera AND totalCostoMadera <= indice.cantOro THEN 
                            UPDATE Tesoro
                            SET cantMadera = cantMadera + cantidad, cantOro = cantOro - totalCostoMadera
                            WHERE idTesoro = indice.idTesoro;
                            
                            UPDATE Reino
                            SET cantCoronas = cantCoronas + 5
                            WHERE idReino = indice.idReino;
                            
                            calculoProporcion := (cantidad * 100) / indice2.cantMadera;
                            
                            UPDATE ReservaCentral
                            SET cantOro = cantOro + totalCostoMadera, precioMadera = (precioMadera + (precioMadera * calculoProporcion)/100), cantMadera = cantMadera - cantidad 
                            WHERE idReserva = indice2.idReserva;
                            
                        ELSE
                            DBMS_OUTPUT.PUT_LINE('No hay suficiente madera en la reserva Central o No tiene suficiente Oro en el reino');
                        END IF;
                    ELSE
                        totalCostoHierro := cantidad * indice2.precioHierro;
                        IF cantidad <= indice2.cantHierro AND totalCostoHierro <= indice.cantOro THEN
                            UPDATE Tesoro
                            SET cantHierro = cantHierro + cantidad, cantOro = cantOro - totalCostoHierro
                            WHERE idTesoro = indice.idTesoro;
                            
                            UPDATE Reino
                            SET cantCoronas = cantCoronas + 5
                            WHERE idReino = indice.idReino;
                            
                            calculoProporcion := (cantidad * 100) / indice2.cantHierro;
                            
                            UPDATE ReservaCentral
                            SET cantOro = cantOro + totalCostoHierro, precioHierro = (precioHierro + (precioHierro * calculoProporcion)/100), cantHierro = cantHierro - cantidad
                            WHERE idReserva = indice2.idReserva;
                            
                        ELSE
                            DBMS_OUTPUT.PUT_LINE('No hay suficiente hierro en la reserva Central o No tiene suficiente Oro en el reino');
                        END IF;
                    END IF;
                    
                    INSERT into Bitacora values(bitacora_sequence.nextval, sysdate, indice.cantOro,indice.cantHierro,indice.cantMadera,indice.cantCoronas,'CMP', indice.IDReino);
                END LOOP;
            END LOOP;
        commit;
        END;
        
       PROCEDURE vender
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
                    IF UPPER(recurso) = 'MADERA' THEN
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
                            SET cantOro = cantOro - totalCostoMadera, precioMadera = (precioMadera - (precioMadera * calculoProporcion)/100), cantMadera = cantMadera + cantidad 
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
                            SET cantOro = cantOro - totalCostoHierro, precioHierro = (precioHierro - (precioHierro * calculoProporcion)/100), cantHierro = cantHierro + cantidad
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
        
        PROCEDURE entrenarEjercitos
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
                            nuevoPrecioMadera := indice3.precioMadera - (indice3.precioMadera * calculoProporcionMadera);
                            nuevoPrecioHierro := indice3.precioHierro - (indice3.precioHierro * calculoProporcionHierro);
                            
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
        
        PROCEDURE comprarDefensas
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
        
        procedure mejorarDefensa(nomReino varchar2 ) is
           reinoid number(15);
           nombreRei  varchar2(200):=nomReino; 
           cursor rein is
           select tesoro_idtesoro tesoro,reservacentral_idreserva reserva
           from reino
           where nombre = nombreRei; 
        begin
          select idreino into reinoid
          from reino
          where UPPER(nombre) = UPPER(nombreRei); 
          for def in rein loop
            update tesoro
            set cantoro=cantoro-2000,
            cantmadera=cantmadera-100,
            canthierro=canthierro-150
            where idtesoro=def.tesoro;
        
            update reservacentral
            set cantoro=cantoro+2000,
            cantmadera=cantmadera+100,
            canthierro=canthierro+150
            where idreserva=def.reserva;
        
            insert into bitacora values (bitacora_sequence.nextval,sysdate,2000,150,100,40,'M+D',reinoid);
        
            update reino
            set puntosdefensa=puntosdefensa * 10/100+500,
            cantcoronas=cantcoronas +40
            where idreino =reinoid;
          end loop;
        Exception
          when no_data_found 
          then DBMS_OUTPUT.PUT_LINE('El reino no se encontro');
        
        end mejorarDefensa;
        
        procedure mejorarAtaque(nomReino varchar2 ) is
           reinoid number(15);
           nombRei varchar2(200):=nomReino;
           cursor rein is
           select tesoro_idtesoro tesoro,reservacentral_idreserva reserva
           from reino
           where UPPER(nombre) = UPPER(nombRei);
        begin
          select idreino into reinoid
          from reino
          where nombre = nombRei;
          
          for def in rein loop
            update tesoro
            set cantoro=cantoro-1500,
            cantmadera=cantmadera-300,
            canthierro=canthierro-200
            where idtesoro=def.tesoro;
        
            update reservacentral
            set cantoro=cantoro+1500,
            cantmadera=cantmadera+300,
            canthierro=canthierro+200
            where idreserva=def.reserva;
        
            insert into bitacora values (bitacora_sequence.nextval,sysdate,1500,300,200,5,'M+A',reinoid);
            update reino
            set puntosdefensa=puntosdefensa * 10/100+500,
            cantcoronas=cantcoronas +40
            where idreino =reinoid;
        
          end loop;
        Exception
          when no_data_found 
          then DBMS_OUTPUT.PUT_LINE('El Reino no se encontro');
         
        end mejorarAtaque;
        
        PROCEDURE atacar
         ( reinoAtacante int, reinoDefensa int)
        IS
          subTotalAtaque number := 0;
          subTotalAtaqueBonus number := 0;
          subTotalDefensa number :=0;
          totalAtaque number := 0;
          totalDefensa number := 0;
          recursoMadera number:= 0;
          recursoHierro number := 0;
          totalRecursoMadera number:= 0;
          totalRecursoHierro number := 0;
          darOro number := 0;
          totalOro number := 0;
          totalOroDado number := 0;
          totalCoronas number := 0;
          subDefectoTotalAtaque number := 0;
          defectoTotalAtaque number := 0;
          subDefectoTotalDefensa number := 0;
          defectoTotalDefensa number := 0;
        
          CURSOR curataque(identAtaque int) IS
             SELECT cantOro, puntosAtaque, puntosDefensa, cantCoronas, cantMadera, cantHierro
             FROM reino r JOIN tesoro t ON r.idreino = t.idtesoro 
             WHERE idReino = identAtaque;
             cantoro tesoro.cantOro%type;
             puntosataque reino.puntosAtaque%type;
             puntosdefensa reino.puntosDefensa%type;
             cantcoronas reino.cantCoronas%type;
             cantmadera tesoro.cantMadera%type;
             canthierro tesoro.cantHierro%type;
        
          CURSOR curdefensa(identDefensa int) IS 
              SELECT cantOro, cantMadera, cantHierro, puntosAtaque, puntosDefensa
              FROM reino r JOIN tesoro t On r.idreino = t.idtesoro
              where idReino = identDefensa;
              cantorodef tesoro.cantOro%type;
              cantmaderadef tesoro.cantMadera%type;
              canthierrodef tesoro.cantHierro%type;
              puntosataquedef reino.puntosAtaque%type;
              puntosdefensadef reino.puntosDefensa%type;
        BEGIN
             open curataque(reinoAtacante);
              LOOP
                 fetch curataque into cantoro, puntosataque, puntosdefensa, cantcoronas, cantmadera, canthierro;
                 exit when curataque%notfound;
                  IF cantoro >= 1000 then
                       UPDATE tesoro
                       SET cantOro = cantoro - 1000
                       WHERE idtesoro = reinoAtacante;
                       subTotalAtaque :=  puntosataque * 80 / 100;
                       subTotalAtaqueBonus := puntosataque * 60 / 100;
                       totalAtaque := subTotalAtaque + subTotalAtaqueBonus;
                       open curdefensa(reinoDefensa);
                        LOOP
                           fetch curdefensa into cantorodef, cantmaderadef, canthierrodef, puntosataquedef, puntosdefensadef;
                           exit when curdefensa%notfound;
                             totalDefensa := puntosdefensadef * 70 / 100;
                        END LOOP;
                       close curdefensa;
                       IF totalAtaque > totalDefensa THEN
                            subTotalAtaque := puntosataque * 80 / 100;
                            totalAtaque := puntosataque - subTotalAtaque;
                            totalCoronas := cantcoronas + 2;
                            UPDATE reino
                            SET puntosAtaque = totalAtaque, cantCoronas = totalCoronas
                            WHERE idReino = reinoAtacante;
                            open curdefensa(reinoDefensa);
                             LOOP
                               fetch curdefensa into cantorodef, cantmaderadef, canthierrodef, puntosataquedef, puntosdefensadef;
                               exit when curdefensa%notfound;
                                   recursoHierro := canthierrodef * 65 / 100;
                                   recursoMadera := cantmaderadef * 65 / 100;
                                   totalRecursoHierro := canthierrodef - recursoHierro;
                                   totalRecursoMadera := cantmaderadef - recursoMadera;
                                   UPDATE tesoro
                                   SET cantMadera = totalRecursoMadera, cantHierro = totalRecursoHierro
                                   WHERE idTesoro = reinoDefensa;
                             END LOOP;
                            close curdefensa;
        
                       ELSE
                            subTotalAtaque := puntosataque * 60 / 100;
                            totalAtaque := puntosataque - subTotalAtaque;
                            UPDATE reino
                            SET puntosAtaque = totalAtaque
                            WHERE idReino = reinoAtacante;
                            darOro := cantoro * 30 / 100;
                            totalOro := cantoro - darOro;
                            UPDATE tesoro
                            SET cantOro = totalOro
                            WHERE idTesoro = reinoAtacante;
                            open curdefensa(reinoDefensa);
                             LOOP
                               fetch curdefensa into cantorodef, cantmaderadef, canthierrodef, puntosataquedef, puntosdefensadef;
                               exit when curdefensa%notfound;
                                    totalOroDado := cantorodef + darOro;
                                   UPDATE tesoro
                                   SET cantOro = totalOroDado
                                   WHERE idTesoro = reinoDefensa;
                             END LOOP;
                            close curdefensa;
                      END IF;
                      open curdefensa(reinoDefensa);
                        LOOP
                           fetch curdefensa into cantorodef, cantmaderadef, canthierrodef, puntosataquedef, puntosdefensadef;
                           exit when curdefensa%notfound;
                             subDefectoTotalAtaque := puntosataquedef * 20 / 100;
                             defectoTotalAtaque := puntosataquedef - subDefectoTotalAtaque;
                             subDefectoTotalDefensa := puntosdefensadef * 35 / 100;
                             defectoTotalDefensa := puntosdefensadef - subDefectoTotalDefensa;
                             UPDATE reino
                             SET puntosAtaque = defectoTotalAtaque, puntosDefensa = defectoTotalDefensa
                             WHERE idReino = reinoDefensa;
                        END LOOP;
                       close curdefensa;
                  ELSE 
                       dbms_output.put_line('El ataque no es posible');
                  END IF;
                   INSERT into Bitacora values(bitacora_sequence.nextval, sysdate, cantoro, canthierro, cantmadera, cantcoronas,'ATK', reinoAtacante);
              END LOOP;
            close curataque;
        END;
        
        procedure monitoriar  is
         valorOro        float(100);
         precioMadera    float(15);
         precioHierro    float(15); 
         tropaOro        float(100);
        
        
         valorArquera    float(15);  
         valorMagos      float(15);
         valorPiqueros   float(15); 
         valorCaballeros float(15);
         costoOro        float(15);  
         costoMadera     float(15);
         costoHierro     float(15); 
         cantOro         float(15);
         cantMadera      float(15);
         cantHierro      float(15);
         
         cursor trop is 
         select nombretropa,costooro,costomadera,costohierro 
         from tropas;
             
         cursor rank is 
         select idreino,cantarqueras,cantpiqueros,cantmagos,cantcaballeros,cantcoronas,puntosdefensa,puntosataque,cantoro,cantmadera,canthierro 
         from reino 
         join tesoro on (reino.tesoro_idtesoro=tesoro.idtesoro);
        
         cursor moni is 
         select idreino,nombre,ranking 
         from reino 
         order by ranking desc; 
        
         cursor bit is 
         select b.fechahora,b.cantdoro,b.canthierro,b.cantmadera,b.cantcoronas,
         tipotransaccion
         from bitacora b;
         
        begin
              
         select preciomadera,preciohierro,cantoro,cantmadera,canthierro
         into precioMadera,precioHierro,cantOro,cantMadera,cantHierro
         from reservacentral; 
        
         
         for rei in rank loop    
          for cost in trop loop
        
        
            
          if cost.nombretropa = 'Arquera' then  
               
               select costooro,costomadera,costohierro 
               into costoOro,costoMadera,costoHierro
               from tropas
               where nombretropa like 'Arquera';       
                             
               valorArquera:= costoOro+cost.costoMadera+cost.costoHierro*rei.cantarqueras *150 /100;
             
               tropaOro:=tropaOro+ValorArquera;
              
           end if;
            
               
           if cost.nombretropa = 'Piqueros' then  
               
               select costooro,costomadera,costohierro 
               into costoOro,costoMadera,costoHierro
               from tropas
               where nombretropa like 'Piqueros';
                             
               valorPiqueros:= costoOro+cost.costoMadera+cost.costoHierro*rei.cantpiqueros *150 /100;
            
               tropaOro:=tropaOro+valorPiqueros;
              
              
            end if;
        
        
           if cost.nombretropa = 'Caballeros' then  
               
               select costooro,costomadera,costohierro 
               into costoOro,costoMadera,costoHierro
               from tropas
               where nombretropa like 'Caballeros';
                             
               valorCaballeros:= costoOro+cost.costoMadera+cost.costoHierro*rei.cantcaballeros *150 /100;
            
               tropaOro:=tropaOro+valorCaballeros;
        
            
            
            end if;      
              
        
        
          if cost.nombretropa = 'Magos' then  
               
               select costooro,costomadera,costohierro 
               into costoOro,costoMadera,costoHierro
               from tropas
               where nombretropa like 'Magos';
                             
               valorMagos:= costoOro+cost.costoMadera+cost.costoHierro*rei.cantmagos *150 /100;
        
               tropaOro:=valorMagos;
            
            end if; 
                  
                                                                     
              valorOro:= precioMadera/2 *rei.cantmadera + precioHierro/2*rei.canthierro + rei.cantcoronas *10  + rei.puntosataque +rei.puntosdefensa+rei.cantoro;        
              
              update reino 
              set  ranking = ranking + tropaOro + valorOro
              where idreino=rei.idreino;    
                 
                             
          end loop;      
         end loop;
         
               
        DBMS_OUTPUT.PUT_LINE('Reserva' );
         
         DBMS_OUTPUT.PUT_LINE('Oro '|| rpad(cantOro ,12,' ') || 'Madera' || rpad(cantMadera,12,' ')||' Hierro' ||
         rpad(cantHierro,12,' ') || 'Precio Madera'|| rpad(precioMadera,12,'' )||'Precio Hierro'|| rpad(precioHierro,12,' '));
           
         
         DBMS_OUTPUT.PUT_LINE('Reino' );
          
           for list in moni loop
           
                DBMS_OUTPUT.PUT_LINE(rpad(list.nombre ,15,' ') || rpad(list.ranking,18,' '));
                
                            
           end loop;
          
         DBMS_OUTPUT.PUT_LINE('Bitacora' );  
           for bita in bit loop
              
              DBMS_OUTPUT.PUT_LINE(rpad(bita.fechahora ,15,' ') || rpad(bita.cantdoro,18,' ')||rpad(bita.canthierro,15,' ')||rpad(bita.cantmadera,15,' ')
              ||rpad(bita.cantcoronas,15,' ')||rpad(bita.tipotransaccion,15,' '));
                  
                      
             end loop;       
        end monitoriar;
    
    END AOE;
    /