create or replace procedure mejorarAtaque(nomReino varchar2 ) is
   reinoid number(15);
   nombRei varchar2(200):=nomReino;
   cursor rein is
   select tesoro_idtesoro tesoro,reservacentral_idreserva reserva
   from reino
   where nombre=nombRei;
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
/
