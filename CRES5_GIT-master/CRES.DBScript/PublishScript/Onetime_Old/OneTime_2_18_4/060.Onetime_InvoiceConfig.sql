truncate table app.InvoiceConfig
go
insert into app.InvoiceConfig(InvoiceTypeID,InvoiceCode,Template)
select LookupID,case when LookupID = 558 then 'Draw Fees' else Name end,'m61 invoice template' from core.lookup where (parentid=94 or parentid=126)

go

update app.InvoiceConfig set IsApplySplit=0




