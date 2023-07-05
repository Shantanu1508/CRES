


CREATE PROCEDURE [dbo].[usp_InsertUpdateFinancingWarehouseDetails] 
(
	@FinancingWarehouseDetailID uniqueidentifier
      ,@FinancingWarehouseID uniqueidentifier
      ,@StartDate datetime
      ,@EndDate datetime
      ,@Value decimal(28, 15)
      ,@CreatedBy nvarchar(256)
      ,@CreatedDate datetime
      ,@UpdatedBy nvarchar(256)
      ,@UpdatedDate datetime
)
as
BEGIN
if(@FinancingWarehouseDetailID!='00000000-0000-0000-0000-000000000000')
BEGIN
 UPDATE [CRE].[FinancingWarehouseDetail]
 SET
 StartDate=@startDate,
 EndDate=@EndDate,
 Value=@Value,
 UpdatedBy=@UpdatedBy,
 UpdatedDate=GETDATE()
 where FinancingWarehouseDetailID=@FinancingWarehouseDetailID
END
ELSE
BEGIN
INSERT INTO [CRE].[FinancingWarehouseDetail]
           ([FinancingWarehouse_FinancingWarehouseID]
           ,[StartDate]
           ,[EndDate]
           ,[Value]
           ,[CreatedBy]
           ,[CreatedDate]
	, [updatedby]
		   ,[UpdatedDate])
     VALUES
           (
		   @FinancingWarehouseID
		   ,@StartDate
		   ,@EndDate 
		   ,@Value
		   ,@CreatedBy
		   ,GETDATE()
		,@UpdatedBy
		   ,GETDATE()
		   )

END

END
