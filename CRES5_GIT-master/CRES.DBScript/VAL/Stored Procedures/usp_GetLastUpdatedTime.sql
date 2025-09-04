-- Procedure
CREATE PROCEDURE [VAL].[usp_GetLastUpdatedTime] --'India Standard Time'
   @MarkedDate Date,
   @TimeZoneName nvarchar(250)
AS
BEGIN


	SET NOCOUNT ON;

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)



	select UpdatedBy 
	,UpdatedDate
	,isnull( [dbo].[ufn_GetTimeByTimeZoneName] (UpdatedDate,@TimeZoneName ),UpdatedDate)  as localUpdatedDate
	from  val.GlobalSetup
	where MarkedDateMasterID = @MarkedDateMasterID

END

GO


