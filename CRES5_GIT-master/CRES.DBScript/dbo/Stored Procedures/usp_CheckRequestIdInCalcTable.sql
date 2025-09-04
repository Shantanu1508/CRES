CREATE PROCEDURE [dbo].[usp_CheckRequestIdInCalcTable]
	@RequestID nvarchar(500)
	
AS
BEGIN
   declare @tableName nvarchar(256)
   If EXISTS (select 1 from core.CalculationRequests where RequestID=@RequestID)
   BEGIN
		set @tableName='CalculationRequests'
   END
   ELSE If EXISTS (select 1 from core.[CalculationRequestsLiability] where RequestID=@RequestID)
   BEGIN
		set @tableName='CalculationRequestsLiability'
   END
   select @tableName as  TableName
END