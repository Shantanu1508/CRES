CREATE TABLE [CRE].[ServicerMasterLiability] (
    [ServicerMasterID]    INT            IDENTITY (1, 1) NOT NULL,
    [ServicerName]        NVARCHAR (MAX) NULL,
    [Staus]               INT            NULL,
    [ServicerDisplayName] VARCHAR (MAX)  NULL,
    [ServicerNamecss]     VARCHAR (100)  NULL,
    [ServicerFile]        VARCHAR (500)  NULL,
    [DownloadDisplayName] VARCHAR (256)  NULL
);

go
ALTER TABLE [CRE].[ServicerMasterLiability]
ADD CONSTRAINT PK_ServicerMasterLiability_ServicerMasterID PRIMARY KEY ([ServicerMasterID]);