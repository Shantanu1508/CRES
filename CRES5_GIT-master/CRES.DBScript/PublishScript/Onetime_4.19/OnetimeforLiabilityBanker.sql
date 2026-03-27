truncate table [CRE].[LiabilityBanker]    


insert into  [CRE].[LiabilityBanker]  (BankerName) values('Capital One')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Morgan Stanley')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Wells Fargo')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Customers')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Axos')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('TP')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('JP Morgan')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Blackstone')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Goldman Sachs')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Aksia')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Churchill')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Sunwest')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Deutsche Bank')
insert into  [CRE].[LiabilityBanker]  (BankerName) values('Prime Finance')


 update  [CRE].[LiabilityBanker] set  
  CreatedBy	='B0E6697B-3534-4C09-BE0A-04473401AB93',CreatedDate=getdate(),	UpdatedBy='B0E6697B-3534-4C09-BE0A-04473401AB93',	UpdatedDate=getdate()



update  cre.Debt  set LiabilityBankerID = 1 where  DebtID =  74
update  cre.Debt  set LiabilityBankerID = 2 where  DebtID =  75
update  cre.Debt  set LiabilityBankerID = 3 where  DebtID =  76
update  cre.Debt  set LiabilityBankerID = 4 where  DebtID =  77
update  cre.Debt  set LiabilityBankerID = 5 where  DebtID =  78
update  cre.Debt  set LiabilityBankerID = 6 where  DebtID =  79
update  cre.Debt  set LiabilityBankerID = 7 where  DebtID =  83
update  cre.Debt  set LiabilityBankerID = 8 where  DebtID =  84
update  cre.Debt  set LiabilityBankerID = 7 where  DebtID =  85
update  cre.Debt  set LiabilityBankerID = 9 where  DebtID =  86
update  cre.Debt  set LiabilityBankerID = 10 where  DebtID =  88
update  cre.Debt  set LiabilityBankerID = 11 where  DebtID =  89
update  cre.Debt  set LiabilityBankerID = 12 where  DebtID =  90
update  cre.Debt  set LiabilityBankerID = 12 where  DebtID =  91
update  cre.Debt  set LiabilityBankerID = 2 where  DebtID =  93
update  cre.Debt  set LiabilityBankerID = 9 where  DebtID =  94
update  cre.Debt  set LiabilityBankerID = 14 where  DebtID =  95
update  cre.Debt  set LiabilityBankerID = 13 where  DebtID =  97
update  cre.Debt  set LiabilityBankerID = 5 where  DebtID =  98
update  cre.Debt  set LiabilityBankerID = 3 where  DebtID =  99
update  cre.Debt  set LiabilityBankerID = 12 where  DebtID =  100
update  cre.Debt  set LiabilityBankerID = 1 where  DebtID =  101

 
 
