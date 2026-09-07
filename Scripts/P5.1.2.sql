SELECT Distinct TOP 10
		NombreProducto,
		(PrecioUnitario - PrecioCosto) as Utilida_por_Unidad
FROM DIM_PRODUCTOS
order by Utilida_por_Unidad DESC








with TB_Utilidad_Promedio as (
	SELECT  DP.NombreProducto,
			round(AVG(((DP.PrecioUnitario * (1.0-Ft.Descuento)) - DP.PrecioCosto))over(partition by NombreProducto), 2) as Promedio_Utilidad_NombreProducto
	FROM FACT_TRANSAC FT 
	INNER JOIN DIM_PRODUCTOS DP ON FT.IDProducto = DP.IDProducto
	)
select top 10 NombreProducto , Promedio_Utilidad_NombreProducto
from TB_Utilidad_Promedio
GROUP BY NombreProducto, Promedio_Utilidad_NombreProducto
ORDER BY Promedio_Utilidad_NombreProducto desc


