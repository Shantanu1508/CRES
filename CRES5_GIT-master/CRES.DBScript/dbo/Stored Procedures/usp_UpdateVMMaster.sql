-- Procedure


CREATE Procedure [dbo].[usp_UpdateVMMaster]
	@VMName nvarchar(256),
	@Status nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;

	Update [App].[VMMaster] set [Status] = @Status,Updateddate = getdate() Where VMName = @VMName

End