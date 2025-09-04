CREATE Procedure [dbo].[usp_GetFinancingWarehouseDetailById] --'629A3892-863B-4313-8CCC-70205B36B9F6'  
(  
@FinancingWarehouseID Varchar(256)  
)  
as   
BEGIN  
  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SELECT FinancingWarehouseDetailID
      ,FinancingWarehouse_FinancingWarehouseID
      ,StartDate  
      ,EndDate  
      ,Value  
      ,CreatedBy  
      ,CreatedDate  
      ,UpdatedBy  
      ,UpdatedDate  
  FROM CRE.FinancingWarehouseDetail where FinancingWarehouse_FinancingWarehouseID=@FinancingWarehouseID  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  END
GO

