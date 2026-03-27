CREATE TABLE [Core].[BatchCalculationMaster] (
    [BatchCalculationMasterID]   INT              IDENTITY (1, 1) NOT NULL,
    [BatchCalculationMasterGUID] UNIQUEIDENTIFIER CONSTRAINT [DF__BatchCalc__Batch__20E1DCB5] DEFAULT (newid()) NOT NULL,
    [AnalysisID]                 UNIQUEIDENTIFIER NULL,
    [StartTime]                  DATETIME         NULL,
    [EndTime]                    DATETIME         NULL,
    [Total]                      INT              NULL,
    [TotalCompleted]             INT              NULL,
    [TotalFailed]                INT              NULL,
    [BatchType]                  VARCHAR (50)     NULL,
    [UserID]                     UNIQUEIDENTIFIER NULL,
    [Status]                     VARCHAR (50)     NULL,
    [PortfolioMasterID]          INT              NULL,
	[TotalCanceled] INT  null
);

go


ALTER TABLE [Core].[BatchCalculationMaster]
ADD CONSTRAINT PK_BatchCalculationMaster_BatchCalculationMasterID PRIMARY KEY ([BatchCalculationMasterID]);


  