
CREATE PROCEDURE [dbo].[usp_InsertWLDealLegalStatus]
(
	@tbltype_WLDealLegalStatus [dbo].[tbltype_WLDealLegalStatus] READONLY 
	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	

Delete From	[CRE].[WLDealLegalStatus] where DealID in (
	SELECT d.dealid FROM @tbltype_WLDealLegalStatus  wl 
	Inner Join cre.deal d on d.credealid = wl.Credealid
	Where d.isdeleted <> 1 
)


---Insert Values
INSERT into [CRE].[WLDealLegalStatus] ([DealID],[StartDate],[Type],[Comment],ReasonCode,CreatedBy,CreatedDate,[UpdatedBy],[UpdatedDate])
SELECT d.dealid ,wl.[StartDate],wl.[Type],wl.[Comment],ReasonCode,wl.[UserID],GETDATE() ,wl.UserID,GETDATE()
FROM @tbltype_WLDealLegalStatus  wl 
Inner Join cre.deal d on d.credealid = wl.Credealid
Where d.isdeleted <> 1 


--Update WatchlistStatus in deal table
Update cre.deal set cre.deal.WatchlistStatus = a.[type]
From (
	Select dealid,[StartDate],[type]
	From(
		SELECT wl.dealid,wl.[StartDate],wl.[Type],
		ROW_NUMBER() Over (Partition By wl.dealid Order by wl.dealid,wl.[StartDate] desc) rno
		FROM [CRE].[WLDealLegalStatus]  wl 
		Inner Join cre.deal d on d.dealid = wl.dealid
		Where d.isdeleted <> 1 
	)z
	Where rno = 1

)a
Where cre.deal.dealid = a.dealid




--declare @DealID varchar(256),@CreatedBy varchar(256)

--SET @DealID = (select top 1 DealID from @tbltype_WLDealLegalStatus)
--SET  @CreatedBy =(select top 1 UserID from @tbltype_WLDealLegalStatus)

--exec dbo.usp_InsertActivityLog @DealID,283,@DealID,833,'Updated',@CreatedBy	

	 

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
