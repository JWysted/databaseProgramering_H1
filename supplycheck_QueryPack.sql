-- ============================================
-- 3D Print Supplier Database
-- QueryPack.sql
-- ============================================

USE PrintSupplierDB;
GO

SELECT 
    id,
    supplier_id,
    price,
    currency,
    created_at
FROM offers
WHERE price > 100;
GO

SELECT 
    id,
    name,
    norm_name
FROM material
ORDER BY norm_name ASC;
GO

SELECT 
    supplier_id,
    COUNT(*) AS antal_tilbud,
    AVG(price) AS gennemsnit_pris,
    SUM(price) AS total_pris,
    MIN(price) AS laveste_pris,
    MAX(price) AS hoejeste_pris
FROM offers
GROUP BY supplier_id
ORDER BY antal_tilbud DESC;
GO

SELECT 
    id,
    UPPER(name) AS navn_store_bogstaver,
    ROUND(x * y * z, 2) AS beregnet_volumen,
    CONCAT(ref, ' - ', name) AS fuld_reference
FROM model;
GO

SELECT 
    id,
    created_at,
    DATEDIFF(DAY, created_at, GETDATE()) AS dage_siden_oprettelse,
    YEAR(created_at) AS aar,
    MONTH(created_at) AS maaned
FROM offers
WHERE created_at >= DATEADD(DAY, -90, GETDATE());
GO

INSERT INTO supplier (name, img, url)
VALUES ('Nordic 3D Print', 'nordic3d.png', 'https://nordic3dprint.se');

SELECT * FROM supplier WHERE id = 6;
GO

UPDATE supplier
SET url = 'https://nordic3dprint.com',
    img = 'nordic3d_updated.png'
WHERE id = 6;

SELECT * FROM supplier WHERE id = 6;
GO

DELETE FROM supplier
WHERE id = 6;

SELECT * FROM supplier;
GO

SELECT 
    o.id AS tilbud_id,
    s.name AS leverandor,
    l.city AS bynavn,
    c.name AS land,
    con.name AS kontinent,
    t.norm_name AS teknologi,
    m.norm_name AS materiale,
    mo.name AS model_navn,
    o.quantity AS antal,
    o.price AS pris,
    o.currency AS valuta,
    o.leadtime AS leveringstid_dage,
    o.delivery_type AS leveringstype
FROM offers o
INNER JOIN supplier s ON o.supplier_id = s.id
INNER JOIN location l ON l.supplier_id = s.id
INNER JOIN country c ON l.country_id = c.id
INNER JOIN continent con ON c.continent_id = con.id
INNER JOIN technology t ON o.tech_id = t.id
INNER JOIN material m ON o.material_id = m.id
INNER JOIN model mo ON o.model_id = mo.id
ORDER BY o.price DESC;
GO

SELECT 
    id,
    name,
    url
FROM supplier
WHERE id IN (
    SELECT DISTINCT supplier_id
    FROM offers
    WHERE price > (
        SELECT AVG(price) FROM offers
    )
);
GO

SELECT 
    s.id,
    s.name,
    (SELECT COUNT(*) FROM offers o WHERE o.supplier_id = s.id) AS antal_tilbud,
    (SELECT AVG(price) FROM offers o WHERE o.supplier_id = s.id) AS gns_pris
FROM supplier s
ORDER BY antal_tilbud DESC;
GO

DROP VIEW IF EXISTS Offer_view;
GO

CREATE VIEW Offer_view AS
SELECT 
    o.id AS offer_id,
    s.name AS supplier,
    s.img AS img,
    s.url AS url,
    l.city AS city,
    c.name AS country,
    con.name AS continent,
    t.name AS technology,
    t.alt_norm_name AS alt_technology,
    m.name AS material,
    m.norm_name AS alt_material,
    mo.name AS model,
    o.quantity AS quantity,
    o.price AS price,
    o.currency AS currency,
    o.leadtime AS leadtime,
    o.delivery_type AS delivery_type,
    o.created_at AS created_at
FROM offers o
INNER JOIN supplier s ON o.supplier_id = s.id
INNER JOIN location l ON l.supplier_id = s.id
INNER JOIN country c ON l.country_id = c.id
INNER JOIN continent con ON c.continent_id = con.id
INNER JOIN technology t ON o.tech_id = t.id
INNER JOIN material m ON o.material_id = m.id
INNER JOIN model mo ON o.model_id = mo.id;
GO

SELECT * FROM Offer_view ORDER BY price DESC;
GO

SELECT 
    m.norm_name AS materiale,
    mc.name AS kategori
FROM material m
INNER JOIN mat_cat_junction mcj ON m.id = mcj.mat_id
INNER JOIN material_categories mc ON mcj.cat_id = mc.id
ORDER BY m.norm_name;
GO

SELECT 
    t.norm_name AS teknologi,
    t.name AS teknologi_fuldt_navn,
    m.norm_name AS materiale
FROM technology t
INNER JOIN tech_material_junction tmj ON t.id = tmj.tech_id
INNER JOIN material m ON tmj.material_id = m.id
ORDER BY t.norm_name, m.norm_name;
GO

SELECT 
    s.name AS leverandor,
    COUNT(l.id) AS antal_lokationer,
    STRING_AGG(l.city, ', ') AS byer
FROM supplier s
LEFT JOIN location l ON l.supplier_id = s.id
GROUP BY s.id, s.name
ORDER BY antal_lokationer DESC;
GO

PRINT 'Alle queries kørt succesfuldt!';
GO