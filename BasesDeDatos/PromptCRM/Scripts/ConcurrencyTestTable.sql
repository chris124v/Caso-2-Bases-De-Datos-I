use PromptCrm

CREATE TABLE ##ProductsTest (
	IdProduct INT PRIMARY KEY IDENTITY(1,1),
	ProductName VARCHAR(30),
	Price DECIMAL(16,2),
	Quantity INT,
	CreatedAt DATETIME,
	UpdatedAt DATETIME
)