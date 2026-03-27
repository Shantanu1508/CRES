
Update [CORE].PrepayAndAdditionalFeeSchedule set [CORE].PrepayAndAdditionalFeeSchedule.Value = a.Value
From(
	Select PrepayAndAdditionalFeeScheduleID,n.crenoteid,(pafs.Value * -1) as  [Value]
	from [CORE].PrepayAndAdditionalFeeSchedule pafs  
	INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId  
	LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID    
	LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature   
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	Inner join cre.deal d on d.dealid= n.dealid
	where e.StatusID = 1 and LValueTypeID.FeeTypeNameText = 'ACORE Orig Fee'
	and pafs.Value > 0
	---and n.crenoteid <> '11838'
)a
where [CORE].PrepayAndAdditionalFeeSchedule.PrepayAndAdditionalFeeScheduleID = a.PrepayAndAdditionalFeeScheduleID
