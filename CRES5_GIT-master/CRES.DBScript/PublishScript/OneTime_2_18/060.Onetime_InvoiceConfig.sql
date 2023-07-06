truncate table app.InvoiceConfig
go
insert into app.InvoiceConfig
select LookupID,case when LookupID = 558 then 'Draw Fees' else Name end,'m61 invoice template' from core.lookup where parentid=94