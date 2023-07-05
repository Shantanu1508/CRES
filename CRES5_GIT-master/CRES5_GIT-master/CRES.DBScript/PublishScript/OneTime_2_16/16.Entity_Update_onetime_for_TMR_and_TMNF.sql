update  [CRE].[ClientTrancheMapping] set [IsDeleted]=0
go
update  [CRE].[ClientTrancheMapping] set [IsDeleted]=1 where TrancheName='TMR'
go
update  [CRE].[ClientTrancheMapping] set [TrancheName] ='TMD-DL' where TrancheName='TMNF'
