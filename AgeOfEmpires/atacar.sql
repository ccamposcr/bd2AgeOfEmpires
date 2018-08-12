CREATE OR REPLACE PROCEDURE atacar
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
  subDefectoTotalAtaque number := 0;
  defectoTotalAtaque number := 0;
  subDefectoTotalDefensa number := 0;
  defectoTotalDefensa number := 0;

  CURSOR curataque(identAtaque int) IS
     SELECT cantOro, puntosAtaque, puntosDefensa 
     FROM reino r JOIN tesoro t ON r.idreino = t.idtesoro 
     WHERE idReino = identAtaque;
     cantoro tesoro.cantOro%type;
     puntosataque reino.puntosAtaque%type;
     puntosdefensa reino.puntosDefensa%type;

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
         fetch curataque into cantoro, puntosataque, puntosdefensa;
         exit when curataque%notfound;
          IF cantoro >= 1000 then
               UPDATE tesoro
               SET cantOro = cantoro - 1000
               WHERE idtesoro = reinoAtacante;
               subTotalAtaque :=  puntosataque * 80 / 100;
               subTotalAtaqueBonus := puntosataque * 60 / 100;
               totalAtaque := subTotalAtaque + subTotalAtaqueBonus;
               dbms_output.put_line(subTotalAtaqueBonus);
               dbms_output.put_line(subTotalAtaque);
               open curdefensa(reinoDefensa);
                LOOP
                   fetch curdefensa into cantorodef, cantmaderadef, canthierrodef, puntosataquedef, puntosdefensadef;
                   exit when curdefensa%notfound;
                     totalDefensa := puntosdefensadef * 70 / 100;
                     dbms_output.put_line(totalDefensa);

                END LOOP;
               close curdefensa;
               IF totalAtaque > totalDefensa THEN
                    subTotalAtaque := puntosataque * 80 / 100;
                    totalAtaque := puntosataque - subTotalAtaque;
                    UPDATE reino
                    SET puntosAtaque = totalAtaque
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
         
      END LOOP;
    close curataque;
END;
/