CREATE PROCEDURE [dbo].[usp_InsertWellsDataTap] --'B0E6697B-3534-4C09-BE0A-04473401AB93'
(  
	@CreatedBy  nvarchar(256)   
) 
AS  
BEGIN  
    SET NOCOUNT ON; 
 
	TRUNCATE TABLE  [DW].[WellsDataTap]
	
	INSERT INTO dw.wellsdatatap(
	NoteID
	,TransactionDate
	,Current_Interest_Paid_To_Date
	,Current_All_In_Interest_Rate
	,Balance_After_Funding_Transacton
	,Entry_No
	,Transaction_Type
	,CreatedBy
	,CreatedDate
	,UpdatedBy
	,UpdatedDate)

	Select Distinct
	INVESTOR_LOANNUMBER as NoteID
	,FIRST_PAYMENT_DATE as TransactionDate
	,null as Current_Interest_Paid_To_Date
	,null as Current_All_In_Interest_Rate
	,CURRENT_BALANCE as Balance_After_Funding_Transacton
	,1 as Entry_No
	,null as Transaction_Type
	,@CreatedBy
	,GETDATE()  
	,@CreatedBy
	,GETDATE()  
	From [DW].[WellsTrialBalanceDataTap]




	--INSERT INTO [CRE].[WellsDataTap]
 --          ([NoteID]
 --          ,[Balance_After_Funding_Transacton]
 --          ,[CreatedBy]
 --          ,[CreatedDate]
 --          ,[UpdatedBy]
 --          ,[UpdatedDate])
 --    SELECT 
 --           NoteID
 --          ,Balance_After_Funding_Transacton
 --          ,@CreatedBy
 --          ,GETDATE()  
 --          ,@CreatedBy
 --          ,GETDATE()  
	--	   FROM @TableTypeWellsDataTap
END
