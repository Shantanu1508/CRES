
Print('One time VMMaster')
go
Truncate table [App].[VMMaster]
INSERT INTO [App].[VMMaster] (VMName,IsActive,[Status]) VALUES('NonProdExcelServer01',1,'STOP')
INSERT INTO [App].[VMMaster] (VMName,IsActive,[Status]) VALUES('ProdExcelServer02',1,'STOP')
