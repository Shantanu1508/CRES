CREATE View [dbo].[Fee_Payrules]  
AS  
Select   
SourceNote  
,ReceiverNote  
,PayruleSetupID  
 , Payruledistributionsid  
 ,Value  
 , TransactionDate  
 , Amount   
 , Analysisid   
 ,Case when Ps.RuleID = 1 then 'Exit Fee Strip'  
  When Ps.RuleID =  4 Then 'Origination Fee Strip'  
  When Ps.Ruleid = 3 then 'Extension Fee_COMM Strip'   
  when Ps.RuleID = 10 then 'Blank'  
  When PS.RuleID = 11 then 'Extension Fee_UPB Strip'  
  End as Type  
 , DealID  
    
   
 from [CRE].[PayruleDistributions] PD  
Left Join [CRE].[PayruleSetup] PS on PS.StripTransferFrom = PD.SourceNoteID  
and PS.StripTransferTo = PD.ReceiverNoteid  
Outer Apply (Select CreNoteid SourceNote from Cre.Note  
   Where PD.SourceNoteID = Noteid)X  
  
Outer Apply (  
   Select CreNoteid ReceiverNote from Cre.Note  
   Where PD.ReceiverNoteid = Noteid  
  
   )y  
   wHERE AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
  
