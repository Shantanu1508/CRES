

Print('ONe time for chatham config')
--777	32	1M USD SOFR
--837	32	SOFR
--838	32	3M Term SOFR

Truncate table [App].[ChathamConfig]

INSERT INTO [App].[ChathamConfig] ([URL],[RatesCode],[IndexTypeID],[IndexesMasterGuid],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[Description])
VALUES('https://www.chathamfinancial.com/getrates/','167949',837,'80DF3B15-8E57-4A13-94BE-C10489461A89',1,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'Default Index - SOFR')

INSERT INTO [App].[ChathamConfig] ([URL],[RatesCode],[IndexTypeID],[IndexesMasterGuid],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[Description])
VALUES('https://www.chathamfinancial.com/getrates/','297760',777,'80DF3B15-8E57-4A13-94BE-C10489461A89',1,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'Default Index - 1M Term SOFR')

INSERT INTO [App].[ChathamConfig] ([URL],[RatesCode],[IndexTypeID],[IndexesMasterGuid],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[Description])
VALUES('https://www.chathamfinancial.com/getrates/','347524',838,'80DF3B15-8E57-4A13-94BE-C10489461A89',1,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'Default Index - 3M USD SOFR')

