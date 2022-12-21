
--[dbo].[usp_UpdateAutoRepayDataFromBackshopProduction_ForPhantom] '81572FF9-442D-4D16-AAF4-05046E3A4151','B0E6697B-3534-4C09-BE0A-04473401AB93',325


CREATE PROCEDURE [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction_ForPhantom]
@DealID UNIQUEIDENTIFIER,
@CreatedBy nvarchar(256),
@DealStatus int	
AS
BEGIN
	SET NOCOUNT ON;


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


exec  ('
	IF EXISTS(select [name] from sys.external_data_sources where name = ''RemoteReference_ImportBSProd'')
		Drop EXTERNAL DATA SOURCE RemoteReference_ImportBSProd 
	IF EXISTS(select [name] from sys.database_scoped_credentials where name = ''Credential_ImportBSProd'')
		Drop DATABASE SCOPED CREDENTIAL Credential_ImportBSProd

	--CREATE DATABASE SCOPED CREDENTIAL
	CREATE DATABASE SCOPED CREDENTIAL Credential_ImportBSProd  WITH IDENTITY = ''ACOREAccounting'',  SECRET = ''cv9ftqVc?BtxbCS''

	--CREATE EXTERNAL DATA SOURCE
	Create EXTERNAL DATA SOURCE RemoteReference_ImportBSProd
	WITH 
	( 
		TYPE=RDBMS, 
		LOCATION=''tcp:z70t9nlx1v.database.secure.windows.net'', 
		DATABASE_NAME=''BackshopProduction'', 
		CREDENTIAL= Credential_ImportBSProd 
	); 
')
--========================================================================

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

	DECLARE @query1 nvarchar(256) = N'Select COUNT(ControlID) from tblControlMaster where ControlID = '''+@CREDealID+''' '  
	DECLARE @DealCount TABLE (Cnt int,ShardName nvarchar(max))
	INSERT INTO @DealCount (Cnt,ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReference_ImportBSProd', @stmt = @query1

	IF ((Select cnt from @DealCount) > 0) --Check if deal exists in backshop database
	BEGIN
			
		DECLARE @query nvarchar(MAX) = N'exec acore.spProjectedPayOffAccounting '''+@CREDealID+''''

		INSERT INTO @tbl_ProjectedPayOffAccounting([ProjectedPayOffHeaderId],[ControlId],[EarliestDate],[LatestDate],OpenDate,[ExpectedDate],[AuditUpdateDate],[AsOfDate],[CumulativeProbability],ShardName)
		EXEC sp_execute_remote @data_source_name  = N'RemoteReference_ImportBSProd', @stmt = @query


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



--Select ControlId,EarliestDate,LatestDate,ExpectedDate,CAST(AuditUpdateDate as date) AuditUpdateDate,AsOfDate,(CumulativeProbability/100) as CumulativeProbability,[Status] 
--from @tbl_ProjectedPayOffAccounting
--WHERE ControlId is not null


IF EXISTS(select [ControlId] from @tbl_ProjectedPayOffAccounting)
BEGIN
	---Update deal level data
	Update cre.deal set
	cre.deal.EnableAutoSpreadRepayments = a.EnableAutoSpreadRepayments,
	cre.deal.AutoUpdateFromUnderwriting = a.AutoUpdateFromUnderwriting,
	cre.deal.RepaymentAutoSpreadMethodID = a.RepaymentAutoSpreadMethodID,
	cre.deal.ExpectedFullRepaymentDate = a.ExpectedFullRepaymentDate,
	cre.deal.PossibleRepaymentdayofthemonth = a.PossibleRepaymentdayofthemonth,
	cre.deal.Repaymentallocationfrequency = a.Repaymentallocationfrequency,
	cre.deal.AutoPrepayEffectiveDate = a.AutoPrepayEffectiveDate,
	cre.deal.EarliestPossibleRepaymentDate = a.EarliestPossibleRepaymentDate,
	cre.deal.LatestPossibleRepaymentDate = a.LatestPossibleRepaymentDate
	From(
		Select Distinct ControlId as credealid,
		1 as EnableAutoSpreadRepayments,
		0 as AutoUpdateFromUnderwriting,
		701 as RepaymentAutoSpreadMethodID, ---CPR
		ExpectedDate as ExpectedFullRepaymentDate, 
		tblDe.DeterminationDateReferenceDayoftheMonth as PossibleRepaymentdayofthemonth,
		1 as Repaymentallocationfrequency,
		CAST(AuditUpdateDate as date) as AutoPrepayEffectiveDate,
		EarliestDate as EarliestPossibleRepaymentDate,
		LatestDate as LatestPossibleRepaymentDate

		From @tbl_ProjectedPayOffAccounting t
		inner join cre.deal d on d.credealid = t.ControlId
		left join(
			Select top 1 d.dealid,n.DeterminationDateReferenceDayoftheMonth from cre.note n
			inner join core.account acc on acc.accountid = n.account_accountid
			inner join cre.deal d on d.dealid = n.dealid
			where acc.isdeleted <> 1
			and n.DeterminationDateReferenceDayoftheMonth is not null
			and d.credealid = @CREDealID
		)tblDe on tblDe.dealid = d.dealid
		where d.credealid = @CREDealID
	)a
	where cre.deal.dealid = @DealID

	---Insert ProjectedPayOffDate data
	declare @TableTypeProjectedPayOffDate TableTypeProjectedPayOffDate

	Delete from @TableTypeProjectedPayOffDate

	insert into @TableTypeProjectedPayOffDate(DealID,ProjectedPayoffAsofDate,CumulativeProbability)
	Select @DealID as dealid,t.AsOfDate,(t.CumulativeProbability/100) as CumulativeProbability
	From @tbl_ProjectedPayOffAccounting t
	inner join cre.deal d on d.credealid = t.ControlId
	where d.credealid = @CREDealID
	
	exec [dbo].[usp_InsertProjectedPayOffDateByDealID] @TableTypeProjectedPayOffDate,@CreatedBy

END


--========================================================================
exec  ('
	IF EXISTS(select [name] from sys.external_data_sources where name = ''RemoteReference_ImportBSProd'')
		Drop EXTERNAL DATA SOURCE RemoteReference_ImportBSProd 
	IF EXISTS(select [name] from sys.database_scoped_credentials where name = ''Credential_ImportBSProd'')
		Drop DATABASE SCOPED CREDENTIAL Credential_ImportBSProd	
')



Print('Underwriting data updated successfully.')




END
GO

