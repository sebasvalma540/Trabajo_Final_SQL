CREATE DATABASE RETAIL_SALES
USE RETAIL_SALES;

-- ============================================
-- TABLA DIMENSIÓN: DIM_CLIENTES
-- ============================================

--el OBJECT_ID nos ayuda a decir si la tabla seleccionada ya existe,
--si la tabla existe cumple la condición de ser no nulo y la elimina para luego con el CREATE crearla 
--si no existe la tabla no cumple la condición, asi que no elimina nada pero con el CREATE la creamos 

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
)

---Cargamos los datos desde el CSV por dimension 
BULK INSERT DIM_CLIENTES
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Dim_Clientes.csv' 
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

---Verificamos que se haya cargado bien la información
select *
from DIM_CLIENTES

---------------------------------------------------------------------------------------------------
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
PrecioUnitario Nvarchar(150),
PrecioCosto Nvarchar(150)
)

BULK INSERT DIM_PRODUCTOS
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Dim_Productos.csv' 
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

select *
from DIM_PRODUCTOS

---------------------------------------------------------------------------------------------------
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
)

BULK INSERT DIM_TIENDAS
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Dim_Tiendas.csv' 
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

select *
from DIM_TIENDAS

---------------------------------------------------------------------------------------------------
-- ============================================
-- TABLA DIMENSIÓN: DIM_TIEMPO 
-- ============================================

IF OBJECT_ID('DIM_TIEMPO') IS NOT NULL
	DROP TABLE DIM_TIEMPO;

CREATE TABLE DIM_TIEMPO ( 
ClaveFecha Date PRIMARY KEY,
Año Nvarchar(150) ,
NúmeroMes int ,
Mes Nvarchar(150) ,
Trimestre Nvarchar(150) ,
AñoTrimestre Nvarchar(150) ,
AñoMes Nvarchar(150) ,
NúmeroDíaSemana int ,
DíaSemana Nvarchar(150) ,
NúmeroDíaMes int ,
EsFinDeSemana Nvarchar(150) ,
NúmeroSemana Int ,
)

BULK INSERT DIM_TIEMPO
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Dim_Tiempo.csv' 
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

select *
from DIM_TIEMPO

---------------------------------------------------------------------------------------------------
-- ============================================
-- TABLA DE HECHOS: FACT_TRANSAC
-- ============================================
---------------------------------------------------------------------------------------------------

IF OBJECT_ID('FACT_TRANSAC') IS NOT NULL
	DROP TABLE FACT_TRANSAC;

CREATE TABLE FACT_TRANSAC ( 
IDTransaccion Nvarchar(150) PRIMARY KEY ,
ClaveFecha date ,
IDCliente Nvarchar(150) ,
IDProducto Nvarchar(150) ,
IDTienda Nvarchar(150) ,
Cantidad int ,
Descuento Nvarchar(150) ,
MetodoPago Nvarchar(150),
    CONSTRAINT FK_Fact_Cliente  FOREIGN KEY (IDCliente)  REFERENCES DIM_CLIENTES(IDCliente),
    CONSTRAINT FK_Fact_Producto FOREIGN KEY (IDProducto) REFERENCES DIM_PRODUCTOS(IDProducto),
    CONSTRAINT FK_Fact_Tienda   FOREIGN KEY (IDTienda)   REFERENCES DIM_TIENDAS(IDTienda),
    CONSTRAINT FK_Fact_Fecha    FOREIGN KEY (ClaveFecha) REFERENCES DIM_TIEMPO(ClaveFecha)
)

BULK INSERT FACT_TRANSAC
FROM 'D:\CURSO DE SQL-General\TF_SQL_2026\Trabajo_Final_SQL\Data\Fact_Transacciones.csv' 
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

select *
from FACT_TRANSAC
