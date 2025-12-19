# 3D Print Supplier Database

## Firmabeskrivelse

databasen er designet som en **markedsplads for 3D-print leverandører**. 
Platformen samler tilbud fra forskellige leverandører verden over, så kunder kan 
sammenligne priser, leveringstider og materialer for deres 3D-print projekter.

Systemet håndterer:
- Leverandører med flere lokationer
- Forskellige 3D-print teknologier 
- Materialer med kategorisering
- Modeller med dimensioner
- Tilbud med priser, leveringstid og ekstra info

---

## Tabeller og Relationer

### Oversigt (12 tabeller)

| Tabel | Beskrivelse |
|-------|-------------|
| `continent` | Verdensdele (Europa, Nordamerika, Asien) |
| `country` | Lande tilknyttet en verdensdel |
| `location` | Adresser tilknyttet leverandører |
| `supplier` | Leverandører af 3D-print services |
| `technology` | 3D-print teknologier (FDM, SLA, etc.) |
| `material` | Materialer (PLA, ABS, PA12, etc.) |
| `material_categories` | Kategorier for materialer |
| `mat_cat_junction` | Kobling: materiale ↔ kategorier |
| `tech_material_junction` | Kobling: teknologi ↔ materialer |
| `model` | 3D-modeller med dimensioner |
| `extra_info` | Ekstra printindstillinger |
| `offers` | Tilbud fra leverandører |

### Relationstyper

| Relation | Type | Forklaring |
|----------|------|------------|
| `continent` → `country` | 1:M | Én verdensdel har mange lande |
| `country` → `location` | 1:M | Ét land har mange lokationer |
| `supplier` → `location` | 1:M | Én leverandør kan have flere lokationer |
| `supplier` → `offers` | 1:M | Én leverandør laver mange tilbud |
| `material` ↔ `material_categories` | M:M | Materialer kan have flere kategorier |
| `technology` ↔ `material` | M:M | Teknologier understøtter flere materialer |
| `offers` → `extra_info` | 1:1 | Ét tilbud har én ekstra info |

---

## Constraints

### NOT NULL Constraints
- `continent.name` - Verdensdele skal have et navn
- `country.name` - Lande skal have et navn
- `supplier.name` og `supplier.url` - Leverandører skal have navn og hjemmeside
- `offers.created_at` - Tilbud skal have oprettelsesdato
- `location.supplier_id` - Lokationer skal tilhøre en leverandør

### UNIQUE Constraints
- `continent.name` - Ingen duplikerede verdensdele
- `country.name` - Ingen duplikerede lande
- `supplier.name` - Ingen duplikerede leverandørnavne
- `material.norm_name` - Unikke materialenavne
- `material_categories.name` - Unikke kategorinavne

### CHECK Constraints
- `chk_model_x`, `chk_model_y`, `chk_model_z` - Modeldimensioner skal være positive
- `chk_price_positive` - Priser må ikke være negative
- `chk_quantity_positive` - Antal skal være større end 0
- `chk_leadtime_positive` - Leveringstid må ikke være negativ

---

## View og Sikkerhed

### Offer_view

Viewet `Offer_view` samler data fra 8 tabeller til én nem oversigt over alle tilbud.

**Sikkerhedsargument:**

Et VIEW fungerer som et sikkerhedstiltag ved at:

1. **Skjule kompleksitet** - Brugere behøver ikke kende databasestrukturen
2. **Begrænse adgang** - Man kan give rettigheder til viewet uden at give adgang til tabellerne
3. **Filtrere data** - Følsomme kolonner kan udelades (fx interne ID'er eller fortrolige priser)
4. **Forhindre manipulation** - Brugere kan kun læse, ikke ændre de underliggende data

---

## Kørsel af Scripts

**Rækkefølge:**

1. `Supplycheck_CreateDB_and_Tables.sql` - Opretter database og tabeller
2. `Supplycheck_SeedData.sql` - Indsætter testdata
3. `Supplycheck_QueryPack.sql` - Kører alle bevis-queries

---

## ER-Diagram

Se vedlagt fil: `supplycheck_ER-diagram.png`

https://dbdiagram.io/d/supplycheck-6941556a6167ba7414739b7c
---
December 2025
