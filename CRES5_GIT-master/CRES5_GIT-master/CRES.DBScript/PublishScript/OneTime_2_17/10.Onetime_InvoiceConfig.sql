-- 558-Draw Fee from lookup
if not exists(select 1 from [App].[InvoiceConfig] where [InvoiceTypeID]=558)
begin
  insert into  [App].[InvoiceConfig]([InvoiceTypeID],InvoiceCode,[Template]) values (558,'Draw Fees','m61 invoice template')
end