CREATE PROCEDURE [dbo].[usp_UpdateSponsorDetailFromBackshop] 
(
	@DealID nvarchar(256)= null
)	
AS
BEGIN


Declare @L_DealID UNIQUEIDENTIFIER = null;

IF(@DealID IS NOT NULL)
BEGIN
	IF((SELECT 1 WHERE @DealID LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]')) = 1)
	BEGIN
		---If @DealID is guid
		SET @L_DealID = @DealID
	END
	ELSE
	BEGIN
		SET @L_DealID = (Select DealID from cre.Deal where CREDealID = @DealID and isdeleted <> 1)
	END
END



IF((Select [value] from [App].[AppConfig] where [Key] = 'AllowSponsorDetailFromBackshop') = 1)
BEGIN
	
	IF OBJECT_ID('tempdb..#tblDeal') IS NOT NULL         
		DROP TABLE #tblDeal

	CREATE TABLE #tblDeal(
	InvoiceDetailID		Int,
	DealFundingID		uniqueidentifier,
	DealID		uniqueidentifier
	)

	INSERT INTO #tblDeal(InvoiceDetailID,DealFundingID,DealID)
	select i.InvoiceDetailID,df.DealFundingID,df.DealID--,df.Applied 
	from cre.InvoiceDetail i 
	join cre.DealFunding df on i.ObjectID=df.DealFundingID
	where i.ObjectTypeID=698
	and i.InvoiceTypeID=558
	and i.DrawFeeStatus not in (693,694)
	and isnull(df.Applied,0)=0
	and ((@L_DealID is not null and df.DealID=@L_DealID) or @L_DealID is null)

	union
	select i.InvoiceDetailID,null as DealFundingID,d.DealID--,df.Applied 
	from cre.InvoiceDetail i 
	join cre.Deal d on i.ObjectID=d.DealID
	where i.ObjectTypeID=697
	and i.DrawFeeStatus not in (693,694)
	and ((@L_DealID is not null and d.DealID=@L_DealID) or @L_DealID is null)
	-------===============================================================

	IF EXISTS(Select DealID from #tblDeal)
	BEGIN
		Declare @deallist nvarchar(max);

		select @deallist = STUFF((SELECT ',''' + (CAST(credealid as nvarchar(MAX))) +''''
               			From(
							
							select Distinct d.credealid
							from cre.InvoiceDetail i 
							join cre.DealFunding df on i.ObjectID=df.DealFundingID
							inner Join cre.deal d on d.dealid = df.dealid
							where i.ObjectTypeID=698
							and i.InvoiceTypeID=558
							and i.DrawFeeStatus not in (693,694)
							and isnull(df.Applied,0)=0 
							and ((@L_DealID is not null and df.DealID=@L_DealID) or @L_DealID is null) 
							
							union
							
							select Distinct d.credealid
							from cre.InvoiceDetail i 
							join cre.Deal d on i.ObjectID=d.DealID
							where i.ObjectTypeID=697
							and i.DrawFeeStatus not in (693,694)
							and ((@L_DealID is not null and d.DealID=@L_DealID) or @L_DealID is null) 
							
                		 )a
           			FOR XML PATH(''), TYPE
           			).value('.', 'NVARCHAR(MAX)') 
       			,1,1,'')


		--Print(@deallist)
		--=================================================================

		IF OBJECT_ID('tempdb..#tblBackshopSponsor') IS NOT NULL         
			DROP TABLE #tblBackshopSponsor

		CREATE TABLE #tblBackshopSponsor(
		controlId	nvarchar(256),
		DealName	nvarchar(256),
		Sponsor	nvarchar(256),
		BorrowerAssetMgmtContactCompany	nvarchar(256),
		EmailAddress1	nvarchar(256),
		DealBorrower2	nvarchar(256),
		EmailAddress2	nvarchar(256),
		DealBorrower3	nvarchar(256),
		EmailAddress3	nvarchar(256),
		DealBorrower4	nvarchar(256),
		EmailAddress4	nvarchar(256),
		DealBorrower5	nvarchar(256),
		EmailAddress5	nvarchar(256),
		DealBorrower6	nvarchar(256),
		EmailAddress6	nvarchar(256),
		ShardName		nvarchar(256)
		)


		Declare @query nvarchar(max);

		SET @query = N'
		Select cm.controlId
		,cm.dealname
		--,cm.Sponsor_OrgId_F
		--,cm.DealBorrower_OrgId_F
		--,DealBorrowerContact1_ContactId_F
		,org.OrganizationName as Sponsor

		,dborr1.OrganizationName as [BorrowerAssetMgmtContactCompany]
		,ct1.EmailAddress as [EmailAddress1]

		,dborr2.OrganizationName as [DealBorrower2]
		,ct2.EmailAddress as [EmailAddress2]

		,dborr3.OrganizationName as [DealBorrower3]
		,ct3.EmailAddress as [EmailAddress3]

		,dborr4.OrganizationName as [DealBorrower4]
		,ct4.EmailAddress as [EmailAddress4]

		,dborr5.OrganizationName as [DealBorrower5]
		,ct5.EmailAddress as [EmailAddress5]

		,dborr6.OrganizationName as [DealBorrower6]
		,ct6.EmailAddress as [EmailAddress6]

		from tblcontrolmaster cm
		Left join tblOrganization org on cm.Sponsor_OrgId_F = org.OrganizationID

		Left join tblOrganization dborr1 on cm.DealBorrower_OrgId_F = dborr1.OrganizationID
		Left join tblOrganization dborr2 on cm.DealBorrower2_OrgId_F = dborr2.OrganizationID
		Left join tblOrganization dborr3 on cm.DealBorrower3_OrgId_F = dborr3.OrganizationID
		Left join tblOrganization dborr4 on cm.DealBorrower4_OrgId_F = dborr4.OrganizationID
		Left join tblOrganization dborr5 on cm.DealBorrower5_OrgId_F = dborr5.OrganizationID
		Left join tblOrganization dborr6 on cm.DealBorrower6_OrgId_F = dborr6.OrganizationID

		Left join tblContact ct1 on cm.DealBorrowerContact1_ContactId_F = ct1.ContactId
		Left join tblContact ct2 on cm.DealBorrowerContact2_ContactId_F = ct2.ContactId
		Left join tblContact ct3 on cm.DealBorrowerContact3_ContactId_F = ct3.ContactId
		Left join tblContact ct4 on cm.DealBorrowerContact4_ContactId_F = ct4.ContactId
		Left join tblContact ct5 on cm.DealBorrowerContact5_ContactId_F = ct5.ContactId
		Left join tblContact ct6 on cm.DealBorrowerContact6_ContactId_F = ct6.ContactId
		where cm.controlid in ('+ @deallist +')
		'


		INSERT INto #tblBackshopSponsor (controlId,DealName,Sponsor,BorrowerAssetMgmtContactCompany,EmailAddress1,DealBorrower2,EmailAddress2,DealBorrower3,EmailAddress3,DealBorrower4,EmailAddress4,DealBorrower5,EmailAddress5,DealBorrower6,EmailAddress6,ShardName)
		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
		@stmt = @query



		Declare @tblResult as Table
		(
			controlId	nvarchar(256),
			Sponsor		nvarchar(256),
			EmailIDs 	nvarchar(256)
		)

		INSERT INTO @tblResult(controlId,Sponsor, EmailIDs)
		SELECT controlId,Sponsor, EmailIDs 
		FROM(
			Select controlId,Sponsor	,EmailAddress1	,EmailAddress2	,EmailAddress3	,EmailAddress4	,EmailAddress5	,EmailAddress6	from #tblBackshopSponsor
		) p  
		UNPIVOT  
		(
			EmailIDs FOR Email IN (EmailAddress1	,EmailAddress2	,EmailAddress3	,EmailAddress4	,EmailAddress5	,EmailAddress6)  
		)AS unpvt  




			--Select Distinct id.InvoiceDetailID,id.DealFundingID,d.dealid,t.controlId,t.Sponsor  
			--,STUFF((SELECT ',' + (CAST(EmailIDs as nvarchar(MAX))) 
	 	 --              		From(

			--				 	 Select controlId,Sponsor, EmailIDs 
			--					from @tblResult t1  
			--					Where t1.controlId = t.controlId
					               
	 	 --               	 )a
	 	 --          		FOR XML PATH(''), TYPE
	 	 --          		).value('.', 'NVARCHAR(MAX)') 
	 	 --      		,1,1,'') as EmailIDs
			--from @tblResult t
			--Inner Join cre.deal d on d.credealid = t.controlId
			--Inner join #tblDeal id on id.DealID= d.dealid
			--Where d.IsDeleted <> 1




		update cre.InvoiceDetail set  cre.InvoiceDetail.FirstName=tbl.Sponsor,cre.InvoiceDetail.Email1=tbl.EmailIDs
		from(
			Select Distinct id.InvoiceDetailID,id.DealFundingID,d.dealid,t.controlId,t.Sponsor  
			,STUFF((SELECT ',' + (CAST(EmailIDs as nvarchar(MAX))) 
	               			From(

						 		 Select controlId,Sponsor, EmailIDs 
								from @tblResult t1  
								Where t1.controlId = t.controlId
					               
	                		 )a
	           			FOR XML PATH(''), TYPE
	           			).value('.', 'NVARCHAR(MAX)') 
	       			,1,1,'') as EmailIDs
			from @tblResult t
			Inner Join cre.deal d on d.credealid = t.controlId
			Inner join #tblDeal id on id.DealID= d.dealid
			Where d.IsDeleted <> 1
		) tbl
		where cre.InvoiceDetail.InvoiceDetailID =tbl.InvoiceDetailID ---and cre.InvoiceDetail.DealID = tbl.DealID
	
	END
	--for testing-need to remove
	--update cre.InvoiceDetail set Email1='rsahu@mailinator.com,shantanu@hvantage.com,skhan@hvantage.com'

END




END






