CREATE PROCEDURE [dbo].[usp_UpdateBatchDetailWhenCancel] 
  @AnalysisID uniqueidentifier
AS BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    declare @tBatchCalculationMasterID as table(
		BatchCalculationMasterID int
	)
	INSERT INTO @tBatchCalculationMasterID(BatchCalculationMasterID)
	select BatchCalculationMasterID
	from Core.BatchCalculationMaster
	where AnalysisID=@AnalysisID and EndTime is null

    Update Core.BatchCalculationDetail
    SET StatusID=736, EndTime=getdate(), ErrorMessage=null
    where EndTime is null and BatchCalculationMasterID in(Select BatchCalculationMasterID from @tBatchCalculationMasterID)
 
	
    update [Core].[BatchCalculationMaster]
    set EndTime=getdate(),
	Status='Completed',
	TotalCanceled = z.cnt
	From(
		Select m.BatchCalculationMasterID,count(d.BatchCalculationMasterID) cnt
		from [Core].[BatchCalculationMaster] m
		Inner join Core.BatchCalculationDetail d on m.BatchCalculationMasterID =d.BatchCalculationMasterID
		where d.StatusID=736 and m.BatchCalculationMasterID in (Select BatchCalculationMasterID from @tBatchCalculationMasterID)
		Group by m.BatchCalculationMasterID
	)z
	Where [Core].[BatchCalculationMaster].BatchCalculationMasterID = z.BatchCalculationMasterID

 
 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END