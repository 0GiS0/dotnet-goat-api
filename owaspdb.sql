CREATE DATABASE owaspdb

GO

USE owaspdb

GO

CREATE TABLE [dbo].[Users]
(
  [Id] INT NOT NULL PRIMARY KEY IDENTITY,

  [Username] NVARCHAR(50) NOT NULL,

  [Password] NVARCHAR(50) NOT NULL,

  [Email] NVARCHAR(50) NOT NULL,

  [IsAdmin] BIT NOT NULL,

  [IsLocked] BIT NOT NULL,

  [LastLogin] DATETIME NOT NULL

)

GO

CREATE TABLE [dbo].[Customers]
(
  [Id] INT NOT NULL PRIMARY KEY IDENTITY,
  [Name] NVARCHAR(50) NOT NULL,
  [Address] NVARCHAR(50) NOT NULL,
  [City] NVARCHAR(50) NOT NULL,
  [State] NVARCHAR(50) NOT NULL,
  [Zip] NVARCHAR(50) NOT NULL,
  [Country] NVARCHAR(50) NOT NULL,
  [Phone] NVARCHAR(50) NOT NULL,
  [Email] NVARCHAR(50) NOT NULL,
  [CreditCard] NVARCHAR(50) NOT NULL,
  [CreditCardType] NVARCHAR(50) NOT NULL,
  [CreditCardExpiration] NVARCHAR(50) NOT NULL,
  [Username] NVARCHAR(50) NOT NULL,
  [Password] NVARCHAR(50) NOT NULL

)

GO

CREATE TABLE [dbo].[CreditCards]
(
  [Id] INT NOT NULL PRIMARY KEY IDENTITY,
  [CardNumber] VARCHAR(16) NOT NULL,
  [ExpirationDate] DATETIME NOT NULL,
  [CVV] VARCHAR(3) NOT NULL,  
  [UserId] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Users]([Id]),
)

GO

-- Populate tables
-- =============================================
-- Populate Customers table
-- =============================================
INSERT INTO [dbo].[Customers]
    ([Name]
    ,[Address]
    ,[City]
    ,[State]
    ,[Zip]
    ,[Country]
    ,[Phone]
    ,[Email]
    ,[CreditCard]
    ,[CreditCardType]
    ,[CreditCardExpiration]
    ,[Username]
    ,[Password])
VALUES
    (
        'John Doe',
        '123 Main St',
        'Anytown',
        'CA',
        '12345',
        'USA',
        '555-555-5555',
        'johndoe@email.com',
        '1234567890123456',
        'Visa',
        '12/12',
        'johndoe',
        'password')

INSERT INTO [dbo].[Customers]
    ([Name]
    ,[Address]
    ,[City]
    ,[State]
    ,[Zip]
    ,[Country]
    ,[Phone]
    ,[Email]
    ,[CreditCard]
    ,[CreditCardType]
    ,[CreditCardExpiration]
    ,[Username]
    ,[Password])
VALUES
    (
        'Jane Doe',
        '123 Main St',
        'Anytown',
        'CA',
        '12345',
        'USA',
        '555-555-5555',
        'janedoe@email.com',
        '1234567890123456',
        'Visa',
        '12/12',
        'janedoe',
        'password')


-- Populate users with this table definition
INSERT INTO [dbo].[Users]
    ([Username]
    ,[Password]
    ,[Email]
    ,[IsAdmin]
    ,[IsLocked]
    ,[LastLogin]
    )
VALUES
    (
        'johndoe',
        'password',
        'johndoe@email.com',
        0,
        0,
        '2012-01-01 00:00:00.000'
)

INSERT INTO [dbo].[Users]
    ([Username]
    ,[Password]
    ,[Email]
    ,[IsAdmin]
    ,[IsLocked]
    ,[LastLogin]
    )
VALUES
    (
        'admin',
        'admin',
        'admin@email.com',
        1,
        0,
        '2012-01-01 00:00:00.000'
    )
