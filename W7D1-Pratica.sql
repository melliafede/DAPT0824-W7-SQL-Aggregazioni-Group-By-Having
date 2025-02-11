-- Verifa che il campo ProductKey nella tabella DimProduct sia una chiave primaria
SELECT count(ProductKey) as numProductKey, count(DISTINCT ProductKey) as numDistinctProductKey
FROM dimproduct;

DESCRIBE dimproduct;

-- Verifica che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber
select SalesOrderNumber, SalesOrderLineNumber, count(*) as numRipetizioni
from factresellersales
GROUP BY SalesOrderNumber, SalesOrderLineNumber
Having	numRipetizioni > 1;	-- Non compare nessuna combinazione che abbia più di 1 ripetizioni, quindi le combinazioni sono uniche

-- Conta numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020
SELECT COUNT(SalesOrderLineNumber) as conteggioTransazioni
from factresellersales
where orderdate >= "2020-01-01";

-- Calcola fatturato totale, la quantità totale venduta e il prezzo medio di vendita per prodotto a paritre
-- dal 1 Gennaio 2020. Il result set deve esporre il nome del prodotto, il fatturato totale, la quantità totale
-- venduta e il prezzo medio di vendita. I campi in output devono essere parlanti.
SELECT dimproduct.EnglishProductName, 
SUM(factresellersales.SalesAmount) as FatturatoTotale,
SUM(factresellersales.OrderQuantity) as QuantitàTotale,
ROUND(AVG(factresellersales.UnitPrice), 2) as PrezzoMedioVendita
FROM dimproduct left join factresellersales on dimproduct.ProductKey = factresellersales.ProductKey
WHERE factresellersales.OrderDate >= "2020-01-01"
GROUP BY dimproduct.ProductKey;


-- Calcola il fatturato totale e la quantità totale venduta per Categoria prodotto.
-- Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta.
-- I campi in output devono essere parlanti.
SELECT 
EnglishProductCategoryName as NomeCategoriaProdotto,
SUM(factresellersales.SalesAmount) as FatturatoTotale,
SUM(factresellersales.OrderQuantity) as QuantitàTotale
from factresellersales 
join dimproduct on factresellersales.ProductKey = dimproduct.ProductKey
join dimproductsubcategory on dimproductsubcategory.ProductSubcategoryKey = dimproduct.ProductSubcategoryKey
join dimproductcategory on dimproductcategory.ProductCategoryKey = dimproductsubcategory.ProductCategoryKey
group by dimproductcategory.ProductCategoryKey;

-- Calcola il fatturato totale per aree città realizzato a partire dal 1 Gennaio 2020.
-- IL result set deve esporre l'elenco delle città con fatturato realizzato superiore a 60K.
SELECT dimgeography.City as Città,
SUM(factresellersales.SalesAmount) as FatturatoTotale
FROM dimgeography
join dimreseller on dimreseller.GeographyKey = dimgeography.GeographyKey
join factresellersales on dimreseller.ResellerKey = factresellersales.ResellerKey
where factresellersales.OrderDate >= "2020-01-01"
group by dimgeography.City
having FatturatoTotale > 60000
order by dimgeography.City;