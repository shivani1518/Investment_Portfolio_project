CREATE DATABASE investment_portfolio;
USE investment_portfolio;
CREATE TABLE clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    city VARCHAR(50),
    age INT
);
INSERT INTO clients VALUES
(1,'Rahul Sharma','Mumbai',35),
(2,'Priya Patel','Delhi',29),
(3,'Amit Singh','Pune',42),
(4,'Neha Verma','Bangalore',31),
(5,'Arjun Gupta','Hyderabad',38);
INSERT INTO assets VALUES
(101,'TCS','Stock','Medium'),
(102,'Infosys','Stock','Medium'),
(103,'Government Bond','Bond','Low'),
(104,'Nifty ETF','ETF','Medium'),
(105,'Reliance','Stock','High');
CREATE TABLE portfolio (
    portfolio_id INT PRIMARY KEY,
    client_id INT,
    asset_id INT,
    quantity INT,
    purchase_price DECIMAL(10,2),

    FOREIGN KEY (client_id)
    REFERENCES clients(client_id),

    FOREIGN KEY (asset_id)
    REFERENCES assets(asset_id)
);
INSERT INTO portfolio VALUES
(1,1,101,50,3200),
(2,1,104,100,210),
(3,2,102,30,1500),
(4,2,103,200,100),
(5,3,105,40,2500),
(6,4,101,25,3100),
(7,5,104,150,200);
CREATE TABLE market_prices (
    asset_id INT,
    current_price DECIMAL(10,2),

    FOREIGN KEY (asset_id)
    REFERENCES assets(asset_id)
);
INSERT INTO market_prices VALUES
(101,3600),
(102,1700),
(103,110),
(104,250),
(105,2900);
SELECT *
FROM portfolio p
JOIN clients c
ON p.client_id = c.client_id;
SELECT
c.client_name,
SUM(p.quantity * mp.current_price) AS portfolio_value
FROM portfolio p
JOIN clients c
ON p.client_id = c.client_id
JOIN market_prices mp
ON p.asset_id = mp.asset_id
GROUP BY c.client_name;
SELECT
c.client_name,
a.asset_name,
p.quantity,
p.purchase_price,
mp.current_price,
(p.quantity * mp.current_price) -
(p.quantity * p.purchase_price) AS profit_loss
FROM portfolio p
JOIN clients c
ON p.client_id = c.client_id
JOIN assets a
ON p.asset_id = a.asset_id
JOIN market_prices mp
ON p.asset_id = mp.asset_id;
SELECT
c.client_name,
SUM(p.quantity * mp.current_price) AS portfolio_value
FROM portfolio p
JOIN clients c
ON p.client_id = c.client_id
JOIN market_prices mp
ON p.asset_id = mp.asset_id
GROUP BY c.client_name;
SELECT
c.client_name,
SUM(p.quantity * mp.current_price) AS portfolio_value
FROM portfolio p
JOIN clients c
ON p.client_id = c.client_id
JOIN market_prices mp
ON p.asset_id = mp.asset_id
GROUP BY c.client_name
ORDER BY portfolio_value DESC
LIMIT 1;
SELECT
client_name,
portfolio_value,
RANK() OVER (
ORDER BY portfolio_value DESC
) AS ranking
FROM
(
SELECT
c.client_name,
SUM(p.quantity * mp.current_price) AS portfolio_value
FROM portfolio p
JOIN clients c
ON p.client_id = c.client_id
JOIN market_prices mp
ON p.asset_id = mp.asset_id
GROUP BY c.client_name
) t;
SELECT
client_name,
portfolio_value,
RANK() OVER (
ORDER BY portfolio_value DESC
) AS ranking
FROM
(
    SELECT
    c.client_name,
    SUM(p.quantity * mp.current_price) AS portfolio_value
    FROM portfolio p
    JOIN clients c
    ON p.client_id = c.client_id
    JOIN market_prices mp
    ON p.asset_id = mp.asset_id
    GROUP BY c.client_name
) t;
WITH portfolio_summary AS
(
    SELECT
    c.client_name,
    SUM(p.quantity * mp.current_price) AS portfolio_value
    FROM portfolio p
    JOIN clients c
    ON p.client_id = c.client_id
    JOIN market_prices mp
    ON p.asset_id = mp.asset_id
    GROUP BY c.client_name
)

SELECT
client_name,
portfolio_value,
RANK() OVER(
ORDER BY portfolio_value DESC
) AS ranking
FROM portfolio_summary;
SELECT *
FROM
(
    SELECT
    c.client_name,
    SUM(p.quantity * mp.current_price) AS portfolio_value
    FROM portfolio p
    JOIN clients c
    ON p.client_id = c.client_id
    JOIN market_prices mp
    ON p.asset_id = mp.asset_id
    GROUP BY c.client_name
) t
WHERE portfolio_value >
(
    SELECT AVG(portfolio_value)
    FROM
    (
        SELECT
        SUM(p.quantity * mp.current_price) AS portfolio_value
        FROM portfolio p
        JOIN market_prices mp
        ON p.asset_id = mp.asset_id
        GROUP BY client_id
    ) x
);
SELECT
c.client_name,
SUM(p.quantity * mp.current_price) AS portfolio_value
FROM portfolio p
JOIN clients c
ON p.client_id = c.client_id
JOIN market_prices mp
ON p.asset_id = mp.asset_id
GROUP BY c.client_name
HAVING portfolio_value > 100000;
SELECT
a.asset_name,
SUM((mp.current_price - p.purchase_price) * p.quantity) AS total_profit
FROM portfolio p
JOIN assets a
ON p.asset_id = a.asset_id
JOIN market_prices mp
ON p.asset_id = mp.asset_id
GROUP BY a.asset_name
ORDER BY total_profit DESC
LIMIT 1;
SELECT
risk_level,
COUNT(*) AS total_assets
FROM assets
GROUP BY risk_level;
SELECT
AVG(portfolio_value) AS avg_portfolio_value
FROM
(
    SELECT
    client_id,
    SUM(p.quantity * mp.current_price) AS portfolio_value
    FROM portfolio p
    JOIN market_prices mp
    ON p.asset_id = mp.asset_id
    GROUP BY client_id
) t;
SELECT * FROM market_prices;