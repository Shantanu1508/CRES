CREATE TABLE [CRE].[DealAmortizationSchedule] (
    [DealAmortizationScheduleID]     UNIQUEIDENTIFIER CONSTRAINT [DF__DealAmort__DealA__4BCC3ABA] DEFAULT (newid()) NOT NULL,
    [DealID]                         UNIQUEIDENTIFIER NOT NULL,
    [Date]                           DATE             NULL,
    [Amount]                         DECIMAL (28, 15) NULL,
    [CreatedBy]                      NVARCHAR (256)   NULL,
    [CreatedDate]                    DATETIME         NULL,
    [UpdatedBy]                      NVARCHAR (256)   NULL,
    [UpdatedDate]                    DATETIME         NULL,
    [DealAmortizationScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    [DealAmortScheduleRowno]         INT              NULL,
    CONSTRAINT [FK_DealAmortizationSchedule_DealID] FOREIGN KEY ([DealID]) REFERENCES [CRE].[Deal] ([DealID])
);
go
ALTER TABLE [CRE].[DealAmortizationSchedule]
ADD CONSTRAINT PK_DealAmortizationSchedule_DealAmortizationScheduleID PRIMARY KEY ([DealAmortizationScheduleAutoID]);
