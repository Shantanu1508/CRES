--[dbo].[usp_GetEquitySummaryByDealID]   '7F088F66-B435-46D5-9059-7039A786E7E8'    


-- Procedure
--[dbo].[usp_GetEquitySummaryByDealID]   '702B0F01-F028-4900-A00A-0BB94B5DCAD2'  
  
CREATE PROCEDURE [dbo].[usp_GetEquitySummaryByDealID]   
(  
 @DealID UNIQUEIDENTIFIER  
)    
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  
  
  
  
Declare @tblEquitySummary as table  
(  
Dealid UNIQUEIDENTIFIER,  
[Type] nvarchar(256),  
ExpectedEquity decimal(28,15),  
EquityContributedToDate  decimal(28,15),  
  
RemainingEquity decimal(28,15),  
Per_ContributedToDate  decimal(28,15),  
  
SortOrder int  
)  
  
INSERT INTO @tblEquitySummary(Dealid,[Type],ExpectedEquity,EquityContributedToDate,RemainingEquity,Per_ContributedToDate,SortOrder)  
  
Select Dealid,[Type],ISnull(ExpectedEquity,0) as ExpectedEquity,ISNULL(EquityContributedToDate,0) as EquityContributedToDate,(ISNULL(ExpectedEquity,0) - ISNULL(EquityContributedToDate,0)) RemainingEquity,((ISNULL(EquityContributedToDate ,0) / (CASE WHEN ISNULL(ExpectedEquity,0) = 0 THEN 1 ELSE ExpectedEquity END) )*100
)  as Per_ContributedToDate  ,SortOrder  
From(  
 Select d.dealid, 'Closing' as [Type],ISNULL(d.EquityAtClosing,0) as ExpectedEquity,ISNULL(d.EquityAtClosing,0) as EquityContributedToDate, 1 as SortOrder  
 from cre.deal d  
 where d.isdeleted <> 1  
 and d.dealid = @dealid  
  
 UNION ALL  
  
 Select d.dealid, 'FF Required Equity' as [Type],ISNULL(tblncm_reqeq.NCM_TotalRequiredEquity,0) as ExpectedEquity,ISNULL(tbldf_reqeq.df_TotalRequiredEquity,0) as EquityContributedToDate, 2 as SortOrder  
 from cre.deal d  
 LEFT JOIN(  
  Select dealid,SUM(ISNULL(TotalRequiredEquity,0))  as NCM_TotalRequiredEquity  
  from cre.NoteAdjustedCommitmentMaster  
  where date <= CAST(getdate() as date)  
  group by dealid  
 ) tblncm_reqeq on tblncm_reqeq.dealid = d.dealid  
 LEFT JOIN(  
  Select dealid,SUM(ISNULL(RequiredEquity,0))  as df_TotalRequiredEquity  
  from cre.dealfunding  
  where date <= CAST(getdate() as date)  
  group by dealid  
 ) tbldf_reqeq on tbldf_reqeq.dealid = d.dealid  
  
 where d.isdeleted <> 1  
 and d.dealid = @dealid  
  
 UNION ALL  
  
 Select d.dealid, 'FF Additional Equity' as [Type],ISNULL(tbldf_reqeq.df_TotalAdditionalEquity,0) as ExpectedEquity,ISNULL(tbldf_reqeq.df_TotalAdditionalEquity,0) as EquityContributedToDate, 3 as SortOrder  
 from cre.deal d  
 LEFT JOIN(  
  Select dealid,SUM(ISNULL(TotalAdditionalEquity,0))  as NCM_TotalAdditionalEquity  
  from cre.NoteAdjustedCommitmentMaster  
  where date <= CAST(getdate() as date)  
  group by dealid  
 ) tblncm_reqeq on tblncm_reqeq.dealid = d.dealid  
 LEFT JOIN(  
  Select dealid,SUM(ISNULL(AdditionalEquity,0))  as df_TotalAdditionalEquity  
  from cre.dealfunding  
  where date <= CAST(getdate() as date)  
  group by dealid  
 ) tbldf_reqeq on tbldf_reqeq.dealid = d.dealid  
  
 where d.isdeleted <> 1  
 and d.dealid = @dealid  
  
)a  
  
  
INSERT INTO @tblEquitySummary(Dealid,[Type],ExpectedEquity,EquityContributedToDate,RemainingEquity,Per_ContributedToDate,SortOrder)  
  
select Dealid,[Type],ISNULL(ExpectedEquity,0) as ExpectedEquity,ISNULL(EquityContributedToDate,0) as EquityContributedToDate,RemainingEquity, ((ISNULL(EquityContributedToDate ,0) / (CASE WHEN ISNULL(ExpectedEquity,0) = 0 THEN 1 ELSE ExpectedEquity END) )*100)  as Per_ContributedToDate, 4 as SortOrder  
from(  
 Select dealid, 'Total Equity' as [Type],SUM(ExpectedEquity) as ExpectedEquity,SUM(EquityContributedToDate) as EquityContributedToDate,SUM(RemainingEquity) as RemainingEquity,null as Per_ContributedToDate  
 from @tblEquitySummary  
 group by dealid  
)b  
  
  
  
  
Select Dealid,[Type],ExpectedEquity,EquityContributedToDate,RemainingEquity,Per_ContributedToDate   
from @tblEquitySummary  
order by SortOrder  
  
  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END  