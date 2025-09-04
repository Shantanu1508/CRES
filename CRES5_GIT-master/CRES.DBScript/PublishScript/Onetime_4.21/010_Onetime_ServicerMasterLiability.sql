IF NOT EXISTS(select 1 from [CRE].[ServicerMasterLiability] where [ServicerName]='ManualTransactionLiability')
BEGIN
    INSERT INTO [CRE].[ServicerMasterLiability]
           ([ServicerName]
           ,[Staus]
           ,[ServicerDisplayName]
           ,[ServicerNamecss]
           ,[ServicerFile]
           ,[DownloadDisplayName])
     VALUES
           (
		    'ManualTransactionLiability'
           ,1
           ,'Manual Transaction'
           ,null
           ,'Manual Transaction File Liability Template.xlsx'
           ,'Manual Transaction File Template'
		   )
END