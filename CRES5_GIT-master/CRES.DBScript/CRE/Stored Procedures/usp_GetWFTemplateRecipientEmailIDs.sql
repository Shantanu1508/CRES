
--[CRE].[usp_GetWFTemplateRecipientEmailIDs] 1

CREATE PROCEDURE [CRE].[usp_GetWFTemplateRecipientEmailIDs]	  --2307
	@WFNotificationMasterID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  
	Declare @WFTemplateID int 
	SET @WFTemplateID = (Select TemplateID from cre.WFNotificationMaster where WFNotificationMasterID = @WFNotificationMasterID)
      
 
	Select WFTemplateID,[To],[CC],[ReplyTo],[WFNotificationMasterID]
	From(
		SELECT WFTemplateID,RecipientType, EmailID = 
		STUFF((SELECT ', ' + EmailID
			FROM [CRE].WFTemplateRecipient b 
			WHERE b.RecipientType = a.RecipientType  and b.WFTemplateID = a.WFTemplateID 
			FOR XML PATH('')), 1, 2, ''),
			WFNotificationMasterID
		FROM [CRE].WFTemplateRecipient a join 
		CRE.WFNotificationMaster nm on a.WFTemplateID = nm.TemplateID
		--where WFTemplateID = @WFTemplateID
		GROUP BY RecipientType,WFTemplateID,WFNotificationMasterID
	)AS SourceTable 
	PIVOT  
	(  
		MIN(EmailID)  
		FOR RecipientType IN ([To],[CC],[ReplyTo])  
	) AS PivotTable
 

 


-- Select top 1 credealid,dealname,EmailID  from(
--       Select d.dealid,d.credealid,d.dealname,l.ClientName,l.EmailID
--       from cre.deal d
--       inner join cre.note n on d.dealid = n.dealid
--       left join cre.client l on l.ClientID = n.ClientID 
--       where n.ClientID is not null
--       group by d.dealid,d.credealid,l.ClientName,d.dealname,l.EmailID
--)a
--inner join cre.dealfunding df on df.dealid = a.dealid
--where df.dealfundingid =  '9EF8DCF5-0BE0-45F1-AAB2-0CF219F278A3'

 
END


