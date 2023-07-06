--[dbo].[usp_GetProjectedPayOffFromBackshopByDealID] 'D359D002-25D0-4284-B02A-01ED32C9247E','B0E6697B-3534-4C09-BE0A-04473401AB93',325
CREATE PROCEDURE [dbo].[usp_GetProjectedPayOffFromBackshopByDealID]
(
	@DealID UNIQUEIDENTIFIER,
	@UserID nvarchar(256),
	@DealStatus int	
)
AS
BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
Declare @CREDealID nvarchar(256);


IF(@DealStatus = 325) --Phantom deal
BEGIN
	Declare @LinkedDealID nvarchar(256)
	SET @LinkedDealID = (Select NULLIF(LinkedDealID,'') from cre.deal where DealID = @DealID);

	IF(@LinkedDealID is null)
	BEGIN
		--Logic
		SET @CREDealID = (Select SUBSTRING(CREDealID,0,8) from cre.deal where DealID = @DealID);
	END
	ELSE
	BEGIN
		SET @CREDealID = @LinkedDealID
	END
	
END
ELSE
BEGIN
	SET @CREDealID = (Select CREDealID from cre.deal where DealID = @DealID);
END



Declare @tbl_ProjectedPayOffAccounting as Table(
ProjectedPayOffHeaderId int null,
ControlId	nvarchar(256) null,
EarliestDate	Date null,
LatestDate		Date null,
OpenDate		Date null,
ExpectedDate	Date null,	
AuditUpdateDate	DateTime null,	
AsOfDate Date null,
CumulativeProbability decimal(28,15) null,
[Status] nvarchar(256) null,
ShardName nvarchar(256) null
)

--IF EXISTS(Select AutoUpdateFromUnderwriting from cre.deal where dealid = @DealID and AutoUpdateFromUnderwriting = 1)
--BEGIN

	DECLARE @query1 nvarchar(256) = N'Select COUNT(ControlID) from tblControlMaster where ControlID = '''+@CREDealID+''' '  
	DECLARE @DealCount TABLE (Cnt int,ShardName nvarchar(max))
	INSERT INTO @DealCount (Cnt,ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @query1

	IF ((Select cnt from @DealCount) > 0) --Check if deal exists in backshop database
	BEGIN
		--DECLARE @query nvarchar(MAX) = N'Select m.ProjectedPayOffHeaderId,m.ControlId_F,m.EarliestDate,m.LatestDate,m.ExpectedDate ,m.AuditUpdateDate,d.Date,d.Amount
		--from acore.tblProjectedPayoffHeader m
		--left join acore.tblProjectedPayoffDetail d on m.ProjectedPayoffHeaderId = d.ProjectedPayoffHeaderId_F
		--where m.ControlId_F = '''+@CREDealID+'''
		--order by d.date'		
		DECLARE @query nvarchar(MAX) = N'exec acore.spProjectedPayOffAccounting '''+@CREDealID+''''

		INSERT INTO @tbl_ProjectedPayOffAccounting([ProjectedPayOffHeaderId],[ControlId],[EarliestDate],[LatestDate],OpenDate,[ExpectedDate],[AuditUpdateDate],[AsOfDate],[CumulativeProbability],ShardName)
		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @query


		IF EXISTS(select [ControlId] from @tbl_ProjectedPayOffAccounting)
		BEGIN
			Update @tbl_ProjectedPayOffAccounting Set [Status] = 'Success'
		END
		ELSE
		BEGIN
			INSERT INTO @tbl_ProjectedPayOffAccounting([Status])VALUES('Data not exists in Backshop for this deal')
		END	
	END
	ELSE
	BEGIN
		INSERT INTO @tbl_ProjectedPayOffAccounting([Status])VALUES('Deal does not exists in Backshop')
	END
--END
--ELSE
--BEGIN
	--INSERT INTO @tbl_ProjectedPayOffAccounting([Status])VALUES('Flag Auto update from underwriting is disable')
--END


Select ControlId,EarliestDate,LatestDate,ExpectedDate,CAST(AuditUpdateDate as date) AuditUpdateDate,AsOfDate,(ISNULL(CumulativeProbability,0)/100) as CumulativeProbability,[Status] 
from @tbl_ProjectedPayOffAccounting
WHERE ControlId is not null



SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

