create or replace procedure monitoriar(n number) is
 valorOro     float(100);
 precioMadera float(15);
 precioHierro float(15); 
 tropaOro     float(100);

 oroReser     float(15); 
 maderaReser  number(15); 
 hierroReser  number(15);   

 cursor trop is 
 select nombretropa,costooro,costomadera,costohierro 
 from tropas;
     
 cursor rank is 
 select cantarqueras,cantpiqueros,cantmagos,cantcaballeros,cantoro,cantmadera,canthierro 
 from reino 
 join tesoro on (reino.tesoro_idtesoro=tesoro.idtesoro);

begin
 select preciomadera,preciohierro,cantoro,cantmadera,canthierro
 into precioMadera,precioHierro,oroReser, maderaReser,hierroReser
 from reservacentral;
declare 
 TYPE tesoro_tbl IS TABLE OF tesoro%rowtype;
  valor tesoro_tbl;  

 valorArquera    float(15);  
 valorMagos      float(15);
 valorPiqueros   float(15); 
 valorCaballeros float(15);
 costoOro        float(15);  
 costoMadera     float(15);
 costoHierro     float(15);
begin 
 
 for rei in rank loop    
  for cost in trop loop

    valorOro:= precioMadera/2 *rei.cantmadera + precioHierro/2*rei.canthierro;
     if cost.nombretropa = 'Arquera' then  
       
       select costooro,costomadera,costohierro 
       into costoOro,costoMadera,costoHierro
       from tropas
       where nombretropa like 'Arquera';       
                     
       valorArquera:= costoOro+cost.costoMadera+cost.costoHierro*rei.cantarqueras *150 /100;
    end if;
    tropaOro :=ValorArquera;
       
    if cost.nombretropa = 'Piqueros' then  
       select costooro,costomadera,costohierro 
       into costoOro,costoMadera,costoHierro
       from tropas
       where nombretropa like 'Piqueros';
                     
       valorPiqueros:= costoOro+cost.costoMadera+cost.costoHierro*rei.cantarqueras *150 /100;
    end if;
      
     if cost.nombretropa = 'Caballeros' then  
       
       select costooro,costomadera,costohierro 
       into costoOro,costoMadera,costoHierro
       from tropas
       where nombretropa like 'Caballeros';
                     
       valorCaballeros:= costoOro+cost.costoMadera+cost.costoHierro*rei.cantarqueras *150 /100;
    end if;


  if cost.nombretropa = 'Magos' then  
       
       select costooro,costomadera,costohierro 
       into costoOro,costoMadera,costoHierro
       from tropas
       where nombretropa like 'Magos';
                     
       valorMagos:= costoOro+cost.costoMadera+cost.costoHierro*rei.cantarqueras *150 /100;
    end if;
     
                    
  end loop;      
 end loop;
end;  
end monitoriar;
/




