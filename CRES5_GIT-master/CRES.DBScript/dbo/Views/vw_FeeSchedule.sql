-- View  
Create View dbo.vw_FeeSchedule  
as  
  
Select   
DealID as DealKey  
,NoteID as NoteKey  
,DealName  
,CREDealID as DealID  
,CRENoteID as NoteID  
,NoteName  
,EffectiveDate  
,StartDate  
,EndDate  
,Value as Fee  
,IncludedLevelYield  
,ValueTypeText as FeeType  
,FeeName  
,FeeAmountOverride  
,BaseAmountOverride  
,ApplyTrueUpFeatureText as ApplyTrueUpFeature  
,FeetobeStripped  
,FinancingSourceName  
,ScheduleText  
,(select [Value]+'#/dealdetail/'+CREDealID from app.appconfig where [key]='M61BaseUrl')  as DealUrl

From [DW].[PrepayAndAdditionalFeeScheduleBI]  
Where ScheduleText = 'Latest Schedule'


