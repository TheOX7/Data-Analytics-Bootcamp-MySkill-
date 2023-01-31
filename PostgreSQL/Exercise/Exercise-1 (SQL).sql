-- Nomor 1
-- Q : Urutkan benua berdasarkan jumlah company terbanyak. Benua mana yang memiliki unicorn paling banyak?
SELECT
	uc.continent,
	COUNT(DISTINCT uc.company_id) AS total_per_country
FROM unicorn_companies uc
GROUP BY 1
ORDER BY 2 DESC

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 2
-- Q: Negara apa saja yang memiliki jumlah unicorn di atas 100? (Tampilkan jumlahnya)
SELECT
	uc.country,
	COUNT(DISTINCT uc.company_id) AS total_per_country
FROM unicorn_companies uc
GROUP BY 1
HAVING COUNT(DISTINCT uc.company_id) > 100
ORDER BY 2 DESC

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 3
-- Q: Industri apa yang paling besar di antara unicorn company berdasarkan total fundingnya? Berapa rata-rata valuasinya?
SELECT
	ui.industry,
	SUM(uf.funding) AS total_funding,
	ROUND(AVG(uf.valuation),0) AS avg_valuation
FROM unicorn_industries ui
INNER JOIN unicorn_funding uf 
	ON ui.company_id = uf.company_id
GROUP BY 1
ORDER BY 2 DESC

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 4
-- Q: Berdasarkan dataset ini, untuk industri jawaban nomor 3 berapakah jumlah company yang bergabung sebagai unicorn di tiap tahunnya di rentang tahun 2016-2022?
SELECT 
	EXTRACT(YEAR FROM ud.date_joined) AS year_joined,
	COUNT(DISTINCT uc.company_id) AS total_company
FROM unicorn_companies uc 
INNER JOIN unicorn_industries ui 
	ON uc.company_id = ui.company_id 
INNER JOIN unicorn_dates ud 
	ON uc.company_id = ud.company_id 
	AND ui.industry = 'Fintech'
	AND EXTRACT(YEAR FROM ud.date_joined) BETWEEN 2016 AND 2022
GROUP BY 1
ORDER BY 1 DESC

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 5
-- Q: Tampilkan data detail company (nama company, kota asal, negara dan benua asal) beserta industri dan valuasinya. Dari negara mana company dengan valuasi terbesar berasal dan apa industrinya?
-- Bagaimana dengan Indonesia? Company apa yang memiliki valuasi paling besar di Indonesia?
SELECT
	uc.*,
	ui.industry,
	uf.valuation
FROM unicorn_companies uc 
INNER JOIN unicorn_industries ui 
	ON uc.company_id = ui.company_id
INNER JOIN unicorn_funding uf 
	ON uc.company_id = uf.company_id 
--WHERE country = 'Indonesia'
ORDER BY uf.valuation DESC

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 6
-- Q: Berapa umur company tertua ketika company tersebut bergabung menjadi unicorn company? Dari negara mana company tersebut berasal?
SELECT
	uc.*,
	ud.date_joined,
	ud.year_founded,
	EXTRACT(YEAR FROM ud.date_joined) - ud.year_founded AS company_age
FROM unicorn_companies uc 
INNER JOIN unicorn_dates ud 
	ON uc.company_id = ud.company_id 
ORDER BY company_age DESC

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 7
-- Q: Untuk company yang didirikan tahun antara tahun 1960 dan 2000 (batas atas dan bawah masuk ke dalam rentang), berapa umur company tertua ketika company tersebut bergabung menjadi unicorn company (date_joined)? Dari negara mana company tersebut berasal?
SELECT
	uc.*,
	ud.date_joined,
	ud.year_founded,
	EXTRACT(YEAR FROM ud.date_joined) - ud.year_founded AS company_age
FROM unicorn_companies uc 
INNER JOIN unicorn_dates ud 
	ON uc.company_id = ud.company_id 
	AND ud.year_founded BETWEEN 1960 AND 2000
ORDER BY company_age DESC

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 8
-- Q1: Ada berapa company yang dibiayai oleh minimal satu investor yang mengandung nama ‘venture’?
SELECT
	COUNT(DISTINCT company_id) AS total_company
FROM unicorn_funding uf
WHERE LOWER(select_investors) LIKE '%venture%'

-- Q2: Ada berapa company yang dibiayai oleh minimal satu investor yang mengandung nama: Venture, Capital, dan Partner
SELECT
	COUNT(DISTINCT CASE WHEN LOWER(select_investors) LIKE '%venture%' THEN company_id END) AS investor_venture,
	COUNT(DISTINCT CASE WHEN LOWER(select_investors) LIKE '%capital%' THEN company_id END) AS investor_capital,
	COUNT(DISTINCT CASE WHEN LOWER(select_investors) LIKE '%partner%' THEN company_id END) AS investor_partner
FROM unicorn_funding uf 

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 9 
-- Q: Di Indonesia terdapat banyak startup yang bergerak di bidang layanan logistik. Ada berapa startup logistik yang termasuk unicorn di Asia? Berapa banyak startup logistik yang termasuk unicorn di Indonesia?
SELECT
	COUNT(DISTINCT uc.company_id) AS total_asia,
	COUNT(DISTINCT CASE WHEN uc.country = 'Indonesia' THEN uc.company_id END) AS total_indonesia
FROM unicorn_companies uc 
INNER JOIN unicorn_industries ui 
	ON uc.company_id = ui.company_id
WHERE ui.industry = '"Supply chain, logistics, & delivery"' AND uc.continent = 'Asia'

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 10
-- Q: Di Asia terdapat tiga negara dengan jumlah unicorn terbanyak. Tampilkan data jumlah unicorn di tiap industri dan negara asal di Asia, terkecuali tiga negara tersebut. Urutkan berdasarkan industri, jumlah company (menurun), dan negara asal.

-- 1st Query -> CTE + NOT IN
WITH top_3 AS (
SELECT
	uc.country,
	COUNT(DISTINCT uc.company_id) AS total_company
FROM unicorn_companies uc 
WHERE uc.continent = 'Asia'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3
)

SELECT
	ui.industry,
	uc.country,
	COUNT(DISTINCT uc.company_id) AS total_company
FROM unicorn_companies uc
INNER JOIN unicorn_industries ui
	ON uc.company_id = ui.company_id 
WHERE uc.continent = 'Asia'
AND uc.country NOT IN (
	SELECT
		DISTINCT country
	FROM top_3
)
GROUP BY 1,2
ORDER BY 1,3 DESC,2



-- 2nd Query -> CTE + JOIN
WITH top_3 AS (
SELECT
	uc.country,
	COUNT(DISTINCT uc.company_id) AS total_company
FROM unicorn_companies uc 
WHERE uc.continent = 'Asia'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3
)

SELECT
	ui.industry,
	uc.country,
	COUNT(DISTINCT uc.company_id) AS total_company
FROM unicorn_companies uc
INNER JOIN unicorn_industries ui
	ON uc.company_id = ui.company_id 
LEFT JOIN top_3 t
	ON uc.country = t.country
WHERE uc.continent = 'Asia' AND t.country IS NULL
GROUP BY 1,2
ORDER BY 1,3 DESC,2

-- 3rd Query --> Subquery + JOIN
SELECT
	ui.industry,
	uc.country,
	COUNT(DISTINCT uc.company_id) AS total_company
FROM unicorn_companies uc
INNER JOIN unicorn_industries ui
	ON uc.company_id = ui.company_id 
LEFT JOIN (
	SELECT
		uc1.country,
		COUNT(DISTINCT uc1.company_id) AS total_company
	FROM unicorn_companies uc1 
	WHERE uc1.continent = 'Asia'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 3
) top_3
	ON uc.country = top_3.country
WHERE uc.continent = 'Asia' AND top_3.country IS NULL
GROUP BY 1,2
ORDER BY 1,3 DESC,2

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 11
-- Q: Amerika Serikat, China, dan India adalah tiga negara dengan jumlah unicorn paling banyak. Apakah ada industri yang tidak memiliki unicorn yang berasal dari India? Apa saja?

-- 1st Query -> CTE + JOIN
WITH industry_india AS (
SELECT
	DISTINCT ui.industry 
FROM unicorn_industries ui
INNER JOIN unicorn_companies uc 
	ON uc.company_id = ui.company_id 
	AND uc.country = 'India' 
)
SELECT
	DISTINCT ui.industry 
FROM unicorn_industries ui
LEFT JOIN industry_india ii
	ON ui.industry = ii.industry
WHERE ii.industry IS NULL

-- 2nd Option Query -> Subquery + NOT IN
SELECT
	DISTINCT ui.industry 
FROM unicorn_industries ui
WHERE ui.industry NOT IN (
	SELECT
		DISTINCT ui2.industry 
	FROM unicorn_companies uc
	INNER JOIN unicorn_industries ui2 
		ON uc.company_id = ui2.company_id 
	WHERE uc.country = 'India'
)

-- 3rd Query -> JOIN + Subquery
SELECT
	DISTINCT ui.industry 
FROM unicorn_industries ui
LEFT JOIN (
	SELECT
		DISTINCT ui2.industry 
	FROM unicorn_companies uc
	INNER JOIN unicorn_industries ui2 
		ON uc.company_id = ui2.company_id 
	WHERE uc.country = 'India'
) 
ii ON ui.industry = ii.industry
WHERE ii.industry IS NULL

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 12
-- Q: Cari tiga industri yang memiliki paling banyak unicorn di tahun 2019-2021 dan tampilkan jumlah unicorn serta rata-rata valuasinya (dalam milliar) di tiap tahun.

-- 1st Option Query
WITH top_3 AS (
SELECT
	ui.industry,
	COUNT(DISTINCT ui.company_id)
FROM unicorn_industries ui 
INNER JOIN unicorn_dates ud 
	ON ui.company_id = ud.company_id 
WHERE EXTRACT(YEAR FROM ud.date_joined) IN (2019,2020,2021)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3
),

yearly_rank AS (
SELECT
	ui.industry,
	EXTRACT(YEAR FROM ud.date_joined) AS year_joined,
	COUNT(DISTINCT ui.company_id) AS total_company,
	ROUND(AVG(uf.valuation)/1000000000,2) AS avg_valuation_billion
FROM unicorn_industries ui 
INNER JOIN unicorn_dates ud 
	ON ui.company_id = ud.company_id 
INNER JOIN unicorn_funding uf 
	ON ui.company_id = uf.company_id 
GROUP BY 1,2
)

SELECT
	y.*
FROM yearly_rank y
INNER JOIN top_3 t
	ON y.industry = t.industry
WHERE y.year_joined IN (2019,2020,2021)
ORDER BY 1,2 DESC

-- 2nd Option Query 
WITH top_3 AS (
SELECT
	ui.industry,
	COUNT(DISTINCT ui.company_id)
FROM unicorn_industries ui 
INNER JOIN unicorn_dates ud 
	ON ui.company_id = ud.company_id 
WHERE EXTRACT(YEAR FROM ud.date_joined) IN (2019,2020,2021)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3
),

yearly_rank AS (
SELECT
	ui.industry,
	EXTRACT(YEAR FROM ud.date_joined) AS year_joined,
	COUNT(DISTINCT ui.company_id) AS total_company,
	ROUND(AVG(uf.valuation)/1000000000,2) AS avg_valuation_billion
FROM unicorn_industries ui 
INNER JOIN unicorn_dates ud 
	ON ui.company_id = ud.company_id 
INNER JOIN unicorn_funding uf 
	ON ui.company_id = uf.company_id 
GROUP BY 1,2
)

SELECT
	y.*
FROM yearly_rank y
WHERE y.year_joined IN (2019,2020,2021)
AND y.industry IN (
	SELECT industry FROM top_3
	)
ORDER BY 1,2 DESC

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ --

-- Nomor 13
-- Q: Negara mana yang memiliki unicorn paling banyak (seperti pertanyaan nomor 1) dan berapa persen proporsinya?

-- 1st Query Option
WITH country_level AS (
SELECT
	uc.country,
	COUNT(DISTINCT uc.company_id) AS total_per_country
FROM unicorn_companies uc
GROUP BY 1
)

SELECT
	*,
	(total_per_country / SUM(total_per_country) OVER())*100 AS pct_company
FROM country_level
ORDER BY 2 DESC

-- 2nd Query Option
SELECT
	uc.country,
	COUNT(DISTINCT uc.company_id) AS total_per_country,
	(CAST(COUNT(DISTINCT uc.company_id) AS FLOAT) / CAST(COUNT(DISTINCT uc2.company_id) AS FLOAT))*100 AS pct_company
FROM unicorn_companies uc, unicorn_companies uc2 
GROUP BY 1
ORDER BY 2 DESC

