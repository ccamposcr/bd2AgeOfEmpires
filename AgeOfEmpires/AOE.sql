CREATE OR REPLACE PACKAGE AOE IS
	PROCEDURE inicializar ( idReino int, oro int, madera int, hierro int, coronas int);
	PROCEDURE comprar ( recurso varchar2 , reino varchar2, cantidad float );
	PROCEDURE vender ( recurso varchar2 , reino varchar2, cantidad float );
	PROCEDURE entrenarEjercitos ( tropa varchar2 , reino varchar2, cantidad float );
	PROCEDURE comprarDefensas ( defensa varchar2 , reino varchar2, cantidad float );
	PROCEDURE mejorarDefensa (nomReino varchar2 );
	PROCEDURE mejorarAtaque (nomReino varchar2 );
	PROCEDURE atacar ( reinoAtacante int, reinoDefensa int);
	PROCEDURE monitoriar;
END AOE;
/