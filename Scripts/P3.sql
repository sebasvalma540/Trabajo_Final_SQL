SELECT MetodoPago,
       COUNT(IDTransaccion) AS Total_Transacciones,
       SUM(Cantidad) AS Total_Cantidad_Vendida,
       ROUND(100.0 * COUNT(IDTransaccion) / SUM(COUNT(IDTransaccion)) OVER(), 2) AS Peso_Transacciones_Percent,
       ROUND(100.0 * SUM(Cantidad) / SUM(SUM(Cantidad)) OVER(), 2) AS Peso_Cantidad_Percent
FROM FACT_TRANSAC
GROUP BY MetodoPago
ORDER BY Total_Transacciones DESC;