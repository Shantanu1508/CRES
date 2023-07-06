CREATE TABLE [CRE].[ServicingFeeSchedule] (
    [AcoreServicingFeeScheduleId] INT              NULL,
    [InvestorId]                  INT              NULL,
    [MinimumBalance]              DECIMAL (28, 15) NULL,
    [MaximumBalance]              DECIMAL (28, 15) NULL,
    [FeePct]                      DECIMAL (28, 15) NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdatedBy]                   NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    ServicingFeeSchedule_AutoID int IDENTITY(1,1)
);
go
 
ALTER TABLE [CRE].[ServicingFeeSchedule]
ADD CONSTRAINT PK_ServicingFeeSchedule_ServicingFeeScheduleID PRIMARY KEY (ServicingFeeSchedule_AutoID);
