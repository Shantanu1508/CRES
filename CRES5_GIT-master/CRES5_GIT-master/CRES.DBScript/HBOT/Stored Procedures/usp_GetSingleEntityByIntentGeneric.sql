--Select InitialFundingAmount,* from cre.Note where crenoteid = '3846'
--Select AMUSERID,* from cre.Deal
--[HBOT].[usp_GetSingleEntityByIntentGeneric]  'Deal','Name','The Post','AssetManager'
--[HBOT].[usp_GetSingleEntityByIntentGeneric]  'Note','Id','3846','ClosingDate'
--[HBOT].[usp_GetSingleEntityByIntentGeneric]  'Note','Id','3846','Initial FundingAmount'
--[HBOT].[usp_GetSingleEntityByIntentGeneric]  'Note','Id','3846','Financing Source'
--[HBOT].[usp_GetSingleEntityByIntentGeneric]  'Deal','Name','The Post','Status'

--[HBOT].[usp_GetSingleEntityByIntentGeneric]  'Note','Id','2144','TotalCommitment'
--[HBOT].[usp_GetSingleEntityByIntentGeneric]  'Deal','name','Mission Hills Apartments','TotalCommitment'


CREATE PROCEDURE [HBOT].[usp_GetSingleEntityByIntentGeneric]  
@ObjectType  nvarchar(256),
@ObjectNature  nvarchar(256),
@ObjectValue  nvarchar(256),
@Intent  nvarchar(256)  

AS  
BEGIN  
    SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	
Declare @query nvarchar(max);

Declare @DBColumn nvarchar(max);	
Declare @TableName	nvarchar(max);
Declare @IsLookup	bit;
Declare @Lookup_TableName	nvarchar(max);
Declare @Lookup_KeyColumn	nvarchar(max);
Declare @Lookup_ValueColumn nvarchar(max);

Select  
@DBColumn= DBColumn,
@TableName= TableName,
@IsLookup= IsLookup,
@Lookup_TableName= Lookup_TableName,
@Lookup_KeyColumn= Lookup_KeyColumn,
@Lookup_ValueColumn= Lookup_ValueColumn
from HBOT.IntentColumnMapping 
Where intent = @Intent and objectType = @ObjectType
--===========================================

IF(@ObjectType = 'Deal')
BEGIN

	IF(@IsLookup = 0)
	BEGIN
		SET @query = N'	Select '+@DBColumn+' as SingleResult From '+@TableName+' d
		where IIF('''+@ObjectNature+''' = ''name'',d.dealname,d.credealid) =  '''+@ObjectValue+''' '
	END
	ELSE
	BEGIN
		SET @query = N'	Select '+@Lookup_ValueColumn+' as SingleResult From '+@TableName+' d
		left Join '+@Lookup_TableName+' l on l.'+@Lookup_KeyColumn+' = d.'+@DBColumn+'
		where IIF('''+@ObjectNature+''' = ''name'',d.dealname,d.credealid) =  '''+@ObjectValue+''' '
	END
END

IF(@ObjectType = 'Note')
BEGIN
	IF(@IsLookup = 0)
	BEGIN
		SET @query = N'	Select '+@DBColumn+' as SingleResult
		From '+@TableName+' d
		inner join core.account acc on acc.accountid = d.Account_Accountid
		where IIF('''+@ObjectNature+''' = ''name'',acc.Name,d.CreNoteId) =  '''+@ObjectValue+''' '
	END
	ELSE
	BEGIN
		SET @query = N'	Select '+@Lookup_ValueColumn+' as SingleResult
		From '+@TableName+' d
		inner join core.account acc on acc.accountid = d.Account_Accountid
		left Join '+@Lookup_TableName+' l on l.'+@Lookup_KeyColumn+' = d.'+@DBColumn+'
		where IIF('''+@ObjectNature+''' = ''name'',acc.Name,d.CreNoteId) =  '''+@ObjectValue+''' '
	END
END




Print(@query)
EXEC(@query)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
