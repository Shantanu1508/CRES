CREATE View [dbo].[ExitFeeNoteSetupDetail]
As
Select 
nn.crenoteid
,e.EffectiveStartDate as EffectiveDate
,pafs.FeeName
,pafs.[StartDate] as [StartDate]
,pafs.EndDate as [EndDate]
,LValueTypeID.FeeTypeNameText as FeeType
,pafs.[Value] as [Value]
,pafs.FeeAmountOverride
,pafs.BaseAmountOverride
,LApplyTrueUpFeature.[Name] as ApplyTrueUpFeature
,pafs.[IncludedLevelYield]
,pafs.FeetobeStripped
from [CORE].PrepayAndAdditionalFeeSchedule pafs
INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId
LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature
INNER JOIN 
			(
						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
					and acc.IsDeleted = 0
					GROUP BY n.Account_AccountID,EventTypeID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
left join cre.note nn on nn.account_accountid = e.accountid 

where e.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
and  Valuetypeid =1






