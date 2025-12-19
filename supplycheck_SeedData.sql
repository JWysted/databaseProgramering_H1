-- ============================================
-- 3D Print Supplier Database
-- SeedData.sql
-- ============================================

USE PrintSupplierDB;
GO

DELETE FROM offers;
DELETE FROM extra_info;
DELETE FROM model;
DELETE FROM tech_material_junction;
DELETE FROM mat_cat_junction;
DELETE FROM material_categories;
DELETE FROM material;
DELETE FROM technology;
DELETE FROM location;
DELETE FROM supplier;
DELETE FROM country;
DELETE FROM continent;

DBCC CHECKIDENT ('offers', RESEED, 0);
DBCC CHECKIDENT ('extra_info', RESEED, 0);
DBCC CHECKIDENT ('model', RESEED, 0);
DBCC CHECKIDENT ('tech_material_junction', RESEED, 0);
DBCC CHECKIDENT ('material_categories', RESEED, 0);
DBCC CHECKIDENT ('material', RESEED, 0);
DBCC CHECKIDENT ('technology', RESEED, 0);
DBCC CHECKIDENT ('location', RESEED, 0);
DBCC CHECKIDENT ('supplier', RESEED, 0);
DBCC CHECKIDENT ('country', RESEED, 0);
DBCC CHECKIDENT ('continent', RESEED, 0);
GO

INSERT INTO continent (name) VALUES
('Europe'),
('North America'),
('Asia');

INSERT INTO country (name, continent_id) VALUES
('Denmark', 1),
('Germany', 1),
('United States', 2),
('Canada', 2),
('China', 3),
('Japan', 3);

INSERT INTO supplier (name, img, url) VALUES
('PrintMaster DK', 'printmaster.png', 'https://printmaster.dk'),
('3D Solutions GmbH', '3dsolutions.png', 'https://3dsolutions.de'),
('RapidPrint USA', 'rapidprint.png', 'https://rapidprint.com'),
('TokyoMakers', 'tokyomakers.png', 'https://tokyomakers.jp'),
('ShenzenPrint Co', NULL, 'https://shenzenprint.cn');

INSERT INTO location (street, city, country_id, street_number, supplier_id) VALUES
('Vestergade', 'København', 1, '12A', 1),
('Industrivej', 'Aarhus', 1, '45', 1),
('Hauptstraße', 'Berlin', 2, '78', 2),
('Innovation Drive', 'San Francisco', 3, '500', 3),
('Tech Boulevard', 'Toronto', 4, '221B', 3),
('Shibuya Street', 'Tokyo', 6, '33', 4),
('Factory Road', 'Shenzhen', 5, '888', 5);

INSERT INTO technology (name, norm_name, alt_norm_name) VALUES
('Fused Deposition Modeling', 'FDM', 'FFF'),
('Stereolithography', 'SLA', NULL),
('Selective Laser Sintering', 'SLS', NULL),
('Multi Jet Fusion', 'MJF', 'HP MJF');

INSERT INTO material (name, norm_name) VALUES
('Polylactic Acid', 'PLA'),
('Acrylonitrile Butadiene Styrene', 'ABS'),
('Polyamide 12', 'PA12'),
('Standard Resin', 'RESIN'),
('Thermoplastic Polyurethane', 'TPU'),
('Polyethylene Terephthalate Glycol', 'PETG');

INSERT INTO material_categories (name) VALUES
('Plastic'),
('Flexible'),
('Industrial'),
('Biodegradable');

INSERT INTO mat_cat_junction (mat_id, cat_id) VALUES
(1, 1),  -- PLA -> Plastic
(1, 4),  -- PLA -> Biodegradable
(2, 1),  -- ABS -> Plastic
(2, 3),  -- ABS -> Industrial
(3, 1),  -- PA12 -> Plastic
(3, 3),  -- PA12 -> Industrial
(5, 2),  -- TPU -> Flexible
(6, 1);  -- PETG -> Plastic

INSERT INTO tech_material_junction (tech_id, material_id) VALUES
(1, 1),   -- FDM + PLA
(1, 2),   -- FDM + ABS
(1, 5),   -- FDM + TPU
(1, 6),   -- FDM + PETG
(2, 4),   -- SLA + RESIN
(3, 3),   -- SLS + PA12
(3, 5),   -- SLS + TPU
(4, 3),   -- MJF + PA12
(4, 5),   -- MJF + TPU
(2, 5);   -- SLA + TPU

INSERT INTO model (name, x, y, z, v, ref) VALUES
('Bracket v1', 50.0, 30.0, 15.0, 22.5, 'BRK-001'),
('Phone Stand', 80.0, 60.0, 120.0, 145.8, 'PHN-002'),
('Gear Assembly', 40.0, 40.0, 20.0, 25.1, 'GER-003'),
('Custom Enclosure', 150.0, 100.0, 50.0, 750.0, 'ENC-004'),
('Prototype Housing', 200.0, 150.0, 80.0, 2400.0, 'PRO-005');

INSERT INTO extra_info (infill, color, resolution, finish) VALUES
('20%', 'Black', '0.2mm', 'Standard'),
('100%', 'White', '0.1mm', 'Polished'),
('50%', 'Gray', '0.15mm', 'Sanded'),
('80%', 'Red', '0.05mm', 'Painted');

INSERT INTO offers (supplier_id, tech_id, model_id, material_id, quantity, price, currency, leadtime, delivery_type, created_at, extra_info_id) VALUES
(1, 1, 1, 1, 10, 125.50, 'DKK', 5, 'Standard', '2025-01-15', 1),
(1, 1, 2, 2, 5, 299.00, 'DKK', 7, 'Express', '2025-01-16', 2),
(2, 3, 3, 3, 20, 89.99, 'EUR', 10, 'Standard', '2025-02-01', NULL),
(2, 4, 4, 3, 3, 450.00, 'EUR', 14, 'Standard', '2025-02-10', 3),
(3, 2, 1, 4, 50, 15.99, 'USD', 3, 'Express', '2025-03-01', NULL),
(3, 1, 5, 6, 2, 899.00, 'USD', 21, 'Freight', '2025-03-05', 4),
(4, 2, 2, 4, 100, 12.50, 'USD', 5, 'Standard', '2025-03-10', 1),
(4, 3, 3, 5, 15, 67.80, 'USD', 8, 'Express', '2025-03-12', NULL),
(5, 4, 4, 3, 500, 8.25, 'USD', 30, 'Freight', '2025-04-01', 2),
(5, 1, 5, 1, 1000, 3.50, 'USD', 45, 'Freight', '2025-04-05', NULL),
(1, 2, 3, 4, 25, 185.00, 'DKK', 6, 'Standard', '2025-04-10', 3),
(3, 4, 1, 3, 8, 220.00, 'USD', 12, 'Express', '2025-04-15', 4);

GO

PRINT 'Testdata indsat succesfuldt!';
GO
