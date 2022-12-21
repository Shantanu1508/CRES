
--[dbo].[usp_DeleteModuleByID] 'b0e6697b-3534-4c09-be0a-04473401ab93',"Deal",'f4c26166-9808-480c-ba65-a259331e796b',0
CREATE PROCEDURE [dbo].[usp_DeleteFeeSchedulesConfigByID] --'1479'
(
	@UserId Uniqueidentifier,
	@FeeTypeGuID Uniqueidentifier
)
AS
BEGIN
     DECLARE @FeeTypeNameID INT
	 SELECT @FeeTypeNameID = FeeTypeNameID FROM [CRE].[FeeSchedulesConfig] where FeeTypeGuID = @FeeTypeGuID
	 IF NOT EXISTS(select 1 from [CORE].PrepayAndAdditionalFeeSchedule where ValueTypeID=@FeeTypeNameID)
	 BEGIN
	    DELETE FROM [CRE].[FeeSchedulesConfig] where FeeTypeGuID = @FeeTypeGuID
	 END
END







