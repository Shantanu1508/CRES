CREATE TABLE [App].[TimeZone] (
    [TimeZoneID]         INT            IDENTITY (1, 1) NOT NULL,
    [Name]               VARCHAR (256)  NOT NULL,
    [current_utc_offset] NVARCHAR (256) NOT NULL,
    [is_currently_dst]   INT            NOT NULL,
    [CreatedBy]          NVARCHAR (256) NULL,
    [CreatedDate]        DATETIME       NULL,
    [UpdatedBy]          NVARCHAR (256) NULL,
    [UpdatedDate]        DATETIME       NULL,
    [Abbreviation]       NVARCHAR (20)  NULL,
    CONSTRAINT [PK_TimeZoneID] PRIMARY KEY CLUSTERED ([TimeZoneID] ASC)
);

