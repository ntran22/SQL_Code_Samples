-- Nancy Tran
-- SQL Sample Code


-- Query 1-4 uses the SQLite's Chinook sample database to excute the following queries.

-- Query 1: Display the Artists, Title and the Amount earned in order by the top 50 artists.
-- Also display a column indicating if the genre is Rock. The highest amount earned should be at the top.
SELECT
  Artist.Name,
	Album.Title, 
	SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity ) AS AmountEarned,
	CASE Genre.Name
		WHEN 'Rock'
			THEN 'YES'
		ELSE 'NO'
	END AS Rock	
FROM Artist
	INNER JOIN Album ON Artist.ArtistId = Album.ArtistID
	INNER JOIN Track ON Album.AlbumId = Track.AlbumId
	INNER JOIN Genre ON Track.GenreId = Genre.GenreId
	INNER JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY
	Artist.Name;




-- Query 2: Write a query that determines the most popular composer amongst the customers 
-- of the city of Paris. That is music composed by composers whose music has been downloaded 
-- by the customers in the city of Paris. In other words, you need to find the number of occurrences of composers.
SELECT
	Customer.City,
	Track.Composer,
	Count(Track.Composer) AS NumberOfOccurances
FROM Customer
	INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
	INNER JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
	INNER JOIN Track ON InvoiceLine.TrackId = Track.TrackId
WHERE
		Customer.City = 'Paris'	
GROUP BY
	Track.Composer
ORDER BY
	NumberOfOccurances DESC;




-- Query 3: Find out the customer who spent the highest amount to buy music. Write a query 
-- that returns the customer id, first name, last name and the total spent by the customer. 
-- The customer that spent the highest amount should be at the top. The rest should be in 
-- order where the least spent is the last row.
SELECT
	Customer.CustomerID,
	Customer.FirstName,
	Customer.LastName,
	SUM(Invoice.Total) AS TotalSpent
FROM Customer
	INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY
	Customer.CustomerId
ORDER BY
	TotalSpent DESC;




-- Query 4:Write a query that determines the amount spent by customers whose last name starts 
-- with “S”. Also, the last name should display in the descending order.
SELECT
  Customer.CustomerID,
  Customer.LastName,
  Customer.City,
  SUM(Invoice.Total) OVER (PARTITION BY Customer.CustomerId ) AS AmountSpent
From Customer
  INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
WHERE
  Customer.LastName LIKE 'S%'
ORDER BY
  Customer.LastName DESC;




-- Query 5-8 uses a Pet Store Database to complete the following queries.

-- Query 5: Determining the type of pet that the pet store sells the most.
SELECT
    Top(1)
    Count(PetStore.dbo.Animal.AnimalID) AS Count_AnimalID,
    PetStore.dbo.Animal.Category,
    PetStore.dbo.Animal.SaleID
FROM
    PetStore.dbo.Animal
GROUP BY
    PetStore.dbo.Animal.Category,
    PetStore.dbo.Animal.SaleID
ORDER BY
    Count_AnimalID DESC;



-- Query 6: Determining the oldest sold cat(on the day that it was sold).
SELECT
    Top (1)
    PetStore.dbo.Animal.DateBorn,
    PetStore.dbo.Animal.Category,
    PetStore.dbo.Animal.AnimalID,
    PetStore.dbo.Sale.SaleDate,
    DateDiff(day, PetStore.dbo.Animal.DateBorn, PetStore.dbo.Sale.SaleDate) As Diffs,
    PetStore.dbo.Animal.Name
FROM
    PetStore.dbo.Animal INNER JOIN
    PetStore.dbo.Sale ON PetStore.dbo.Sale.SaleID = PetStore.dbo.Animal.SaleID
WHERE
    PetStore.dbo.Animal.Category = 'Cat'
GROUP BY
    PetStore.dbo.Animal.DateBorn,
    PetStore.dbo.Animal.Category,
    PetStore.dbo.Animal.AnimalID,
    PetStore.dbo.Sale.SaleDate,
    DateDiff(day, PetStore.dbo.Animal.DateBorn, PetStore.dbo.Sale.SaleDate),
    PetStore.dbo.Animal.Name
ORDER BY
    Diffs DESC;



-- Query 7: Comparing the average sale price of registered dogs to unregistered dogs(Displaying both results in descending order).
SELECT
    Avg(PetStore.dbo.SaleItem.SalePrice) AS Avg_SalePrice,
    PetStore.dbo.Animal.Category,
    PetStore.dbo.Animal.Registered
FROM
    PetStore.dbo.Animal INNER JOIN
    PetStore.dbo.Sale ON PetStore.dbo.Sale.SaleID = PetStore.dbo.Animal.SaleID INNER JOIN
    PetStore.dbo.SaleItem ON PetStore.dbo.SaleItem.SaleID = PetStore.dbo.Sale.SaleID
WHERE
    (PetStore.dbo.Animal.Category = 'Dog' AND
        PetStore.dbo.Animal.Registered IS NOT NULL) OR
    (PetStore.dbo.Animal.Category = 'Dog' AND
        PetStore.dbo.Animal.Registered IS NULL)
GROUP BY
    PetStore.dbo.Animal.Category,
    PetStore.dbo.Animal.Registered
ORDER BY
    Avg_SalePrice DESC;



-- Query 8: Determining the category of animal that provides the highest average profit percentage.
-- Profit is defined as the sale price less cost. Percentage would be divided by the cost.
SELECT
    PetStore.dbo.Animal.Category,
    Max(100.0 * (PetStore.dbo.OrderItem.Cost - PetStore.dbo.SaleItem.SalePrice) / PetStore.dbo.OrderItem.Cost)
    AS [PercentDiff (%)]
FROM
    PetStore.dbo.Animal INNER JOIN
    PetStore.dbo.Sale ON PetStore.dbo.Sale.SaleID = PetStore.dbo.Animal.SaleID INNER JOIN
    PetStore.dbo.SaleItem ON PetStore.dbo.SaleItem.SaleID = PetStore.dbo.Sale.SaleID INNER JOIN
    PetStore.dbo.Merchandise ON PetStore.dbo.SaleItem.ItemID = PetStore.dbo.Merchandise.ItemID INNER JOIN
    PetStore.dbo.OrderItem ON PetStore.dbo.OrderItem.ItemID = PetStore.dbo.Merchandise.ItemID
GROUP BY
    PetStore.dbo.Animal.Category
ORDER BY
    [PercentDiff (%)] DESC;