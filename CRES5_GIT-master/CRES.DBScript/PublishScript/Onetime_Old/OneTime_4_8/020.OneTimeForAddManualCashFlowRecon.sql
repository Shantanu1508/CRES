
IF NOT EXISTS(Select ServicerName from cre.ServicerMaster where ServicerName = 'ManualCashFlowRecon')
BEGIN
	Insert into cre.ServicerMaster(ServicerName,Staus,ServicerDisplayName)values('ManualCashFlowRecon',1,'ManualCashFlowRecon')
END