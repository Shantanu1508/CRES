-- Procedure

-- Procedure

--[dbo].[usp_GetXIRROutputDealLevel]  107,'Delphi I','CA',null
--[dbo].[usp_GetXIRROutputDealLevel]  107,'Delphi I',null,'Realized'
--[dbo].[usp_GetXIRROutputDealLevel]  107,null,'CA',null

CREATE PROCEDURE [dbo].[usp_GetXIRROutputDealLevel] 
 @XIRRConfigID int,  
 @GValue1 nvarchar(256) = null,  
 @GValue2 nvarchar(256) = null,  
 @LoanStatus nvarchar(256) = null  
AS    
BEGIN      
    
SET NOCOUNT ON;   
  
Declare @AnalysisID nvarchar(256) =(Select analysisid from cre.xirrconfig where XIRRConfigID = @XIRRConfigID)  
  
Declare @Group1_LableName nvarchar(256)  
Declare @Group2_LableName nvarchar(256)  
Declare @Group1_ColumnAliasName nvarchar(256)  
Declare @Group2_ColumnAliasName nvarchar(256)  
  
  
Select @Group1_LableName = g1.Name   
,@Group2_LableName = g2.Name   
,@AnalysisID = xc.AnalysisID  
,@Group1_ColumnAliasName = g1.[ReferenceColumnAliasName]   
,@Group2_ColumnAliasName = g2.[ReferenceColumnAliasName]   
from cre.xirrconfig xc   
left Join [CRE].XIRRFilterSetup g1 on g1.XIRRFilterSetupID = xc.Group1  
left Join [CRE].XIRRFilterSetup g2 on g2.XIRRFilterSetupID = xc.Group2  
Where xc.xirrconfigID = @XIRRConfigID  
  
Declare @query_Where nvarchar(MAX) = ''  

IF(@GValue1 IS NOT NULL)
BEGIN  
	SET @query_Where = N' and '+REPLACE(CAst(@Group1_ColumnAliasName as nvarchar(256)) ,'LoanStatus','xrg.LoanStatus') +' in (''' + CAst(@GValue1 as nvarchar(256))+ ''')'  
END
IF(@GValue2 IS NOT NULL)
BEGIN
	SET @query_Where = @query_Where + N' and '+REPLACE(CAst(@Group2_ColumnAliasName as nvarchar(256)),'LoanStatus','xrg.LoanStatus') +' in (''' + CAst(@GValue2 as nvarchar(256))+ ''')'  
END


IF(@query_Where IS NULL)  
 SET @query_Where = ''  
  
  
Declare @g2_query nvarchar(MAX) = 'and xrg.LoanStatus = '''+Cast(@LoanStatus as nvarchar(256))+'''  '  
  
  
Declare @query nvarchar(MAX)  
Declare @query1 nvarchar(MAX)  
Declare @query2 nvarchar(MAX)  
  
SET @query1 = N'SELECT Distinct x.XIRRConfigID--,x.XIRRReturnGroupID  
 ,d.CREDealID as DealID  
 ,d.DealName as [DealName]  
 ,d.LinkedDealID as [LegalDealID]
 ,CASE 
        WHEN d.LinkedDealID IS NOT NULL THEN LD.DealName
        ELSE NULL
    END AS [LegalDealName]
 ,[XIRRValue] as XIRR   
  ,STUFF((SELECT '', '' + CAST(PoolName AS VARCHAR(256)) [text()]  
  From(  
  Select Distinct d.AccountID,lpool.name  as PoolName  
  from cre.note n   
  Inner Join core.account acc on acc.accountid = n.account_accountid    
  Inner join cre.deal d on d.dealid = n.dealid  
  Left join core.lookup lpool on lpool.lookupid = n.poolid  
  WHERE acc.isdeleted <> 1   
  --and n.poolid = xinp.PoolID
  and d.AccountID = x.DealAccountID  
 )a  
 FOR XML PATH(''''), TYPE)  
 .value(''.'',''NVARCHAR(MAX)''),1,1,'' '') PoolName  
  ,xinp.ProductType 
  ,xinp.[State]  
 ,xinp.DealType  
 ,xinp.LoanStatus  
 ,xinp.MSA as [MSA]   
  ,xinp.VintageYear as [VintageYear]    
   ,dl.closingdate as ClosingDate  
 ,dl.Maturity as Maturity   
 ,x.WholeLoanInvestment
 ,x.SubordinateDebtInvestment
 ,x.SeniorDebtInvestment
 ,x.OutstandingBalance
 ,x.CapitalInvested
 ,x.ProjCapitalInvested
 ,x.RealizedProceeds
 ,x.UnrealizedProceeds
 ,x.TotalProceeds
 ,x.MultipleCalculation as GrossMultiples
 ,x.WholeLoanSpread
 ,x.SubDebtSpread
 ,x.SeniorDebtSpread
 ,x.CutoffDateOverride
 
 FROM [CRE].[XIRROutputDealLevel] x  
 Inner join cre.XIRRConfig xc on xc.XIRRConfigID = x.XIRRConfigID  
 Inner Join cre.XIRRReturnGroup xrg on xrg.XIRRConfigID = x.XIRRConfigID and xrg.XIRRReturnGroupID = x.XIRRReturnGroupID  
 JOIN CRE.Deal d on d.AccountID=x.dealAccountID  and  d.isdeleted <> 1
 JOIN core.Analysis a on a.AnalysisID =x.AnalysisID  
 LEFT JOIN CRE.Deal LD ON d.LinkedDealID = LD.CREDealID
 LEFT JOIN(  
  Select d.dealname,d.dealid,MIN(n.closingdate) as closingdate,MAX(ISNULL(n.ActualPayOffDate,n.FullyExtendedMaturityDate)) as Maturity  
  from cre.note n  
  Inner JOIN CRE.Deal d on d.dealid=n.dealid  
  Inner Join core.account acc on acc.accountid = n.account_accountid    
  where acc.isdeleted <> 1  and  d.isdeleted <> 1
  GROUP BY d.dealname,d.dealid  
 )dl on dl.dealid = d.dealid  
 'SET @query2 = N'  
 Left Join(  
  Select Distinct xi.XIRRConfigID ,xi.XIRRReturnGroupID,xi.[Type],xi.AnalysisID,xi.DealAccountID,xi.PoolID,xi.ProductTypeID,xi.[State],xi.DealTypeID,lpool.name as PoolName,lprop.PropertyTypeMajorDesc as ProductType    
  ,ldt.DealTypeName as DealType,xi.LoanStatus,xi.VintageYear,xi.MSA  
  from cre.XIRRCalculationInput xi  
  Inner join cre.note n on n.Account_AccountID = xi.NoteAccountID  
  Inner join cre.deal d on d.dealid = n.dealid  
  Left join core.lookup lpool on lpool.lookupid = n.poolid  
  Left join [CRE].[PropertyTypeMajor] lprop on lprop.PropertyTypeMajorID = d.PropertyTypeMajorID  
  Left Join cre.DealTypeMaster ldt on ldt.DealTypeMasterID = d.DealTypeMasterID  
  WHERE xi.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''   
  and xi.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+'''   
 )xinp on xinp.XIRRConfigID = x.XIRRConfigID and xinp.DealAccountID = x.DealAccountID  and xinp.XIRRReturnGroupID = x.XIRRReturnGroupID    
 WHERE x.analysisid = '''+Cast(@AnalysisID as nvarchar(256))+'''  
 and x.XIRRConfigID = '''+Cast(@XIRRConfigID as nvarchar(256))+'''   
 '+ISNULL(@g2_query,'')+'  
 '  
  
  
 SET @query = (@query1 + @query2) +' '+ @query_Where + '  Order By DealName'  
   
 Print(@query)  
 EXEC(@query)  
  
  
  
  
  
END
GO

