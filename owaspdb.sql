
SET NOCOUNT ON
GO

set quoted_identifier on
GO

/* Set DATEFORMAT so that the date strings are interpreted correctly regardless of
   the default DATEFORMAT on the server.
*/
SET DATEFORMAT mdy
GO

-- Create owaspdb database
CREATE DATABASE IF NOT EXISTS 'owaspdb'

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