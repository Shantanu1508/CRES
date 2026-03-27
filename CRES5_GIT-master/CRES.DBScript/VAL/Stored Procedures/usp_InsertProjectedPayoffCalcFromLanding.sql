CREATE PROCEDURE [VAL].[usp_InsertProjectedPayoffCalcFromLanding]  
	@MarkedDate date,
	@UserID nvarchar(256)
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	IF EXISTS(
		Select ControlID from [IO].[L_ProjectedPayoffCalc] 
		Where ControlID in (
				Select Distinct d.credealid from val.deallist dl
				Inner Join cre.deal d on d.dealid = dl.dealid
				where dl.MarkedDateMasterID = @MarkedDateMasterID
			)
	)
	BEGIN
		Delete From [VAL].[ProjectedPayoffCalc]  where MarkedDateMasterID = @MarkedDateMasterID

		INSERT INTO [VAL].[ProjectedPayoffCalc] (MarkedDateMasterID,ControlID,DealName,Client,PropertyType,OpenDate,FullyExtendedMaturityDate,CreatedBy,CreatedDate,UpdateBy,UpdatedDate)		
		Select
		@MarkedDateMasterID
		,p.ControlID
		,p.DealName
		,p.Client	
		,p.PropertyType	
		,p.OpenDate
		,p.FullyExtendedMaturityDate
		,@UserID
		,getdate()
		,@UserID
		,getdate()
		from [IO].[L_ProjectedPayoffCalc] p
		Where p.ControlID in (
				Select Distinct d.credealid from val.deallist dl
				Inner Join cre.deal d on d.dealid = dl.dealid
				where dl.MarkedDateMasterID = @MarkedDateMasterID
			)

	END




	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
