--simple SQL code
SELECT *
FROM [AdventureWorks2022].[Person].[Address]

--specifiying the columns to query
SELECT DepartmentID, GroupName, Name 
FROM HumanResources.Department;

--filtering and slicing the date using WHERE
SELECT *
FROM [AdventureWorks2022].[Person].[Address]
WHERE PostalCode = '98011' AND YEAR(ModifiedDate) > '2012'

--not equal symbol
SELECT *
FROM HumanResources.Department
WHERE GroupName <> 'Finance' AND DepartmentID < 10;

--Order by statement
SELECT *
FROM HumanResources.Department
ORDER BY GroupName DESC, DepartmentID;

--Values with constants and Aliasing
SELECT Name, ProductNumber,  'AdventureWorks' AS Manufacturer, ListPrice, (ListPrice * .85) AS SalePrice
FROM Production.Product
WHERE ListPrice >0;

--Determining top records
SELECT TOP 5 TaxRate, Name
FROM Sales.SalesTaxRate
ORDER BY TaxRate DESC;

-- Using WITH TIES
SELECT TOP 5 WITH TIES TaxRate, Name
FROM Sales.SalesTaxRate
ORDER BY TaxRate DESC;

--Removing Duplicates using Distinct
SELECT DISTINCT City, StateProvinceID
FROM Person.Address
ORDER BY City;

--Comparison Operators
SELECT Name, TaxRate
FROM Sales.SalesTaxRate
WHERE TaxRate BETWEEN 7.5 AND 10
ORDER BY TaxRate DESC;

--Dealing with Null values
SELECT WorkOrderID, ScrappedQty, ScrapReasonID
FROM Production.WorkOrder
WHERE ScrapReasonID IS NOT NULL;

--Displaying Null values
SELECT WorkOrderID, ScrappedQty, ISNULL(ScrapReasonID, 99) AS ScrapReason
FROM Production.WorkOrder

--Matching text using Like and wildcards
SELECT Name, TaxRate
FROM Sales.SalesTaxRate
WHERE Name LIKE '%C__%'
ORDER BY TaxRate DESC;

--JOINS--
--Inner join, using the ON and JOIN Key Words
SELECT P1.BusinessEntityID, P1.FirstName, P1.LastName, P2.PhoneNumber
FROM Person.Person AS P1
INNER JOIN Person.PersonPhone AS P2
ON P1.BusinessEntityID = P2.BusinessEntityID;

--Left join
SELECT A.BusinessEntityID, A.PersonType, A.FirstName, A.LastName, B.JobTitle 
FROM Person.Person AS A
LEFT OUTER JOIN HumanResources.Employee AS B
ON A.BusinessEntityID = B.BusinessEntityID;

--Right join
SELECT A.BusinessEntityID, A.PersonType, A.FirstName, A.LastName, B.JobTitle 
FROM Person.Person AS A
RIGHT OUTER JOIN HumanResources.Employee AS B
ON A.BusinessEntityID = B.BusinessEntityID;

--Full outer join
SELECT A.BusinessEntityID, A.PersonType, A.FirstName, A.LastName, B.JobTitle 
FROM Person.Person AS A
FULL OUTER JOIN HumanResources.Employee AS B
ON A.BusinessEntityID = B.BusinessEntityID;

--Cross Join
SELECT Department.Name AS DepartmentName, AddressType.Name AS AddressName
FROM HumanResources.Department CROSS JOIN Person.AddressType;

--Group By
SELECT City, StateProvinceID, COUNT(*) AS AddressCount
FROM Person.Address
GROUP BY City, StateProvinceID
ORDER BY AddressCount DESC;

--Combining Order By and Aggregate Functions
-- Which order ID has highest value?
SELECT SalesOrderID
	, SUM(LineTotal) AS OrderTotal
	, SUM(OrderQty) AS NumberOfItems
	, COUNT(DISTINCT ProductID) AS UniqueItems
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID

-- which is the most popular product in adventureworks?
SELECT S.ProductID
	, P.Name
	, SUM(S.OrderQty) AS TotalQtySold
FROM Sales.SalesOrderDetail AS S 
INNER JOIN Production.Product AS P
ON S.ProductID = P.ProductID
GROUP BY S.ProductID, P.Name
ORDER BY TotalQtySold DESC;

--most popular product color
SELECT Color, COUNT(*) AS NumberOfProducts
FROM Production.Product
WHERE Color IS NOT NULL
GROUP BY Color
HAVING COUNT(*) > 25;

--FUNCTIONS
--String Functions
SELECT FirstName, LastName
	, UPPER(FirstName) AS UpperCase -- convert to uppercase
	, LOWER(LastName) AS LowerCase -- convert to lowercase
	, LEN(FirstName) AS LenghtOfFirstName -- get number of letter in word
	, LEFT(FirstName, 3) AS FirstThreeLetters --get first three letters
	, RIGHT(FirstName, 3) AS LastThreeLetters --get first three letters
	, TRIM(FirstName) AS TrimmedName -- remove leading and trailing spaces
FROM Person.Person;

--Text Concatenation
SELECT FirstName, LastName
	, CONCAT(FirstName, ' ', LastName) AS FullName -- concatenation ofdifferent elements
	, CONCAT_WS(' ', FirstName, MiddleName, LastName) AS WithSeparatorsName -- concatenation special
FROM Person.Person;
--Mathematical functions
SELECT BusinessEntityID
	, SalesYTD
	, ROUND(SalesYTD,2) AS Round2 -- rounds to decimals
	, ROUND(SalesYTD,-2) AS RoundHundreds -- rounds to hundreds
	, CEILING(SalesYTD) AS RoundCeiling --rounds to next number after decimal
	, FLOOR(SalesYTD) AS RoundFloor -- rounds to the number before decimal
FROM Sales.SalesPerson;

--DateTime functions
SELECT BusinessEntityID
	, HireDate
	, YEAR(HireDate) AS HireYear
	, MONTH(HireDate) AS HireMonth
	, DAY(HireDate) AS HireDay
	, DATEDIFF(day, HireDate, GETUTCDATE()) AS DaysSinceHire
	, DATEDIFF(year, HireDate, GETUTCDATE()) AS YearsSinceHire
	, DATEADD(year, 30, HireDate) AS RetireYear
FROM HumanResources.Employee
ORDER BY RetireYear DESC;

--Format Date and Time
SELECT BusinessEntityID
	, HireDate
	, FORMAT(HireDate,'dddd') AS FormattedHireDay
	, FORMAT(HireDate,'dddd, mmmm-dd-yyyy') AS FormattedHireDay
FROM HumanResources.Employee

-- randomID
SELECT TOP 10 WorkOrderID
	, NEWID() AS NewID
FROM Production.WorkOrder
ORDER BY NewID;

--Logical function
SELECT 
--BusinessEntityID
	--, SalesYTD,
	 IIF (SalesYTD > 2000000, 'Met performance goal','Not met performance goal') AS PerformanceStatus
	, COUNT(*)
FROM Sales.SalesPerson;

--Subquerying
SELECT BusinessEntityID
	, SalesYTD
	, (SELECT MAX(SalesYTD)
	   FROM Sales.SalesPerson) AS HighestSalesYTD
	, (SELECT MAX(SalesYTD)
	   FROM Sales.SalesPerson) - SalesYTD AS SalesGap
FROM Sales.SalesPerson
ORDER BY SalesYTD DESC;

--Subquering using WHERE Clause
SELECT SalesOrderID, SUM(LineTotal) AS OrderTotal --subquery of getting totals above average value
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(LineTotal) > 
	(SELECT AVG(ResultTable.MyValues) AS AverageValue -- subquery to get the average of the added numbers 
	 FROM (SELECT SUM(LineTotal) AS MyValues -- subquery to sum and add the values
		   FROM Sales.SalesOrderDetail
           GROUP BY SalesOrderID) AS ResultTable);

--Correlated subqueries
SELECT Person.BusinessEntityID
	, Person.FirstName
	, Person.LastName
	, Employee.JobTitle
 FROM Person.Person INNER JOIN HumanResources.Employee
 ON Person.BusinessEntityID = Employee.BusinessEntityID


-- Alternate of the above inner join using principle of subqueries
SELECT BusinessEntityID
	, FirstName
	, LastName
	, (SELECT JobTitle
		FROM HumanResources.Employee
		WHERE BusinessEntityID = MyPeople.BusinessEntityID) AS JobTitle
FROM Person.Person AS MyPeople
WHERE ((SELECT JobTitle
		FROM HumanResources.Employee
		WHERE BusinessEntityID = MyPeople.BusinessEntityID)) IS NOT NULL;  

-- Pivot Operator column
SELECT 'Average List Price' AS 'Product Line' --giving labels to the pivot table
	, M, R, S, T --specifying the different items
FROM (SELECT ProductLine, ListPrice
	  FROM Production.Product) AS SourceData-- query to list the productline items
PIVOT (AVG(ListPrice) FOR ProductLine IN (M, R, S, T)) AS PivotTable; --pivoting the data using aggregate values

--Declaring a variable
DECLARE @MyColor VARCHAR(20) = 'Red' -- creating variable my color and initializing it to 'Red'

SELECT ProductID, Name, ProductNumber, Color, ListPrice -- Simple query
FROM Production.Product
WHERE Color = @MyColor; -- filter for values equal to the variable

--Using a for loop for execution of a query
DECLARE @Counter INT = 1; 
DECLARE @Product INT = 710; -- declaring the variables

WHILE @Counter < = 4
BEGIN --start
	SELECT ProductID, Name, ProductNumber, Color, ListPrice
	FROM Production.Product
	WHERE ProductID = @Product
	SET @Counter = @Counter + 1
	SET @Product = @Product + 10
END -- close

--Union
SELECT ProductCategoryID
	, NULL AS ProductSubcategory
	, Name
FROM Production.ProductCategory

UNION

SELECT ProductCategoryID
	, ProductSubcategoryID
	, Name
FROM Production.ProductSubcategory;

--Except (distinct rows in first table not in second table)
SELECT BusinessEntityID
FROM Person.Person
WHERE PersonType <> 'EM'

EXCEPT

SELECT BusinessEntityID
FROM Sales.PersonCreditCard

-- alternate left join for above query
SELECT Person.BusinessEntityID
FROM Person.Person 
LEFT JOIN Sales.PersonCreditCard
ON Person.BusinessEntityID = PersonCreditCard.BusinessEntityID
WHERE Person.PersonType <> 'EM' AND PersonCreditCard.CreditCardID IS NULL;


--INTERSECT (rows identical in both tables
SELECT ProductID
FROM Production.ProductProductPhoto

INTERSECT

SELECT ProductID
FROM Production.ProductReview

--Modified inner join for above
SELECT DISTINCT A.ProductID
FROM Production.ProductProductPhoto AS A
	INNER JOIN Production.ProductReview AS B
	ON A.ProductID = B.ProductID


