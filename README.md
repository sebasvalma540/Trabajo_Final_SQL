![HR Analytics](./Pictures/BanerS.png)
# Proyecto SQL: Análisis de Ventas Retail (Modelo MegaMart)

## 📌 Resumen (Overview)
_El área comercial de **MegaMart**, una cadena de tiendas retail, desea entender mejor el comportamiento de sus ventas, sus clientes y el desempeño de sus tiendas y productos. Sin embargo, no cuenta con una visión clara ni consolidada de esta información. Mi objetivo es utilizar **SQL** dentro de **SQL Server Management Studio**, analizando los datos de clientes, productos, tiendas y transacciones para responder preguntas de negocio clave y entregar recomendaciones accionables._

## 📩 Si quieres contactarme aqui te dejo mi linkedin =)
<p align="center">
  <a href="https://www.linkedin.com/in/sebastian-valentin-malpartida-11664428a/">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white" />
  </a>
</p> 


## 🔄Estructura del Proyecto

- [Sobre los Datos](#sobre-los-datos)
- [Habilidades de SQL server aplicadas](#habilidades-de-sql-server-aplicadas)
- [Creación de la Base de Datos y Tablas](#creación-de-la-base-de-datos-y-tablas)
- [Carga de Datos](#carga-de-datos)
- [Validación de los Datos](#validación-de-los-datos)
- [Tareas](#tareas)
- [Desarrollo de Tareas](#desarrollo-de-tareas)

## Sobre los Datos

El conjunto de datos ("Retail Sales Dataset", disponible en Kaggle) es un dataset simulado que representa el entorno de una tienda retail: compras de clientes distribuidas en varias tiendas y categorías de productos. Incluye 4 tablas que capturan información sobre ventas, clientes, productos y tiendas, distribuidas en 25 columnas y más de 5000 transacciones para un análisis detallado (sin contar la tabla de tiempo).

El modelo se estructura en las siguientes tablas:
* **Clientes:** Nombre, apellido, género, fecha_de_nacimiento, ciudad, fecha_de_ingreso
* **Productos:** Nombre_de_producto, categoría, subcategoría, precio_unitario, costo
* **Tiendas:** Nombre_de_tienda, ciudad, región
* **Transacciones (tabla de hechos)**: ClaveFecha, ID_de_cliente, ID_de_producto, ID_de_tienda, cantidad, descuento, método_de_pago

Adicionalmente, tal como se mencionó anteriormente, se agregó una nueva tabla dimensional para el manejo de fechas mediante Lenguaje M de Excel, la cual contiene:

* **Tiempo**: ClaveFecha, Año, NúmeroMes, Mes, Trimestre, AñoTrimestre, AñoMes, NúmeroDíaSemana, DíaSemana, NúmeroDíaMes, EsFinDeSemana, NúmeroSemana

Para encontrar mucha más información sobre la base de datos original la puedes encontrar [aquí](https://www.kaggle.com/datasets/buharishehu/retail-sales-dataset/data).

El modelo cuenta con una estructura en estrella, estableciendo relaciones de uno a muchos entre la tabla de hechos y las cuatro tablas dimensionales para un análisis más directo y eficiente.

![alt text](<Pictures/Modelado_de_datos .png>)


## 🎓 Habilidades de SQL server aplicadas
- Comandos basicos
- Agregaciones
- Joins
    - left join
    - right join 
    - inner join
- Subconsultas
- Funciones de ventana


## Creación de la Base de Datos y Tablas

Se creó la base de datos `RETAIL_SALES` en SQL Server Management Studio, junto con las 4 tablas dimensionales (`DIM_CLIENTES`, `DIM_PRODUCTOS`, `DIM_TIENDAS`, `DIM_TIEMPO`) y la tabla de hechos (`FACT_TRANSAC`), relacionadas mediante llaves foráneas siguiendo el esquema en estrella.

Justo después de `USE`, se configura `SET DATEFORMAT dmy` para que SQL Server interprete las fechas en formato peruano (día/mes/año) al momento de la carga; sin esto, el `BULK INSERT` falla con errores de conversión en columnas `date`.

Antes de cada `CREATE TABLE` se valida con `OBJECT_ID` si la tabla ya existe, para eliminarla y evitar conflictos al volver a ejecutar el script.


```sql
CREATE DATABASE RETAIL_SALES;
USE RETAIL_SALES;

-- Convierte el formato de fecha de Perú (dd/mm/yyyy) al que espera SQL Server.
-- Debe ejecutarse una sola vez, antes de cualquier carga de datos.
SET DATEFORMAT dmy;

-- ============================================
-- TABLA DIMENSIÓN: DIM_CLIENTES
-- ============================================

IF OBJECT_ID('DIM_CLIENTES') IS NOT NULL
    DROP TABLE DIM_CLIENTES;

CREATE TABLE DIM_CLIENTES ( 
    IDCliente Nvarchar(150) PRIMARY KEY,
    Nombre Nvarchar(150),
    Apellido Nvarchar(150),
    Genero Nvarchar(150),
    FechaNacimiento date,
    Ciudad Nvarchar(150),
    FechaRegistro date
);

-- ============================================
-- TABLA DIMENSIÓN: DIM_PRODUCTOS
-- ============================================

IF OBJECT_ID('DIM_PRODUCTOS') IS NOT NULL
    DROP TABLE DIM_PRODUCTOS;

CREATE TABLE DIM_PRODUCTOS ( 
    IDProducto Nvarchar(150) PRIMARY KEY,
    NombreProducto Nvarchar(150),
    Categoria Nvarchar(150),
    SubCategoria Nvarchar(150),
    PrecioUnitario float,
    PrecioCosto float
);

-- ============================================
-- TABLA DIMENSIÓN: DIM_TIENDAS 
-- ============================================

IF OBJECT_ID('DIM_TIENDAS') IS NOT NULL
    DROP TABLE DIM_TIENDAS;

CREATE TABLE DIM_TIENDAS ( 
    IDTienda Nvarchar(150) PRIMARY KEY,
    NombreTienda Nvarchar(150),
    Ciudad Nvarchar(150),
    Region Nvarchar(150)
);

-- ============================================
-- TABLA DIMENSIÓN: DIM_TIEMPO 
-- ============================================

IF OBJECT_ID('DIM_TIEMPO') IS NOT NULL
    DROP TABLE DIM_TIEMPO;

CREATE TABLE DIM_TIEMPO ( 
    ClaveFecha Date PRIMARY KEY,
    Año Nvarchar(150),
    NumeroMes int,
    Mes Nvarchar(150),
    Trimestre Nvarchar(150),
    AñoTrimestre Nvarchar(150),
    AñoMes Nvarchar(150),
    NumeroDiaSemana int,
    DiaSemana Nvarchar(150),
    NumeroDiaMes int,
    EsFinDeSemana Nvarchar(150),
    NumeroSemana int
);

-- ============================================
-- TABLA DE HECHOS: FACT_TRANSAC
-- ============================================

IF OBJECT_ID('FACT_TRANSAC') IS NOT NULL
    DROP TABLE FACT_TRANSAC;

CREATE TABLE FACT_TRANSAC ( 
    IDTransaccion Nvarchar(150) PRIMARY KEY,
    ClaveFecha date,
    IDCliente Nvarchar(150),
    IDProducto Nvarchar(150),
    IDTienda Nvarchar(150),
    Cantidad int,
    Descuento float,
    MetodoPago Nvarchar(150),
    CONSTRAINT FK_Fact_Cliente  FOREIGN KEY (IDCliente)  REFERENCES DIM_CLIENTES(IDCliente),
    CONSTRAINT FK_Fact_Producto FOREIGN KEY (IDProducto) REFERENCES DIM_PRODUCTOS(IDProducto),
    CONSTRAINT FK_Fact_Tienda   FOREIGN KEY (IDTienda)   REFERENCES DIM_TIENDAS(IDTienda),
    CONSTRAINT FK_Fact_Fecha    FOREIGN KEY (ClaveFecha) REFERENCES DIM_TIEMPO(ClaveFecha)
);
```

## Carga de Datos

Los datos se cargaron desde archivos CSV usando `BULK INSERT`, con `;` como delimitador de campo y omitiendo la fila de encabezado (`FIRSTROW = 2`). El `SET DATEFORMAT dmy` ejecutado en la sección anterior aplica a toda la sesión, por lo que no es necesario repetirlo antes de cada carga. 
Importante, si pienzas usar estos datos debes saber en que parte de tu escritorio lo guardas para poder el remplazar la dirección de este codigo por el tuyo.
En la carpeta `Data` estare dejando los archivos csv.

```sql
-- Clientes
BULK INSERT DIM_CLIENTES
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Dim_Clientes.csv' 
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
);

-- Productos
BULK INSERT DIM_PRODUCTOS
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Dim_Productos.csv' 
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
);

-- Tiendas
BULK INSERT DIM_TIENDAS
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Dim_Tiendas.csv' 
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
);

-- Tiempo
BULK INSERT DIM_TIEMPO
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Dim_Tiempo.csv' 
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
);

-- Transacciones (tabla de hechos)
BULK INSERT FACT_TRANSAC
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Fact_Transacciones.csv' 
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
);
```

Tras cada carga se verificó el resultado con `SELECT * FROM <tabla>` para confirmar que los datos ingresaron correctamente.


## Validación de los Datos

#### Valores Nulos o Faltantes

Se verificó la existencia de valores faltantes en los campos clave de las tablas dimensionales y de hechos. No se encontraron valores nulos (las llaves primarias ya lo impiden por diseño, pero se documenta como parte del proceso de validación).

```sql
-- Verificar valores faltantes en DIM_CLIENTES --
SELECT COUNT(*) AS MissingValues
FROM DIM_CLIENTES
WHERE IDCliente IS NULL;

-- Verificar valores faltantes en DIM_PRODUCTOS --
SELECT COUNT(*) AS MissingValues
FROM DIM_PRODUCTOS
WHERE IDProducto IS NULL;

-- Verificar valores faltantes en DIM_TIENDAS --
SELECT COUNT(*) AS MissingValues
FROM DIM_TIENDAS
WHERE IDTienda IS NULL;

-- Verificar valores faltantes en FACT_TRANSAC --
SELECT COUNT(*) AS MissingValues
FROM FACT_TRANSAC
WHERE IDTransaccion IS NULL
    OR IDCliente IS NULL
    OR IDProducto IS NULL
    OR IDTienda IS NULL;
```

A continuación, se verificó que no existan filas duplicadas en los campos clave. No se encontraron duplicados.

```sql
-- Verificar valores duplicados en DIM_CLIENTES --
SELECT IDCliente, COUNT(*)
FROM DIM_CLIENTES
GROUP BY IDCliente
HAVING COUNT(*) > 1;

-- Verificar valores duplicados en FACT_TRANSAC --
SELECT IDTransaccion, COUNT(*)
FROM FACT_TRANSAC
GROUP BY IDTransaccion
HAVING COUNT(*) > 1;
```


## Tareas

En este análisis, ayudo al área comercial de MegaMart a responder lo siguiente:

1. ¿Cuáles son los productos y categorías que generan más ventas y utilidad?
2. ¿Cuál es la tendencia de ventas a lo largo del tiempo (mensual, trimestral, anual)?
3. ¿Qué tiendas y regiones tienen mejor desempeño en ventas?
4. ¿Cómo se distribuyen las ventas según el género y la ciudad de los clientes?
5. ¿Cuál es el ticket promedio (venta promedio por transacción) por tienda?
6. ¿Cuál es el impacto de los descuentos aplicados en el volumen de ventas?
7. ¿Cuáles son los métodos de pago más utilizados por los clientes?
8. ¿Cuál es la antigüedad promedio de los clientes según su fecha de registro?
9. ¿Qué categorías de productos tienen mayor margen de utilidad (precio unitario - costo)?
10. ¿Quiénes son los clientes con mayor volumen de compra (top clientes)?


## Desarrollo de Tareas

### Pregunta #1: ¿Cuáles son los productos y categorías que generan más ventas y utilidad?

```sql
SELECT 
    p.Categoria,
    SUM(f.Cantidad * p.PrecioUnitario) AS VentasTotales,
    SUM(f.Cantidad * (p.PrecioUnitario - p.PrecioCosto)) AS UtilidadTotal
FROM FACT_TRANSAC f
INNER JOIN DIM_PRODUCTOS p ON f.IDProducto = p.IDProducto
GROUP BY p.Categoria
ORDER BY VentasTotales DESC;
```
