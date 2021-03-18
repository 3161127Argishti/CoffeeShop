DROP TABLE orders;
DROP TABLE coffees;
DROP TABLE customers;

CREATE TABLE coffees (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC NOT NULL
);

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  "CreditCardNumber" TEXT NOT NULL
);

CREATE TABLE orders (
  customerid INTEGER,
  coffeeid INTEGER NOT NULL,
  date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  to_go BOOLEAN NOT NULL,
  discount NUMERIC NOT NULL DEFAULT 0,
  pcs INTEGER NOT NULL,
  CONSTRAINT fk_coffee
      FOREIGN KEY(coffeeid) 
	  REFERENCES coffees(id)
);

INSERT INTO coffees (name, price)
VALUES ('Espresso', 2.9);
INSERT INTO coffees (name, price)
VALUES ('Machiatto', 2.9);
INSERT INTO coffees (name, price)
VALUES ('Americano', 2.9);
INSERT INTO coffees (name, price)
VALUES ('Cappuccino', 3.0);
INSERT INTO coffees (name, price)
VALUES ('Latte', 3.2);
INSERT INTO coffees (name, price)
VALUES ('Mocha', 3.4);

SELECT *
FROM coffees;

INSERT INTO customers ("CreditCardNumber")
VALUES ('1234123412341234');
INSERT INTO customers ("CreditCardNumber")
VALUES ('1111111111111111');
INSERT INTO customers ("CreditCardNumber")
VALUES ('2222222222222222');
INSERT INTO customers ("CreditCardNumber")
VALUES ('3333333333333333');
INSERT INTO customers ("CreditCardNumber")
VALUES ('4444444444444444');
INSERT INTO customers ("CreditCardNumber")
VALUES ('5555555555555555');

SELECT *
FROM customers;

INSERT INTO orders (customerid, coffeeid, to_go, discount, pcs)
VALUES (1, 1, true, 10, 2);
INSERT INTO orders (customerid, coffeeid, to_go, discount, pcs)
VALUES (3, 2, false, 0, 1);
INSERT INTO orders (coffeeid, to_go, discount, pcs)
VALUES (4, true, 10, 2);
INSERT INTO orders (coffeeid, to_go, discount, pcs)
VALUES (2, true, 10, 2);
INSERT INTO orders (coffeeid, to_go, discount, pcs)
VALUES (1, true, 10, 2);
INSERT INTO orders (customerid, coffeeid, to_go, discount, pcs)
VALUES (4, 3, false, 0, 1);
INSERT INTO orders (customerid, coffeeid, to_go, discount, pcs)
VALUES (5, 5, false, 0, 2);
INSERT INTO orders (customerid, coffeeid, to_go, discount, pcs)
VALUES (2, 4, true,10, 2);
INSERT INTO orders (coffeeid, to_go, discount, pcs)
VALUES (4, false, 0, 2);
INSERT INTO orders (coffeeid, to_go, discount, pcs)
VALUES (1, false, 0, 2);
INSERT INTO orders (customerid, coffeeid, to_go, discount, pcs)
VALUES (1, 1, false, 0, 1);
INSERT INTO orders (customerid, coffeeid, to_go, discount, pcs)
VALUES (3, 2, true, 10, 1);
INSERT INTO orders (coffeeid, to_go, discount, pcs)
VALUES (1, true, 10, 2);
INSERT INTO orders (customerid, coffeeid, date, to_go, discount, pcs)
VALUES (4, 1, '2021-02-18 19:51:06.568181', false, 0, 1);
INSERT INTO orders (coffeeid, date, to_go, discount, pcs)
VALUES (2, '2020-08-18 19:51:06.568181', false, 0, 2);
INSERT INTO orders (customerid, coffeeid, date, to_go, discount, pcs)
VALUES (5, 2, '2020-11-18 19:51:06.568181', true, 10, 3);

SELECT *
FROM orders;

--get the average per month
SELECT to_char(date, 'YYYY-MM') AS months, AVG((price - price * discount / 100) * pcs) AS "Average"
FROM orders INNER JOIN coffees ON coffeeid = id
GROUP BY to_char(date, 'YYYY-MM')
ORDER BY months;

--the highest income of the last 10 months 
WITH t AS (
SELECT to_char(date, 'YYYY-MM') AS months, SUM((price - price * discount / 100) * pcs) AS sums
FROM orders INNER JOIN coffees ON coffeeid = id AND date >  CURRENT_DATE - INTERVAL '10 months'
GROUP BY to_char(date, 'YYYY-MM')
)
SELECT t.months AS "Month", t.sums AS "Highest Income"
FROM (
	SELECT MAX(sums) AS sums
	FROM t) k INNER JOIN t ON k.sums = t.sums;

--top 2 customers(customers that have most frequent visits) for last month.
SELECT customerid, COUNT(customerid) AS "Visits"
FROM orders
WHERE date >  CURRENT_DATE - INTERVAL '1 months' AND customerid IS NOT NULL
GROUP BY customerid
ORDER BY "Visits" DESC
LIMIT 2