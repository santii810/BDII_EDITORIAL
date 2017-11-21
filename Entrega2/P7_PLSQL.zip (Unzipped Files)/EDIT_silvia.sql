/*************************************************/
/* SCRIPT */
/*************************************************/
SET AUTOCOMMIT on;

/**********************************************************/
/* 1.- Sentencias de borrado de todas las tablas y vistas */
/**********************************************************/

DROP FUNCTION descue;
DROP FUNCTION precio_desc;
DROP FUNCTION dniEmp;
DROP PROCEDURE ListaEmp;
DROP PROCEDURE ListaLib;
DROP PROCEDURE AumentDesc;


DROP VIEW CLIENTE_DATOS;
DROP VIEW CLIENTE_EMPLEADO;


DROP INDEX nombre_dis_i;
DROP INDEX tlf_dis_i;
DROP INDEX nombre_ed_i;
DROP INDEX cif_editorial_i;
DROP INDEX tlf_emp_i;
DROP INDEX nombre_imprenta_i;
DROP INDEX tlf_imp_i;
DROP INDEX nombre_publicacion_i;
DROP INDEX tipo_per_i;
DROP INDEX puntos_i;
DROP INDEX codigo_prom_i;
DROP INDEX papel_i;
DROP INDEX url_i;
DROP INDEX nombre_li_i;
DROP INDEX autor_i;
DROP INDEX numero_paginas_i;
DROP INDEX dni_emp_i;
DROP INDEX tema_i;
DROP INDEX valor_i;
DROP INDEX numero_publicacion_i;
DROP INDEX nom_p_i;
DROP INDEX nom_jur_i;
DROP INDEX cuota_i;
DROP INDEX funcion_i;
DROP INDEX tecnica_i;
DROP INDEX equipo_i;
DROP INDEX tipo_i;
DROP INDEX idioma_i;
DROP INDEX especialidad_i;
DROP INDEX fecha_compra_i;
DROP INDEX numero_empleados_i;
DROP INDEX cod_seccion_i;
DROP INDEX cif_p_j_i;
DROP INDEX tlf_sede_i;


DROP TABLE cliente_emp CASCADE CONSTRAINTS;
DROP TABLE entrega_a CASCADE CONSTRAINTS;
DROP TABLE trabaja_en CASCADE CONSTRAINTS;
DROP TABLE seccion CASCADE CONSTRAINTS;
DROP TABLE distribuida_por CASCADE CONSTRAINTS;
DROP TABLE compra CASCADE CONSTRAINTS;
DROP TABLE suscrito_a CASCADE CONSTRAINTS;
DROP TABLE cread_cont CASCADE CONSTRAINTS;
DROP TABLE corrector CASCADE CONSTRAINTS;
DROP TABLE idioma CASCADE CONSTRAINTS;
DROP TABLE traductor CASCADE CONSTRAINTS;
DROP TABLE tipo_de_escritor CASCADE CONSTRAINTS;
DROP TABLE escritor CASCADE CONSTRAINTS;
DROP TABLE redactor CASCADE CONSTRAINTS;
DROP TABLE fotografo CASCADE CONSTRAINTS;
DROP TABLE ilustrador CASCADE CONSTRAINTS;
DROP TABLE grafista CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE persona_juridica CASCADE CONSTRAINTS;
DROP TABLE persona_fisica CASCADE CONSTRAINTS;
DROP TABLE regala CASCADE CONSTRAINTS;
DROP TABLE accesorio CASCADE CONSTRAINTS;
DROP TABLE revista CASCADE CONSTRAINTS;
DROP TABLE gestor CASCADE CONSTRAINTS;
DROP TABLE edicion CASCADE CONSTRAINTS;
DROP TABLE autor CASCADE CONSTRAINTS;
DROP TABLE libro CASCADE CONSTRAINTS;
DROP TABLE digital CASCADE CONSTRAINTS;
DROP TABLE fisico CASCADE CONSTRAINTS;
DROP TABLE oferta CASCADE CONSTRAINTS;
DROP TABLE promocion CASCADE CONSTRAINTS;
DROP TABLE periodico CASCADE CONSTRAINTS;
DROP TABLE publicacion CASCADE CONSTRAINTS;
DROP TABLE telefono_imprenta CASCADE CONSTRAINTS;
DROP TABLE imprenta CASCADE CONSTRAINTS;
DROP TABLE telefono_sede CASCADE CONSTRAINTS;
DROP TABLE sede CASCADE CONSTRAINTS;
DROP TABLE telefono_empleado CASCADE CONSTRAINTS;
DROP TABLE empleado CASCADE CONSTRAINTS;
DROP TABLE editorial CASCADE CONSTRAINTS;
DROP TABLE telefono_distribuidor CASCADE CONSTRAINTS;
DROP TABLE distribuidor CASCADE CONSTRAINTS;


/**************************************************/
/* 2.- Creamos las tablas */
/**************************************************/

CREATE TABLE distribuidor (
	codigo_dis int NOT NULL,
	nombre_dis varchar2(25) NOT NULL,
	transporte varchar2(25) NOT NULL,
	PRIMARY KEY (codigo_dis),
	CHECK (transporte  IN ('Furgoneta', 'Camion', 'Coche','Avion', 'Barco'))
);


CREATE TABLE telefono_distribuidor (
	tlf_dis int NOT NULL,
	codigo_dis int NOT NULL ,
	FOREIGN KEY(codigo_dis) REFERENCES distribuidor(codigo_dis),
	PRIMARY KEY (tlf_dis,codigo_dis),
	CHECK (tlf_dis  BETWEEN 600000000 and 999999999)
);


CREATE TABLE editorial (
	cif_editorial varchar2(10) NOT NULL,
	nombre_ed varchar2(25) NOT NULL,
	cif_matriz varchar2(10),
	PRIMARY KEY (cif_editorial),
	FOREIGN KEY (cif_matriz) REFERENCES editorial(cif_editorial)
);


CREATE TABLE empleado (
	dni_emp varchar2(9) NOT NULL ,
	dni_emp_sup varchar2(9),
	cif_editorial varchar2(10) NOT NULL,
	FOREIGN KEY (dni_emp_sup) REFERENCES empleado(dni_emp),
	PRIMARY KEY (dni_emp),
	FOREIGN KEY (cif_editorial) REFERENCES editorial(cif_editorial)
);


CREATE TABLE telefono_empleado (
	tlf_emp int NOT NULL,
	dni_emp varchar2(9) NOT NULL ,
	FOREIGN KEY (dni_emp) REFERENCES empleado(dni_emp),
	PRIMARY KEY (tlf_emp,dni_emp),
	CHECK (tlf_emp  BETWEEN 600000000 and 999999999)
);


CREATE TABLE sede (
	numero_local_sede int NOT NULL,
	calle varchar2(25) NOT NULL,
	numero int NOT NULL,
	piso varchar2(20) NOT NULL,
	cp int NOT NULL ,
	cif_editorial varchar2(10) NOT NULL,
	FOREIGN KEY (cif_editorial) REFERENCES editorial(cif_editorial),
	PRIMARY KEY (numero_local_sede,cif_editorial),
	CHECK (numero_local_sede  BETWEEN 1 and 100)
);


CREATE TABLE telefono_sede (
	tlf_sede int NOT NULL ,
	cif_editorial varchar2(10) NOT NULL,
	numero_local_sede int NOT NULL,
	FOREIGN KEY (cif_editorial,numero_local_sede) REFERENCES sede(cif_editorial,numero_local_sede),
	PRIMARY KEY (tlf_sede,cif_editorial,numero_local_sede),
	CHECK (tlf_sede  BETWEEN 600000000 and 999999999)
);


CREATE TABLE imprenta (
	cif_imprenta varchar2(10) NOT NULL,
	nombre_imprenta varchar2(30) NOT NULL ,
	local_impr varchar2(30) NOT NULL,
	PRIMARY KEY (cif_imprenta)
);


CREATE TABLE telefono_imprenta (
	tlf_imp int NOT NULL,
	cif_imprenta varchar2(10) NOT NULL,
	FOREIGN KEY (cif_imprenta) REFERENCES imprenta (cif_imprenta),
	PRIMARY KEY (tlf_imp,cif_imprenta),
	CHECK (tlf_imp  BETWEEN 600000000 and 999999999)
);


CREATE TABLE publicacion (
	numero_publicacion int NOT NULL ,
	nombre_publicacion varchar2(25) NOT NULL,
	tipo varchar2(25) NOT NULL,
	precio float(5) NOT NULL,
	fecha varchar2(30) NOT NULL,
	cif_imprenta varchar2(10) NOT NULL,
	fecha_impresion varchar2(30) NOT NULL,
	FOREIGN KEY (cif_imprenta) REFERENCES imprenta(cif_imprenta),
	PRIMARY KEY (numero_publicacion),
	CHECK (precio  >=0)
);


CREATE TABLE periodico(
	tipo_per varchar2(25) NOT NULL,
	numero_publicacion int NOT NULL,
	FOREIGN KEY (numero_publicacion) REFERENCES publicacion(numero_publicacion),
	PRIMARY KEY (numero_publicacion)
);


CREATE TABLE promocion(
	codigo_prom varchar2(25) NOT NULL,
	puntos int NOT NULL,
	regalo varchar2(25) NOT NULL,
	PRIMARY KEY (codigo_prom)
);


CREATE TABLE oferta(
	codigo_prom varchar2(25) NOT NULL,
	numero_publicacion int NOT NULL,
	FOREIGN KEY (codigo_prom) REFERENCES promocion(codigo_prom),
	FOREIGN KEY (numero_publicacion) REFERENCES periodico(numero_publicacion),
	PRIMARY KEY (codigo_prom,numero_publicacion)
);


CREATE TABLE fisico(
	papel varchar2(30) NOT NULL,
	numero_publicacion int NOT NULL ,
	FOREIGN KEY (numero_publicacion) REFERENCES periodico(numero_publicacion),
	PRIMARY KEY (numero_publicacion)
);


CREATE TABLE digital(
	url varchar2(25) NOT NULL,
	numero_publicacion int NOT NULL ,
	FOREIGN KEY (numero_publicacion) REFERENCES periodico(numero_publicacion),
	PRIMARY KEY (numero_publicacion)
);


CREATE TABLE  libro  (
	numero_publicacion int NOT NULL ,
	foreign key (numero_publicacion) REFERENCES publicacion(numero_publicacion),
	ISBN int not null unique,
	nombre_li varchar2(120) not null,
	genero varchar2(30) not null,
	primary key (numero_publicacion)
);


CREATE TABLE  autor  (
	autor varchar2(50) NOT NULL,
	numero_publicacion int NOT NULL ,
	foreign key (numero_publicacion) REFERENCES libro(numero_publicacion),
	primary key (numero_publicacion,autor),
	CHECK (numero_publicacion >= 0)
);


CREATE TABLE  edicion  (
	numero_edicion int NOT NULL,
	numero_publicacion int NOT NULL,
	numero_paginas int not null ,
	encuadernado varchar2(40) not null,
	foreign key (numero_publicacion) references   libro(numero_publicacion),
	primary key (numero_publicacion, numero_edicion)
);


CREATE TABLE  gestor  (
	dni_emp varchar2(9),
	tipo varchar2(30) not null,
	foreign key (dni_emp) references  empleado(dni_emp),
	primary key (dni_emp, tipo)
);


CREATE TABLE  revista  (
	numero_publicacion int NOT NULL,
	tam varchar2(30) not null,
	tema varchar2(30) not null,
	foreign key (numero_publicacion) references   publicacion(numero_publicacion),
	primary key (numero_publicacion)
);


CREATE TABLE accesorio(
	codigo_accesorio int NOT null,
	valor int NOT null,
	primary key (codigo_accesorio)
);


CREATE TABLE  regala  (
	numero_publicacion int NOT NULL ,
	codigo_accesorio int,
	foreign key (codigo_accesorio) REFERENCES   accesorio(codigo_accesorio),
	foreign key (numero_publicacion) REFERENCES   revista(numero_publicacion),
	primary key (codigo_accesorio,numero_publicacion)
);


CREATE TABLE cliente(
	cod_cli int not null,
	direccion varchar2(25) not null,
	cuota float(4) not null,
	PRIMARY KEY (cod_cli),
	CHECK (cuota  >=0)
);


CREATE TABLE persona_fisica(
	dni_p_f varchar2(9) NOT NULL,
	nom_p varchar2(25) not null,
	cod_cli int null unique,
FOREIGN KEY (cod_cli) REFERENCES cliente(cod_cli),
	primary key (dni_p_f)
);


CREATE TABLE persona_juridica(
	cif_p_j varchar2(9) not null,
	cod_cli int null unique,
	nom_jur varchar2(25) not null,
FOREIGN KEY (cod_cli) REFERENCES persona_juridica(cod_cli),
	primary key (cif_p_j)
);


CREATE TABLE cread_cont(    
	cod_cread_cont int not null,
	primary key (cod_cread_cont)
);


CREATE TABLE grafista(
	funcion varchar2(25) NOT NULL,
	cod_cread_cont int null unique,
	dni_emp varchar2(9) NOT NULL ,
	PRIMARY KEY (dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES empleado(dni_emp)
);


CREATE TABLE ilustrador(    
	tecnica varchar2(20) not null,
	dni_emp varchar2(9) not null,
	PRIMARY KEY (dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES grafista(dni_emp)
);


CREATE TABLE fotografo(    
	equipo varchar2(20) not null,
	dni_emp varchar2(9) not null,
	PRIMARY KEY (dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES grafista(dni_emp)
);


CREATE TABLE redactor(    
	dni_emp varchar2(9) NOT NULL ,
	cod_cread_cont int null unique,   	 
	PRIMARY KEY (dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES empleado(dni_emp),
foreign key (cod_cread_cont) REFERENCES cread_cont(cod_cread_cont)
);


CREATE TABLE escritor(    
	cod_cread_cont int not null,
	dni_emp varchar2(9) not null,
	PRIMARY KEY (dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES redactor(dni_emp),
foreign key (cod_cread_cont) REFERENCES cread_cont(cod_cread_cont)
);


CREATE TABLE tipo_de_escritor(    
	tipo varchar2(25) not null,
	dni_emp varchar2(9) not null,
	PRIMARY KEY (dni_emp,tipo),
	FOREIGN KEY (dni_emp) REFERENCES escritor(dni_emp)
);


CREATE TABLE traductor(    
	dni_emp varchar2(9) not null,
	PRIMARY KEY (dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES redactor(dni_emp)
);


CREATE TABLE idioma(    
	idioma varchar2(25) not null,
	dni_emp varchar2(9) not null,
	PRIMARY KEY (dni_emp,idioma),
	FOREIGN KEY (dni_emp) REFERENCES traductor(dni_emp)
);


CREATE TABLE corrector(    
	dni_emp varchar2(9) not null,
	especialidad varchar2(20) not null,
	PRIMARY KEY (dni_emp),
	FOREIGN KEY (dni_emp) REFERENCES redactor(dni_emp)
	);


CREATE TABLE suscrito_a(
	cod_cli int null unique,
	foreign key (cod_cli) REFERENCES cliente(cod_cli),
	numero_publicacion int NOT NULL,
	foreign key (numero_publicacion) REFERENCES periodico(numero_publicacion),
	fec_alta date not null,
	fec_baja date not null,
	primary key (fec_alta,cod_cli,numero_publicacion)    
);


CREATE TABLE compra(
	cod_cli int null unique,
	numero_publicacion int NOT NULL ,
	fecha_compra date not null,
	foreign key (cod_cli) REFERENCES cliente(cod_cli),
	foreign key (numero_publicacion) REFERENCES publicacion(numero_publicacion),
	primary key (cod_cli,numero_publicacion,fecha_compra),
CHECK (numero_publicacion >= 0)
);


CREATE TABLE distribuida_por(
	fecha_distribucion date not null,
	codigo_dis int NOT NULL,
	numero_publicacion int NOT NULL ,
	foreign key (codigo_dis) REFERENCES distribuidor (codigo_dis),
	foreign key (numero_publicacion) REFERENCES publicacion (numero_publicacion),
	primary key (fecha_distribucion,codigo_dis,numero_publicacion),
	CHECK (numero_publicacion >= 0)
);


CREATE TABLE seccion(
	cod_seccion int not null,
	nom_sec varchar2(25) not null,
	numero_empleados int not null,
	primary key (cod_seccion)
);


CREATE TABLE trabaja_en(
	cod_cread_cont int null,
	cod_seccion int not null,
	numero_publicacion int NOT NULL,
	foreign key (cod_cread_cont) REFERENCES cread_cont(cod_cread_cont),
	foreign key (cod_seccion) REFERENCES seccion(cod_seccion),
	foreign key (numero_publicacion) REFERENCES publicacion(numero_publicacion),
	primary key (cod_cread_cont,cod_seccion, numero_publicacion)
);


CREATE TABLE entrega_a(
	codigo_dis int NOT NULL,
	foreign key (codigo_dis) REFERENCES distribuidor (codigo_dis),
	cif_p_j varchar2(9) not null,
	foreign key (cif_p_j) REFERENCES persona_juridica (cif_p_j),
	primary key (cif_p_j,codigo_dis)
);


CREATE TABLE cliente_emp(
descuento int not null,
	dni_cliente_emp varchar2(9) not null,
	foreign key (dni_cliente_emp) references empleado  (dni_emp),
	foreign key (dni_cliente_emp) references persona_fisica  (dni_p_f),
	primary key(dni_cliente_emp)
);



/*******************************************************/
/* 3.- Creamos los Ã­ndices necesarios sobre las tablas */
/*******************************************************/

CREATE INDEX nombre_dis_i  ON distribuidor (nombre_dis) ;
CREATE INDEX tlf_dis_i ON telefono_distribuidor (tlf_dis);
CREATE INDEX cif_editorial_i ON empleado (cif_editorial);
CREATE INDEX tlf_emp_i ON telefono_empleado (tlf_emp);
CREATE INDEX nombre_ed_i ON editorial (nombre_ed);
CREATE INDEX nombre_imprenta_i ON imprenta (nombre_imprenta);
CREATE INDEX tlf_imp_i ON telefono_imprenta (tlf_imp);
CREATE INDEX nombre_publicacion_i ON publicacion (nombre_publicacion);
CREATE INDEX tipo_per_i ON periodico (tipo_per);
CREATE INDEX puntos_i ON promocion (puntos);
CREATE INDEX codigo_prom_i ON oferta (codigo_prom);
CREATE INDEX papel_i ON fisico (papel);
CREATE INDEX url_i ON digital (url);
CREATE INDEX nombre_li_i ON libro (nombre_li);
CREATE INDEX autor_i ON autor (autor);
CREATE INDEX numero_paginas_i ON edicion (numero_paginas);
CREATE INDEX dni_emp_i ON gestor (dni_emp);
CREATE INDEX tema_i ON revista (tema);
CREATE INDEX valor_i ON accesorio (valor);
CREATE INDEX numero_publicacion_i ON regala (numero_publicacion);
CREATE INDEX nom_p_i ON persona_fisica (nom_p);
CREATE INDEX nom_jur_i ON persona_juridica (nom_jur);
CREATE INDEX cuota_i ON cliente (cuota);
CREATE INDEX funcion_i ON grafista (funcion);
CREATE INDEX tecnica_i ON ilustrador (tecnica);
CREATE INDEX equipo_i ON fotografo (equipo);
CREATE INDEX tipo_i ON tipo_de_escritor (tipo);
CREATE INDEX idioma_i ON idioma (idioma);
CREATE INDEX especialidad_i ON corrector (especialidad);
CREATE INDEX fecha_compra_i ON compra (fecha_compra);
CREATE INDEX codigo_dis_i ON distribuida_por (codigo_dis);
CREATE INDEX numero_empleados_i ON seccion(numero_empleados);
CREATE INDEX cod_seccion_i ON trabaja_en (cod_seccion);
CREATE INDEX cif_p_j_i ON entrega_a (cif_p_j);
CREATE INDEX tlf_sede_i ON telefono_sede (tlf_sede);



/************************************************/
/* 4.- Creamos las vistas para nuestra temÃ¡tica */
/************************************************/

/*VISTAS

ESTA SERÃ?A UNA VISTA EN LA QUE NO ES POSIBLE LA INSERCIÃ“N, YA QUE SI SE INTRODUCE UN NUEVO DATO DE CLIENTES FALTARÃ?A EL CAMPO CUOTA EN LA TABLA CLIENTE
QUE ESTÃ? DECLARADO COMO NOT NULL Y NO TIENE VALOR POR DEFECTO (LA INSERCIÃ“N EN LA TABLA cliente_datos PONDRÃ?A A NULL EL CAMPO cuota EN LA TABLA CLIENTE).
EL BORRADO SÃ? ESTARÃ?A PERMITIDO, PERO HAY QUE TENER EN CUENTA EL CÃ“MO SE BORRA UN CAMPO YA QUE SI BORRAMOS LOS DATOS DEL EMPLEADO CUYA DIRECCIÃ“N SEA 
JUAN XXIII, SE BORRARÃ?AN TODOS LOS EMPLEADOS QUE TUVIESEN ESA DIRECCIÃ“N AUNQUE SÃ“LO QUISIERAMOS BORRAR 1 EN CONCRETO.
MODIFICAR LOS DATOS TAMBIÃ‰N SERÃ?A POSIBLE, PERO SÃ“LO SOBRE LOS CAMPOS QUE ESTÃ‰N EN LA VISTA.

JUSTFICACIÃ“N: CREAMOS LA VISTA cliente_datos PARA QUE UN USUARIO QUE NECESITE CONOCER LOS DATOS DE UN CLIENTE 
PERO NO NECESITE SABER CUANTO PAGA(cuota) PUEDA CONSULTAR ESTA INFORMACIÃ“N
ESTA INFORMACIÃ“N PODRÃ?A SEGUIR CONSULTANDOSE A PESAR DE QUE AUMENTASE O REDUJESE LA CUOTA QUE EL CLIENTE PAGA.*/
CREATE OR REPLACE VIEW cliente_datos AS SELECT cod_cli AS codigo, direccion as direc FROM cliente ORDER BY codigo;

/*NO SE PUEDE INSERTAR, NI BORRAR, NI MODIFICAR, PUESTO QUE ES UNA VISTA NO ACTUALIZABLE (APARICIÃ“N DE LA CONDICIÃ“N ROUND).
UNA VISTA ES NO ACTUALIZABLE SI CONTIENE: FUNCIONES AGREGADAS, LAS CONDICIONES GROUP BY, DISTINCT, HAVING O UNION, UNA SUBCONSULTA EN LA LISTA DE COLUMNAS 
DEL SELECT, JOIN, UNA VISTA NO ACTUALIZABLE EN LA CLÃ?USULA FROM, Una subconsulta en la clÃ¡usula WHERE que hace referencia a una tabla en la clÃ¡usula FROM, 
Hace referencia solamente a valores literales (en tal caso no hay una) tabla subyacenta para actualizar O ALGORITHM = TEMPTABLE (utilizar una tabla temporal 
siempre resulta en una vista no actualizable). 

JUSTIFICACIÃ“N: CREAMOS LA VISTA cliente_empledo PARA FACILITAR LA BUSQUEDA DE TODAS LAS PERSONAS FÃ?SICAS QUE A LA VEZ SON EMPLEADOS Y CLIENTES Y TIENEN UN 
DESCUENTO>0 Y ASÃ? TENER UN ACCESO MÃ?S FÃ?CIL A DATOS COMO SU DNI, LA CUOTA TOTAL QUE PAGAN TRAS APLICARLES EL DESCUENTO, EL CODIGO DE CLIENTE QUE TIENEN Y SU
DIRECCIÃ“N.*/
CREATE OR REPLACE VIEW cliente_empleado 
AS SELECT dni_cliente_emp AS DNI, ROUND((cuota - ((descuento * cuota)/100)),2) AS pago_total, D.cod_cli AS codigo_cliente, direccion 
FROM persona_fisica D, cliente E, cliente_emp F WHERE D.dni_p_f = F.dni_cliente_emp AND D.cod_cli = E.cod_cli AND F.descuento > 0; 



/*********************************************************/
/* 5.- Insertamos datos de ejemplo para todas las tablas */
/*********************************************************/

INSERT INTO distribuidor (codigo_dis, nombre_dis, transporte) VALUES (888, 'Seur', 'Furgoneta');
INSERT INTO distribuidor (codigo_dis, nombre_dis, transporte) VALUES (889, 'MRW', 'Camion');
INSERT INTO distribuidor (codigo_dis, nombre_dis, transporte) VALUES (890, 'Nacex', 'Coche');
 
INSERT INTO telefono_distribuidor (tlf_dis, codigo_dis) VALUES (999999999,888);
INSERT INTO telefono_distribuidor (tlf_dis, codigo_dis) VALUES (999999998,889);
INSERT INTO telefono_distribuidor (tlf_dis, codigo_dis) VALUES (999999997,890);
 
INSERT INTO editorial (cif_editorial, nombre_ed, cif_matriz) VALUES ('45454543F', 'Galaxia', NULL);
INSERT INTO editorial (cif_editorial, nombre_ed, cif_matriz) VALUES ('45454545T', 'Planeta','45454543F');
 
INSERT INTO empleado (dni_emp, dni_emp_sup,cif_editorial) VALUES ('43215423S',NULL,'45454545T');
INSERT INTO empleado (dni_emp, dni_emp_sup,cif_editorial) VALUES ('44484512I', '43215423S','45454545T');
INSERT INTO empleado (dni_emp, dni_emp_sup,cif_editorial) VALUES ('46475836G', '43215423S','45454545T');
INSERT INTO empleado (dni_emp, dni_emp_sup,cif_editorial) VALUES ('46475836H', '43215423S','45454545T');
INSERT INTO empleado (dni_emp, dni_emp_sup,cif_editorial) VALUES ('46475836L', '43215423S','45454545T');
INSERT INTO empleado (dni_emp, dni_emp_sup,cif_editorial) VALUES ('46475836A', '43215423S','45454545T');
INSERT INTO empleado (dni_emp, dni_emp_sup,cif_editorial) VALUES ('46475836B', '43215423S','45454545T');
INSERT INTO empleado (dni_emp, dni_emp_sup,cif_editorial) VALUES ('46475836C', '43215423S','45454545T');
INSERT INTO empleado (dni_emp, dni_emp_sup,cif_editorial) VALUES ('46475836D', '43215423S','45454545T');
 
INSERT INTO telefono_empleado (tlf_emp, dni_emp) VALUES (988765432, '43215423S');
INSERT INTO telefono_empleado (tlf_emp, dni_emp) VALUES (988763332, '46475836G');
 
INSERT INTO sede (numero_local_sede, calle, numero, piso, cp, cif_editorial) VALUES (1,'Calle Falsa', '123', '3e','33333', '45454545T');
INSERT INTO sede (numero_local_sede, calle, numero, piso, cp, cif_editorial) VALUES (2,'Quinta Avenida', '5', '2b','33324', '45454545T');
 
INSERT INTO telefono_sede (tlf_sede, cif_editorial, numero_local_sede) VALUES (988787323,'45454545T', 1);
INSERT INTO telefono_sede (tlf_sede, cif_editorial, numero_local_sede) VALUES (988732323, '45454545T', 2);
 
INSERT INTO imprenta (cif_imprenta, nombre_imprenta, local_impr) VALUES ('32435465U', 'Oficode', 'Calle Falsa');
INSERT INTO imprenta (cif_imprenta, nombre_imprenta, local_impr) VALUES ('32435432T', 'Impr', 'Juan XIII');
 
INSERT INTO telefono_imprenta (tlf_imp, cif_imprenta) VALUES (989898878, '32435465U');
INSERT INTO telefono_imprenta (tlf_imp, cif_imprenta) VALUES (989895478, '32435432T');
 
INSERT INTO publicacion  (numero_publicacion, nombre_publicacion, tipo, precio, fecha, cif_imprenta, fecha_impresion) VALUES (100, 'El Quijote','Libro', 4, '1998','32435465U','1-3-2013');
INSERT INTO publicacion  (numero_publicacion, nombre_publicacion, tipo, precio, fecha, cif_imprenta, fecha_impresion) VALUES (101, 'El Mundo','Periodico', 2, '2016','32435465U','12-11-2016');
INSERT INTO publicacion  (numero_publicacion, nombre_publicacion, tipo, precio, fecha, cif_imprenta, fecha_impresion) VALUES (102, 'Quo','Revista', 3, '2016','32435465U','13-11-2016');
 
INSERT INTO periodico (tipo_per, numero_publicacion) VALUES ('noticias', 101);
INSERT INTO promocion (codigo_prom, puntos, regalo) VALUES ('90A', 85 ,'pulsera');
INSERT INTO promocion (codigo_prom, puntos, regalo) VALUES ('90B', 35 ,'llavero');
INSERT INTO promocion (codigo_prom, puntos, regalo) VALUES ('93B', 25 ,'reloj');
 
INSERT INTO oferta (codigo_prom, numero_publicacion) VALUES ('90B', 101);
 
INSERT INTO fisico(papel, numero_publicacion) VALUES ('Reciclado', 101);
INSERT INTO digital (url, numero_publicacion) VALUES ('www.elmundo.com', 101);
 
INSERT INTO libro (numero_publicacion, ISBN, nombre_li, genero) VALUES (100, 435424, 'El Quijote', 'Ficcion');
INSERT INTO autor(autor,numero_publicacion) VALUES('joaquin',100);
INSERT INTO edicion (numero_edicion, numero_publicacion, numero_paginas, encuadernado) VALUES (43, 100,987,'tapa dura');
 
INSERT INTO gestor (dni_emp, tipo) VALUES ('43215423S', 'secretario');
INSERT INTO gestor (dni_emp, tipo) VALUES ('44484512I', 'contable');


INSERT INTO revista (numero_publicacion, tam, tema) VALUES (102, 'medio','ciencia');
 
INSERT INTO accesorio(codigo_accesorio,valor) VALUES(00,30);
INSERT INTO accesorio(codigo_accesorio,valor) VALUES(01,100);
INSERT INTO accesorio(codigo_accesorio,valor) VALUES(02,20);
 
INSERT INTO regala(numero_publicacion,codigo_accesorio) VALUES(102,00);
INSERT INTO regala(numero_publicacion,codigo_accesorio) VALUES(102,01);
 INSERT INTO CLIENTE (COD_CLI,DIRECCION,CUOTA) VALUES(24,'JUAN XIII',20);
 INSERT INTO CLIENTE (COD_CLI,DIRECCION,CUOTA) VALUES(00,'JUAN XIII',35);
INSERT INTO persona_fisica(dni_p_f,nom_p,cod_cli) VALUES('44484512I','juan',24);


 
INSERT INTO persona_juridica(cif_p_j,cod_cli,nom_jur) VALUES ('5847632D',00,'ladislao');
INSERT INTO cread_cont(cod_cread_cont) VALUES (04);
INSERT INTO cread_cont(cod_cread_cont) VALUES (03);
INSERT INTO cread_cont(cod_cread_cont) VALUES (00);
INSERT INTO cread_cont(cod_cread_cont) VALUES (01);
INSERT INTO grafista(funcion,cod_cread_cont,dni_emp) VALUES ('dibujar',04,'46475836C');
INSERT INTO grafista(funcion,cod_cread_cont,dni_emp) VALUES ('dibujar',03,'46475836D');
 
INSERT INTO ilustrador(tecnica,dni_emp) VALUES('acuarela','46475836D');
 
INSERT INTO fotografo(equipo,dni_emp) VALUES('camara de fotos','46475836C');
 
INSERT INTO redactor(dni_emp,cod_cread_cont) VALUES ('46475836A',00);
INSERT INTO redactor(dni_emp,cod_cread_cont) VALUES ('46475836B',01);
 
INSERT INTO escritor(dni_emp, cod_cread_cont) VALUES('46475836A', 00);
 
INSERT INTO tipo_de_escritor(tipo,dni_emp) VALUES ('teatro','46475836A');
 
INSERT INTO traductor(dni_emp) VALUES('46475836A');
 
INSERT INTO idioma(idioma,dni_emp) VALUES ('ingles','46475836A');
 
INSERT INTO corrector (dni_emp,especialidad) VALUES ('46475836A','ingles');
 
INSERT INTO distribuida_por (fecha_distribucion,codigo_dis,numero_publicacion) VALUES ('02/03/2014',888,100);
INSERT INTO distribuida_por (fecha_distribucion,codigo_dis,numero_publicacion) VALUES ('02/03/2014',889,101);
INSERT INTO distribuida_por (fecha_distribucion,codigo_dis,numero_publicacion) VALUES ('19/02/2016',890,102);
 
INSERT INTO seccion(cod_seccion,nom_sec,numero_empleados) VALUES (0,'edicion',15);
INSERT INTO seccion(cod_seccion,nom_sec,numero_empleados) VALUES (1,'rotulado',3);
INSERT INTO seccion(cod_seccion,nom_sec,numero_empleados) VALUES (3,'imformatica',10);
 
INSERT INTO entrega_a(codigo_dis,cif_p_j) VALUES (888,'5847632D');
 


 
INSERT INTO CLIENTE_EMP (DESCUENTO,DNI_CLIENTE_EMP) VALUES(5,'44484512I');


/********************************************/
/* 6.- Incluímos sentencias de comprobación */
/********************************************/
 
SELECT nombre_dis FROM distribuidor WHERE codigo_dis=888;
SELECT transporte FROM distribuidor WHERE nombre_dis='Seur';
 
SELECT tlf_dis FROM telefono_distribuidor WHERE codigo_dis=890;
 
SELECT * FROM editorial WHERE cif_matriz='45454543F';
 
SELECT dni_emp_sup FROM empleado WHERE dni_emp='43215423S';
 
SELECT tlf_emp FROM telefono_empleado WHERE dni_emp='43215423S';
 
SELECT * FROM sede where cif_editorial='45454545T';
 
SELECT * FROM telefono_sede where cif_editorial='45454545T';
 
SELECT nombre_imprenta FROM imprenta WHERE cif_imprenta='32435465U';
 
SELECT tlf_imp FROM telefono_imprenta WHERE cif_imprenta='32435432T';
 
SELECT * FROM publicacion WHERE cif_imprenta='32435465U';
 
SELECT puntos FROM promocion WHERE regalo='reloj';
 
SELECT numero_publicacion FROM oferta WHERE codigo_prom='90B';
 
SELECT * FROM digital;
SELECT numero_publicacion FROM fisico WHERE papel= 'Reciclado';
 
SELECT encuadernado FROM edicion WHERE numero_publicacion=100;
 
SELECT tema FROM revista WHERE numero_publicacion=102;
 
SELECT * FROM accesorio WHERE valor >15;
 
SELECT * FROM regala;
 
SELECT * FROM persona_fisica;
SELECT * FROM persona_fisica WHERE cod_cli > 25;
 
SELECT nom_jur FROM persona_juridica WHERE cod_cli=00;
SELECT * FROM persona_juridica;
 
SELECT * FROM grafista WHERE funcion = 'dibujar';
 
SELECT * FROM ilustrador WHERE tecnica = 'acuarela';
 
SELECT DISTINCT dni_emp FROM fotografo WHERE equipo = 'camara de fotos';
 
SELECT * FROM redactor;
SELECT * FROM redactor WHERE cod_cread_cont = 00;
 
SELECT * FROM escritor;
 
SELECT * FROM tipo_de_escritor;
 
SELECT * FROM traductor;
 
SELECT * FROM idioma WHERE idioma='ingles';
 
SELECT * FROM corrector;       	
 
SELECT * FROM distribuida_por;
 
SELECT * FROM seccion;
 
SELECT * FROM entrega_a;



/********************************************/
/* 6.- IncluÃ­mos sentencias de comprobaciÃ³n */
/********************************************/

SELECT nombre_dis FROM distribuidor WHERE codigo_dis=888;

SELECT transporte FROM distribuidor WHERE nombre_dis='Seur';

SELECT tlf_dis FROM telefono_distribuidor WHERE codigo_dis=890;

SELECT * FROM editorial WHERE cif_matriz='45454543F';

SELECT dni_emp_sup FROM empleado WHERE dni_emp='43215423S';

SELECT tlf_emp FROM telefono_empleado WHERE dni_emp='43215423S';

SELECT * FROM sede where cif_editorial='45454545T';

SELECT * FROM telefono_sede where cif_editorial='45454545T';

SELECT nombre_imprenta FROM imprenta WHERE cif_imprenta='32435465U';

SELECT tlf_imp FROM telefono_imprenta WHERE cif_imprenta='32435432T';

SELECT * FROM publicacion WHERE cif_imprenta='32435465U';

SELECT puntos FROM promocion WHERE regalo='reloj';

SELECT numero_publicacion FROM oferta WHERE codigo_prom='90B';

SELECT * FROM digital;

SELECT numero_publicacion FROM fisico WHERE papel= 'Reciclado';

SELECT encuadernado FROM edicion WHERE numero_publicacion=100;

SELECT tema FROM revista WHERE numero_publicacion=102;

SELECT * FROM accesorio WHERE valor>15;

SELECT * FROM regala;

SELECT * FROM persona_fisica;

SELECT * FROM persona_fisica WHERE cod_cli>25;

SELECT nom_jur FROM persona_juridica WHERE cod_cli=00;

SELECT * FROM persona_juridica;

SELECT * FROM grafista WHERE funcion = 'dibujar';

SELECT * FROM ilustrador WHERE tecnica = 'acuarela';

SELECT DISTINCT dni_emp FROM fotografo WHERE equipo = 'camara de fotos';

SELECT * FROM redactor;

SELECT * FROM redactor WHERE cod_cread_cont = 00;

SELECT * FROM escritor;

SELECT * FROM tipo_de_escritor;

SELECT * FROM traductor;

SELECT * FROM idioma WHERE idioma='ingles';

SELECT * FROM corrector;

SELECT * FROM distribuida_por;

SELECT * FROM seccion;

SELECT * FROM entrega_a;



/*****************************************/
/* 7.- Procedimientos y Funciones PL/SQL */
/*****************************************/

/*Calcula la cuota que debe pagar un cliente-empleado despues de aplicarle el descuento correspondiente*/
CREATE OR REPLACE
FUNCTION descue (codigo IN INT)
RETURN NUMBER
IS
  prec_total NUMBER;
  
BEGIN 

    SELECT ROUND(cuota-(cuota*(c.descuento/100)),2) INTO prec_total
    FROM PERSONA_FISICA a, CLIENTE b, CLIENTE_EMP c
    WHERE a.cod_cli=b.cod_cli AND a.dni_p_f=c.dni_cliente_emp AND a.cod_cli=codigo;
    RETURN prec_total;

  
  EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT('No existe ningun cliente-empleado con ese código ===> ');
    RETURN 0;
   
END descue;
/
show errors;


/*Calcula el precio de una publicación tras aplicar un descuento dado*/
CREATE OR REPLACE
FUNCTION precio_desc (cod_publi IN INT, descuento IN FLOAT)
RETURN FLOAT
IS
  precio_fin FLOAT;
  MI_EXCEPTION EXCEPTION;
  CURSOR C_DES IS
    SELECT ROUND(precio * (1-(descuento/100)),2)
    FROM PUBLICACION
    WHERE numero_publicacion = cod_publi;
BEGIN 
  OPEN C_DES;
    FETCH C_DES INTO precio_fin;
    IF (C_DES%ROWCOUNT = 0) THEN
      RAISE MI_EXCEPTION;
    ELSE
      RETURN precio_fin;
    END IF;
  CLOSE C_DES;
  
  EXCEPTION WHEN MI_EXCEPTION THEN
    DBMS_OUTPUT.PUT('No existe ninguna publicación con ese código ===> ');
    RETURN 0;
    
END precio_desc;
/
show errors;



/*Comprueba si existe un empleado con un dni dado*/
CREATE OR REPLACE
FUNCTION dniEmp (dni_num IN VARCHAR2)
RETURN VARCHAR2
IS
  dni_ret EMPLEADO.DNI_EMP%TYPE;
  toRet VARCHAR2(2);
  CURSOR C_DNI IS
    SELECT dni_emp
    FROM EMPLEADO
    WHERE dni_emp = dni_num AND dni_emp LIKE ('_________');
BEGIN 
  OPEN C_DNI;
    FETCH C_DNI INTO dni_ret;
    IF (C_DNI%ROWCOUNT = 0) THEN
      RETURN 'NO';
    ELSE
      RETURN 'SI';
    END IF;
  CLOSE C_DNI;
  
END dniEmp;
/
show errors;


/*Procedimiento que muestra una lista de empleados que tienen supervisor.*/
CREATE OR REPLACE
PROCEDURE ListaEmp 
IS
  tab_emp EMPLEADO%ROWTYPE;
  MI_EXCEPTION EXCEPTION;
  
CURSOR C_EMP IS
  SELECT dni_emp, dni_emp_sup, cif_editorial
  FROM EMPLEADO
  WHERE dni_emp_sup IS NOT NULL;
  
BEGIN
  OPEN C_EMP;
  DBMS_OUTPUT.PUT_LINE('Lista de empleados supervisados de la editorial: ');
  LOOP
  FETCH C_EMP INTO tab_emp;
  EXIT WHEN C_EMP%NOTFOUND;
  DBMS_OUTPUT.PUT_LINE(tab_emp.dni_emp || ' superior: ' || tab_emp.dni_emp_sup || ' trabaja en: ' || tab_emp.cif_editorial);
  END LOOP;
  IF (C_EMP%ROWCOUNT = 0) THEN
    RAISE MI_EXCEPTION;
  END IF;
  CLOSE C_EMP;
  

EXCEPTION 
  WHEN MI_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE('No hay empleados con supervisor.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Codigo: ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SUBSTR(SQLERRM, 11, 100));
END ListaEmp;
/
show errors;


/*Muestra el listado de libros pertenecientes a un género dado.*/
CREATE OR REPLACE
PROCEDURE ListaLib(gen IN VARCHAR2, numLib OUT NUMBER)
IS
   regEmp LIBRO%ROWTYPE;
   E_MI_EXCEPCION EXCEPTION;

  CURSOR C_EMP IS
    SELECT numero_publicacion,ISBN, nombre_li,genero
    FROM LIBRO
    WHERE genero = gen;
BEGIN
   OPEN C_EMP;
   DBMS_OUTPUT.PUT_LINE('Libros del genero: "' || gen || '"');  
   LOOP
      FETCH C_EMP INTO regEmp;
      EXIT WHEN C_EMP%NOTFOUND;
      DBMS_OUTPUT.PUT(regEmp.nombre_li || ', ISBN=' || regEmp.ISBN || ', Numero de publicacion=' || regEmp.numero_publicacion );
      DBMS_OUTPUT.PUT_LINE('');
   END LOOP;

   numLib := C_EMP%ROWCOUNT;
   IF (numLib = 0) THEN
      RAISE E_MI_EXCEPCION;
   END IF;
   
   CLOSE C_EMP;
   
EXCEPTION
   WHEN E_MI_EXCEPCION THEN
      DBMS_OUTPUT.PUT_LINE('No hay libros de ese género.');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Código: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SUBSTR(SQLERRM, 11, 100));
END ListaLib;
/
show errors


/*Procedimiento que muestra una lista de clientes cuya cuota es mayor a una dada y actualiza automaticamente la cuota que deben pagar despues de aplicarle un descuento.*/
CREATE OR REPLACE
PROCEDURE AumentDesc (cuota_dada IN INT, des IN FLOAT, num_aum OUT INT)
IS
  rcli CLIENTE%ROWTYPE;
  rcli1 CLIENTE%ROWTYPE;
  MI_EXCEPTION EXCEPTION;
  
CURSOR C_CLI IS
  SELECT *
  FROM CLIENTE
  WHERE cuota > cuota_dada FOR UPDATE;
  
CURSOR C_CLI_N IS
  SELECT *
  FROM CLIENTE;
  
BEGIN
  DBMS_OUTPUT.PUT_LINE('Lista de código de clientes con cuota mayor que ' || cuota_dada || ': ');
  num_aum := 0;
  FOR rcli IN C_CLI LOOP
    DBMS_OUTPUT.PUT_LINE(rcli.cod_cli || ' tiene una cuota de: ' || rcli.cuota);
    UPDATE CLIENTE SET cuota=ROUND(cuota-(cuota * (des/100)),2)
    WHERE CURRENT OF C_CLI;
    OPEN C_CLI_N;
    LOOP
      FETCH C_CLI_N INTO rcli1;
      EXIT WHEN C_CLI_N%NOTFOUND;
        IF (rcli1.cod_cli = rcli.cod_cli) THEN
          DBMS_OUTPUT.PUT_LINE('Nueva cuota del cliente ' || rcli1.cod_cli || ': ' || rcli1.cuota);
        END IF;
      END LOOP;
    CLOSE C_CLI_N;
    
    num_aum := num_aum + 1;
  END LOOP;
  
  IF (num_aum = 0) THEN
    RAISE MI_EXCEPTION;
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Numero de empleados a los que se les aplica descuento: ' || num_aum);
  
  EXCEPTION
   WHEN MI_EXCEPTION THEN
      DBMS_OUTPUT.PUT_LINE('No hay clientes con una cuota superior a ' || cuota_dada || '.');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Código: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SUBSTR(SQLERRM, 11, 100));

END AumentDesc;
/
show errors;



/************************/
/* 8.- Bloque PRINCIPAL */
/************************/

SET SERVEROUTPUT ON
DECLARE
  toRet FLOAT;
  toRet1 VARCHAR2(2);
  toRet2 FLOAT;
  codigo INT;
  descuento FLOAT;
  dni VARCHAR2(9);
  
BEGIN
  DBMS_OUTPUT.NEW_LINE;
  
--FUNCIONES
  DBMS_OUTPUT.PUT_LINE('======>INICIO FUNCION: desc');
  codigo := 24;
  toRet:= descue(codigo);
  DBMS_OUTPUT.PUT_LINE('Cuota con descuento del empleado ' || codigo ||  ': ' || toRet);
  codigo := 0;
  toRet:= descue(codigo);
  DBMS_OUTPUT.PUT_LINE('Cuota con descuento del empleado ' || codigo ||  ': ' || toRet);
  DBMS_OUTPUT.PUT_LINE('======>FIN FUNCION: desc');
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE('======>INICIO FUNCION: precio_desc');
  codigo := 102;
  descuento := 2.5;
  toRet:= precio_desc(codigo,descuento);
  DBMS_OUTPUT.PUT_LINE('Precio de la publicacion ' || codigo || ' con el descuento del ' || descuento ||  ': ' || toRet);
  codigo := 1;
  descuento := 12;
  toRet:= precio_desc(codigo,descuento);
  DBMS_OUTPUT.PUT_LINE('Precio de la publicacion ' || codigo || ' con el descuento del ' || descuento ||  ': ' || toRet);
  DBMS_OUTPUT.PUT_LINE('======>FIN FUNCION: precio_desc');
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE('======>INICIO FUNCION: dniEmp');
  dni := '76583535K';
  toRet1 := dniEmp(dni);
  DBMS_OUTPUT.PUT_LINE('Existe dni ' || dni || ': ' || toRet1);
  dni := '46475836A';
  toRet1 := dniEmp(dni);
  DBMS_OUTPUT.PUT_LINE('Existe dni ' || dni || ': ' || toRet1);
  DBMS_OUTPUT.PUT_LINE('======>FIN FUNCION: dniEmp');
  DBMS_OUTPUT.NEW_LINE;
  
-- Procedimientos
  DBMS_OUTPUT.PUT_LINE('======>INICIO PROCEDIMIENTO: ListaEmp');
  ListaEmp();
  DBMS_OUTPUT.PUT_LINE('======>FIN PROCEDIMIENTO: ListaEmp');
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE('======>INICIO PROCEDIMIENTO: ListaLib');
  ListaLib('Ficcion', toRet2);
  DBMS_OUTPUT.NEW_LINE;
  ListaLib('Accion', toRet2);
  DBMS_OUTPUT.PUT_LINE('======>FIN PROCEDIMIENTO: ListaLib');
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE('======>INICIO PROCEDIMIENTO: AumentDesc');
  AumentDesc(6,15,toRet2);
  DBMS_OUTPUT.PUT_LINE('======>FIN PROCEDIMIENTO: AumentDesc');
  DBMS_OUTPUT.NEW_LINE;

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[EXCEPCIÓN]');
      DBMS_OUTPUT.PUT_LINE('[Código]: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('[Mensaje]: ' || SUBSTR(SQLERRM, 11, 100));
      
END;
/
