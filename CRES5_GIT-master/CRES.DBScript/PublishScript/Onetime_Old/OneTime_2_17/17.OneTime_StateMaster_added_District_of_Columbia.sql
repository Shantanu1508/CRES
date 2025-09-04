if not exists (select 1 from App.StatesMaster where StatesName = 'District of Columbia')
begin
Insert into  App.StatesMaster(CountryName,StatesName,StatesAbbreviation)
values('US','District of Columbia','DC')
end