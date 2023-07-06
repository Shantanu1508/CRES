CREATE TABLE [App].[ColorMaster] (
    [ColorMasterID] INT            IDENTITY (1, 1) NOT NULL,
    [ColorName]     NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_ColorMasterID] PRIMARY KEY CLUSTERED ([ColorMasterID] ASC)
);

