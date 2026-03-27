Select * into dbo.PeriodicInterestRateUsed_07212023
from cre.PeriodicInterestRateUsed where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

 go

Truncate table cre.PeriodicInterestRateUsed

 go


INSERT INTO cre.PeriodicInterestRateUsed(
 [NoteID]                                   ,
    [Date]                                  ,
    [CouponSpread]                          ,
    [AllInCouponRate]                       ,
    [AllInPikRate]                          ,
    [LiborRate]                             ,
    [IndexFloor]                            ,
    [CouponRate]                            ,
    [AdditionalPIKinterestRatefromPIKTable] ,
    [AdditionalPIKSpreadfromPIKTable]       ,
    [PIKIndexFloorfromPIKTable]             ,
    [AnalysisID]                            ,
    [CreatedBy]                             ,
    [CreatedDate]                           ,
    [UpdatedBy]                             ,
    [UpdatedDate]                           
)
SELECT  [NoteID]                                   ,
    [Date]                                  ,
    [CouponSpread]                          ,
    [AllInCouponRate]                       ,
    [AllInPikRate]                          ,
    [LiborRate]                             ,
    [IndexFloor]                            ,
    [CouponRate]                            ,
    [AdditionalPIKinterestRatefromPIKTable] ,
    [AdditionalPIKSpreadfromPIKTable]       ,
    [PIKIndexFloorfromPIKTable]             ,
    [AnalysisID]                            ,
    [CreatedBy]                             ,
    [CreatedDate]                           ,
    [UpdatedBy]                             ,
    [UpdatedDate]   FROM dbo.PeriodicInterestRateUsed_07212023

 go

 Drop table dbo.PeriodicInterestRateUsed_07212023

 go

