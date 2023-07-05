truncate table app.QuickBookCompany
--for integration
if not exists(select * from app.QuickBookCompany where name ='M61-QA')
begin
insert into app.QuickBookCompany (name,endpointid,autofycompanyid,createdby,createdDate,UpdatedBy,UpdatedDate,IsActive)
values ('M61-QA','fd9d849f22524cf2889ef763056a759b','ffacbd0dc67f482c88b135d677fedfbe','',getdate(),'',getdate(),1)
end

/*
--for production
if not exists(select * from app.QuickBookCompany where name ='ACORE Capital, LP')
begin
insert into app.QuickBookCompany (name,endpointid,autofycompanyid,createdby,createdDate,UpdatedBy,UpdatedDate,IsActive)
values ('ACORE Capital, LP','e276f8a9b30a4f8ca8417b29807d1932','52cb460c16434003b4e1e37a8b54cd0a','',getdate(),'',getdate(),1)
end
*/