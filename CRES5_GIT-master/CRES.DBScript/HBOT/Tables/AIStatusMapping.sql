CREATE TABLE [HBOT].[AIStatusMapping] (
    [StatusID]    INT            NOT NULL,
    [StatusName]  NVARCHAR (256) NOT NULL,
    [Description] NVARCHAR (256) NULL,

    AIStatusMappingID int IDENTITY(1,1)
);

go
ALTER TABLE [HBOT].AIStatusMapping
ADD CONSTRAINT PK_AIStatusMapping PRIMARY KEY (AIStatusMappingid);