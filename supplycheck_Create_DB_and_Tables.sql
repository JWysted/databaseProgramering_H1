-- ============================================
-- 3D Print Supplier Database
-- CreateDB_and_Tables.sql
-- ============================================

USE master;
GO

-- Kill alle forbindelser og drop database, har haft problemer hvor jeg ikke måtte slette den fordi den var i brug eller var blevet til single user, dette var den bedst løsning rundt om det som jeg kunne finde
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'PrintSupplierDB')
BEGIN
    DECLARE @kill varchar(8000) = '';
    
    SELECT @kill = @kill + 'KILL ' + CONVERT(varchar(5), session_id) + ';'
    FROM sys.dm_exec_sessions
    WHERE database_id = DB_ID('PrintSupplierDB');
    
    EXEC(@kill);
    
    DROP DATABASE PrintSupplierDB;
END
GO

CREATE DATABASE PrintSupplierDB;
GO

USE PrintSupplierDB;
GO


CREATE TABLE continent (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE country (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    continent_id INT NOT NULL,
    CONSTRAINT FK_country_continent FOREIGN KEY (continent_id) REFERENCES continent(id)
);

CREATE TABLE supplier (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    img VARCHAR(255) DEFAULT NULL,
    url VARCHAR(255) NOT NULL
);

CREATE TABLE location (
    id INT IDENTITY(1,1) PRIMARY KEY,
    street VARCHAR(255) DEFAULT NULL,
    city VARCHAR(255) DEFAULT NULL,
    country_id INT NOT NULL,
    street_number VARCHAR(255) DEFAULT NULL,
    supplier_id INT NOT NULL,
    CONSTRAINT FK_location_country FOREIGN KEY (country_id) REFERENCES country(id),
    CONSTRAINT FK_location_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

CREATE TABLE technology (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    norm_name VARCHAR(255) NOT NULL,
    alt_norm_name VARCHAR(255) DEFAULT NULL
);

CREATE TABLE material (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) DEFAULT NULL,
    norm_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE material_categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE mat_cat_junction (
    mat_id INT NOT NULL,
    cat_id INT NOT NULL,
    PRIMARY KEY (mat_id, cat_id),
    CONSTRAINT FK_matcat_material FOREIGN KEY (mat_id) REFERENCES material(id),
    CONSTRAINT FK_matcat_category FOREIGN KEY (cat_id) REFERENCES material_categories(id)
);

CREATE TABLE tech_material_junction (
    id INT IDENTITY(1,1) PRIMARY KEY,
    tech_id INT NOT NULL,
    material_id INT NOT NULL,
    CONSTRAINT FK_techmat_tech FOREIGN KEY (tech_id) REFERENCES technology(id),
    CONSTRAINT FK_techmat_material FOREIGN KEY (material_id) REFERENCES material(id)
);

CREATE TABLE model (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) DEFAULT NULL,
    x FLOAT DEFAULT NULL,
    y FLOAT DEFAULT NULL,
    z FLOAT DEFAULT NULL,
    v FLOAT DEFAULT NULL,
    ref VARCHAR(255) DEFAULT NULL,
    CONSTRAINT chk_model_x CHECK (x IS NULL OR x > 0),
    CONSTRAINT chk_model_y CHECK (y IS NULL OR y > 0),
    CONSTRAINT chk_model_z CHECK (z IS NULL OR z > 0),
    CONSTRAINT chk_model_dimensions_required CHECK (
        ref IS NOT NULL OR (x IS NOT NULL AND y IS NOT NULL AND z IS NOT NULL)
    )
);

CREATE TABLE extra_info (
    id INT IDENTITY(1,1) PRIMARY KEY,
    infill VARCHAR(255) DEFAULT NULL,
    color VARCHAR(255) DEFAULT NULL,
    resolution VARCHAR(255) DEFAULT NULL,
    finish VARCHAR(255) DEFAULT NULL
);

CREATE TABLE offers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id INT NOT NULL,
    tech_id INT NOT NULL,
    model_id INT NOT NULL,
    material_id INT NOT NULL,
    quantity INT DEFAULT NULL,
    price FLOAT DEFAULT NULL,
    currency VARCHAR(255) DEFAULT NULL,
    leadtime INT DEFAULT NULL,
    delivery_type VARCHAR(255) DEFAULT NULL,
    created_at DATE NOT NULL,
    extra_info_id INT DEFAULT NULL,
    CONSTRAINT FK_offers_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id),
    CONSTRAINT FK_offers_technology FOREIGN KEY (tech_id) REFERENCES technology(id),
    CONSTRAINT FK_offers_model FOREIGN KEY (model_id) REFERENCES model(id),
    CONSTRAINT FK_offers_material FOREIGN KEY (material_id) REFERENCES material(id),
    CONSTRAINT FK_offers_extra FOREIGN KEY (extra_info_id) REFERENCES extra_info(id),
    CONSTRAINT chk_price_positive CHECK (price IS NULL OR price >= 0),
    CONSTRAINT chk_quantity_positive CHECK (quantity IS NULL OR quantity > 0),
    CONSTRAINT chk_leadtime_positive CHECK (leadtime IS NULL OR leadtime >= 0)
);

GO

PRINT 'Database og tabeller oprettet succesfuldt!';
GO
