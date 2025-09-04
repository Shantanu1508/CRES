CREATE PROCEDURE [dbo].[usp_GetXIRRConfigByID]
(
	@XIRRConfigID int,
	@UserID nvarchar(256)
)
AS
BEGIN

SELECT [XIRRConfigID]
      ,[XIRRConfigGUID]
      ,[ReturnName]
      ,[Type]
      ,a.AnalysisID
      ,a.Name
      ,xc.[CreatedBy]
      ,xc.[CreatedDate]
      ,xc.[UpdatedBy]
      ,xc.[UpdatedDate]
      ,[Comments]
      ,FileName_Input as [FileNameInput]
      ,FileName_Output as [FileNameOutput]
      ,[RowNumber]
      ,[Group1]
      ,[Group2]
      ,[ReferencingDealLevelReturn]
      ,[UpdateXIRRLinkedDeal]
      ,[ArchivalRequirement]
  FROM [CRE].[XIRRConfig] xc
  LEFT JOIN [CORE].[Analysis] a on a.AnalysisID = xc.AnalysisID
  WHERE [XIRRConfigID] =@XIRRConfigID

END
