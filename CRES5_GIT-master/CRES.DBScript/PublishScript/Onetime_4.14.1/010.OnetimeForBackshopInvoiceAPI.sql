IF NOT EXISTS(select 1 from app.InvoiceConfig where InvoiceTypeID=904)
BEGIN
	insert into app.InvoiceConfig (InvoiceTypeID,InvoiceCode,Template,IsApplySplit,InvoiceAccountNo)
	values(904,'Processing Fee','m61 invoice template',1,null)
END

if NOT EXISTS (select 1 from cre.QBAccountFinancingSourceMapping where InvoiceTypeID=904)
BEGIN
	insert into cre.QBAccountFinancingSourceMapping(FinancingSourceID,QBAccountNo,InvoiceTypeID,QBItemName)
	select FinancingSourceID,QBAccountNo,904,'Processing Fees' from cre.QBAccountFinancingSourceMapping where InvoiceTypeID=558
END