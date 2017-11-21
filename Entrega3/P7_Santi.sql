
/*		Necesario para que el proceso pueda imprimir*/
set serveroutput on;

/*	Busca entre los empleados si existe alguno que no haya sido asignado a algun departamento */
CREATE OR REPLACE
PROCEDURE comprobarAsignacionEmpleados 
IS
  coincidencias NUMBER;
  empNoAsig NUMBER;
  nifEmpleado EMPLEADO.NIF_EMPLEADO%TYPE;
  nifResponsable EMPLEADO.NIF_EMPLEADO%TYPE;
  nifTraductor EMPLEADO.NIF_EMPLEADO%TYPE;
  nifDiseNador EMPLEADO.NIF_EMPLEADO%TYPE;
  nifRedactor EMPLEADO.NIF_EMPLEADO%TYPE;
  
  CURSOR C_EMPLEADO IS     SELECT NIF_EMPLEADO    FROM EMPLEADO     ORDER BY NIF_EMPLEADO;
  CURSOR C_REDACTOR IS     SELECT NIF_EMPLEADO    FROM REDACTOR     ORDER BY NIF_EMPLEADO;
  CURSOR C_TRADUCTOR IS    SELECT NIF_EMPLEADO    FROM TRADUCTOR    ORDER BY NIF_EMPLEADO;
  CURSOR C_DISENADOR IS    SELECT NIF_EMPLEADO    FROM DISENADOR    ORDER BY NIF_EMPLEADO;
  CURSOR C_RESPONSABLE IS  SELECT NIF_EMPLEADO    FROM RESPONSABLE  ORDER BY NIF_EMPLEADO;
       
  
BEGIN 

empNoAsig := 0;
OPEN  C_EMPLEADO ;
OPEN  C_REDACTOR ;
OPEN  C_TRADUCTOR  ;
OPEN  C_DISENADOR ;
OPEN  C_RESPONSABLE ;

/*FETCH C_EMPLEADO INTO nifEmpleado;*/
FETCH C_REDACTOR INTO nifRedactor;
FETCH C_TRADUCTOR INTO nifTraductor;
FETCH C_DISENADOR INTO nifDiseNador;
FETCH C_RESPONSABLE INTO nifResponsable;


 LOOP
 coincidencias := 0;
    FETCH C_EMPLEADO INTO nifEmpleado;
     EXIT WHEN C_EMPLEADO%NOTFOUND;
   
      IF (nifEmpleado = nifRedactor)
      THEN 
        FETCH C_REDACTOR INTO nifRedactor;
        coincidencias:=coincidencias + 1;
      END IF;
      
      IF (nifEmpleado = nifTraductor)
      THEN 
        FETCH C_TRADUCTOR INTO nifTraductor;
        coincidencias:=coincidencias + 1;
      END IF;
      
      IF (nifEmpleado = nifDiseNador)
      THEN 
        FETCH C_DISENADOR INTO nifDiseNador;
        coincidencias:=coincidencias + 1;
      END IF;
      
      IF (nifEmpleado = nifResponsable)
      THEN 
        FETCH C_RESPONSABLE INTO nifResponsable;
        coincidencias:=coincidencias + 1;
      END IF;

   /*   DBMS_OUTPUT.PUT_LINE('Empleado: ' || nifEmpleado || ' coincidencias' || coincidencias); */
      IF(coincidencias = 0)
      THEN 
         DBMS_OUTPUT.PUT_LINE('Empleado: ' || nifEmpleado || ' no asignado a ningun departamento'); 
         empNoAsig := empNoAsig +1;
      END IF;
          
   
  END LOOP;
  
  IF(empNoAsig = 0)
  THEN 
        DBMS_OUTPUT.PUT_LINE('Todos los empleados estan asignados a algún departamento'); 
  END IF;
 
END comprobarAsignacionEmpleados;
/
show errors;

/* Comprobacion */
exec comprobarAsignacionEmpleados();
DELETE FROM REDACTOR WHERE NIF_EMPLEADO='54985513H';
exec comprobarAsignacionEmpleados();
INSERT INTO REDACTOR VALUES('54985513H','DISTANCIA');

























/* Retorna la edad en funcion de la fecha pasada como parametro */
CREATE OR REPLACE
FUNCTION calcularEdad (fechaNac IN DATE)
RETURN NUMBER
IS
  edad NUMBER;
BEGIN
  /* trucamos ( diferencia (mesActual-mesNacimiento)/12 )*/
  SELECT FLOOR(months_between(sysdate,fechaNac)/12) INTO edad FROM dual;
  RETURN edad;
END calcularEdad;

/* Comprobacion */
SELECT nombre, calcularEdad(FECHA_NACIMIENTO)
FROM EMPLEADO;




















/*Aplica X nuevoDescuento enviado como parametro a los empleados que se hayan registrado como cliente y lleven mas de Y tiempo
 siendo X el porcentaje de nuevoDescuento e Y el numero de meses que llevan contratados
 Se controla que el descuento a aplicar sea mayor al que ya tiene el cliente_empleado 
 */
CREATE OR REPLACE
PROCEDURE descuentoEmpleados (nuevoDescuento IN NUMBER, antiguedadRequerida IN NUMBER)
IS
  clienteEmpleado CLIENTE_EMPLEADO%ROWTYPE;
  antiguedadEmpleado NUMBER;
  
CURSOR CLI_EMP IS
  SELECT *
  FROM CLIENTE_EMPLEADO
  WHERE  DESCUENTO < nuevoDescuento
  FOR UPDATE;
  
BEGIN
  FOR clienteEmpleado IN CLI_EMP LOOP
    SELECT  months_between(sysdate,FECHA_CONTRATACION) 
    INTO antiguedadEmpleado
    FROM EMPLEADO
    WHERE NIF_EMPLEADO  = clienteEmpleado.NIF_CLI_EMP;
    
    IF(antiguedadEmpleado >= antiguedadRequerida)
    THEN 
      UPDATE CLIENTE_EMPLEADO 
      SET DESCUENTO = nuevoDescuento 
      WHERE CURRENT OF CLI_EMP;
    END IF;
    
  END LOOP;
    
END descuentoEmpleados;
/
show errors;

/* Comprobacion:
Aplica un 10% de descuento a los empleados con 12 meses de antiguedad*/
SELECT CE.NIF_CLI_EMP, E.NOMBRE, CE.DESCUENTO, 
FLOOR(months_between(sysdate,E.FECHA_CONTRATACION)) AS ANTIGUEDAD  
FROM EMPLEADO E, CLIENTE_EMPLEADO CE 
WHERE  E.NIF_EMPLEADO = CE.NIF_CLI_EMP;
  
exec descuentoEmpleados (10,12);

SELECT CE.NIF_CLI_EMP, E.NOMBRE, CE.DESCUENTO, 
FLOOR(months_between(sysdate,E.FECHA_CONTRATACION)) AS ANTIGUEDAD  
FROM EMPLEADO E, CLIENTE_EMPLEADO CE 
WHERE  E.NIF_EMPLEADO = CE.NIF_CLI_EMP;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 



CREATE OR REPLACE
PROCEDURE ejemplaresNoVendidos 
IS
  codCompra EJEMPLAR.COD_EJEMPLAR%TYPE;
  codEjemplar EJEMPLAR.COD_EJEMPLAR%TYPE;

  CURSOR C_EJEMPLAR IS     SELECT COD_EJEMPLAR    FROM EJEMPLAR;
  CURSOR C_COMPRA  IS      SELECT COD_EJEMPLAR    FROM COMPRA     ORDER BY COD_EJEMPLAR;

BEGIN 
OPEN  C_EJEMPLAR ;
OPEN  C_COMPRA ;

FETCH C_COMPRA INTO codCompra;
 LOOP
    FETCH C_EJEMPLAR INTO codEjemplar;
    EXIT WHEN C_EJEMPLAR%NOTFOUND;
   
      IF (codEjemplar = codCompra)
      THEN 
        FETCH C_COMPRA INTO codCompra;
      ELSE
        DBMS_OUTPUT.PUT_LINE('Ejemplar: ' || codEjemplar || ' sigue en stock'); 
      END IF;  
  END LOOP;
  
 
END ejemplaresNoVendidos; 

























































 /*
 COMPROBACIONES
 */
 SET SERVEROUTPUT ON;

DECLARE
  emp EMPLEADO%ROWTYPE;
  empNIF EMPLEADO.NIF_EMPLEADO%TYPE;
  empNac EMPLEADO.FECHA_NACIMIENTO%TYPE; 
  descuent CLIENTE_EMPLEADO.DESCUENTO%TYPE;
  antigued NUMBER;
 
 CURSOR C_EMP IS
  SELECT NIF_EMPLEADO, FECHA_NACIMIENTO
  FROM EMPLEADO;
 
 CURSOR C_CLI_EMP IS
 SELECT CE.NIF_CLI_EMP, CE.DESCUENTO, 
FLOOR(months_between(sysdate,E.FECHA_CONTRATACION)) AS ANTIGUEDAD  
FROM EMPLEADO E, CLIENTE_EMPLEADO CE 
WHERE  E.NIF_EMPLEADO = CE.NIF_CLI_EMP;


 BEGIN
  OPEN C_EMP;
  OPEN C_CLI_EMP;
 
  
  /*Empieza a imprimir los resultados*/
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.NEW_LINE;
  
  DBMS_OUTPUT.PUT_LINE('***** INICIO FUNCION: comprobarAsignacionEmpleados');
  DBMS_OUTPUT.PUT_LINE('** Hacemos comprobacion: ');
  DBMS_OUTPUT.PUT('   ');  
  comprobarAsignacionEmpleados();
  DELETE FROM REDACTOR WHERE NIF_EMPLEADO='54985513H';
  DBMS_OUTPUT.PUT_LINE('** Borramos a un empleado de un departamento y repetimos comprobacion');
  DBMS_OUTPUT.PUT('   ');  
  comprobarAsignacionEmpleados();
  INSERT INTO REDACTOR VALUES('54985513H','DISTANCIA');
  DBMS_OUTPUT.PUT_LINE('***** FIN FUNCION: comprobarAsignacionEmpleados');
 
 
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.NEW_LINE;


  DBMS_OUTPUT.PUT_LINE('***** INICIO FUNCION: calcularEdad');
  LOOP
    FETCH C_EMP INTO empNIF,empNac;
     EXIT WHEN C_EMP%NOTFOUND;
  DBMS_OUTPUT.PUT_LINE('   Edad de empleado ' || empNIF || ': ' ||calcularEdad(empNac) || ' años.');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('***** FIN FUNCION: calcularEdad');

  
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.NEW_LINE;

  DBMS_OUTPUT.PUT_LINE('***** INICIO FUNCION: descuentoEmpleados');
  DBMS_OUTPUT.PUT_LINE('** Estado inicial');

  LOOP
    FETCH C_CLI_EMP INTO  empNIF, descuent,antigued;
     EXIT WHEN C_CLI_EMP%NOTFOUND;
  DBMS_OUTPUT.PUT_LINE('   Empleado: ' || empNIF || ',  descuento ' ||descuent || ',  antiguedad: ' || antigued || 'meses.');
  END LOOP;

CLOSE C_CLI_EMP;
OPEN C_CLI_EMP;
   descuentoEmpleados(10,12);
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE('** Estado estado tras ejecucion');
   LOOP
      FETCH C_CLI_EMP INTO empNIF, descuent,antigued;
      EXIT WHEN C_CLI_EMP%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('   Empleado: ' || empNIF || ',  descuento ' ||descuent || ',  antiguedad: ' || antigued || 'meses.');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('***** FIN FUNCION: descuentoEmpleados');


CLOSE C_CLI_EMP;
CLOSE C_EMP;


  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.NEW_LINE;
  
  DBMS_OUTPUT.PUT_LINE('***** INICIO FUNCION: ejemplaresNoVendidos');
  DBMS_OUTPUT.PUT_LINE('** Hacemos comprobacion: ');
  DBMS_OUTPUT.PUT('   ');  
  ejemplaresNoVendidos();
  delete from compra where cod_ejemplar between 30 AND 34;
  DBMS_OUTPUT.PUT_LINE('** Borramos algunas ventas y repetimos comprobacion:');
  DBMS_OUTPUT.PUT('   ');  
  ejemplaresNoVendidos();
  DBMS_OUTPUT.PUT_LINE('***** FIN FUNCION: ejemplaresNoVendidos');



END;
 