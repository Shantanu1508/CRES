--QuickBookCustomer table
CREATE TABLE App.[QuickBookCustomer](
[QuickBookCustomerID] [int] IDENTITY(1,1) NOT NULL,
[ID] [nvarchar](256) NULL,
[Name] [nvarchar](256) NULL,
[FullName] [nvarchar](256) NULL,
[FirstName] [nvarchar](256) NULL,
[LastName] [nvarchar](256) NULL,
[CompanyName] [nvarchar](256) NULL,
[IsActive] bit default 1,
[CreatedBy] [nvarchar](256) NULL,
[CreatedDate] [datetime] NULL,
[UpdatedBy] [nvarchar](256) NULL,
[UpdatedDate] [datetime] NULL,
[CustomerNo] NVARCHAR(256) NULL,
[ContactID] NVARCHAR(256) NULL
    CONSTRAINT PK_QuickBookCustomerID PRIMARY KEY (QuickBookCustomerID)

);