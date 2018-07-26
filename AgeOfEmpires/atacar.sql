CREATE OR REPLACE PROCEDURE ATACAR
 ( reinoAtacante int, reinoDefensa int)
IS
  CURSOR curataque(identAtaque int) IS
     SELECT t.cantoro, r.puntosataque, r.puntosdefensa 
     FROM reino r join tesoro t WHERE idreino = identAtaque;
     cantoro tesoro.cantoro%type;
     puntosataque reino.puntosataque%type;
     puntosdefensa reino.puntosdefensa%type;

  CURSOR curdefensa(identDefensa int) IS
     SELECT t.cantoro, r.puntosataque, r.puntosdefensa 
     FROM reino r join tesoro t WHERE idreino = identAtaque;
     cantoro tesoro.cantoro%type;
     puntosataque reino.puntosataque%type;
     puntosdefensa reino.puntosdefensa%type;
BEGIN
     open curataque(reinoatacante);
      LOOP
         fetch curataque into cantoro, puntosataque, puntosataque;
          IF cantoro <= 1000 then
               dbms_output.put_line(' El ataque es posible');
          ELSE 
               dbms_output.put_line('El ataque no es posible');
          END IF;
         exit when curataque%notfound;
      END LOOP;
END;
/