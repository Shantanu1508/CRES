
 
update App.ChathamConfig set FrequencyType='DailyRate'

go
INSERT INTO [App].[ChathamConfig]

           ([URL]

           ,[RatesCode]

           ,[IndexTypeID]

           ,[IndexesMasterGuid]

           ,[Description]

           ,[IsActive]

           ,[CreatedBy]

           ,[CreatedDate]

           ,[UpdatedBy]

           ,[UpdatedDate]

           ,[FrequencyType])

     VALUES

	 (

           'https://www.chathamfinancial.com/getrates/' 

           ,285116

           ,777

           ,'40fc143e-f215-4e02-b75c-0c08b0a8dd76'

           ,'Forward Rate Test'

           ,1

           ,'vbalapure'

           ,getdate()

           ,'vbalapure'

           ,getdate()

           ,'QuarterlyForwardRate'

		   )

GO
 
 