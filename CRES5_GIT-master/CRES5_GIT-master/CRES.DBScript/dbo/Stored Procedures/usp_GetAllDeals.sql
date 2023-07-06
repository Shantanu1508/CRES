


CREATE PROCEDURE [dbo].[usp_GetAllDeals] --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
    @UserID UNIQUEIDENTIFIER,
    @PgeIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
AS
BEGIN
      SET NOCOUNT ON;
	 
     SELECT @TotalCount = COUNT(DealID) FROM CRE.Deal;
     
		SELECT DealID
			,DealName
			,DealType
			,l1.name DealTypeText
			--  ,(select name from Core.Lookup where LookupID=DealType)DealTypeText 
			,LoanProgram     
			,l2.name LoanProgramText
			-- ,(select name from Core.Lookup where LookupID=LoanProgram)LoanProgramText
			,LoanPurpose
			,l3.name LoanPurposeText
			-- ,(select name from Core.Lookup where LookupID=LoanPurpose)LoanPurposeText
			,Status
			,l4.name StatusText
			--,(select name from Core.Lookup where LookupID=Status)StatusText
			,AppReceived  
			,EstClosingDate 
			, BorrowerRequest
			,l5.Name BorrowerRequestText
			-- ,(select name from Core.Lookup where LookupID=BorrowerRequest)BorrowerRequestText
			,RecommendedLoan
			,TotalFutureFunding
			,Source
			,l6.Name SourceText
			--  ,(select name from Core.Lookup where LookupID=Source)SourceText
			,BrokerageFirm
			,BrokerageContact
			,Sponsor
			,Principal
			,NetWorth
			,Liquidity
			,ClientDealID
			,CREDealID	  
			,LinkedDealID
			,d.TotalCommitment
			,d.AdjustedTotalCommitment
			,d.AggregatedTotal
			,d.AssetManagerComment
			,d.AllowSizerUpload
		     ,l7.Name as AllowSizerUploadText
			 ,(case when r.roleName is not null then (u.FirstName+' '+u.LastName) else null end) as AssetManager
            ,d.DealCity
            ,d.DealState
            ,d.DealPropertyType
			,d.DealComment
            ,d.FullyExtMaturityDate			
			,REPLACE(
			case
			when right(rtrim((ISNULL(d.DealState,'') +','+ISNULL(d.DealCity,''))),1) = ',' 
			then substring(rtrim((ISNULL(d.DealState,'') +','+ISNULL(d.DealCity,''))),1,len(rtrim((ISNULL(d.DealState,'') +','+ISNULL(d.DealCity,''))))-1)
			when left(rtrim((ISNULL(d.DealState,'') +','+ISNULL(d.DealCity,''))),1) = ',' 
			then substring(rtrim((ISNULL(d.DealState,'') +','+ISNULL(d.DealCity,''))),2,len(rtrim((ISNULL(d.DealState,'') +','+ISNULL(d.DealCity,'')))))
			else (ISNULL(d.DealState,'') +','+ISNULL(d.DealCity,'')) END 
			,',',', ') AS  GeoLocation
			,d.CreatedBy
			,d.CreatedDate
			,d.UpdatedBy
			,d.UpdatedDate			 

			,(CASE When EXISTS (SELECT 1 WHERE d.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
  THEN (select  top 1 u.[Login]  from CRE.DealFunding  df left join App.[User]  u  on u.UserID =  d.UpdatedBy) 
  ELSE d.UpdatedBy END) as LastUpdatedByFF
			      

			--,(select  top 1 u.[Login]  from CRE.DealFunding  df left join App.[User]  u  on u.UserID =  df.UpdatedBy) as LastUpdatedByFF

			,(Select Max(df.UpdatedDate) from [CRE].[DealFunding] df where df.DealID = d.DealID) as LastUpdatedFF	




  FROM CRE.Deal d
    LEFT Join Core.Lookup l1 on d.DealType=l1.LookupID
    LEFT Join Core.Lookup l2 on d.LoanProgram=l2.LookupID
	LEFT Join Core.Lookup l3 on d.LoanPurpose=l3.LookupID
	LEFT Join Core.Lookup l4 on d.Status=l4.LookupID
	LEFT Join Core.Lookup l5 on d.BorrowerRequest=l5.LookupID
	LEFT Join Core.Lookup l6 on d.Source=l6.LookupID
	Left Join Core.Lookup l7 on d.AllowSizerUpload=l7.LookupID
	left join app.[User] u on d.AMUserID = u.UserID
	left join app.UserRoleMap ur on u.UserID=ur.UserID
	left join app.role r on ur.RoleID=r.RoleID  and r.roleName='Asset Manager'
Where IsDeleted = 0

  ORDER BY d.UpdatedDate DESC
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY
    
END      

