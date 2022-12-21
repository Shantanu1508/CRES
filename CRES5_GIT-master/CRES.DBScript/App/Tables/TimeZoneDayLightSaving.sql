CREATE TABLE [App].[TimeZoneDayLightSaving] (
    [TimeZoneDayLightSavingID] INT            IDENTITY (1, 1) NOT NULL,
    [TimeZoneID]               INT            NOT NULL,
    [StartDate]                DATE           NULL,
    [EndDate]                  DATE           NULL,
    [current_utc_offset]       NVARCHAR (256) NOT NULL,
    [CreatedBy]                NVARCHAR (256) NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (256) NULL,
    [UpdatedDate]              DATETIME       NULL,
    [Abbreviation]             NVARCHAR (20)  NULL,
    CONSTRAINT [PK_TimeZoneDayLightSavingID] PRIMARY KEY CLUSTERED ([TimeZoneDayLightSavingID] ASC)
);

