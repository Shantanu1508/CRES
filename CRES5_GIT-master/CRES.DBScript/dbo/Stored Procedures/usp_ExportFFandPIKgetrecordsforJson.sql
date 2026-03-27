CREATE PROCEDURE [dbo].[usp_ExportFFandPIKgetrecordsforJson]     
(    
 @DealID nvarchar(256),    
 @NoteID nvarchar(256),     
 @userName nvarchar(256),     
 @flag nvarchar(10)    
)    
AS    
BEGIN    
    
Declare @CRENoteId nvarchar(256)    
    
IF(@flag = 'FF')    
BEGIN     
 select    
 GeneratedByText as GeneratedBy    
 ,Comments as CommentsShort    
 ,null as FundingLBLock    
 ,null as NoteFundingReasonCD_F    
 ,CRENoteID as ParentID    
 ,CRENoteID as Noteid_F    
 ,Applied    
 ,FundingDate    
 ,FundingAmount    
 ,FundingPurpose as FundingPurposeCD_F    
 ,null as FundingExpense    
 ,Comments    
 ,WireConfirm    
 ,AuditUserName    
 ,WF_CurrentStatus as [Status]    
 ,'Funding' as [Type]    
 ,IsProjectedPaydown    
 ,IsDeleted    
 ,FF_BlankJson    
 ,AdjustmentType
 ,FundingAdjustmentTypeCd_F
 From [IO].[out_FutureFunding]    
 where [Status] = 'ReadyForExport'    
 and DealID = @DealID ---and [AuditUserName] = @userName    
END    
ELSE IF(@flag = 'PIK')    
BEGIN    
    
     
 SET @CRENoteId = (Select crenoteid from cre.note where noteid = @noteid)    
    
 select    
 null as GeneratedBy    
 ,Comments as CommentsShort    
 ,null as FundingLBLock    
 ,null as NoteFundingReasonCD_F    
 ,CRENoteID as ParentID    
 ,CRENoteID as Noteid_F    
 ,Applied    
 ,FundingDate    
 ,FundingAmount    
 ,FundingPurpose as FundingPurposeCD_F    
 ,null as FundingExpense    
 ,Comments    
 ,WireConfirm    
 ,AuditUserName    
 ,WF_CurrentStatus as [Status]    
 ,'PIK' as [Type]    
 ,CAST(0 as bit) as IsProjectedPaydown     
 ,IsDeleted     
 ,0 as FF_BlankJson 
 ,null as AdjustmentType
 ,null as FundingAdjustmentTypeCd_F
 From [IO].[out_PIKPrincipalFunding]    
 where [Status] = 'ReadyForExport'    
 and FundingPurpose in ('PIKNC','PIKPP')    
 and CRENoteID = @CRENoteId ---and [AuditUserName] = @userName    
    
END    
--ELSE IF(@flag = 'Balloon')    
--BEGIN    
    
     
-- SET @CRENoteId = (Select crenoteid from cre.note where noteid = @noteid)    
    
-- select    
-- null as GeneratedBy    
-- ,Comments as CommentsShort    
-- ,null as FundingLBLock    
-- ,null as NoteFundingReasonCD_F    
-- ,CRENoteID as ParentID    
-- ,CRENoteID as Noteid_F    
-- ,Applied    
-- ,FundingDate    
-- ,FundingAmount    
-- ,'BALLOON' as FundingPurposeCD_F    
-- ,null as FundingExpense    
-- ,Comments    
-- ,WireConfirm    
-- ,AuditUserName    
-- ,WF_CurrentStatus as [Status]    
-- ,'BALLOON' as [Type]    
-- ,CAST(0 as bit) as IsProjectedPaydown     
-- ,IsDeleted     
-- ,0 as FF_BlankJson    
-- ,null as AdjustmentType
-- ,null as FundingAdjustmentTypeCd_F
-- From [IO].[out_PIKPrincipalFunding]    
-- where [Status] = 'ReadyForExport'    
-- and FundingPurpose in ('Balloon')    
-- and CRENoteID = @CRENoteId ---and [AuditUserName] = @userName    
    
--END    
     
     
    
END    
    
    