CREATE OR REPLACE Function comprar
   ( recurso varchar2 , reino varchar2, cantidad float )
   RETURN boolean
IS
    resultado boolean;
    recursoModificar varchar2;
    CURSOR cursor_reino is
        SELECT IDReino, IDTesoro, CantidadDeOro, CantidadDeMadera, CantidadDeHierro, PuntosDeCoronas
        from Reino
        INNER JOIN Tesoro ON Reino.Tesoro_IDTesoro = Tesoro.IDTesoro
        where Reino.nombre = UPPER(reino);
    oro number := 0;
    madera number := 0;
    hierro number := 0;
BEGIN
    FOR indice IN cursor_reino
    LOOP
        oro := indice.CantidadDeOro;
        madera := indice.CantidadDeMadera;
        hierro := indice.CantidadDeHierro;
    END LOOP;
    IF recurso = 'madera' THEN
        recursoModificar := 'cantMadera';
    ELSE
        recursoModificar := 'cantHierro';
    END IF;
    
    /*UPDATE reservaCentral
    SET recursoModificar = 'Anderson'
    WHERE customer_id = 5000;*/

RETURN resultado;

END;
/