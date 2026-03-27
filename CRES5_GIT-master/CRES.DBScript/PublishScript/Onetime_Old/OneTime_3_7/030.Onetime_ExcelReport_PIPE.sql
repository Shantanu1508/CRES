
--select * from app.ReportFile where ReportFileID in (1,2,7)
--select * from app.ReportFileSheet where ReportFileID in (1,2,7)

update app.ReportFileSheet set SheetName='Aflac TRE Misc' where ReportFileID =1
update app.ReportFileSheet set SheetName='Aflac TRE Positions' where ReportFileID =2
update app.ReportFileSheet set SheetName='Aflac ACR Transaction' where ReportFileID =7

update app.ReportFile set ReportFileFormat='CSVPIPE' where ReportFileID in (1,2,7)
