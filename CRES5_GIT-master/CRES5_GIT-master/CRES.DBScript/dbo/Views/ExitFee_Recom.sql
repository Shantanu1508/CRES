CREATE View [dbo].[ExitFee_Recom]
AS

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
,ValueTypeid
, nn.TotalCommitment
, x.ExitFees

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

Left join (Select Crenoteid ,ExitFees, analysisid, Type, Feename from ExitFee_TotalCommitment E
			)x
			on x.Crenoteid = nn.Crenoteid and x.Feename = pafs.Feename
--Left Join (Select CreNoteid, Analysisid, Amount as Balloon, type from CRe.TransactionEntry T
--			inner join CRe.Note n on n.Noteid = T.Noteid
--			)y
--			on Y.creNoteid = nn.creNoteid 

where e.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
--and nn.crenoteid = '4048'



AND pafs.fEEnAME = ( sELECT   cASE WHEN   EXISTS (sELECT FeeName
											from  [CORE].PrepayAndAdditionalFeeSchedule pafs1
											INNER JOIN [CORE].[Event] e on e.EventID = pafs1.EventId
											Inner join CRE.Note N on N.Account_AccountID = E.Accountid 
											WHERE NN.cRENOTEID = N.cRENOTEID 
											AND pafs1.VALUETYPEID = pafs.vALUETYPEID
											--AND pafs1.sTARTdATE = pafs.sTARTDATE 
											--AND pafs1.eNDDATE = pafs.eNDDATE 
											AND pafs1.FeeNamE = 'Exit Fee #2'  
											
											--and pafs.FeeName = 'Exit Fee #2'
											) 
											
											
			Then 'Exit Fee #2' 

			eLSE 'Exit Fee #1'
			 End
				)
				and X.Type = 'ExitfeeExcludedFromLevelYield' and x.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				--and y.Type = 'Balloon' and y.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				--and   T.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
				--order by feename

