Print('update script for servicer(wells/berkadia)')
 
update [CRE].[FileImportMaster] set FileName='Trial_Balance.xlsx' where FileImportMasterID=1
update [CRE].[FileImportMaster] set FileName='tbl_ACORE_Daily_Extract.zip' where FileImportMasterID=2