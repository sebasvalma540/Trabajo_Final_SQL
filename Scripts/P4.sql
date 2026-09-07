SELECT Descuento,
		COUNT(IDTransaccion) AS NumeroTransaccione ,
		SUM(Cantidad) AS TotalCantidad,
		CAST(ROUND(100.0 * COUNT(IDTransaccion) / SUM(COUNT(IDTransaccion)) OVER(), 2) AS decimal(10,2)) AS Peso_NumTransac_Percent,
        CAST(ROUND(100.0 * SUM(Cantidad) / SUM(SUM(Cantidad)) OVER(), 2) AS decimal(10,2)) AS Peso_TotalCantidad_Percent
FROM FACT_TRANSAC
GROUP BY Descuento
order by Descuento desc