create or replace procedure monitoriar  is
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
/




