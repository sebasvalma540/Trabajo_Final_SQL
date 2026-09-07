SELECT Categoria,
		count(*) as Total_Productos,
		Max(PrecioUnitario) as PrecioMaximo,
		Avg(PrecioUnitario) as PrecioPromedio,
		Min(PrecioUnitario) as PrecioMinimo,
		100 *count(*) / sum(count(*)) over () as PorcentajeTotal 
FROM DIM_PRODUCTOS
GROUP BY Categoria
ORDER BY Categoria ASC