SELECT DP.Categoria,
       DP.SubCategoria,
       COUNT(FT.IDTransaccion) AS Total_Transacciones,
       SUM(FT.Cantidad) AS Total_Unidades,
       ROUND(AVG(FT.Cantidad * DP.PrecioUnitario * (1.0 - FT.Descuento)), 2) AS Ticket_Promedio,
       ROUND(AVG(CAST(FT.Cantidad AS FLOAT)), 2) AS Unidades_Por_Transaccion
FROM FACT_TRANSAC FT
INNER JOIN DIM_PRODUCTOS DP ON FT.IDProducto = DP.IDProducto
GROUP BY DP.Categoria, DP.SubCategoria
ORDER BY DP.Categoria, Ticket_Promedio DESC;