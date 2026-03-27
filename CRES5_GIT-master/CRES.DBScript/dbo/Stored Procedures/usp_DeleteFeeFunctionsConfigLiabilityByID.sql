--[dbo].[usp_DeleteModuleByID] 'b0e6697b-3534-4c09-be0a-04473401ab93',"Deal",'f4c26166-9808-480c-ba65-a259331e796b',0
CREATE PROCEDURE [dbo].[usp_DeleteFeeFunctionsConfigLiabilityByID] --'1479'
(
	@UserId Uniqueidentifier,
	@FunctionGuID Uniqueidentifier
)
AS
BEGIN
     DECLARE @FunctionNameID INT
	 SELECT @FunctionNameID = FunctionNameID FROM [CRE].FeeFunctionsConfigLiability where FunctionGuID = @FunctionGuID
	 IF NOT EXISTS(select 1 from [CRE].FeeSchedulesConfigLiability where FeeFunctionID=@FunctionNameID)
	 BEGIN
	    DELETE FROM [CRE].FeeFunctionsConfigLiability where FunctionGuID = @FunctionGuID
	 END
END
