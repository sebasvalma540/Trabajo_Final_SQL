WITH TB_BASE AS (
    SELECT
        DT.AñoMes,
        DT.EsFinDeSemana,
        FT.Cantidad * DP.PrecioUnitario * (1.0 - FT.Descuento) AS VentaNeta
    FROM FACT_TRANSAC FT
    INNER JOIN DIM_PRODUCTOS DP ON DP.IDProducto = FT.IDProducto
    INNER JOIN DIM_TIEMPO DT ON DT.ClaveFecha = FT.ClaveFecha
)
SELECT AñoMes,
       CASE 
			WHEN EsFinDeSemana = 'VERDADERO' 
				THEN 'Fin de Semana' 
			ELSE 'Entre Semana' 
				END AS TipoDia,
       ROUND(SUM(VentaNeta), 2) AS Venta_Neta,
       ROUND(100.0 * SUM(VentaNeta) / SUM(SUM(VentaNeta)) OVER (PARTITION BY AñoMes), 2) AS Peso_Dentro_Mes_Percent
FROM TB_BASE
GROUP BY AñoMes, EsFinDeSemana
ORDER BY AñoMes, TipoDia;

