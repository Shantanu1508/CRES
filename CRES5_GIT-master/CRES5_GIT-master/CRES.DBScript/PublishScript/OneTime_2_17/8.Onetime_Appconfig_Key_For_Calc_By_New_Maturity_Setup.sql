
IF NOT Exists(SELECT 1 from App.AppConfig WHERE [Key]='CalcByNewMaturitySetup')
INSERT INTO App.AppConfig([Key],[Value],[Comments],CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
VALUES('CalcByNewMaturitySetup',0,'Calculate by new maturity setup','B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
