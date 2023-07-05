CREATE TABLE [CRE].[FileImportMaster] (
    [FileImportMasterID]    INT            IDENTITY (1, 1) NOT NULL,
    [FileName]              NVARCHAR (256) NULL,
    [ObjectTypeID]          INT            NULL,
    [SourceStorageTypeID]   INT            NULL,
    [SourceStorageLocation] NVARCHAR (256) NULL,
    [HeaderPosition]        INT            CONSTRAINT [DF__FileImpor__Heade__60C757A0] DEFAULT ((0)) NULL,
    [Status]                INT            CONSTRAINT [DF__FileImpor__Statu__61BB7BD9] DEFAULT ((1)) NOT NULL,
    [Frequency]             NVARCHAR (256) NULL,
    [LastExecutionTime]     DATETIME       NULL
);

go
ALTER TABLE [CRE].[FileImportMaster]
ADD CONSTRAINT PK_FileImportMaster_FileImportMasterID PRIMARY KEY (FileImportMasterID);