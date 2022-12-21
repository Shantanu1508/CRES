/*
[dbo].[usp_UpdateTagFileName]
'<ArrayOfTagFileDataContract>
<TagFileDataContract>
<TagMasterID>
B5D41141-574A-4EEB-836C-062B39E8163A
</TagMasterID>
<TagFileName>
test1.csv
</TagFileName>
</TagFileDataContract>
<TagFileDataContract>
<TagMasterID>
AF3042F6-E85C-482A-B104-F4D07F441170
</TagMasterID>
<TagFileName>
test2.csv
</TagFileName>
</TagFileDataContract>
<TagFileDataContract>
<TagMasterID>
1F2F8130-028C-4C8E-9EAA-25AD2F534404
</TagMasterID>
<TagFileName>test3.csv</TagFileName>
</TagFileDataContract>
</ArrayOfTagFileDataContract>'
*/
CREATE PROCEDURE [dbo].[usp_UpdateTagFileName]
(
 @XMLTagFile XML
)
  
AS
BEGIN
  SET NOCOUNT ON;  
		
	declare @TagFile table
	(
	    ID int identity,
		TagMasterID  uniqueidentifier,
		TagFileName varchar(256)
	)
	
	INSERT INTO @TagFile
	--Remove space and newline from the input 
	select 
	REPLACE(REPLACE(RTRIM(LTRIM(Pers.value('(TagMasterID)[1]', 'varchar(256)'))), CHAR(13), ''), CHAR(10), ''),  
	REPLACE(REPLACE(RTRIM(LTRIM(Pers.value('(TagFileName)[1]', 'varchar(256)'))), CHAR(13), ''), CHAR(10), '')
	FROM @XMLTagFile.nodes('/ArrayOfTagFileDataContract/TagFileDataContract') as t(Pers)
	
	UPDATE [CRE].[TagMaster]
			SET 
				[CRE].[TagMaster].[TagFileName] = tbltag.TagFileName
	 
				from
				(
				Select TagMasterID,TagFileName FROM @TagFile
				) as tbltag
				
	WHERE [CRE].[TagMaster].[TagMasterID] = tbltag.TagMasterID
				  

END

