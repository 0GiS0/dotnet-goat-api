-- This file contains SQL statements that will be executed after the build script.
-- =============================================
SELECT TOP (1000)
    [Id]
      , [Name]
      , [Address]
      , [City]
      , [State]
      , [Zip]
      , [Country]
      , [Phone]
      , [Email]
      , [CreditCard]
      , [CreditCardType]
      , [CreditCardExpiration]
      , [Username]
      , [Password]
FROM [owaspdb].[dbo].[Customers]

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
    