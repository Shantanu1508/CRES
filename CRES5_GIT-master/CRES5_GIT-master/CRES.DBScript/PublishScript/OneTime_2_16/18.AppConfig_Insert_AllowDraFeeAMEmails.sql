if not exists(select 1 from  app.AppConfig where [key]='AllowDrawFeeAMEmail')
begin
		insert into app.AppConfig([Key],[Value],Comments) values ('AllowDrawFeeAMEmail',1,'draw fee deal specific AM email ids and group email id')
end