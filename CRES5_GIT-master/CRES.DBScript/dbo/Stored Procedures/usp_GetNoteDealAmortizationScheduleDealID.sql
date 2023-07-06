
--[dbo].[usp_GetNoteDealAmortizationScheduleDealID]  'b0e6697b-3534-4c09-be0a-04473401ab93',  'e6a07b3e-dea3-436f-baf0-a9873753fa14',618

CREATE PROCEDURE [dbo].[usp_GetNoteDealAmortizationScheduleDealID]  
(
    @UserID UNIQUEIDENTIFIER,
    @DealID UNIQUEIDENTIFIER,
	@AmortizationMethod int
)	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ColPivot AS NVARCHAR(MAX),
@query1  AS NVARCHAR(MAX),
@query2 as nvarchar(MAX)


Declare  @AmortSchedule  int = 19;

--DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
--Declare @InActive as nvarchar(256)=(select LookupID from core.lookup where name ='InActive' and ParentID=1);
Declare @OrderBy nvarchar(256);


DECLARE @DBAmortMethod int =(select AmortizationMethod from cre.deal where dealid = @DealID )

	IF EXISTS(Select * from [cre].[DealAmortizationSchedule] where dealid = @DealID and @AmortizationMethod=@DBAmortMethod)
	BEGIN

	SET @ColPivot = STUFF((SELECT  ',' + QUOTENAME(cast(acc.Name as nvarchar(256)) )                   
						from [CRE].[Note] n
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						and n.DealID = @DealID
						and acc.IsDeleted = 0						
						order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name 							
						FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')

		set @query1=N'Select 
		a.DealAmortizationScheduleAutoID	
		,a.DealAmortScheduleRowno
		,a.DealAmortizationScheduleID	
		,a.DealID	
		,a.Date	
		,a.Amount 
		' + IIF(ISNULL(@ColPivot,'') = '','',','+ISNULL(@ColPivot,'')) + '
		from(
			Select 
			df.DealAmortizationScheduleAutoID	
			,df.DealAmortScheduleRowno
			,df.DealAmortizationScheduleID	
			,df.DealID	
			,df.Date	
			,df.Amount
			from cre.DealAmortizationSchedule df
			where df.dealid = '''+convert(varchar(MAX),@DealID)+'''
		)a
		LEFT JOIN(
			SELECT DealID, Date,DealAmortizationScheduleAutoID,' + @ColPivot + '  
			from (
				Select  df.DealAmortizationScheduleAutoID				
				,df.DealID 
				,acc.Name Name
				,fs.[Date] Date			
				,fs.Value Value
				from 
				[CRE].[DealAmortizationSchedule] df
				left join cre.deal d on d.DealID = df.DealID and d.DEalID='''+convert(varchar(MAX),@DealID)+'''
				left join [CORE].AmortSchedule fs on df.[Date]=fs.[Date]  and ISNULL(df.DealAmortScheduleRowno,0)=ISNULL(fs.DealAmortScheduleRowno,ISNULL(df.DealAmortScheduleRowno,0))
				INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
				INNER JOIN (
								Select 
								(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
								MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
								from [CORE].[Event] eve
								INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
								INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
								where EventTypeID = '''+convert(varchar(MAX),@AmortSchedule)+''' 
								and n.DealID = '''+convert(varchar(MAX),@DealID)+'''
								and eve.StatusID =1  
								and acc.IsDeleted = 0
								GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

							) sEvent ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				where sEvent.StatusID = e.StatusID 				
				and acc.IsDeleted = 0 and 
				df.DealID ='''+convert(varchar(MAX),@DealID)+''' and d.IsDeleted = 0

			) x 
			pivot 
			(
				sum(Value)
				for 
				Name in (' + @ColPivot + ' )
			) p
		)b on a.dealid = b.dealid and a.date = b.date				
		'
		SET @OrderBy  = 'order by a.Date,ISNULL(a.DealAmortScheduleRowno,0)' 

	END
	ELSE
	BEGIN		

		SET @ColPivot = STUFF((SELECT  ',null as ' + QUOTENAME(cast(acc.Name as nvarchar(256)) )                   
						from [CRE].[Note] n
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						and n.DealID = @DealID
						and acc.IsDeleted = 0
						order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name 							
						FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)') 
						,1,1,'')

		set @query1=N'			
		Select * from (Select
		null as DealAmortizationScheduleAutoID,
		null as DealAmortScheduleRowno,
		null as DealAmortizationScheduleID,
		null as DealID,	
		getdate() as Date ,
		null as Amount ,' + @ColPivot + '  )n  where DealAmortizationScheduleID is not null'

		set @query2 = ' '
		SET @OrderBy  = ' ' 

	END
	---








print @query1
print @query2
print @OrderBy


exec(@query1+@query2 + @OrderBy);


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END






