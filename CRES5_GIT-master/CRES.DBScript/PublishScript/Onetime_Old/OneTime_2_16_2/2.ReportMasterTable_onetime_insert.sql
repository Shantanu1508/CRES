--update app.reportfile set [status]=1 
--select * from app.reportfile
--select * from app.reportfilesheet
--select * from app.reportfilelog
truncate table app.reportfilesheet
delete from app.reportfile
DBCC CHECKIDENT ('app.reportfile', RESEED, 0);
go
INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Aflac TRE Misc'
           ,'CSV'
           ,'001_Aflac_TRE Misc.csv'
           ,'001_Aflac_TRE Misc.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Daily'
           ,1
		 --  ,'{"Root": {
			--	"001_Aflac_TRE Misc": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}' 
		   )
GO

INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Aflac TRE Positions'
           ,'CSV'
           ,'002_Aflac_TREPositions.csv'
           ,'002_Aflac_TREPositions.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Daily'
           ,1
		 --  ,'{"Root": {
			--	"002_Aflac_TREPositions": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}'
		   )
		   GO

INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Aflac ACR Pricing'
           ,'CSV'
           ,'003_14_Aflac_ACR_PricingME20200131.csv'
           ,'003_14_Aflac_ACR_PricingME20200131.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Daily'
           ,1
		  -- ,'{"Root": {
				--	"003_14_Aflac_ACR_PricingME20200131": {
				--		"CLIENT_ID": "ACR003419",
				--		"SOURCE": "ACR"
				--	}
				--}}'
			)
		   GO

INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Aflac ACR_Disclosure'
           ,'XLSX'
            ,'005_16_Aflac_ACR_DisclosureME20200131.xlsx'
           ,'005_16_Aflac_ACR_DisclosureME20200131.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Daily'
           ,1
		 --  ,'{"Root": {
			--	"TRE ACR": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	},
			--	"AFLAC US": { 
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}'
		   )
go
INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Aflac TRE Cancel'
           ,'CSV'
            ,'AFlac_TRE365cancel.csv'
           ,'AFlac_TRE365cancel.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Daily'
           ,1
		 --  ,'{"Root": {
			--	"TRE ACR": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	},
			--	"AFLAC US": { 
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}'
		   )
		   go
INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Aflac ACR Interest Payment'
           ,'CSV'
            ,'Aflac_ACR_410InterestPayment.csv'
           ,'Aflac_ACR_410InterestPayment.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Daily'
           ,1
		 --  ,'{"Root": {
			--	"TRE ACR": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	},
			--	"AFLAC US": { 
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}'
		   )
		   go
		   INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Aflac ACR Transaction'
           ,'CSV'
            ,'Aflac_ACR_365Transaction.csv'
           ,'Aflac_ACR_365Transaction.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Daily'
           ,1
		 --  ,'{"Root": {
			--	"TRE ACR": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	},
			--	"AFLAC US": { 
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}'
		   )
	go
		   INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Aflac ACR Interest Accrual'
           ,'CSV'
            ,'Aflac_ACR_409InterestAccrual.csv'
           ,'Aflac_ACR_409InterestAccrual.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Daily'
           ,1
		 --  ,'{"Root": {
			--	"TRE ACR": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	},
			--	"AFLAC US": { 
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}'
		   )
		    INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Delphi Transactions'
           ,'XLSX'
            ,'Delphi_Transactions.xlsx'
           ,'Delphi_Transactions.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Daily'
           ,1
		 --  ,'{"Root": {
			--	"TRE ACR": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	},
			--	"AFLAC US": { 
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}'
		   )
           INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('Delphi Fixed Rate Amortized Cost'
           ,'XLSX'
            ,'Delphi_Fixed Rate_Amortized_Cost.xlsx'
           ,'Delphi_Fixed Rate_Amortized_Cost.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Monthly'
           ,1
		 --  ,'{"Root": {
			--	"TRE ACR": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	},
			--	"AFLAC US": { 
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}'
		   )

           go

INSERT INTO [App].[ReportFile]
           ([ReportFileName]
           ,[ReportFileFormat]
           ,[ReportFileTemplate]
           ,[ReportFileJSON]
           ,[SourceStorageTypeID]
           ,[SourceStorageLocation]
           ,[DestinationStorageTypeID]
           ,[DestinationStorageLocation]
           ,[Status]
           ,[Frequency]
           ,[FrequencyStatus]
		   --,[DefaultAttributes]
		   )
     VALUES
           ('zDraft - Portfolio Investment Activity'
           ,'XLSX'
            ,'Portfolio_Investment_Activity.xlsx'
           ,'Portfolio_Investment_Activity.json'
           ,392
           ,'AcoreReportTemplates'
           ,392
           ,'AcoreReports'
           ,1
           ,'Monthly'
           ,1
		 --  ,'{"Root": {
			--	"TRE ACR": {
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	},
			--	"AFLAC US": { 
			--		"CLIENT_ID": "ACR003419",
			--		"SOURCE": "ACR"
			--	}
			--}}'
		   )


--insert to [ReportFileSheet]


INSERT INTO [App].[ReportFileSheet]
           ([ReportFileID]
           ,[SheetName]
           ,[DataSourceProcedure]
		   ,[IsIncludeHeader])
     VALUES
           (1
           ,'001_Aflac_TRE Misc'
           ,'usp_GetAflac_TREMisc'
		   ,1)
GO
INSERT INTO [App].[ReportFileSheet]
           ([ReportFileID]
           ,[SheetName]
           ,[DataSourceProcedure]
		   ,[IsIncludeHeader])
     VALUES
           (2
           ,'002_Aflac_TREPositions'
           ,'usp_GetAflac_TREPositions'
		   ,1)
GO
INSERT INTO [App].[ReportFileSheet]
           ([ReportFileID]
           ,[SheetName]
           ,[DataSourceProcedure]
		   ,[IsIncludeHeader])
     VALUES
           (3
           ,'003_14_Aflac_ACR_PricingME20200131'
           ,'usp_GetAflac_ACR_Pricing'
		   ,1)
GO
INSERT INTO [App].[ReportFileSheet]
           ([ReportFileID]
           ,[SheetName]
           ,[DataSourceProcedure]
		   ,[HeaderPOsition]
		   ,[IsIncludeHeader]
		   )
     VALUES
           (4
           ,'TRE ACR'
           ,'usp_Get_TREACR_DisclosureME'
		   ,7
		   ,0)

GO
INSERT INTO [App].[ReportFileSheet]
           ([ReportFileID]
           ,[SheetName]
           ,[DataSourceProcedure] 
		   ,[HeaderPOsition]
		   ,[IsIncludeHeader]
		   )
     VALUES
           (4
           ,'AFLAC US'
           ,'usp_Get_AFLAC_DisclosureME'
		   ,7
		   ,0)
GO
		INSERT INTO [App].[ReportFileSheet]
		([ReportFileID]
		,[SheetName]
		,[DataSourceProcedure] 
		,[HeaderPOsition]
		,[IsIncludeHeader]
		)
     VALUES
           (5
           ,'AFlac_TRE365cancel'
           ,'usp_Get_AFlac_TREcancel'
		   ,0
		   ,1)
GO
	INSERT INTO [App].[ReportFileSheet]
	([ReportFileID]
	,[SheetName]
	,[DataSourceProcedure] 
	,[HeaderPOsition]
	,[IsIncludeHeader]
	)
     VALUES
           (6
           ,'Aflac_ACR_410InterestPayment'
           ,'usp_GetAflac_ACR_InterestPayment'
		   ,0
		   ,1)
GO
	INSERT INTO [App].[ReportFileSheet]
	([ReportFileID]
	,[SheetName]
	,[DataSourceProcedure] 
	,[HeaderPOsition]
	,[IsIncludeHeader]
	)
     VALUES
           (7
           ,'Aflac_ACR_365Transaction'
           ,'usp_GetAflac_ACR_Transaction'
		   ,0
		   ,1)
GO
	INSERT INTO [App].[ReportFileSheet]
	([ReportFileID]
	,[SheetName]
	,[DataSourceProcedure] 
	,[HeaderPOsition]
	,[IsIncludeHeader]
	)
     VALUES
           (8
           ,'Aflac_ACR_409InterestAccrual'
           ,'usp_GetAflac_ACR_InterestAccrual'
		   ,0
		   ,1)
GO
	INSERT INTO [App].[ReportFileSheet]
	([ReportFileID]
	,[SheetName]
	,[DataSourceProcedure] 
	,[HeaderPOsition]
	,[IsIncludeHeader]
	)
     VALUES
           (9
           ,'Delphi Transactions'
           ,'usp_GetDelphiTransactionsReport'
		   ,2
		   ,0)
           INSERT INTO [App].[ReportFileSheet]
	([ReportFileID]
	,[SheetName]
	,[DataSourceProcedure] 
	,[HeaderPOsition]
	,[IsIncludeHeader]
	)
     VALUES
           (10
		   ,'Delphi Fixed Rate Amort Cost'
           ,'usp_GetDelphiFixedRateAmortizedCost'
		   ,6
		   ,0)
           go
            INSERT INTO [App].[ReportFileSheet]
	([ReportFileID]
	,[SheetName]
	,[DataSourceProcedure] 
	,[HeaderPOsition]
    ,[IsIncludeHeader]
    ,[AdditionalParameters]
	)
     VALUES
           (11
           ,'Q Activity Detail'
           ,'usp_Get_QuarterlyPortfolioInvestmentActivity'
		   ,6
           ,1
           ,'StartDate|B,Enddate|B')
go
 INSERT INTO [App].[ReportFileSheet]
	([ReportFileID]
	,[SheetName]
	,[DataSourceProcedure] 
	,[HeaderPOsition]
    ,[IsIncludeHeader]
    ,[AdditionalParameters]
	)
     VALUES
           (11
           ,'Q Transacton Detail'
           ,'usp_Get_QuarterlyPortfolioTransactionDetailActivity'
		   ,7
           ,0
           ,'StartDate|B,Enddate|B')



--update [App].[ReportFileSheet] set isincludeheader=1 where reportfileid in (select reportfileid from app.reportfile where reportfileformat='CSV')
--update [App].[ReportFileSheet] set isincludeheader=0 where reportfileid in (select reportfileid from app.reportfile where reportfileformat='XLSX')
--update [App].[ReportFileSheet] set isincludeheader=1 where reportfileid =11
--update [App].[ReportFileSheet] set isincludeheader=0 where REportFileSheetID =13 

update [App].[ReportFile] set IsAllowInput=0 
update [App].[ReportFile] set IsAllowInput=1 where ReportFileID=11


