CREATE View [dbo].[Receiver_Stripping]
as
Select  
 PayruleSetupID
 , Payruledistributionsid
 , CreNoteid
 ,Value
 , TransactionDate
 , Amount 
 , Analysisid 
 ,Exitfeestrip= Case when Pd.RuleID = 164 then 'ExitfeeStripping' End
 , Addfeestrip= Case when Pd.RuleID = 165 then 'AdditionalfeeStripping' End
 from
 [CRE].[PayruleDistributions] PD
Left join [CRE].[PayruleSetup] PS  on Ps.[StripTransferto] = PD.ReceiverNoteID
Left Join Cre.Note n on N.NoteID = PS.[StripTransferto]
where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 








