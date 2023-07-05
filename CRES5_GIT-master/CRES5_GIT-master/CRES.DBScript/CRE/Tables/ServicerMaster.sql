CREATE TABLE [CRE].[ServicerMaster] (
    [ServicerMasterID]    INT            IDENTITY (1, 1) NOT NULL,
    [ServicerName]        NVARCHAR (MAX) NULL,
    [Staus]               INT            NULL,
    [ServicerDisplayName] VARCHAR (MAX)  NULL,
    [ServicerNamecss]     VARCHAR (100)  NULL,
    [ServicerFile]        VARCHAR (500)  NULL,
    [DownloadDisplayName] VARCHAR (256)  NULL
);

go
ALTER TABLE [CRE].[ServicerMaster]
ADD CONSTRAINT PK_ServicerMaster_ServicerMasterID PRIMARY KEY ([ServicerMasterID]);