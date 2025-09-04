
CREATE PROCEDURE [dbo].[usp_RefreshTagXIRR]

AS
BEGIN
	SET NOCOUNT ON;

Select TableName, TagName, ObjectID, NoteName, CREDealID, DealName, Location, PropertyType, FinancingSourceType from (

	SELECT 
	        TableName = 'M61.Tables.TagXIRR_Note',
			ms.Name as TagName,
			n.CRENoteID as ObjectID,
			a.Name as NoteName,
			d.CREDealID as CREDealID,
			d.DealName as DealName,
			loc.M61_location as Location,
			p.PropertyTypeMajorDesc as PropertyType,
			f.FinancingSourceName as FinancingSourceType
   FROM  [CRE].[TagAccountMappingXIRR] ta
   Inner Join [CRE].[TagMasterXIRR] ms on ms.TagMasterXIRRID =  ta.TagMasterXIRRID
   Inner Join [CRE].[Note] n on n.Account_AccountID = ta.AccountID
   LEFT Join [CRE].[Deal] d on d.DealID = n.DealID
   LEFT Join (
   Select Distinct dealid,credealid,city,[State],[M61_location]
    From(
	Select Distinct d.dealid,d.credealid,p.city,p.PState as [State],Allocation,(city + ', ' +PState) as [M61_location],
	ROW_NUMBER() Over(Partition by credealid order by credealid,PropertyRollUpSW desc,Allocation desc) as rno,
	BSPropertyID,PropertyRollUpSW
	from cre.Property p
	inner join cre.deal d on d.dealid = p.deal_dealid
	where p.isdeleted <> 1 and d.isdeleted <> 1 
    )b where rno = 1 
   )as loc on loc.DealID = d.DealID

   LEFT Join [CRE].[FinancingSourceMaster] f on f.FinancingSourceMasterID = n.FinancingSourceID
   LEFT Join [CRE].[PropertyTypeMajor] p on p.PropertyTypeMajorID = d.PropertyTypeMajorID
   Inner Join [CORE].[Account] a on a.AccountID = n.Account_AccountID 
   where a.IsDeleted = 0

   --UNION ALL

   --SELECT 
	  --      TableName = 'M61.Tables.TagXIRR_Deal',
			--d.CREDealID as ObjectID,
			--ms.Name as TagName
   --FROM  [CRE].[TagAccountMappingXIRR] ta
   --Inner Join [CRE].[TagMasterXIRR] ms on ms.TagMasterXIRRID =  ta.TagMasterXIRRID
   --Inner Join [CRE].[Deal] d on d.AccountID = ta.AccountID
   --Inner Join [CORE].[Account] a on a.AccountID = d.AccountID where a.IsDeleted = 0

   --UNION ALL

   --SELECT 
	  --      TableName = 'M61.Tables.TagXIRR_Debt',
			--a.Name as ObjectID,
			--ms.Name as TagName
   --FROM  [CRE].[TagAccountMappingXIRR] ta
   --Inner Join [CRE].[TagMasterXIRR] ms on ms.TagMasterXIRRID =  ta.TagMasterXIRRID
   --Inner Join [CRE].[Debt] d on d.AccountID = ta.AccountID
   --Inner Join [CORE].[Account] a on a.AccountID = d.AccountID where a.IsDeleted = 0

   --UNION ALL

   --SELECT 
	  --      TableName = 'M61.Tables.TagXIRR_Equity',
			--a.Name as ObjectID,
			--ms.Name as TagName
   --FROM  [CRE].[TagAccountMappingXIRR] ta
   --Inner Join [CRE].[TagMasterXIRR] ms on ms.TagMasterXIRRID =  ta.TagMasterXIRRID
   --Inner Join [CRE].[Equity] e on e.AccountID = ta.AccountID
   --Inner Join [CORE].[Account] a on a.AccountID = e.AccountID where a.IsDeleted = 0

   --UNION ALL

   --SELECT 
	  --      TableName = 'M61.Tables.TagXIRR_LiabilityNote',
			--ln.LiabilityNoteID as ObjectID,
			--ms.Name as TagName
   --FROM  [CRE].[TagAccountMappingXIRR] ta
   --Inner Join [CRE].[TagMasterXIRR] ms on ms.TagMasterXIRRID =  ta.TagMasterXIRRID
   --Inner Join [CRE].[LiabilityNote] ln on ln.AccountID = ta.AccountID
   --Inner Join [CORE].[Account] a on a.AccountID = ln.AccountID where a.IsDeleted = 0

) as result 

    ORDER BY 
        CASE TableName
            WHEN 'M61.Tables.TagXIRR_Note' THEN 1
            WHEN 'M61.Tables.TagXIRR_Deal' THEN 2
            WHEN 'M61.Tables.TagXIRR_Debt' THEN 3
			WHEN 'M61.Tables.TagXIRR_Equity' THEN 4
			WHEN 'M61.Tables.TagXIRR_LiabilityNote' THEN 5
            ELSE 6 
        END;

END

