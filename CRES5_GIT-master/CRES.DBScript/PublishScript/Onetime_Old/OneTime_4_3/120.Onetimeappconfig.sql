IF NOT EXISTS(select * from app.appconfig where [key] = 'CutOffDate_BackshopExport')
BEGIN
	Insert into app.appconfig([key],[value],comments)VALUES('CutOffDate_BackshopExport','12/31/2019','Cutoff date for export backshop data')
END

--update app.[appconfig] set [value] = '1/1/1900' where [key] = 'CutOffDate_BackshopExport'