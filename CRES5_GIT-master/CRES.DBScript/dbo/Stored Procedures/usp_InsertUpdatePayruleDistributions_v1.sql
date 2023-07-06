
CREATE PROCEDURE [dbo].[usp_InsertUpdatePayruleDistributions_v1] --'6d7be350-31ea-4455-b04a-733e107371d9','Null'
	@tbltype_PayRuleDist_V1 [tbltype_PayRuleDist_V1] READONLY,  
	@UpdatedBy nvarchar(256),
	@AnalysisID UNIQUEIDENTIFIER 
AS
 Begin




IF OBJECT_ID('tempdb..[#TablePayRuleDist]') IS NOT NULL                                         
	 DROP TABLE [#TablePayRuleDist]

CREATE TABLE [#TablePayRuleDist](
	[Date]            DATE             NULL,
	SourceNoteID NVARCHAR (256)   NULL,
	[Note] NVARCHAR (256)   NULL,
	[Type] NVARCHAR (256)   NULL,
	[value]          DECIMAL (28, 15) NULL,
	[Rate]          DECIMAL (28, 15) NULL,
	[EffectiveDate]          date null,
	[FeeName]         NVARCHAR (256)   NULL,

	SourceNoteGuiID UNIQUEIDENTIFIER   NULL,
	ChildNoteGuiID UNIQUEIDENTIFIER  NULL
	
)

INSERT INTO [#TablePayRuleDist](
[Date],
SourceNoteID,
[Note],
[Type],
[value],
[Rate],
[EffectiveDate],
[FeeName],
SourceNoteGuiID,
ChildNoteGuiID
)
Select 
t1.[Date],
t1.SourceNoteID,
t1.[Note], 
t1.[Type] as [Type],  --- + ' Strip'
t1.[value],
t1.[Rate],
t1.[EffectiveDate],
t1.[FeeName],
nS.NoteId as SourceNoteGuiID,
nC.NoteId as ChildNoteGuiID

from @tbltype_PayRuleDist_V1 t1
left join cre.note nS on nS.crenoteid = t1.SourceNoteID
left join cre.note nC on nC.crenoteid = t1.[Note]
inner join(
	Select SourceNoteID,MAX(EffectiveDate) max_EffectiveDate from @tbltype_PayRuleDist_V1
	group by SourceNoteID
)tmaxeff on t1.SourceNoteID = tmaxeff.SourceNoteID and t1.[EffectiveDate] = tmaxeff.max_EffectiveDate




delete CRE.PayruleDistributions where SourceNoteID in (Select Distinct SourceNoteGuiID from [#TablePayRuleDist])
and (AnalysisID = @AnalysisID or AnalysisID is null)




INSERT INTO CRE.PayruleDistributions  
(   
	TransactionDate,
	SourceNoteID,
	ReceiverNoteID,
	RuleID,
	Amount,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,
	FeeName,
	AnalysisID
 )  

select
distinct nc.[Date]
,nc.SourceNoteGuiID as SourceNoteID
,nc.ChildNoteGuiID  as StripTransferTo
,fsc.FeeTypeNameID as  RuleID
,nc.value  as Amount
,@UpdatedBy
,GETDATE()
,@UpdatedBy
,GETDATE()
,nc.FeeName
,@AnalysisID	
 
from [#TablePayRuleDist] nc
Inner join cre.feeschedulesconfig fsc on fsc.FeeTypeNameText = nc.Type 



--========================================================

-----Save coupon----------------------------
Declare @SourceNoteGUID UNIQUEIDENTIFIER
 
IF CURSOR_STATUS('global','CursorDealSourceNote')>=-1
BEGIN
	DEALLOCATE CursorDealSourceNote
END

DECLARE CursorDealSourceNote CURSOR 
for
(
	Select Distinct SourceNoteGuiID from [#TablePayRuleDist]
)
OPEN CursorDealSourceNote 
FETCH NEXT FROM CursorDealSourceNote
INTO @SourceNoteGUID

WHILE @@FETCH_STATUS = 0
BEGIN

	EXEC usp_InsertUpdateFeeCouponStripReceivableForPayruleSetup @SourceNoteGUID,@UpdatedBy,@AnalysisID
					 
FETCH NEXT FROM CursorDealSourceNote
INTO @SourceNoteGUID
END
CLOSE CursorDealSourceNote   
DEALLOCATE CursorDealSourceNote

-----------------------------------------------


-- set all dependent note as Processing   

  
IF EXISTS(select distinct SourceNoteGuiID from [#TablePayRuleDist])  
BEGIN    
	DECLARE @PriorityID INT  
	SET @PriorityID = (Select top 1 PriorityID FROM Core.CalculationRequests where AnalysisID = @analysisID and CalcType = 775 and NoteId in (select distinct SourceNoteGuiID from [#TablePayRuleDist]) )
 
	Update Core.CalculationRequests SET [StatusID] = 292 ,StartTime = null,Endtime = null , PriorityID = @PriorityID  
	where  AnalysisID = @analysisID  
	and noteid in (    
		SELECT NoteId FROM CORE.CalculationRequests    
		WHERE AnalysisID = @analysisID  
		and NoteId In  (select p.StripTransferTo from CRE.PayruleSetup p  where  p.StripTransferFrom in (select distinct SourceNoteGuiID from [#TablePayRuleDist]) )  
		and [StatusID] = 326  
		and CalcType = 775         
	)    
	and CalcType = 775        
END   



End
