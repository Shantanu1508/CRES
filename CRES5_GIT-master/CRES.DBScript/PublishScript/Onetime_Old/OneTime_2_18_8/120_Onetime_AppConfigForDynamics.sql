if not exists(select 1 from app.AppConfig where [Key]='UseDynamicsForInvoice')
begin
insert into app.AppConfig([Key],[Value],Comments) values('UseDynamicsForInvoice',0,'Enable/Disable invoice creation in dynamics 365')
end