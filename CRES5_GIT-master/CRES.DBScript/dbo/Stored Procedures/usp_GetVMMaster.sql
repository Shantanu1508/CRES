-- Procedure


CREATE Procedure [dbo].[usp_GetVMMaster]
AS
BEGIN
	SET NOCOUNT ON;


	Select [VMMasterID],VMName,IsActive,[Status]
	from [App].[VMMaster]
End