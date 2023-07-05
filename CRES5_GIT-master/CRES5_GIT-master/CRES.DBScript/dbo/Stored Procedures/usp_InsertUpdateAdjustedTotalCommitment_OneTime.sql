


-- Procedure
-- select * from cre.note where noteid='4f22f3b1-c4e0-4e3b-8bfd-fbf897227382'
CREATE PROCEDURE [dbo].[usp_InsertUpdateAdjustedTotalCommitment_OneTime]

@TableAdjustedTotalCommitment [TableAdjustedTotalCommitment] READONLY,
@UserID uniqueidentifier


AS	
BEGIN		
SET NOCOUNT ON;	
DECLARE  @rownumberOuter int;
DECLARE  @tAdjustementtotalcommitment TABLE (tMasterID int);
DECLARE  @insertedMasterID int;

Declare @DealID uniqueidentifier = (SELECT Top 1 DealID FROM @TableAdjustedTotalCommitment)

--------============Delete table NoteAdjustedCommitmentMaster==============------
 DELETE  FROM CRE.NoteAdjustedCommitmentDetail WHERE DealID = @DealID 
 DELETE FROM CRE.NoteAdjustedCommitmentMaster WHERE DealID = @DealID 


 INSERT INTO CRE.NoteAdjustedCommitmentMaster 
	(
		DealID
		,[Date]
		,[Type]
		,Comments	
		,DealAdjustmentHistory	
		,AdjustedCommitment	
		,TotalCommitment	
		,AggregatedCommitment	
		,CreatedBy	
		,CreatedDate	
		,UpdatedBy	
		,UpdatedDate
		,TotalRequiredEquity
		,TotalAdditionalEquity
	)
	SELECT Distinct DealID
	,[Date]
	,[Type]
	,Comments	
	,DealAdjustmentHistory	
	,AdjustedCommitment	
	,TotalCommitment	
	,AggregatedCommitment	
	,CAST(@UserID as nvarchar(256))
	,getdate()	
	,CAST(@UserID as nvarchar(256))
	,getdate()
	,TotalRequiredEquity
	,TotalAdditionalEquity
	FROM @TableAdjustedTotalCommitment ttc
	

	INSERT INTO CRE.NoteAdjustedCommitmentDetail
		(
			NoteAdjustedCommitmentMasterID,
			NoteID,
			[Value],
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			[Type],
			DealID,
			NoteAdjustedTotalCommitment,
            NoteAggregatedTotalCommitment,
            NoteTotalCommitment
		)
	SELECT
			(Select nc.NoteAdjustedCommitmentMasterID from CRE.NoteAdjustedCommitmentMaster nc where nc.dealid = @DealID and nc.[type] = ttc.Type and nc.date = ttc.date  )insertedMasterID,
			NoteID,
			[Amount],
			CAST(@UserID as nvarchar(256)),
			getdate(),
			CAST(@UserID as nvarchar(256)),
			getdate(),
		    [Type],
			DealID,
			NoteAdjustedTotalCommitment,
            NoteAggregatedTotalCommitment,
            NoteTotalCommitment
	FROM @TableAdjustedTotalCommitment ttc
	

	IF(@DealID = '825DBB7C-EA47-41FF-9E9D-57DDA4AF65CD')
	BEGIN
		Update CRE.NoteAdjustedCommitmentMaster set [Date] = '03/10/2020' where dealid = '825DBB7C-EA47-41FF-9E9D-57DDA4AF65CD' and [Date] = '2020-03-11' --and [Type] = 649
	END

	IF(@DealID = '8714EEA0-D6C8-45E6-A3C7-1CF13BF5FBA5')
	BEGIN
		Update CRE.NoteAdjustedCommitmentMaster set [Date] = '02/24/2020' where dealid = '8714EEA0-D6C8-45E6-A3C7-1CF13BF5FBA5' and [Date] = '02/25/2020' --and [Type] = 649
	END

END
