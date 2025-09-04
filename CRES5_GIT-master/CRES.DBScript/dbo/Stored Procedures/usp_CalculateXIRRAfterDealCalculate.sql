-- Procedure

---[dbo].[usp_CalculateXIRRAfterDealCalculate]  'B0E6697B-3534-4C09-BE0A-04473401AB93'

CREATE PROCEDURE [dbo].[usp_CalculateXIRRAfterDealCalculate]
	@UserId nvarchar(256)
AS  
BEGIN   


---Queue xirr to processing after deal calculation is completed
IF EXISTS(Select Distinct dealaccountid From [CRE].[XIRRCalculationRequests] where [status] = 882)
BEGIN

Declare @tbldeal as Table(
credealid nvarchar(256),
DealAccountID UNIQUEIDENTIFIER,
DealID UNIQUEIDENTIFIER,
[Status] nvarchar(256)
)

INSERT INTO @tbldeal(credealid,DealAccountID,DealID,[Status])
Select credealid,DealAccountID,DealID,
(CASE WHEN (Processing = 0 and Running = 0 and CalcWait = 0) Then 'Completed'	
WHEN Running > 0 Then 'Running'
WHEN CalcWait > 0 Then 'CalcWait'	
else 'Processing' end
) as [Status]
FROM   
(   
	SELECT credealid,DealAccountID,DealID,[TotalCount]
	,ISNULL(Failed,0)	as Failed
	,ISNULL(Completed,0)	as Completed
	,ISNULL(Running,0)	as Running
	,ISNULL(Processing,0) as Processing
	,ISNULL(CalcWait,0) as CalcWait
	FROM   
	(    
		Select a.credealid,a.DealAccountID,a.DealID,a.[Status],a.[count]
		from(
			select dd.credealid, dd.Accountid as DealAccountID,cr.DealID,'TotalCount' as [Status],count(cr.[StatusID]) [count] 
			from [CORE].[CalculationRequests] cr
			Inner join cre.deal dd on dd.dealid = cr.dealid
			Where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			and cr.dealid in (Select Distinct d.dealid From [CRE].[XIRRCalculationRequests] xr Inner join cre.deal d on d.Accountid = xr.dealAccountid	where xr.status = 882)
			group by cr.DealID,dd.Accountid,dd.credealid

			UNION ALL

			select dd.credealid,dd.Accountid as DealAccountID,cr.DealID,l.name as [Status],count(cr.[StatusID]) [count] 
			from [CORE].[CalculationRequests] cr
			Inner join cre.deal dd on dd.dealid = cr.dealid
			Left Join core.lookup l on l.lookupid = cr.[StatusID]
			Where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			and cr.dealid in (Select Distinct d.dealid From [CRE].[XIRRCalculationRequests] xr Inner join cre.deal d on d.Accountid = xr.dealAccountid	where xr.status = 882)
			group by cr.DealID,l.name,dd.Accountid,dd.credealid
		)a	
	) t 
	PIVOT(
		SUM([count]) 
		FOR [Status] IN ([TotalCount],Failed,Completed,Running,Processing,CalcWait)
	) AS pivot_table

)z




Select credealid from @tbldeal where [Status] = 'Completed'




--Declare @DealAccountID UNIQUEIDENTIFIER
 
--IF CURSOR_STATUS('global','CursorDeal')>=-1
--BEGIN
--	DEALLOCATE CursorDeal
--END

--DECLARE CursorDeal CURSOR 
--for
--(
--	Select DealAccountID from @tbldeal where [Status] = 'Completed'
--)


--OPEN CursorDeal 

--FETCH NEXT FROM CursorDeal
--INTO @DealAccountID

--WHILE @@FETCH_STATUS = 0
--BEGIN

--	EXEC [dbo].[usp_CalculateXIRRAfterDealSave]	@DealAccountid,@UserId,292
					 
--FETCH NEXT FROM CursorDeal
--INTO @DealAccountID
--END
--CLOSE CursorDeal   
--DEALLOCATE CursorDeal


END
	--

END