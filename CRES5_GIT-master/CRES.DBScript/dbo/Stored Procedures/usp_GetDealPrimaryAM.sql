CREATE PROCEDURE [dbo].[usp_GetDealPrimaryAM]
	@InvoiceDetailId int,
	@UserID NVARCHAR(256)
AS
	
 BEGIN
	SELECT u.FirstName as SenderFirstName,u.LastName as SenderLastName,u.Email as SenderEmail from app.[User] u join
	(
	SELECT invoiceDetailid,ISnull(d.AMUserID,isnull(d.AMsecondUserID,d.AMTeamLeadUserID)) as UserID from cre.invoicedetail i join Cre.Deal d on i.DealID=d.DEalID
	WHERE i.invoiceDetailid=@InvoiceDetailId
	) tbl ON u.UserID=tbl.UserID

 END