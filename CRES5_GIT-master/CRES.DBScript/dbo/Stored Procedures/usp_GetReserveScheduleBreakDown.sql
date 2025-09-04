--[usp_GetReserveScheduleBreakDown] '', '1614e4ac-aaca-454a-918b-d7f94621e319/719'
 
 create PROCEDURE [dbo].[usp_GetReserveScheduleBreakDown] 
(  
	@UserID varchar(100), 
	@DealReserveScheduleGUID varchar(100)
)  
AS
 BEGIN

 Declare  @DealReserveScheduleID int,@Date as date,@DealID uniqueidentifier
								
 Declare @FundingDetail as table(
 ReserveAccountID int,
 InitialFundingAmount DECIMAL (28, 15),
 Amount DECIMAL (28, 15),
 CurrentBalance DECIMAL (28, 15)
 )
 
 select @DealReserveScheduleID= DealReserveScheduleID,@Date=[Date],@DealID=DealID from [CRE].[DealReserveSchedule] where DealReserveScheduleGUID=@DealReserveScheduleGUID

 insert into @FundingDetail
 select ra.ReserveAccountID,isnull(ra.InitialFundingAmount,0) as InitialFundingAmount,tbl.Amount,isnull(ra.EstimatedReserveBalance,0) as CurrentBalance from Cre.ReserveAccount ra join
 ( 
 select ras.ReserveAccountID,sum(isnull(ras.Amount,0)) as Amount  from [CRE].[DealReserveSchedule] dr join [CRE].[ReserveAccountSchedule] ras on dr.DealReserveScheduleID=ras.DealReserveScheduleID  where dr.[Date]<=@Date 
 and dr.DealReserveScheduleGUID<>@DealReserveScheduleGUID
 and dr.DealReserveScheduleID<@DealReserveScheduleID
 and dr.DealID=@DealID
 group by ras.ReserveAccountID
 ) tbl on ra.ReserveAccountID=tbl.ReserveAccountID

 insert into @FundingDetail
 select ReserveAccountID,InitialFundingAmount,0,InitialFundingAmount from Cre.ReserveAccount where ReserveAccountID not in (select ReserveAccountID from @FundingDetail)
 
 
 select ac.ReserveAccountName,fd.CurrentBalance, 
 ABS(rs.Amount) as RequestAmount,(fd.CurrentBalance+rs.Amount) as NewBalance from [CRE].[ReserveAccountSchedule] rs join Cre.ReserveAccount ac  on rs.ReserveAccountID = ac.ReserveAccountID 
 join @FundingDetail fd on fd.ReserveAccountID=ac.ReserveAccountID
 where DealReserveScheduleID=@DealReserveScheduleID
 and rs.Amount is not null and rs.Amount<>0
 order by ac.ReserveAccountName

END