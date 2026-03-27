CREATE PROCEDURE [dbo].[usp_GetLookupforXIRRFilters]  
@XIRRConfigID int = null 

AS
BEGIN
 
SELECT LookupID, Name, Type From( 

   SELECT  
           CAST([LookupID] AS NVARCHAR) AS LookupID,
           [Name] as Name,
		   Type = 'Pool'
        FROM [Core].[Lookup] l
        where l.ParentID = 74 and ISNULL(StatusID,1)=1
 
 UNION ALL

   SELECT 
        CAST(p.PropertyTypeMajorID AS NVARCHAR) AS LookupID,
        p.PropertyTypeMajorDesc as Name,
		Type = 'ProductType'
		FROM [CRE].[PropertyTypeMajor] p
 
 UNION ALL

		SELECT 
		CAST(DealTypeMasterID AS NVARCHAR) AS LookupID, 
		DealTypeName as Name,
		Type = 'DealType'
		from cre.DealTypeMaster
 
 UNION ALL

   SELECT Distinct 
    [State] AS LookupID, 
    [State] as Name,
    Type = 'State'
    From(
	Select Distinct d.dealid,d.credealid,p.city,p.PState as [State],Allocation,(city + ', ' +PState) as [M61_location],
	ROW_NUMBER() Over(Partition by credealid order by credealid,PropertyRollUpSW desc,Allocation desc) as rno,
	BSPropertyID,PropertyRollUpSW
	from cre.Property p
	inner join cre.deal d on d.dealid = p.deal_dealid
	where p.isdeleted <> 1 and d.isdeleted <> 1 AND p.PState IS NOT NULL
    )b where rno = 1

UNION ALL

	Select LookupID,[Name],'LoanStatus' as [Type]
	From(
	Select 'Realized' LookupID,'Realized' as [Name]
	union all
	Select 'Unrealized' LookupID,'Unrealized' as [Name]
	)z

UNION ALL

	 Select Distinct MSA_NAME as LookupID,MSA_NAME as [Name] ,'MSA' as [Type]
	 from  cre.deal where isdeleted <>1
	 and MSA_NAME is not null
	 --Order BY MSA_NAME


UNION ALL

	 Select Distinct CAST(YEAR(InquiryDate) AS NVARCHAR) as LookupID,CAST(YEAR(InquiryDate) AS NVARCHAR)  as [Name] ,'VintageYear' as [Type]
	 from  cre.deal where isdeleted <>1
	 and InquiryDate is not null
	 --Order BY CAST(YEAR(InquiryDate) AS NVARCHAR)




)as Result 

 Order By Type,Name

END