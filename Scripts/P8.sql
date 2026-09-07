WITH TB_EDAD AS (
    SELECT IDCliente,
           Genero,
           DATEDIFF(YEAR, FechaNacimiento, GETDATE())
             - CASE 
					WHEN (MONTH(FechaNacimiento) > MONTH(GETDATE())) OR (MONTH(FechaNacimiento) = MONTH(GETDATE()) AND DAY(FechaNacimiento) > DAY(GETDATE()))
						THEN 1 
					ELSE 0 END AS Edad
    FROM DIM_CLIENTES
),
TB_SEGMENTO AS (
    SELECT IDCliente,
           Genero,
           CASE
               WHEN Edad < 30 THEN 'Menos de 30'
               WHEN Edad BETWEEN 30 AND 44 THEN '30 a 44'
               WHEN Edad BETWEEN 45 AND 59 THEN '45 a 59'
               ELSE '60 o más'
           END AS SegmentoEdad
    FROM TB_EDAD
)
SELECT TS.SegmentoEdad,
       TS.Genero,
       COUNT(DISTINCT TS.IDCliente) AS Total_Clientes,
       ROUND(SUM(FT.Cantidad * DP.PrecioUnitario * (1.0 - FT.Descuento)), 2) AS Venta_Neta_Total
FROM TB_SEGMENTO TS
INNER JOIN FACT_TRANSAC FT ON FT.IDCliente = TS.IDCliente
INNER JOIN DIM_PRODUCTOS DP ON DP.IDProducto = FT.IDProducto
GROUP BY TS.SegmentoEdad, TS.Genero
ORDER BY CASE TS.SegmentoEdad
             WHEN 'Menos de 30' THEN 1
             WHEN '30 a 44' THEN 2
             WHEN '45 a 59' THEN 3
             ELSE 4
         END,
         TS.Genero;