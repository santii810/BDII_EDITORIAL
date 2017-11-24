CREATE OR REPLACE
FUNCTION NUMDESPACHO(NIF IN VARCHAR2)
RETURN INT
IS
   numeroDespacho INT;
   E_MI_EXCEPCION EXCEPTION;
BEGIN
   SELECT NUM_DESPACHO INTO numeroDespacho
      FROM RESPONSABLE 
      WHERE NIF_EMPLEADO = NIF;
   RETURN numeroDespacho;
  EXCEPTION
   WHEN no_data_found THEN
      dbms_output.put_line('No existe el responsable con NIF: '||NIF);
      RETURN NULL;
END NUMDESPACHO;
/
show errors