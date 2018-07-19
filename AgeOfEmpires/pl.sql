CREATE TABLE bitacora (
    idbitacora        NUMBER(15) NOT NULL,
    fechahora         TIMESTAMP,
    cantidadoro       NUMBER(15),
    cantidadhierro    NUMBER(15),
    cantidadmadera    NUMBER(15),
    cantidadcoronas   NUMBER(15),
    tipotransaccion   NVARCHAR2(200),
    reino_idreino     NUMBER(15) NOT NULL
);

ALTER TABLE bitacora ADD CONSTRAINT bitacora_pk PRIMARY KEY ( idbitacora );
create sequence bitacora_sequence start with 1 increment by 1;
 
CREATE TABLE defensas (
    iddefensa         NUMBER(15) NOT NULL,
    tipodefensa       NUMBER(15),
    nombredefensa     NVARCHAR2(200),
    costoenoro        FLOAT(15),
    costoenmadera     FLOAT(15),
    costoenhierro     FLOAT(15),
    puntosdedefensa   NUMBER(15),
    sumadecoronas     NUMBER(15),
    reino_idreino     NUMBER(15) NOT NULL
);

ALTER TABLE defensas ADD CONSTRAINT defensas_pk PRIMARY KEY ( iddefensa );
create sequence defensa_sequence start with 1 increment by 1;
CREATE TABLE reino (
    idreino                    NUMBER(15) NOT NULL,
    nombre                     NVARCHAR2(200),
    logotipo                   NVARCHAR2(200),
    mes                        NVARCHAR2(200),
    cantidadcoronas            NUMBER(15),
    puntosdefensa              NUMBER(15),
    puntosataque               NUMBER(15),
    cantarqueras               NUMBER(15),
    cantpiqueros               NUMBER(15),
    cantcaballeros             NUMBER(15),
    cantidadmagos              NUMBER(15),
    tesoro_idtesoro            NUMBER(15) NOT NULL,
    reservacentral_idreserva   NUMBER(15) NOT NULL
);

CREATE UNIQUE INDEX reino__idx ON
    reino (
        tesoro_idtesoro
    ASC );

ALTER TABLE reino ADD CONSTRAINT reino_pk PRIMARY KEY ( idreino );

create sequence reino_sequence start with 1 increment by 1;

CREATE TABLE reservacentral (
    idreserva      NUMBER(15) NOT NULL,
    cantoro        FLOAT(15),
    cantmadera     NUMBER(15),
    canthierro     NUMBER(15),
    preciomadera   FLOAT(15),
    preciohierro   FLOAT(15)
);


ALTER TABLE reservacentral ADD CONSTRAINT reservacentral_pk PRIMARY KEY ( idreserva );
create sequence reserva_sequence start with 1 increment by 1;
CREATE TABLE tesoro (
    idtesoro           NUMBER(15) NOT NULL,
    cantidaddeoro      NUMBER(15),
    cantidaddemadera   NUMBER(15),
    cantidaddehierro   NUMBER(15),
    puntosdecoronas    NUMBER(15),
    reino_idreino   NUMBER(15) NOT NULL
);


CREATE UNIQUE INDEX tesoro__idx ON
    tesoro (
        reino_idreino
    ASC );

ALTER TABLE tesoro ADD CONSTRAINT tesoro_pk PRIMARY KEY ( idtesoro );
create sequence tesoro_sequence start with 1 increment by 1;

CREATE TABLE tropas (
    idtropa         NUMBER(15) NOT NULL,
    tipotropa       NUMBER(15),
    nombretropa     NVARCHAR2(200),
    costooro        FLOAT(15),
    costomadera     FLOAT(15),
    costohierro     FLOAT(15),
    sumacoronas     NUMBER(15),
    puntosataque    NUMBER(15),
    reino_idreino   NUMBER(15) NOT NULL
);

ALTER TABLE tropas ADD CONSTRAINT tropas_pk PRIMARY KEY ( idtropa );
create sequence tropas_sequence start with 1 increment by 1;
ALTER TABLE bitacora
    ADD CONSTRAINT bitacora_reino_fk FOREIGN KEY ( reino_idreino )
        REFERENCES reino ( idreino );

ALTER TABLE defensas
    ADD CONSTRAINT defensas_reino_fk FOREIGN KEY ( reino_idreino )
        REFERENCES reino ( idreino );

ALTER TABLE reino
    ADD CONSTRAINT reino_reservacentral_fk FOREIGN KEY ( reservacentral_idreserva )
        REFERENCES reservacentral ( idreserva );

ALTER TABLE reino
    ADD CONSTRAINT reino_tesoro_fk FOREIGN KEY ( tesoro_idtesoro )
        REFERENCES tesoro ( idtesoro );

ALTER TABLE tesoro
    ADD CONSTRAINT tesoro_reino_fk FOREIGN KEY ( reino_idreino )
        REFERENCES reino ( idreino );

ALTER TABLE tropas
    ADD CONSTRAINT tropas_reino_fk FOREIGN KEY ( reino_idreino )
        REFERENCES reino ( idreino );