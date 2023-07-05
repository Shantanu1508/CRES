CREATE PROCEDURE [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction]  
@CREDealID nvarchar(256),  
@CreatedBy nvarchar(256)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
exec  ('  
 IF EXISTS(select [name] from sys.external_data_sources where name = ''RemoteReference_ImportBSProd'')  
  Drop EXTERNAL DATA SOURCE RemoteReference_ImportBSProd   
 IF EXISTS(select [name] from sys.database_scoped_credentials where name = ''Credential_ImportBSProd'')  
  Drop DATABASE SCOPED CREDENTIAL Credential_ImportBSProd  
  
 --CREATE DATABASE SCOPED CREDENTIAL  
 CREATE DATABASE SCOPED CREDENTIAL Credential_ImportBSProd  WITH IDENTITY = ''ACOREAccounting'',  SECRET = ''cv9ftqVc?BtxbCS''  
  
 --CREATE EXTERNAL DATA SOURCE  
 Create EXTERNAL DATA SOURCE RemoteReference_ImportBSProd  
 WITH   
 (   
  TYPE=RDBMS,   
  LOCATION=''tcp:z70t9nlx1v.database.secure.windows.net'',   
  DATABASE_NAME=''BackshopProduction'',   
  CREDENTIAL= Credential_ImportBSProd   
 );   
')  
--========================================================================  
  
 Declare @tbl_ProjectedPayOffAccounting as Table(  
 ProjectedPayOffHeaderId int null,  
 ControlId nvarchar(256) null,  
 EarliestDate Date null,  
 LatestDate  Date null,  
 OpenDate  Date null,  
 ExpectedDate Date null,   
 AuditUpdateDate DateTime null,   
 AsOfDate Date null,  
 CumulativeProbability decimal(28,15) null,  
 [Status] nvarchar(256) null,  
 ShardName nvarchar(256) null  
 )  
  
 DECLARE @query1 nvarchar(256) = N'Select COUNT(ControlID) from tblControlMaster where ControlID = '''+@CREDealID+''' '    
 DECLARE @DealCount TABLE (Cnt int,ShardName nvarchar(max))  
 INSERT INTO @DealCount (Cnt,ShardName)  
 EXEC sp_execute_remote @data_source_name  = N'RemoteReference_ImportBSProd', @stmt = @query1  
  
 IF ((Select cnt from @DealCount) > 0) --Check if deal exists in backshop database  
 BEGIN  
     
  DECLARE @query nvarchar(MAX) = N'exec acore.spProjectedPayOffAccounting '''+@CREDealID+''''  
  
  INSERT INTO @tbl_ProjectedPayOffAccounting([ProjectedPayOffHeaderId],[ControlId],[EarliestDate],[LatestDate],OpenDate,[ExpectedDate],[AuditUpdateDate],[AsOfDate],[CumulativeProbability],ShardName)  
  EXEC sp_execute_remote @data_source_name  = N'RemoteReference_ImportBSProd', @stmt = @query  
  
  
  IF EXISTS(select [ControlId] from @tbl_ProjectedPayOffAccounting)  
  BEGIN  
   Update @tbl_ProjectedPayOffAccounting Set [Status] = 'Success'  
  END  
  ELSE  
  BEGIN  
   INSERT INTO @tbl_ProjectedPayOffAccounting([Status])VALUES('Data not exists in Backshop for this deal')  
  END   
 END  
 ELSE  
 BEGIN  
  INSERT INTO @tbl_ProjectedPayOffAccounting([Status])VALUES('Deal does not exists in Backshop')  
 END  
  
  
  
--Select ControlId,EarliestDate,LatestDate,ExpectedDate,CAST(AuditUpdateDate as date) AuditUpdateDate,AsOfDate,(CumulativeProbability/100) as CumulativeProbability,[Status]   
--from @tbl_ProjectedPayOffAccounting  
--WHERE ControlId is not null  
  
  
IF EXISTS(select [ControlId] from @tbl_ProjectedPayOffAccounting)  
BEGIN  
 ---Update deal level data  
 Update cre.deal set  
 cre.deal.EnableAutoSpreadRepayments = a.EnableAutoSpreadRepayments,  
 cre.deal.AutoUpdateFromUnderwriting = a.AutoUpdateFromUnderwriting,  
 cre.deal.RepaymentAutoSpreadMethodID = a.RepaymentAutoSpreadMethodID,  
 cre.deal.ExpectedFullRepaymentDate = a.ExpectedFullRepaymentDate,  
 cre.deal.PossibleRepaymentdayofthemonth = a.PossibleRepaymentdayofthemonth,  
 cre.deal.Repaymentallocationfrequency = a.Repaymentallocationfrequency,  
 cre.deal.AutoPrepayEffectiveDate = a.AutoPrepayEffectiveDate,  
 cre.deal.EarliestPossibleRepaymentDate = a.EarliestPossibleRepaymentDate,  
 cre.deal.LatestPossibleRepaymentDate = a.LatestPossibleRepaymentDate  
 From(  
  Select Distinct ControlId as credealid,  
  1 as EnableAutoSpreadRepayments,  
  0 as AutoUpdateFromUnderwriting,  
  701 as RepaymentAutoSpreadMethodID, ---CPR  
  ExpectedDate as ExpectedFullRepaymentDate,   
  tblDe.DeterminationDateReferenceDayoftheMonth as PossibleRepaymentdayofthemonth,  
  1 as Repaymentallocationfrequency,  
  CAST(AuditUpdateDate as date) as AutoPrepayEffectiveDate,  
  EarliestDate as EarliestPossibleRepaymentDate,  
  LatestDate as LatestPossibleRepaymentDate  
  
  From @tbl_ProjectedPayOffAccounting t  
  inner join cre.deal d on d.credealid = t.ControlId  
  left join(  
   Select top 1 d.dealid,n.DeterminationDateReferenceDayoftheMonth from cre.note n  
   inner join core.account acc on acc.accountid = n.account_accountid  
   inner join cre.deal d on d.dealid = n.dealid  
   where acc.isdeleted <> 1  
   and n.DeterminationDateReferenceDayoftheMonth is not null  
   and d.credealid = @CREDealID  
  )tblDe on tblDe.dealid = d.dealid  
  where d.credealid = @CREDealID  
 )a  
 where cre.deal.credealid = a.credealid  
  
 ---Insert ProjectedPayOffDate data  
 declare @TableTypeProjectedPayOffDate TableTypeProjectedPayOffDate  
  
 Delete from @TableTypeProjectedPayOffDate  
  
 insert into @TableTypeProjectedPayOffDate(DealID,ProjectedPayoffAsofDate,CumulativeProbability)  
 Select d.dealid,t.AsOfDate,(t.CumulativeProbability/100) as CumulativeProbability  
 From @tbl_ProjectedPayOffAccounting t  
 inner join cre.deal d on d.credealid = t.ControlId  
 where d.credealid = @CREDealID  
   
 exec [dbo].[usp_InsertProjectedPayOffDateByDealID] @TableTypeProjectedPayOffDate,@CreatedBy  
  
END  
  
  
--========================================================================  
exec  ('  
 IF EXISTS(select [name] from sys.external_data_sources where name = ''RemoteReference_ImportBSProd'')  
  Drop EXTERNAL DATA SOURCE RemoteReference_ImportBSProd   
 IF EXISTS(select [name] from sys.database_scoped_credentials where name = ''Credential_ImportBSProd'')  
  Drop DATABASE SCOPED CREDENTIAL Credential_ImportBSProd   
')  
  
  
  
Print('Underwriting data updated successfully.')  
  
  
  
  
  
--Select Distinct d.CREDealID,dealname,(CASE WHEN tblPIK.CREDealID is not null THEn 1 Else 0 end) IsPIKDeal,(CASE WHEN tbl_Y_Deal.dealid is not null THEn 'Y' Else 'N' end) UseRuletoDetermineNoteFunding  
--,'exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '''+d.CREDealID+''',''B0E6697B-3534-4C09-BE0A-04473401AB93'''  
--from cre.Note n  
--inner join cre.Deal d on n.DealID = d.DealID  
--inner join core.Account acc on acc.accountid = n.account_accountid  
--left join core.lookup l on l.lookupid = d.Status  
--left JOin(  
  
--Select Distinct credealid from(  
--  Select Distinct d.CREDealID,dealname,  
--  (CASE WHEN tblPIKNotes.credealid is not null then 1 else 0 end) as IsPIKDeal  
--  from cre.Note n  
--  inner join cre.Deal d on n.DealID = d.DealID  
--  inner join core.Account acc on acc.accountid = n.account_accountid  
--  left join core.lookup l on l.lookupid = d.Status  
--  LEFT JOIN(  
--   Select Distinct dealid,credealid   
--   from(  
--    Select n.crenoteid,d.dealid,d.credealid,  
--    (Select count(piks.StartDate) from Core.[PIKSchedule] piks  
--    inner join core.Event e on e.EventID = piks.EventId  
--    inner join core.Account acc on acc.AccountID = e.AccountID  
--    where e.EventTypeID = 12   
--    and acc.AccountID = n.account_accountid) PIKScheduleCnt  
--    from cre.Note n  
--    inner join cre.Deal d on n.DealID = d.DealID  
--    inner join core.Account acc on acc.accountid = n.account_accountid  
--    where acc.isdeleted <> 1  
--   )a  
--   where PIKScheduleCnt > 0  
  
--  )tblPIKNotes on tblPIKNotes.dealid = d.dealid  
--  where d.isdeleted <> 1 and acc.IsDeleted <> 1 and n.ActualPayoffDate is null  
--  and l.name = 'Active'  
-- )z where z.IsPIKDeal = 1  
  
--)tblPIK on tblPIK.CREDealID = d.credealid  
--Left Join(  
  
--Select Distinct d.dealid  
--from cre.Note n  
--inner join cre.Deal d on n.DealID = d.DealID  
--where UseRuletoDetermineNoteFunding = 3  
--)tbl_Y_Deal on tbl_Y_Deal.DealID = d.DealID  
  
--where d.isdeleted <> 1 and acc.IsDeleted <> 1 and n.ActualPayoffDate is null  
--and l.name = 'Active'  
  
  
END
GO

