---  [HBOT].[usp_InsertHBOTChatLog] 'null','The hill','TotalCommitmentNoteID','B0E6697B-3534-4C09-BE0A-04473401AB93','bot'
CREATE PROCEDURE [HBOT].[usp_InsertHBOTChatLog]
(   
        @Status nvarchar(256),
		@Question nvarchar(max),
		@IntentName nvarchar(256), 
		@CreatedBy varchar(256),
		@Sentby nvarchar(256),
		@SessionId nvarchar(50)
 )
AS  
BEGIN  
    SET NOCOUNT ON; 
	SET @Status = nullif(@Status,'null');
	SET @IntentName = nullif(@IntentName,'null');

	DECLARE @l_status nvarchar(256), @l_parentid int, @chatlogid int, @l_createdby nvarchar(256), @l_intentname nvarchar(256),
			@l_question nvarchar(max), @l_chatlogid2 int;  -- @l_status2 int;
    DECLARE @InsertedChatlogid int;

	SELECT top 1 @l_parentid = ParentId,@l_status=Status,@chatlogid =ChatLogID, @l_createdby = CreatedBy, @l_intentname=IntentName,
	@l_question = Question
	FROM HBOT.ChatLog WHERE CreatedBy = @CreatedBy
	ORDER BY CreatedDate DESC

	IF(@Question = 'Session end.')
	BEGIN
		--IF(@l_question = 'Session end.') 
		--BEGIN
		--	return;
		--END
		--ELSE
		--BEGIN
			INSERT INTO [HBOT].[ChatLog]([Status],[Question],[CreatedBy],[CreatedDate],[ParentId],[IntentName],[SentBy],[SessionID])
			VALUES(@Status,@Question,@CreatedBy,GETDATE(),null,null,@Sentby,@SessionId)
			return;
		--END
	END
	
	
	
	IF(ISNULL(@l_status,'4') <> '0' and (@Status is null))
	BEGIN
		SET @l_parentid = null
		SET @l_status = null
		SET @chatlogid = null
	END
	
	IF(@l_parentid is null and @l_status is null)
	BEGIN
		
		IF EXISTS(SELECT 1 FROM hbot.chatlog where CreatedBy = @CreatedBy)
		BEGIN
			INSERT INTO [HBOT].[ChatLog]([Status],[Question],[CreatedBy],[CreatedDate],[ParentId],[IntentName],[SentBy],[SessionID])
			VALUES(@Status,@Question,@CreatedBy,GETDATE(),@chatlogid,@IntentName,@Sentby,@SessionId)
			SET @InsertedChatlogid = @@IDENTITY;
		END
		ELSE
		BEGIN
			INSERT INTO [HBOT].[ChatLog]([Status],[Question],[CreatedBy],[CreatedDate],[ParentId],[IntentName],[SentBy],[SessionID])
			VALUES(@Status,@Question,@CreatedBy,GETDATE(),@chatlogid,@IntentName,@Sentby,@SessionId)
			SET @InsertedChatlogid = @@IDENTITY;
		END
	END
	ELSE 
	BEGIN
		IF(@IntentName is not null)
		BEGIN
			IF(@IntentName <> @l_intentname)
			BEGIN
				UPDATE HBOT.ChatLog SET IntentName = @IntentName, ParentId = null WHERE ChatLogID = @chatlogid
				INSERT INTO [HBOT].[ChatLog]([Status],[Question],[CreatedBy],[CreatedDate],[ParentId],[IntentName],[SentBy],[SessionID])
				VALUES(@Status,@Question,@CreatedBy,GETDATE(),@chatlogid,@IntentName,@Sentby,@SessionId)
				SET @InsertedChatlogid = @@IDENTITY;
			END
			ELSE
			BEGIN
				INSERT INTO [HBOT].[ChatLog]([Status],[Question],[CreatedBy],[CreatedDate],[ParentId],[IntentName],[SentBy],[SessionID])
				VALUES(@Status,@Question,@CreatedBy,GETDATE(),@l_parentid,@IntentName,@Sentby,@SessionId)
				SET @InsertedChatlogid = @@IDENTITY;
			END
		END
		ELSE
		BEGIN
			INSERT INTO [HBOT].[ChatLog]([Status],[Question],[CreatedBy],[CreatedDate],[ParentId],[IntentName],[SentBy],[SessionID])
			VALUES(@Status,@Question,@CreatedBy,GETDATE(),@l_parentid,@l_intentname,@Sentby,@SessionId)
			SET @InsertedChatlogid = @@IDENTITY;
		END
	END

	
	IF(@l_question ='Session end.') 
	BEGIN
		IF(@Sentby='bot')
		BEGIN
			SELECT top 1 @l_chatlogid2 = ChatLogID FROM HBOT.ChatLog WHERE CreatedBy = @CreatedBy and Question<>'Session end.' and chatlogid<> @InsertedChatlogid  ORDER BY CreatedDate DESC
			UPDATE  HBOT.ChatLog SET ParentId = @l_chatlogid2  where chatlogid=@InsertedChatlogid
		END
	--	ELSE
	--	BEGIN
	--		IF(@Sentby ='user')
	--		BEGIN
	--			SELECT top 1 @l_chatlogid2 = ChatLogID,@l_status2=Status FROM HBOT.ChatLog WHERE CreatedBy = @CreatedBy and Question<>'Session end.' and chatlogid<> @InsertedChatlogid  ORDER BY CreatedDate DESC
	--			IF(@l_status2 = '0')
	--			BEGIN
	--				UPDATE  HBOT.ChatLog SET ParentId = @l_chatlogid2  where chatlogid=@InsertedChatlogid
	--			END
	--		END
	--	END
	END
		-- UPDATE  HBOT.ChatLog SET ParentId = chatlogid where ParentId IS NULL
		
END 





