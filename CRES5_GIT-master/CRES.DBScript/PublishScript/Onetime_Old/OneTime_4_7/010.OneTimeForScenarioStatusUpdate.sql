Update [Core].[Analysis] SET [ScenarioStatus]=1


go
IF not EXISTS(Select * from [App].[AppConfig] where [Key] = 'CalculateXIRRAfterDealSave')
BEGIN
	INSERT [App].[AppConfig] ([Key], [Value], [Comments], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (N'CalculateXIRRAfterDealSave', N'0', N'CalculateXIRRAfterDealSave', NULL, NULL, NULL, NULL)
END


go


Update CRE.TransactionTypes set XIRRCategory = 'Other'
Update CRE.TransactionTypes set XIRRCategory = 'Fees' Where TransactionName = 'AccruedInterestSuspense' 
Update CRE.TransactionTypes set XIRRCategory = 'Interest' Where TransactionName = 'FloatInterest' 
Update CRE.TransactionTypes set XIRRCategory = 'Interest' Where TransactionName = 'InterestPaid' 
Update CRE.TransactionTypes set XIRRCategory = 'Interest' Where TransactionName = 'PIKInterest' 
Update CRE.TransactionTypes set XIRRCategory = 'Interest' Where TransactionName = 'PIKInterestPaid' 
Update CRE.TransactionTypes set XIRRCategory = 'Interest' Where TransactionName = 'PurchasedInterest' 
Update CRE.TransactionTypes set XIRRCategory = 'Interest' Where TransactionName = 'StubInterest' 
Update CRE.TransactionTypes set XIRRCategory = 'Principal' Where TransactionName = 'AccruedExitFeeSuspense' 
Update CRE.TransactionTypes set XIRRCategory = 'Interest' Where TransactionName = 'AccruedExtensionFeeSuspense' 
Update CRE.TransactionTypes set XIRRCategory = 'Misc CF' Where TransactionName = 'AccruedPrepaymentFeeSuspense' 
Update CRE.TransactionTypes set XIRRCategory = 'Exit Fees' Where TransactionName = 'AccruedScheduledPrincipalPaidSuspense' 

go



Update [CORE].PikSchedule set PIKSetUp = 871 where PikScheduleID in (
	Select pik.PikScheduleID  ---,n.crenoteid,pik.PIKSetUp
	from [CORE].PikSchedule pik   
	INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where   acc.IsDeleted <> 1
)
go

Update cre.note set PIKSeparateCompounding = 4 where noteid in (
	Select n.NoteID
	from [CORE].PikSchedule pik   
	INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where   acc.IsDeleted <> 1 and n.PIKSeparateCompounding is null

)