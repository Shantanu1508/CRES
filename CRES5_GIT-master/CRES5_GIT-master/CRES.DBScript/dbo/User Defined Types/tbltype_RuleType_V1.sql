
CREATE TYPE [dbo].[tbltype_RuleType_V1] AS TABLE (

RuleTypeMasterID int,
RuleTypeName  NVARCHAR (256)   NULL,
Comments NVARCHAR (256)   NULL,

RuleTypeDetailID int,
FileName  NVARCHAR (256)   NULL,
DBFileName  NVARCHAR (256)   NULL,
Content  NVARCHAR (MAX)   NULL,
IsBalanceAware bit,
[Type]  NVARCHAR (256)   NULL

);



