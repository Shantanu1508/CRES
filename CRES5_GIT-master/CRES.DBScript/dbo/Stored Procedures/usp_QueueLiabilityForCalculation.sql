CREATE PROCEDURE [dbo].[usp_QueueLiabilityForCalculation](
    @TableTypeCalculationRequestsLiability [TableTypeCalculationRequestsLiability] READONLY,
    @CreatedBy nvarchar(256),
    @UpdatedBy nvarchar(256)
    )
 AS
Begin
declare @AnalysisID nvarchar(256)
Select @AnalysisID = AnalysisID from core.Analysis where Name='Default'


delete from [Core].[CalculationRequestsLiability] where AccountId in (select distinct AccountId from @TableTypeCalculationRequestsLiability)


INSERT INTO [Core].[CalculationRequestsLiability]
           ([RequestTime]
           ,[StatusID]
           ,[UserName]
           ,[AnalysisID]
           ,[CalcType]
           ,[CalcEngineType]
           ,[AccountId]
           )
     select
            getdate()
           ,lstatus.lookupid as statusid
           ,@CreatedBy
           ,isnull(AnalysisID,@AnalysisID)
           ,CalcType
           ,CalcEngineType
           ,AccountId
          
 from @TableTypeCalculationRequestsLiability ar
left join core.lookup lstatus on lstatus.name = ar.[StatusText]

END