CREATE PROCEDURE [dbo].[usp_getSponsorDetailFromBackshop] 
(
	@DealID nvarchar(256)= null
)	
AS
BEGIN

Declare @L_DealID nvarchar(256) = null;

IF(@DealID IS NOT NULL)
BEGIN
	IF((SELECT 1 WHERE @DealID LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]')) = 1)
	BEGIN
		---If @DealID is guid
		SET @L_DealID = (Select CREDealID from cre.Deal where DealID = @DealID and isdeleted <> 1)
	END
	ELSE
	BEGIN
		SET @L_DealID = @DealID
	END
END

IF((Select [value] from [App].[AppConfig] where [Key] = 'AllowSponsorDetailFromBackshop') = 1)
BEGIN

	Declare @query nvarchar(max);

	SET @query = N'
	Select cm.controlId	
	,org.OrganizationName as Sponsor	
	,ct1.EmailAddress as [EmailAddress1]	
	,ct2.EmailAddress as [EmailAddress2]	
	,ct3.EmailAddress as [EmailAddress3]	
	,ct4.EmailAddress as [EmailAddress4]
	,ct5.EmailAddress as [EmailAddress5]	
	,ct6.EmailAddress as [EmailAddress6]
	from tblcontrolmaster cm
	Left join tblOrganization org on cm.Sponsor_OrgId_F = org.OrganizationID
	Left join tblContact ct1 on cm.DealBorrowerContact1_ContactId_F = ct1.ContactId
	Left join tblContact ct2 on cm.DealBorrowerContact2_ContactId_F = ct2.ContactId
	Left join tblContact ct3 on cm.DealBorrowerContact3_ContactId_F = ct3.ContactId
	Left join tblContact ct4 on cm.DealBorrowerContact4_ContactId_F = ct4.ContactId
	Left join tblContact ct5 on cm.DealBorrowerContact5_ContactId_F = ct5.ContactId
	Left join tblContact ct6 on cm.DealBorrowerContact6_ContactId_F = ct6.ContactId
	where cm.controlid in ('''+ @L_DealID +''')
	'

	print(@query)

	IF (@query is not null)
	BEGIN
		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
		@stmt = @query
	END






END



END






