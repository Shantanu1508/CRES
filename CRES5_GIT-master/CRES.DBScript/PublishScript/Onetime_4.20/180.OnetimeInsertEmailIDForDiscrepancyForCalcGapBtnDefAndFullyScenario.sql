IF NOT EXISTS (Select * from app.EmailNotification Where ModuleId = 936)
BEGIN

	INSERT INTO app.EmailNotification ([EmailId],[ModuleId],[Status],[Type]) VALUES
	('rsahu@hvantage.com',936,1,782),
	('akothari@hvantage.com',936,1,782),

	('vbalapure@hvantage.com',936,1,783),
	('msingh@hvantage.com',936,1,783),
	('ssingh@hvantage.com',936,1,783),
	('rsingh@hvantage.com',936,1,783);

END