
Print('Onetime ReportFile')

Update  [App].[ReportFile] set [DownloadFileName] = ReportFileName
Update  [App].[ReportFile] set [DownloadFileName] = 'ACR_Position' Where ReportFileName = 'Aflac TRE Positions'
Update  [App].[ReportFile] set [DownloadFileName] = 'ACR_Transaction' Where ReportFileName = 'Aflac ACR Transaction'
Update  [App].[ReportFile] set [DownloadFileName] = 'ACR_MISCCASH' Where ReportFileName = 'Aflac TRE Misc'