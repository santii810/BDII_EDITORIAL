SET AUTOCOMMIT on;


CREATE TABLE DISTRIBUIDOR
(
  COD_DISTRIBUIDOR NUMBER(3) CONSTRAINT PK_distibuidor PRIMARY KEY, 
  NOMBRE_DISTRIBUIDOR VARCHAR(20) NOT NULL,
  TLFN_DISTRIBUIDOR		VARCHAR2(14) NOT NULL,
  EMAIL_DISTRIBUIDOR		VARCHAR2(25) NOT NULL
);

CREATE TABLE PAQUETERIA
(
  COD_PAQUETERIA  NUMBER(3), 
  COD_DISTRIBUIDOR NUMBER (3),
  TIPO_TRANSPORTE VARCHAR(20) NOT NULL,
  CONSTRAINT PK_Paqueteria PRIMARY KEY (COD_PAQUETERIA, COD_DISTRIBUIDOR)
);

CREATE TABLE DISTRIBUIDOR_DIGITAL
(
  COD_DISTRIBUIDOR_DIGITAL NUMBER(3),
  COD_DISTRIBUIDOR NUMBER (3),
  CONSTRAINT PK_Paqueteria PRIMARY KEY (COD_DISTRIBUIDOR_DIGITAL, COD_DISTRIBUIDOR)
);



CREATE TABLE EJEMPLAR
(
  COD_EJEMPLAR NUMBER(5) CONSTRAINT PK_ejemplar PRIMARY KEY
);

CREATE TABLE DISTRIBUYE
(
  COD_EJEMPLAR NUMBER(5),
  COD_DISTRIBUIDOR NUMBER(3),
  FECHA_DISTRIBUCION DATE,
  CONSTRAINT PK_Distribuye PRIMARY KEY (COD_EJEMPLAR,COD_DISTRIBUIDOR)
);


CREATE TABLE IMPRENTA
(
  CIF_IMPRENTA VARCHAR(9) CONSTRAINT PK_imprenta PRIMARY KEY,
  NOMBRE_IMPRENTA VARCHAR(20) NOT NULL,
  TLFN_IMPRENTA		VARCHAR2(14) NOT NULL,
  EMAIL_IMPRENTA		VARCHAR2(25) NOT NULL
);

CREATE TABLE IMPRIME
(
  CIF_IMPRENTA VARCHAR(9),
  COD_EJEMPLAR NUMBER(5),
  FECHA_IMPRESION DATE,
  CONSTRAINT PK_Distribuye PRIMARY KEY (CIF_IMPRENTA,COD_EJEMPLAR)
);

CREATE TABLE PUBLICACION
(
  COD_PUBLICACION NUMBER(5),
  NOMBRE_PUBLICACION VARCHAR (20),
  TEMATICA_PUBLICACION VARCHAR(20),
  FECHA_PUBLICACION DATE,
  AUTOR_PUBLICACION VARCHAR(20),
  FORMATO_PUBLICACION VARCHAR(20)
);