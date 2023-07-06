CREATE TABLE [CRE].[JsonFormatCalcV1] (
[JsonFormatCalcV1]    INT IDENTITY (1, 1) NOT NULL,
[Type] nvarchar(50),
[Key] nvarchar(50),
Position nvarchar(50),
DataType nvarchar(50),
IsActive bit
CONSTRAINT [PK_JsonFormatCalcV1] PRIMARY KEY CLUSTERED (JsonFormatCalcV1 ASC)
);