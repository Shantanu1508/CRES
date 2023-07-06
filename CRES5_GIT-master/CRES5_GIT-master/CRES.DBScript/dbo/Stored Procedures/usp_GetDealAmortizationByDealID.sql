

CREATE PROCEDURE [dbo].[usp_GetDealAmortizationByDealID]
(
	@DealID UNIQUEIDENTIFIER	
)
  
AS
BEGIN
  SET NOCOUNT ON;  

	
	IF EXISTS(SELECT [DealAmortizationScheduleID] FROM [CRE].[DealAmortizationSchedule] Where DealID = @DealID)
	BEGIN
		SELECT [DealAmortizationScheduleID]
		,[DealID]
		,[Date]
		,[Amount]
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate]
		FROM [CRE].[DealAmortizationSchedule]
		Where DealID = @DealID
	END
	ELSE
	BEGIN
		SELECT null as [DealAmortizationScheduleID]
		,@DealID as [DealID]
		,null as [Date]
		,null as [Amount]
		,null as [CreatedBy]
		,null as [CreatedDate]
		,null as [UpdatedBy]
		,null as [UpdatedDate]
	END



END



