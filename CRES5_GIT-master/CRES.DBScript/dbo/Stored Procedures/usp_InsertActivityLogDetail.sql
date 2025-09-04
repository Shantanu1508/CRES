CREATE PROCEDURE [dbo].[usp_InsertActivityLogDetail]      
(  
  @tblActivityLogDetail [TableTypeActivityLogDetail] READONLY
)       
AS      
BEGIN      
		INSERT INTO [App].[ActivityLogDetail]
		(
		ParentModuleName,  
	    ChildModuleName,
        ModuleID,		  
	    FieldName,       
	    FieldValue,      
	    Comment,         
	    CreatedBy,
		CreatedDate
		)  
		SELECT  
		ParentModuleName,  
	    ChildModuleName,
        ModuleID,		  
	    FieldName,       
	    FieldValue,      
	    Comment,         
	    CreatedBy,
		GETDATE()
		FROM
		@tblActivityLogDetail

	END 
GO

