
IF NOT Exists(SELECT 1 from App.AppConfig WHERE [Key]='AllowFundingDevData')
INSERT INTO App.AppConfig([Key],[Value],[Comments],CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
VALUES('AllowFundingDevData',0,'Allow funding download','B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
