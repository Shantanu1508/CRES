CREATE TABLE [CRE].[FileImportColumnMapping] (
    [FileImportColumnMappingID] INT            IDENTITY (1, 1) NOT NULL,
    [FileImportMasterID]        INT            NOT NULL,
    [FileColumnName]            NVARCHAR (256) NULL,
    [LandingColumnName]         NVARCHAR (256) NULL
);

go
ALTER TABLE [CRE].[FileImportColumnMapping]
ADD CONSTRAINT PK_FileImportColumnMapping_FileImportColumnMappingID PRIMARY KEY (FileImportColumnMappingID);