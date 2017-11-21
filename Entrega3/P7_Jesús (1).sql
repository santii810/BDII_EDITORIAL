/* 1 */ /* Quitar de Catálogo aquellas publicaciones que tras pasados 5 meses no consigan mantener el mínimo de venta que se ha estipulado por la empresa (100 ejemplares cada 5 meses).*/

/* 2 */	/* Controlar la demanda de cada publicación (mensualmente) */			
			CREATE OR REPLACE
				PROCEDURE ventasEn5Meses
				IS
				  coincidencias NUMBER;
				  empNoAsig NUMBER;
				  
				  codEjemplar COMPRA.COD_EJEMPLAR%TYPE;
				  codPublicacion EJEMPLAR.COD_PUBLICACION%TYPE;		  
				  
					CURSOR C_EJEMPLAR		 	IS     SELECT COD_EJEMPLAR    	FROM COMPRA			ORDER BY COD_EJEMPLAR;
					CURSOR C_PUBLICACION 		IS     SELECT COD_PUBLICACION   FROM EJEMPLAR		ORDER BY COD_EJEMPLAR;
					CURSOR F_COMPRA				IS     SELECT FECHA_COMPRA   	FROM COMPRA			ORDER BY COD_EJEMPLAR;
				  
				BEGIN 

				empNoAsig := 0;
				OPEN  C_EJEMPLAR ;
				OPEN  C_PUBLICACION ;

				/*FETCH - INTO -;*/
				FETCH C_EJEMPLAR	INTO codEjemplar;
				FETCH C_PUBLICACION INTO codPublicacion;
				FETCH F_COMPRA INTO fechaCompra;

				 LOOP
				 coincidencias := 0;
					FETCH F_COMPRA INTO fechaCompra;
					 EXIT WHEN F_COMPRA%NOTFOUND;
				   
					  IF (fechaCompra >= DATEADD(MM, -1, GETDATE()))
					  THEN
							IF (codEjemplar = codPublicacion)
							THEN 
								FETCH C_EJEMPLAR INTO codEjemplar;
								coincidencias:=coincidencias + 1;
							END IF;
					  END IF;  
				   
				  END LOOP;
				  
				  IF(empNoAsig = 0)
				  THEN 
						DBMS_OUTPUT.PUT_LINE('Sin ventas durente este mes'); 
				  END IF;
				 
				END ventasEn5Meses;
				/
				show errors;
			
						/* Comprobacion */
			
			
			
/* 3 */	/* Para cada Publicacion sus Ejemplares asociados */	
				CREATE OR REPLACE
				FUNCTION ejemplarPublicacion(publicacion IN INT)
				RETURN INT
				IS
				codigo INT;
				BEGIN
				SELECT COD_EJEMPLAR codigo FROM EJEMPLAR WHERE COD_PUBLICACION=publicacion ORDER BY COD_PUBLICACION;
				RETURN codigo;
				END ejemplarPublicacion;
				
					/* Comprobacion */
