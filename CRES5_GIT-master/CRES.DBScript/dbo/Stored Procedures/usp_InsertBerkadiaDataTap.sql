-- Procedure
CREATE PROCEDURE [dbo].[usp_InsertBerkadiaDataTap]
(   
 @TableTypeBerkadiaDataTap [TableTypeBerkadiaDataTap] READONLY,
 @CreatedBy  nvarchar(256)   
 ) 
AS  
BEGIN  
    SET NOCOUNT ON; 
 
 TRUNCATE TABLE  [DW].[BerkadiaDataTap]

 INSERT INTO [DW].[BerkadiaDataTap]
           ([DealID]
           ,[NoteID]
           ,[Principal_Balance]
		   ,[Interest_Rate]
		   ,[Next_Pmt_Due_Dt]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     SELECT 
            DealID
           ,NoteID
           ,Principal_Balance
		   ,Interest_Rate
		   ,Next_Pmt_Due_Dt
           ,@CreatedBy
           ,GETDATE()  
           ,@CreatedBy
           ,GETDATE()  
		   FROM @TableTypeBerkadiaDataTap
END
