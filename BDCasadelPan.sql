CREATE DATABASE BD_CasaDelPan
USE BD_CasaDelPan

CREATE TABLE Cliente (
    ID_Cliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Telefono VARCHAR(15),
    Direccion VARCHAR(255),
    DNI CHAR(8) UNIQUE NOT NULL
);

CREATE TABLE Producto (
    ID_Producto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Descripcion VARCHAR(255),
    Precio DECIMAL(10, 2) NOT NULL,
    Cantidad INT NOT NULL
);

CREATE TABLE Ventas (
    ID_Venta INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT,
    ID_Producto INT,
    Fecha_Venta DATE NOT NULL,
    Cantidad_Vendida INT NOT NULL,
    Precio_Total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);

-- Cliente ###################
CREATE PROCEDURE [dbo].[spListarCliente]
AS
BEGIN
	SELECT ID_Cliente, Nombre, Telefono, Direccion, DNI
	FROM Cliente;
END;
GO

CREATE PROCEDURE [dbo].[spRegistrarCliente] 
(
	@Nombre varchar(255),
	@Telefono varchar(15),
	@Direccion varchar(255),
	@DNI varchar(8)
)
AS
BEGIN 
    INSERT INTO Cliente(Nombre, Telefono, Direccion, DNI) 
    VALUES (@Nombre, @Telefono, @Direccion, @DNI);
END;
GO

CREATE PROCEDURE [dbo].[spEliminarCliente] 
(
    @ID_Cliente int
)
AS
BEGIN 
    BEGIN TRY
        DECLARE @ExistenVentas INT;
        SELECT @ExistenVentas = COUNT(*) 
        FROM Ventas 
        WHERE ID_Cliente = @ID_Cliente;

        IF @ExistenVentas > 0
        BEGIN
            DELETE FROM Ventas WHERE ID_Cliente = @ID_Cliente;
        END

        DELETE FROM Cliente WHERE ID_Cliente = @ID_Cliente;

        SELECT 'Cliente eliminado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

CREATE PROCEDURE [dbo].[spBuscarCliente] 
(
    @ID_Cliente int = NULL,
    @Nombre varchar(255) = NULL,
    @Telefono varchar(15) = NULL,
    @Direccion varchar(255) = NULL,
    @DNI varchar(8) = NULL
)
AS
BEGIN 
    SELECT * 
    FROM Cliente
    WHERE 
        (@ID_Cliente IS NULL OR ID_Cliente = @ID_Cliente) AND
        (@Nombre IS NULL OR Nombre = @Nombre) AND
        (@Telefono IS NULL OR Telefono = @Telefono) AND
        (@Direccion IS NULL OR Direccion = @Direccion) AND
        (@DNI IS NULL OR DNI = @DNI);
END;
GO

-- Producto ###################
CREATE PROCEDURE [dbo].[spListarProducto]
AS
BEGIN
    SELECT ID_Producto, Nombre, Descripcion, Precio, Cantidad
    FROM Producto;
END;
GO

CREATE PROCEDURE [dbo].[spRegistrarProducto]
(
    @Nombre varchar(255),
    @Descripcion text,
    @Precio decimal(10, 2),
    @Cantidad int
)
AS
BEGIN 
    INSERT INTO Producto(Nombre, Descripcion, Precio, Cantidad) 
    VALUES (@Nombre, @Descripcion, @Precio, @Cantidad);
END;
GO

CREATE PROCEDURE [dbo].[spEliminarProducto]
(
    @ID_Producto int
)
AS
BEGIN 
    BEGIN TRY
        DECLARE @ExistenVentas INT;
        SELECT @ExistenVentas = COUNT(*) 
        FROM Ventas 
        WHERE ID_Producto = @ID_Producto;

        IF @ExistenVentas > 0
        BEGIN
            DELETE FROM Ventas WHERE ID_Producto = @ID_Producto;
        END

        DELETE FROM Producto WHERE ID_Producto = @ID_Producto;

        SELECT 'Producto eliminado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

CREATE PROCEDURE [dbo].[spBuscarProducto]
(
    @ID_Producto int = NULL,
    @Nombre varchar(255) = NULL,
    @Descripcion varchar(255) = NULL,
    @Precio decimal(10, 2) = NULL,
    @Cantidad int = NULL
)
AS
BEGIN 
    SELECT * 
    FROM Producto
    WHERE 
        (@ID_Producto IS NULL OR ID_Producto = @ID_Producto) AND
        (@Nombre IS NULL OR Nombre = @Nombre) AND
        (@Descripcion IS NULL OR Descripcion = @Descripcion) AND
        (@Precio IS NULL OR Precio = @Precio) AND
        (@Cantidad IS NULL OR Cantidad = @Cantidad);
END;
GO

-- Ventas ###################
CREATE PROCEDURE [dbo].[spListarVentas]
AS
BEGIN
    SELECT ID_Venta, ID_Cliente, ID_Producto, Fecha_Venta, Cantidad_Vendida, Precio_Total
    FROM Ventas;
END;
GO

CREATE PROCEDURE [dbo].[spRegistrarVenta]
(
    @ID_Cliente int,
    @ID_Producto int,
    @Fecha_Venta date,
    @Cantidad_Vendida int,
    @Precio_Total decimal(10, 2)
)
AS
BEGIN 
    INSERT INTO Ventas(ID_Cliente, ID_Producto, Fecha_Venta, Cantidad_Vendida, Precio_Total) 
    VALUES (@ID_Cliente, @ID_Producto, @Fecha_Venta, @Cantidad_Vendida, @Precio_Total);
END;
GO

CREATE PROCEDURE [dbo].[spEliminarVenta]
(
    @ID_Venta int
)
AS
BEGIN 
    DELETE FROM Ventas WHERE ID_Venta = @ID_Venta;
END;
GO

CREATE PROCEDURE [dbo].[spBuscarVenta]
(
    @ID_Venta int = NULL,
    @ID_Cliente int = NULL,
    @ID_Producto int = NULL,
    @Fecha_Venta date = NULL,
    @Cantidad_Vendida int = NULL,
    @Precio_Total decimal(10, 2) = NULL
)
AS
BEGIN 
    SELECT * 
    FROM Ventas
    WHERE 
        (@ID_Venta IS NULL OR ID_Venta = @ID_Venta) AND
        (@ID_Cliente IS NULL OR ID_Cliente = @ID_Cliente) AND
        (@ID_Producto IS NULL OR ID_Producto = @ID_Producto) AND
        (@Fecha_Venta IS NULL OR Fecha_Venta = @Fecha_Venta) AND
        (@Cantidad_Vendida IS NULL OR Cantidad_Vendida = @Cantidad_Vendida) AND
        (@Precio_Total IS NULL OR Precio_Total = @Precio_Total);
END;
GO

INSERT INTO Cliente (Nombre, Telefono, Direccion, DNI)
VALUES 
('Juan Perez', '123456789', 'Calle 123, Ciudad', '87654321'),
('Maria Lopez', '987654321', 'Avenida 45, Ciudad', '12345678'),
('Carlos Sanchez', '555666777', 'Calle 89, Ciudad', '23456789'),
('Laura Gomez', '111222333', 'Boulevard 67, Ciudad', '34567890'),
('Ana Martinez', '999888777', 'Pasaje 34, Ciudad', '45678901'),
('Luis Fernandez', '444555666', 'Calle 101, Ciudad', '56789012'),
('Isabel Rodriguez', '777888999', 'Avenida 78, Ciudad', '67890123'),
('Pedro Garcia', '222333444', 'Calle 23, Ciudad', '78901234'),
('Carmen Jimenez', '888999000', 'Boulevard 90, Ciudad', '89012345'),
('Miguel Torres', '333444555', 'Pasaje 56, Ciudad', '90123456');

INSERT INTO Producto (Nombre, Descripcion, Precio, Cantidad)
VALUES 
('Pan Integral', 'Pan hecho con harina integral', 1.50, 50),
('Pan Blanco', 'Pan tradicional de harina blanca', 1.20, 100),
('Croissant', 'Croissant de mantequilla', 2.00, 75),
('Baguette', 'Pan largo y crujiente', 1.80, 40),
('Empanada', 'Empanada rellena de carne', 3.00, 30),
('Muffin', 'Muffin de chocolate', 2.50, 60),
('Rosquilla', 'Rosquilla glaseada', 1.00, 120),
('Tarta de Manzana', 'Tarta casera de manzana', 4.00, 20),
('Pastel de Queso', 'Pastel de queso con frutas', 3.50, 25),
('Bollito', 'Bollito relleno de crema', 1.75, 80);

INSERT INTO Ventas (ID_Cliente, ID_Producto, Fecha_Venta, Cantidad_Vendida, Precio_Total)
VALUES 
(1, 1, '2024-06-01', 5, 7.50),  -- Juan Perez compra 5 Pan Integral
(2, 3, '2024-06-02', 2, 4.00),  -- Maria Lopez compra 2 Croissant
(3, 5, '2024-06-03', 1, 3.00),  -- Carlos Sanchez compra 1 Empanada
(4, 2, '2024-06-04', 10, 12.00),-- Laura Gomez compra 10 Pan Blanco
(5, 6, '2024-06-05', 4, 10.00), -- Ana Martinez compra 4 Muffin
(6, 4, '2024-06-06', 3, 5.40),  -- Luis Fernandez compra 3 Baguette
(7, 8, '2024-06-07', 1, 4.00),  -- Isabel Rodriguez compra 1 Tarta de Manzana
(8, 10, '2024-06-08', 2, 3.50), -- Pedro Garcia compra 2 Bollito
(9, 7, '2024-06-09', 12, 12.00),-- Carmen Jimenez compra 12 Rosquilla
(10, 9, '2024-06-10', 1, 3.50); -- Miguel Torres compra 1 Pastel de Queso