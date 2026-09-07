SELECT NombreTienda,
		Region, 
		SUM(Venta_Neta_Transac) as Venta_Total,
		SUM(Utilidad_Bruta_Tienda) as Utilidad_Total,
		round(SUM(Utilidad_Bruta_Tienda) / SUM(Venta_Neta_Transac), 3) as Margen_Bruto_Utilidad
FROM (SELECT DT.NombreTienda,
			DT.Region,
			FT.Cantidad,
			FT.Descuento,
			DP.PrecioUnitario,
			DP.PrecioCosto,
			(FT.Cantidad * DP.PrecioUnitario * (1.0 - FT.Descuento)) AS Venta_Neta_Transac,
			((((1.0-FT.Descuento)*DP.PrecioUnitario) - DP.PrecioCosto)*FT.Cantidad) as Utilidad_Bruta_Tienda
	from FACT_TRANSAC FT 
	INNER JOIN DIM_TIENDAS DT ON  FT.IDTienda = DT.IDTienda
	INNER JOIN DIM_PRODUCTOS DP ON DP.IDProducto = FT.IDProducto) AS TB_TIENDA_VENTA
GROUP BY NombreTienda, Region
ORDER BY Margen_Bruto_Utilidad DESC


