if not exists(select 1 from [App].[ModuleTabMaster] where ModuleTabName='Deal_FeeInvoice')
begin
insert into [App].[ModuleTabMaster] Values('Deal_FeeInvoice',42,1,null,null,null,null,2,'Deal_FeeInvoice','Tab')
end
