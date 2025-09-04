update App.ChathamConfig set 
URL ='https://www.cmegroup.com/services/sofr-strip-rates/' 
where FrequencyType='DailyRate'


 insert into App.ChathamConfig(
URL	
,RatesCode	
,IndexTypeID	
,IndexesMasterGuid	
,Description	
,IsActive	
,CreatedBy	
,CreatedDate	
,UpdatedBy	
,UpdatedDate	
,FrequencyType
)
values 
(
'https://www.chathamfinancial.com/getrates/'
,23710
,878
,'80DF3B15-8E57-4A13-94BE-C10489461A89'
,'PRIME'
,1
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,getdate()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,getdate()
,'DailyRate'
)
 