if not exists(select 1 from app.AppConfig where [Key]='EnableM61Calculator')
begin
insert into [App].[AppConfig] ([Key],	[Value],	Comments	) values('EnableM61Calculator',	0,	'Enable/Disable M61 Calculator'	)
end


