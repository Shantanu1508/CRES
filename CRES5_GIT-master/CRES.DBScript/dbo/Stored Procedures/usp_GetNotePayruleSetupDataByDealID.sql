-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[dbo].[usp_GetNotePayruleSetupDataByDealID] 'c99d7700-7de3-4ac9-819f-9fcd2aa1a700'
CREATE PROCEDURE [dbo].[usp_GetNotePayruleSetupDataByDealID] 
	-- Add the parameters for the stored procedure here
	@DealID as uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @ColPivot AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX);
Declare @InActive as nvarchar(256);
Declare @Active as nvarchar(256)


--,@DealID as nvarchar(MAX)='E30641FC-7268-40A6-A20E-EADA21DD92C9'
set @InActive=(select LookupID from core.lookup where name ='InActive' and ParentID=1);
set @Active=(select LookupID from core.lookup where name ='Active' and ParentID=1);

SET @ColPivot = STUFF((SELECT distinct ',' + QUOTENAME(cast(n.CreNoteID as nvarchar(256)))
					from [CRE].[Note] n inner join Core.Account a on a.AccountID=n.Account_AccountID
where n.DealID =@DealID and isnull(a.StatusID,@Active)!=@InActive and a.IsDeleted=0
order by ',' +QUOTENAME(cast(n.CreNoteID  as nvarchar(256)))

            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
  
set @query = ' 
SELECT  FromNote,RuleText,RuleID, ' + @ColPivot + ',Total from 
( 				
	Select SNO,FromNote,col,RuleID,RuleText,Value,SUM(a.Value) OVER (PARTITION BY  SNO ,FromNote,RuleID ORDER BY SNO) AS Total
	from (
		Select
		ROW_NUMBER() OVER (PARTITION BY   nFrom.CRENoteID,nTo.CRENoteID,ps.RuleID  ORDER BY nFrom.CRENoteID,nTo.CRENoteID,ps.RuleID) AS SNO
		, nFrom.CRENoteID FromNote
		,nTo.CRENoteID col
		,ps.RuleID RuleID
		,lRuleID.FeeTypeNameText +'' Strip'' RuleText
		,isnull(ps.Value,0) Value
		--,sum(total.Value) Total
		from  [CRE].[PayruleSetup] ps 
		INNER JOIN [CRE].[Note] nFrom ON ps.StripTransferFrom=nFrom.NoteID
		inner join Core.Account aFrom on aFrom.AccountID=nFrom.Account_AccountID
		left JOIN [CRE].[Note] nTo ON ps.StripTransferTo=nTo.NoteID
		inner join Core.Account aTo on aTo.AccountID=nTo.Account_AccountID
		LEFT JOIN [CRE].[FeeSchedulesConfig] lRuleID ON lRuleID.FeeTypeNameID = ps.[RuleID]

					
		--left join  [CRE].[PayruleSetup] total on  ps.StripTransferFrom= total.StripTransferFrom and ps.[RuleID]=total.[RuleID]

		where isnull(aFrom.StatusID,'''+convert(varchar(MAX), @Active)+''') !='''+convert(varchar(MAX), @InActive)+''' 
		and aTo.IsDeleted=0 and isnull(aTo.StatusID,'''+convert(varchar(MAX), @Active)+''')  != '''+convert(varchar(MAX), @InActive)+''' and ps.DealID = '''+convert(varchar(MAX),@DealID)+''' 
		group by  
		nFrom.CRENoteID 
		,nTo.CRENoteID 
		,ps.RuleID 
		,lRuleID.FeeTypeNameText 
		,ps.Value

		union 
		select 0 as SNO
		,null FromNote
		,null col
		,null RuleID
		,null RuleText
		,0 Value 
		--,0 as Total 
		WHERE NOT EXISTS (SELECT * from  [CRE].[PayruleSetup] where DealID = '''+convert(varchar(MAX),@DealID)+''')
	)a
) x 
pivot 
(
    sum(Value)
    for col in (' + @ColPivot + ')
            
) p  order by FromNote'


print(@query);
exec(@query);
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END



