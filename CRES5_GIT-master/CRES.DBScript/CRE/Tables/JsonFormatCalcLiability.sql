CREATE TABLE [CRE].[JsonFormatCalcLiability] (
[JsonFormatCalcLiabilityID]    INT IDENTITY (1, 1) NOT NULL,
Position nvarchar(50),
[Key] nvarchar(50),
[KeyFormat] nvarchar(50),
DataType nvarchar(50),
IsActive bit,
ParentID int null,
FilterBy nvarchar(50)
CONSTRAINT [PK_JsonFormatCalcLiability] PRIMARY KEY CLUSTERED (JsonFormatCalcLiabilityID ASC)
);
