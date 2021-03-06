create or replace procedure mejorarDefensa(nomReino varchar2 ) is
   error Exception;
   reinoid number(15);
   puntosDef number(15); 
   nombreRei  varchar2(200):=nomReino; 
   cursor rein is
   select tesoro_idtesoro tesoro,reservacentral_idreserva reserva,t.cantoro cant, t.cantmadera mad ,t.canthierro hierr,puntosdefensa
   from reino
   join tesoro t on (t.idtesoro=reino.tesoro_idtesoro)
   where UPPER(nombre) = UPPER(nombreRei); 
begin
  select idreino into reinoid
  from reino
  where UPPER(nombre) = UPPER(nombreRei); 
  for def in rein loop
          
    if def.cant< 2000 and def.mad <100 and def.hierr < 150  then
     
     raise error; 
    
    else 
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
     puntosDef:=def.puntosdefensa+ (def.puntosdefensa*10/100)+500;
    
    update reino
    set puntosdefensa=puntosDef,
    cantcoronas=cantcoronas +40
    where idreino =reinoid; 
    commit;       

   end if;
 end loop;
Exception
  when no_data_found 
  then DBMS_OUTPUT.PUT_LINE('El reino no se encontro');
  when error then 
   DBMS_OUTPUT.PUT_LINE('El reino no tiene sufiente recursos de madera,oro o hierro');
end mejorarDefensa;
/
