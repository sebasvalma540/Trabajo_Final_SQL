SELECT
    CASE
        WHEN FT.Cantidad <= 2 THEN 'Compra chica (1-2 und)'
        WHEN FT.Cantidad =  3 THEN 'Compra media (3 und)'
        ELSE 'Compra grande (4-5 und)'
    END AS TamanoCompra,
    COUNT(*) as TotalTransacciones,
    SUM(FT.Cantidad) as UnidadesVendidas,
    ROUND(SUM(FT.Cantidad * DP.PrecioUnitario * (1 - FT.Descuento)), 2) as VentaNeta,
    ROUND(SUM(FT.Cantidad * DP.PrecioUnitario * (1 - FT.Descuento)) / COUNT(*), 2) as TicketPromedio,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) as PctTransacciones,
    ROUND(100.0 * SUM(FT.Cantidad * DP.PrecioUnitario * (1 - FT.Descuento)) / SUM(SUM(FT.Cantidad * DP.PrecioUnitario * (1 - FT.Descuento))) OVER (), 1) as PctVenta
FROM FACT_TRANSAC FT
INNER JOIN DIM_PRODUCTOS DP ON FT.IDProducto = DP.IDProducto
GROUP BY
    CASE
        WHEN FT.Cantidad <= 2 THEN 'Compra chica (1-2 und)'
        WHEN FT.Cantidad =  3 THEN 'Compra media (3 und)'
        ELSE 'Compra grande (4-5 und)'
    END
ORDER BY VentaNeta DESC;