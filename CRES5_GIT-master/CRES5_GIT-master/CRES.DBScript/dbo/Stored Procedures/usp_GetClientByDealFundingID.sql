
CREATE PROCEDURE [dbo].[usp_GetClientByDealFundingID] 
(
    @DealFundingID Uniqueidentifier,
	@UserID nvarchar(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
    dealid,credealid,dealname,ClientID,ClientName,EmailID,
	-- format client name as 'client1,client2 and client3'
	(case when charindex(',',reverse(ClientsName))>0 then reverse(replace(STUFF(reverse(ClientsName),charindex(',',reverse(ClientsName)),0,'#'),'#,','dna ')) else ClientsName end) as ClientsName,
	EmailIDs
	FROM 
       (
	   
	   SELECT d.dealid,d.credealid,d.dealname,l.ClientID,l.ClientName,l.EmailID,
		STUFF((SELECT distinct ', ' + l.ClientName
			FROM cre.deal d
			   inner join cre.note n ON d.dealid = n.dealid
			   left join cre.client l ON l.ClientID = n.ClientID
			   join cre.dealfunding df on df.dealid = d.dealid 
			   WHERE n.ClientID is not null
			   and df.dealfundingid =  @DealFundingID
			   GROUP BY d.dealid,d.credealid,l.ClientName,d.dealname,l.EmailID 
			FOR XML PATH('')), 1, 2, '') as ClientsName,
	   STUFF((SELECT distinct ', ' + l.EmailID
		   FROM cre.deal d
			   inner join cre.note n ON d.dealid = n.dealid
			   left join cre.client l ON l.ClientID = n.ClientID
			   join cre.dealfunding df on df.dealid = d.dealid 
			   WHERE n.ClientID is not null
			   and df.dealfundingid =  @DealFundingID
			   GROUP BY d.dealid,d.credealid,l.ClientName,d.dealname,l.EmailID 
			FOR XML PATH('')), 1, 2, '') as EmailIDs
       FROM cre.deal d
       inner join cre.note n ON d.dealid = n.dealid
       left join cre.client l ON l.ClientID = n.ClientID
	   join cre.dealfunding df on df.dealid = d.dealid 
       WHERE n.ClientID is not null
	   and df.dealfundingid =  @DealFundingID
       GROUP BY d.dealid,d.credealid,l.ClientID,l.ClientName,d.dealname,l.EmailID
	   ) tbl order by ClientName desc
END
