create or replace procedure mejorarAtaque(nomReino varchar2 ) is
    error Exception;   
   reinoid number(15);
   nombRei varchar2(200):=nomReino;
   cursor rein is
   select tesoro_idtesoro tesoro,reservacentral_idreserva reserva,t.cantoro cant,t.cantmadera mad,t.canthierro hierr 
   from reino
   join tesoro t on (t.idtesoro=reino.tesoro_idtesoro)
   where UPPER(nombre)=UPPER(nombRei);
begin
  select idreino into reinoid
  from reino
  where UPPER(nombre) = UPPER(nombRei);
  
  for def in rein loop
    if def.cant< 1500 and def.mad<300 and def.hierr <200 then
      
     raise error; 
    
    else   
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
    set puntosAtaque=puntosAtaque * 10/100+300,
    cantcoronas=cantcoronas +5
    where idreino =reinoid;
    end if;
  end loop;
Exception
  when no_data_found 
  then DBMS_OUTPUT.PUT_LINE('El Reino no se encontro');
 when error then 
   DBMS_OUTPUT.PUT_LINE('El reino no tiene sufiente recursos de hierro,madera y oro');
end mejorarAtaque;
/
