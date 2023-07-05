CREATE PROCEDURE [dbo].[usp_UpdatePropertyManagerEmail]
(
@UserID nvarchar(256),    
@CreDealIdOrDealID nvarchar(256),
@PropertyManagerEmail nvarchar(500)
)
AS
BEGIN
    DECLARE @DealID nvarchar(256)
	--if (isnull(@PropertyManagerEmail,'')<>'' and isnull(@CreDealIdOrDealID,'')<>'')
	-- BEGIN
	  if (len(@CreDealIdOrDealID)=36)
		SET @DealID = @CreDealIdOrDealID
	  ELSE
		select @DealID=dealid from cre.Deal where CREDealID=@CreDealIdOrDealID
		Update cre.Deal set PropertyManagerEmail=@PropertyManagerEmail where DealID=@DealID
	 
	 --END
END
