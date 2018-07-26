CREATE OR REPLACE PROCEDURE atacar
 ( reinoAtacante int, reinoDefensa int)
IS
  CURSOR curataque(identAtaque int) IS
     SELECT t.cantoro, r.puntosataque, r.puntosdefensa 
     FROM reino r join tesoro t ON r.idreino = identAtaque;
     cantoro t.cantoro%type;
     puntosataque r.puntosataque%type;
     puntosdefensa r.puntosdefensa%type;
BEGIN
     open curataque(reinoAtacante);
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