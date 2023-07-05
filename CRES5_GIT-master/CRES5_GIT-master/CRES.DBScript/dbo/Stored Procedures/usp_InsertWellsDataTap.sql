CREATE PROCEDURE [dbo].[usp_InsertWellsDataTap]
(   
 @TableTypeWellsDataTap [TableTypeWellsDataTap] READONLY,
 @CreatedBy  nvarchar(256)   
 ) 
AS  
BEGIN  
    SET NOCOUNT ON; 
 
	TRUNCATE TABLE  [CRE].[WellsDataTap]
	
	INSERT INTO [CRE].[WellsDataTap]
           ([NoteID]
           ,[Balance_After_Funding_Transacton]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     SELECT 
            NoteID
           ,Balance_After_Funding_Transacton
           ,@CreatedBy
           ,GETDATE()  
           ,@CreatedBy
           ,GETDATE()  
		   FROM @TableTypeWellsDataTap
END
