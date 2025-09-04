CREATE PROCEDURE [dbo].[usp_GetXIRROutputArchive]
(
	@XIRRConfigID int,
    @ArchiveDate Date,
	@UserID nvarchar(256)
)
AS
BEGIN

   declare @ObjectType nvarchar(256),@Tags nvarchar(1000)
   select @ObjectType=ObjectType from [CRE].[XIRROutputArchive] where XIRRConfigID=@XIRRConfigID and cast(ArchiveDate as date)=@ArchiveDate

IF (@ObjectType='Deal')
BEGIN

--SET @Tags = (
--    Select STUFF((
--    Select Distinct  ', '  + tm.Name  
--    from (
--        Select XIRRConfigID,ObjectID as TagMasterXIRR 
--        from [CRE].[XIRRConfigDetail]
--        Where XIRRConfigID = @XIRRConfigID and ObjectType = 'Tag'
--    )xd
--    Inner join cre.TagMasterXIRR tm on xd.TagMasterXIRR = tm.TagMasterXIRRID
--    where xd.XIRRConfigID =@XIRRConfigID
--    FOR XML PATH('') ), 1, 2, '') as a
--)

SELECT 
		  [ReturnName]
		  ,isnull(replace(Tags,'|',', '),'') as Tags
		  ,[ObjectType] as [Type]
		  ,d.CREDealID as DealID
		  ,d.DealName as [Name]
		  ,dl.PropertyTypeMajorDesc PropertyType
		  ,dl.DealCity as [Location]
		  ,dl.LoanStatusDesc as LoanStatus
		  ,dl.closingdate as ClosingDate
		  ,dl.Maturity as Maturity
		  ,[XIRRValue] as XIRR     
		  ,x.Comments
		  ,a.[Name] as Scenario
     
  FROM [CRE].[XIRROutputArchive] x
  JOIN CRE.Deal d on d.AccountID=x.ObjectID
  JOIN core.Analysis a on a.AnalysisID =x.AnalysisID
   LEFT JOIN(
		Select d.dealname,d.dealid,MIN(n.closingdate) as closingdate,MAX(ISNULL(n.ActualPayOffDate,n.FullyExtendedMaturityDate)) as Maturity,p.PropertyTypeMajorDesc,DealCity,lc.LoanStatusDesc
		from cre.note n
		Inner JOIN CRE.Deal d on d.dealid=n.dealid
		Inner Join core.account acc on acc.accountid = n.account_accountid
		Left join cre.[PropertyTypeMajor] p on p.PropertyTypeMajorid = d.PropertyTypeMajorid
		Left Join cre.LoanStatus  lc on lc.LoanStatusID = d.LoanStatusID
		where acc.isdeleted <> 1

		GROUP BY d.dealname,d.dealid,p.PropertyTypeMajorDesc,DealCity,lc.LoanStatusDesc
	)dl on dl.dealid = d.dealid  
  
  WHERE XIRRConfigID =@XIRRConfigID
  and cast(ArchiveDate as date)=@ArchiveDate
END
ELSE IF (@ObjectType='Portfolio')
BEGIN

--SET @Tags = (
--    Select STUFF((
--    Select Distinct  ', '  + tm.Name  
--    from (
--        Select XIRRConfigID,ObjectID as TagMasterXIRR 
--        from [CRE].[XIRRConfigDetail]
--        Where XIRRConfigID = @XIRRConfigID and ObjectType = 'Tag'
--    )xd
--    Inner join cre.TagMasterXIRR tm on xd.TagMasterXIRR = tm.TagMasterXIRRID
--    where xd.XIRRConfigID =@XIRRConfigID
--    FOR XML PATH('') ), 1, 2, '') as a
--)

	 SELECT  [ReturnName]
	,isnull(replace(Tags,'|',', '),'') as Tags
	,[ObjectType] as Type
	,null as DealID
	,p.PortfoliName as Name
	,null as PropertyType
	,null as [Location]
	,null as LoanStatus
	,null as ClosingDate
	,null as Maturity
	,[XIRRValue] as XIRR
	,x.Comments
	,a.[Name] as Scenario	

  FROM [CRE].[XIRROutputArchive] x
  JOIN core.PortfolioMaster p on p.PortfolioMasterGuid=x.ObjectID
  JOIN core.Analysis a on a.AnalysisID =x.AnalysisID
  WHERE XIRRConfigID =@XIRRConfigID
  and cast(ArchiveDate as date)=@ArchiveDate
END


END