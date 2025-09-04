
CREATE PROCEDURE [dbo].[usp_InsertUpdatedWLDealAccounting]
(
	@tbltype_WLDealAccounting [dbo].[tbltype_WLDealAccounting] READONLY 
	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	

Delete From	[CRE].[WLDealAccounting] where [WLDealAccountingID] in (SELECT [WLDealAccountingID] FROM @tbltype_WLDealAccounting  Where isdeleted = 1)



---Insert Values
INSERT into [CRE].[WLDealAccounting] ([DealID],[StartDate], [EndDate],[TypeID],[Comment],CreatedBy,CreatedDate,[UpdatedBy],[UpdatedDate])
SELECT tmpLegalStatus.[DealID],tmpLegalStatus.[StartDate],tmpLegalStatus.[EndDate],tmpLegalStatus.[TypeID],tmpLegalStatus.[Comment],tmpLegalStatus.UserID,GETDATE() ,tmpLegalStatus.UserID,GETDATE() 
FROM 
(
	SELECT [WLDealAccountingID],[DealID],[StartDate],[EndDate],[TypeID],[Comment],[UserID] FROM @tbltype_WLDealAccounting
	Where isdeleted <> 1
	 
) tmpLegalStatus
left outer join [CRE].[WLDealAccounting] ind on tmpLegalStatus.[WLDealAccountingID]=ind.[WLDealAccountingID] and tmpLegalStatus.[DealID]=ind.[DealID] 
where ind.[WLDealAccountingID] is null 




---Update Values

UPDATE [CRE].[WLDealAccounting]
Set 
[CRE].[WLDealAccounting].[DealID] = tmpLegalStatus.[DealID],
[CRE].[WLDealAccounting].[StartDate] = tmpLegalStatus.[StartDate],
[CRE].[WLDealAccounting].[EndDate] = tmpLegalStatus.[EndDate],
[CRE].[WLDealAccounting].[TypeID]= tmpLegalStatus.[TypeID],
[CRE].[WLDealAccounting].[Comment]= tmpLegalStatus.[Comment],
[CRE].[WLDealAccounting].UpdatedBy =tmpLegalStatus.[UserID],
[CRE].[WLDealAccounting].UpdatedDate =getdate()
FROM (
	SELECT [WLDealAccountingID],[DealID],[StartDate],[EndDate],[TypeID],[Comment],[UserID] FROM @tbltype_WLDealAccounting 
	Where isdeleted <> 1

) tmpLegalStatus
inner join [CRE].[WLDealAccounting] ind on tmpLegalStatus.[WLDealAccountingID]=ind.[WLDealAccountingID] and tmpLegalStatus.[DealID]=ind.[DealID] 



	 

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
