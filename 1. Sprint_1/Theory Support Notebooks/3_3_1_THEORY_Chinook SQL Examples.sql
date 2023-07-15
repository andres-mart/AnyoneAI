-- SELECT example: Select InvoiceId, BillingAddress and BillingCity columns from Invoice table. (This is a comment and won’t be executed)
SELECT InvoiceId, BillingAddress, BillingCity
FROM Invoice;

-- SELECT example: List all the Customers' names without repetition
SELECT DISTINCT FirstName
FROM Customer;

-- WHERE example: Select all the invoices billed from Argentina
SELECT *
FROM Invoice
WHERE Invoice.BillingCountry = 'Argentina';

-- WHERE example: Select all the invoices in which the spent value is over $20
SELECT *
FROM Invoice
WHERE Invoice.Total > 20;

-- WHERE example: Select all the invoices billed from Argentina in which the spent value is over $5
SELECT *
FROM Invoice
WHERE Invoice.BillingCountry = 'Argentina' AND Invoice.Total > 5;

-- WHERE example: Select all the invoices billed from Argentina or Germany
SELECT *
FROM Invoice
WHERE Invoice.BillingCountry = 'Argentina' OR Invoice.BillingCountry = 'Germany';

-- WHERE example: Select all the invoices not billed from Argentina
SELECT *
FROM Invoice
WHERE NOT Invoice.BillingCountry = 'Argentina';

-- IN example: Select all the invoices billed from Oslo, Berlin, and Paris
SELECT *
FROM Invoice 
WHERE Invoice.BillingCity IN ('Oslo', 'Berlin', 'Paris');

-- More complex IN example: Select all the customers who live in the same City as the Employees
SELECT *
FROM Customer 
WHERE Customer.City IN (SELECT City FROM Employee);

-- IS NULL example: Select all the invoices with Billing State value 
SELECT *
FROM Invoice
WHERE Invoice.BillingState IS NOT NULL;

-- BETWEEN example: Select all the invoices with Total value between $2 and $10 
SELECT *
FROM Invoice
WHERE Invoice.Total BETWEEN 2 AND 10;

-- ORDER BY example: Give all the invoices sorted by Total $ descending
SELECT *
FROM Invoice
ORDER BY Invoice.Total DESC;

-- Alias example for columns
SELECT Track.TrackId as Id, Track.UnitPrice as Price 
FROM Track;

-- Alias example for tables
SELECT t.TrackId, t.UnitPrice 
FROM Track as t;

-- More complex example with alias
SELECT * 
FROM Customer as c, Invoice AS i
WHERE c.FirstName = 'Mark' AND c.CustomerId = i.CustomerId;

-- MIN example: Give me the date for the first invoice billed in the system (minimum date)
SELECT MIN(Invoice.InvoiceDate)
FROM Invoice;

-- MAX example: Give me all the data for the track with longest duration
SELECT MAX(Track.Milliseconds), *
FROM Track;

-- SUM example: Give the total amount of $ spent by the users
SELECT SUM(Invoice.Total)
FROM Invoice;

-- AVG example: Give the average value spent by users from USA
SELECT AVG(Invoice.Total)
FROM Invoice
WHERE Invoice.BillingCountry == 'USA';

-- GROUP BY example: Count Customers by Country
SELECT COUNT(*) as Count_by_Country, c.Country
FROM Customer AS c
GROUP BY c.Country
ORDER BY Count_by_Country DESC;

-- GROUP BY example: Number of sales and average amount spent by Country during 2010
SELECT COUNT(*) as Sales_by_Country, AVG(i.Total) as Average_spent, i.BillingCountry as Country
FROM Invoice AS i
WHERE i.InvoiceDate BETWEEN '2010-01-01 00:00:00' and '2010-31-12 00:00:00' 
GROUP BY i.BillingCountry 
ORDER BY Sales_by_Country DESC;

-- GROUP BY example: Number of sales and average amount spent by Country, only for those who had more than 10 sales
SELECT COUNT(*) as Sales_by_Country, AVG(i.Total) as Average_spent, i.BillingCountry as Country
FROM Invoice AS i
GROUP BY i.BillingCountry
HAVING Sales_by_Country > 10
ORDER BY Sales_by_Country DESC;

-- CASE example: Tracks over 8M bytes labeled as 'High-Quality', otherwise 'Mid-Quality' 
SELECT *,
CASE
    WHEN Track.Bytes <= 8000000 THEN 'Mid-Quality'
    WHEN Track.Bytes > 8000000 THEN 'High-Quality'
END
FROM Track
ORDER BY Track.Bytes DESC;

-- CASE example: Tracker below 2M bytes are 'Poor-quality', between 2M and 8M 'Mid-Quality', over 8M 'High-Quality' 
SELECT *,
(CASE
	WHEN Track.Bytes < 2000000 THEN 'Poor-Quality'
    WHEN Track.Bytes >= 2000000 AND Track.Bytes <= 8000000 THEN 'Mid-Quality'
    WHEN Track.Bytes > 8000000 THEN 'High-Quality'
END) AS AudioQuality
FROM Track
ORDER BY Track.Bytes ASC;

-- CASE + GRUOP BY example: Count Tracks by Quality 
SELECT case_result.AudioQuality, COUNT(*) FROM (
    SELECT *,
    (CASE
    	WHEN Track.Bytes < 2000000 THEN 'Poor-Quality'
        WHEN Track.Bytes >= 2000000 AND Track.Bytes <= 8000000 THEN 'Mid-Quality'
        WHEN Track.Bytes > 8000000 THEN 'High-Quality'
    END) AS AudioQuality
    FROM Track
    ORDER BY Track.Bytes ASC
) AS case_result
GROUP BY case_result.AudioQuality;

-- JOIN using WHERE
SELECT c.CustomerId, e.EmployeeId, e.FirstName, e.LastName, e.Title
FROM Customer AS c, Employee as e
WHERE c.SupportRepId = e.EmployeeId;

-- INNER JOIN (same as using WHERE)
SELECT c.CustomerId, e.EmployeeId, e.FirstName, e.LastName, e.Title
FROM Customer AS c
INNER JOIN Employee as e
ON c.SupportRepId = e.EmployeeId;

-- INNER JOIN example: Give me all the Tracks that were sold
SELECT *
FROM Track AS t
INNER JOIN InvoiceLine AS il
ON t.TrackId = il.TrackId;

-- LEFT JOIN example: Give me all the Tracks and the Invoice data IF that song was sold
SELECT *
FROM Track AS t
LEFT JOIN InvoiceLine AS il
ON t.TrackId = il.TrackId;

-- RIGHT JOIN example: Give me only the Tracks that were sold
SELECT *
FROM Track AS t
RIGHT JOIN InvoiceLine AS il
ON t.TrackId = il.TrackId;



