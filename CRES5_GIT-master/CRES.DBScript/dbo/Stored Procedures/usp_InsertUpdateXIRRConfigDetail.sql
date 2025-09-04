 
CREATE PROCEDURE [dbo].[usp_InsertUpdateXIRRConfigDetail] 
	@tblTypeXIRRConfigDetail [tblTypeXIRRConfigDetail] READONLY,
	@tbltypXIRRConfigFilters [TableTypeXIRRConfigFilters] READONLY,
	@UserID nvarchar(256)	
AS  
BEGIN    

SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	DELETE FROM CRE.XIRRConfigDetail WHERE XIRRConfigID IN (SELECT XIRRConfigID FROM @tblTypeXIRRConfigDetail WHERE XIRRConfigID <> 0)
	DELETE FROM CRE.XIRRConfigFilter WHERE XIRRConfigID IN (SELECT XIRRConfigID FROM @tbltypXIRRConfigFilters WHERE XIRRConfigID <> 0)


	INSERT INTO [CRE].[XIRRConfigDetail] (XIRRConfigID,ObjectType,ObjectID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
	SELECT XIRRConfigID ,t.ObjectType,t.ObjectID,@UserID,getdate(),@UserID,getdate()
	FROM @tblTypeXIRRConfigDetail t 


	INSERT INTO [CRE].[XIRRConfigFilter] (XIRRConfigID,XIRRFilterSetupID,FilterDropDownValue,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
	SELECT t.XIRRConfigID,t.XIRRFilterSetupID,t.FilterDropDownValue,@UserID,getdate(),@UserID,getdate()
	FROM @tbltypXIRRConfigFilters t 



END