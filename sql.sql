-- Return to Window Functions!
-- BASIC SYNTAX
-- SELECT <aggregator> OVER(PARTITION BY <col1> ORDER BY <col2>)
-- PARTITION BY (like GROUP BY) a column to do the aggregation within particular category in <col1>
-- Choose what order to apply the aggregator over (if it's a type of RANK)
-- Example SELECT SUM(sales) OVER(PARTITION BY department)
-- Feel free to google RANK examples too.



-- Return a list of all customers, RANKED in order from highest to lowest total spendings
-- WITHIN the country they live in.
-- HINT: find a way to join the order_details, products, and customers tables


-- Return the same list as before, but with only the top 3 customers in each country.


-- PRE-ANSWER #1 

SELECT o.CustomerID, 
    c.country, 
    SUM((d.unitprice * d.quantity* (1-d.discount))) AS total_spending
FROM Customers c INNER JOIN Orders o USING(CustomerID) 
    INNER JOIN OrderDetails d USING(OrderID) 
GROUP BY o.customerID, c.country
ORDER BY c.country, total_spending DESC

-- ANSWER #1


SELECT o.CustomerID, 
    c.country, 
    SUM((d.unitprice * d.quantity* (1-d.discount))) AS total_spending,
    RANK () OVER (PARTITION BY country ORDER BY SUM((d.unitprice * d.quantity* (1-d.discount))) DESC)
FROM Customers c INNER JOIN Orders o USING(CustomerID) 
    INNER JOIN OrderDetails d USING(OrderID) 
GROUP BY o.customerID, c.country
ORDER BY c.country, total_spending DESC;

-- OUTPUT #1 

customerid |   country   | total_spending | rank
------------+-------------+----------------+------
 OCEAN      | Argentina   |         3460.2 |    1
 RANCH      | Argentina   |         2844.1 |    2
 CACTU      | Argentina   |         1814.8 |    3
 ERNSH      | Austria     |    105182.1785 |    1
 PICCO      | Austria     |       23128.86 |    2
 SUPRD      | Belgium     |       24088.78 |    1
 MAISD      | Belgium     |       9989.695 |    2
 HANAR      | Brazil      |       32841.37 |    1
 QUEEN      | Brazil      |     25717.4975 |    2
 RICAR      | Brazil      |        12450.8 |    3
 URL        | Brazil      |       8414.135 |    4
 TRADH      | Brazil      |       6850.664 |    5
 QUEDE      | Brazil      |        6664.81 |    6
 WELLI      | Brazil      |         6068.2 |    7
 FAMIA      | Brazil      |        4107.55 |    8
 COMMI      | Brazil      |        3810.75 |    9
 ...

-- ANSWER #2 


WITH total_spending AS (
    SELECT o.CustomerID, 
        c.country, 
        SUM((d.unitprice * d.quantity* (1-d.discount))) AS total_spending,
        RANK () OVER (PARTITION BY country ORDER BY SUM((d.unitprice * d.quantity* (1-d.discount)))DESC)
    FROM Customers c INNER JOIN Orders o USING(CustomerID) 
        INNER JOIN OrderDetails d USING(OrderID) 
    GROUP BY o.customerID, c.contactname, c.country
)

SELECT country, rank, customerID, total_spending
FROM total_spending
WHERE rank IN(1,2,3)
ORDER BY country ASC, rank ASC, customerID ASC;

-- OUTPUT #2 

   country   | rank | customerid | total_spending
-------------+------+------------+----------------
 Argentina   |    1 | OCEAN      |         3460.2
 Argentina   |    2 | RANCH      |         2844.1
 Argentina   |    3 | CACTU      |         1814.8
 Austria     |    1 | ERNSH      |    105182.1785
 Austria     |    2 | PICCO      |       23128.86
 Belgium     |    1 | SUPRD      |       24088.78
 Belgium     |    2 | MAISD      |       9989.695
 Brazil      |    1 | HANAR      |       32841.37
 Brazil      |    2 | QUEEN      |     25717.4975
 Brazil      |    3 | RICAR      |        12450.8
 Canada      |    1 | MEREP      |       28872.19
 Canada      |    2 | BOTTM      |        20801.6
 Canada      |    3 | LAUGB      |          522.5
 Denmark     |    1 | SIMOB      |     16817.0975
 Denmark     |    2 | VAFFE      |      15843.925
 Finland     |    1 | WARTH      |     15648.7025
 Finland     |    2 | WILMK      |        3161.35
 ...










