CREATE PROCEDURE [val].[usp_GetValuationRequestsDataForEmail] 
	-- Add the parameters for the stored procedure here
  
AS
BEGIN
	 
	SET NOCOUNT ON;

	Declare @count int;
 SET @count = (select count(*) from  val.ValuationRequests where isEmailsent=4) 

 If (@count>0 )
 begin
		  select md.MarkedDate
	, d.CREDealID,d.DealName, l.Name as [Status],vr.ErrorMessage from  val.ValuationRequests vr
	inner join VAL.MarkedDateMaster md on vr.MarkedDateMasterID=md.MarkedDateMasterID 
	inner join CRE.Deal d on d.DealID = vr.DealID
	inner join  Core.Lookup l on l.LookupID = vr.StatusID	 
	where isEmailsent=4
 end

 
	

END
GO
 
 


