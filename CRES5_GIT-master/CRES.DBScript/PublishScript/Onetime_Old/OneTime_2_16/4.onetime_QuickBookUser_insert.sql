truncate table app.QuickBookUser
--for integration
if not exists(select 1 from app.QuickBookUser where AgentToken ='0S6UPXUS2ALXY312NSNED9VSK5A4')
begin
insert into app.QuickBookUser(AgentToken,CompanyId,ExternalId,ID,isActive) values('0S6UPXUS2ALXY312NSNED9VSK5A4','M61-QA','','6b4bc674c4c84cba916fcb27971d29b6',1)
end

/*
--for production
if not exists(select 1 from app.QuickBookUser where AgentToken ='DT44IRDQLIA6W7F2Z6RZ3VOM6ABT')
begin
insert into app.QuickBookUser(AgentToken,CompanyId,ExternalId,ID,isActive) values('DT44IRDQLIA6W7F2Z6RZ3VOM6ABT','ACORE Capital, LP','','5aab6e78069c4fdc93cb66af32118d07',1)
end
*/