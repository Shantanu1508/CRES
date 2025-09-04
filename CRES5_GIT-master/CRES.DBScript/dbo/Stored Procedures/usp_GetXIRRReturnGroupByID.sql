-- Procedure
CREATE PROCEDURE [dbo].[usp_GetXIRRReturnGroupByID]
(
	@XIRRReturnGroupID int,
	@UserID nvarchar(256)
)
AS
BEGIN

SELECT [XIRRReturnGroupID]
      ,[XIRRConfigID]
      ,[Type]
      ,[ReturnName]
      ,[ChildReturnName]
      ,[Group1]
      ,[Group2]
      ,[AnalysisID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[LoanStatus]
      ,[FileName_Input]
  FROM [CRE].[XIRRReturnGroup]

   WHERE [XIRRReturnGroupID]=@XIRRReturnGroupID


END
