

CREATE PROCEDURE [dbo].[usp_UpdateWireConfirmedForPhantomDeal]
(
	@CREDealID nvarchar(256)
)
  
AS
BEGIN
  SET NOCOUNT ON;  

	IF EXISTS(Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0)
	BEGIN
		Declare @Dealid UNIQUEIDENTIFIER = (Select dealid from cre.Deal where CREDealID = @CREDealID and IsDeleted=0 )
		Declare @PhtmDealid UNIQUEIDENTIFIER = (Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0 )
		
		--Update wire confirmed for phtm problem
		 
		Update CRE.DealFunding set Applied = 1 where DealID = @PhtmDealid and ISNULL(Applied,0) = 0 and LegalDeal_DealFundingID in (Select DealFundingID from cre.dealfunding where dealid = @Dealid and Applied = 1)

			
		Update core.FundingSchedule set Applied = 1
		Where ISNULL(Applied,0) = 0
		and DealFundingID in (Select DealFundingID from cre.dealfunding where dealid = @PhtmDealid and Applied = 1)
		and EventID in (
			Select b.EventID from(
				Select a.CrenoteID,a.EventID,a.EffectiveStartDate,ROW_NUMBER() OVER (PARTITION BY  a.crenoteid  ORDER BY a.crenoteid,a.EffectiveStartDate desc) AS SNO
				from(
					Select  Distinct e.EffectiveStartDate,E.eventid,n.crenoteid
					from [CORE].FundingSchedule fs
					INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
					where ISNULL(e.StatusID,1)= 1 
					and n.Dealid = @PhtmDealid
				)a
			)b where b.Sno = 1
		)

	END

END
