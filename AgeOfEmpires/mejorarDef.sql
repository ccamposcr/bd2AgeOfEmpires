create or replace procedure mejorarDefensa(reinoid number ) is
   cursor rein is
   select tesoro_idtesoro tesoro,reservacentral_idreserva reserva
   from reino
   where idreino=reinoid;

begin
  
  for def in rein loop
    update tesoro
    set cantidaddeoro=cantidaddeoro-2000,
    cantidaddemadera=cantidaddemadera-100,
    cantidaddehierro=cantidaddehierro-150
    where idtesoro=def.tesoro;

    update reservacentral
    set cantoro=cantoro+2000,
    cantmadera=cantmadera+100,
    canthierro=canthierro+150
    where idreserva=def.reserva;

    insert into bitacora values (bitacora_sequence.nextval,sysdate,2000,150,100,40,'M+D',reinoid);

    update reino
    set puntosdefensa=puntosdefensa * 10/100+500,
    cantidadcoronas=cantidadcoronas +40
    where idreino =reinoid;
  end loop;
end mejorarDefensa;
/
