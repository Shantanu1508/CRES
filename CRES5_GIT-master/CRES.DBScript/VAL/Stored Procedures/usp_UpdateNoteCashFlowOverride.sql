
CREATE PROCEDURE [VAL].[usp_UpdateNoteCashFlowOverride] 
	@tbltype_NoteCashflow [val].[tbltype_NoteCashflowOverride] READONLY
	
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_NoteCashflow))

	Declare @UserID	nvarchar(256)
	SET @UserID = (Select top 1 UserID from @tbltype_NoteCashflow)




	Update [VAL].[NoteCashFlow] set ValueOverride = a.ValueOverride,
	Updatedby = @UserID,
	UpdatedDate = getdate()
	From(
		Select 
		NoteCashFlowID
		,@MarkedDateMasterID as MarkedDateMasterID
		,ValueOverride
		,UserID
		From @tbltype_NoteCashflow
	)a
	where [VAL].[NoteCashFlow].NoteCashFlowID = a.NoteCashFlowID
	and [VAL].[NoteCashFlow].MarkedDateMasterID = a.MarkedDateMasterID

	


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  



