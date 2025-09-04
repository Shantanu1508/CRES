CREATE PROCEDURE [dbo].[usp_InsertIntoCalculatorExtensionDbSave] --'04dc99b5-52f4-4cfb-8aeb-15cf49be153d','c10f3372-0fc2-4861-a9f5-148f1f80804f','','Periodic',256
(   
        @NoteID  nvarchar(100)   ,	 
		@AnalysisID  nvarchar(100)	 ,
		@RequestID  nvarchar(100)	, 
        @FileName  nvarchar(100)	, 	 
        @ServerFileCount   int       
    
			 
)
AS  
BEGIN  
    SET NOCOUNT ON;
	Declare @Dbcnt int;
	declare @L_noteid uniqueidentifier ;
	declare @L_Accountid uniqueidentifier ;

	 
	select @L_noteid = n.noteid,@L_Accountid = n.Account_AccountID from cre.note n 
	inner join core.account acc on acc.accountid = n.account_accountid 
	where acc.isdeleted <> 1 and  crenoteid =@NoteID
	

	if(@FileName='Periodic')  
	begin
		SET @Dbcnt = (select count(*) from Cre.NotePeriodicCalc where AccountID = @L_Accountid and AnalysisID =@AnalysisID)
	end 

	if(@FileName='Transaction')  
	begin
			
			SET @Dbcnt = (select count(*) 
			from Cre.TransactionEntry tr
			 Inner join core.account acc on acc.accountid = tr.AccountID
             Inner join cre.note n on n.account_accountid = acc.accountid
			
			where n.NoteID = @L_noteid and AnalysisID =@AnalysisID and acc.AccounttypeID = 1 )
	end

  INSERT INTO [CRE].[CalculatorExtensionDbSave] 
           (
			NoteID 
			,AnalysisID 
			,RequestID 
			,FileName 
			,ServerFileCount 
			,DbCount 
			,CreatedDate
		   )
     VALUES
           (
				@NoteID 
				,@AnalysisID 
				,@RequestID 
				,@FileName 
				,@ServerFileCount 
				,@Dbcnt 				 
				,GETDATE()		   
		   )
END
