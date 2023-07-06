


CREATE PROCEDURE [dbo].[usp_UpdateNoteExtenstionSizer]
(
	@CRENoteID	[nvarchar](256),	 
	@DayoftheMonth int,
	@RepaymentDayoftheMonth int = NULL,
	@InterestCalculationRuleForPaydowns int,
	@InterestCalculationRuleForPaydownsAmort int = NULL,
	@DebtTypeID int,
	@BillingNotesID int, 
	@CapStack int,
	@ServicerNameID int = NULL,
	@UpdatedBy	[nvarchar](256)   
)	
AS
begin

declare @lookup_capstack int=null;

if(@CapStack=500) 
begin
  set @lookup_capstack = (select LookupID from Core.Lookup where ParentID =73 and name ='Legal')
end 

if(@CapStack=501) 
begin
  set @lookup_capstack = (select LookupID from Core.Lookup where ParentID =73 and name ='billing')
end 

 update [CRE].[Note] set


		DayoftheMonth=@DayoftheMonth,
		RepaymentDayoftheMonth = ISNULL(@RepaymentDayoftheMonth,RepaymentDayoftheMonth),
		InterestCalculationRuleForPaydowns=@InterestCalculationRuleForPaydowns,
		InterestCalculationRuleForPaydownsAmort=isnull(@InterestCalculationRuleForPaydownsAmort,InterestCalculationRuleForPaydownsAmort),
		DebtTypeID=@DebtTypeID,
		BillingNotesID=@BillingNotesID,
		CapStack=@lookup_capstack, 
		ServicerNameID=isnull(@ServicerNameID,ServicerNameID),
		UpdatedBy    =@UpdatedBy   ,
		UpdatedDate    =getdate()   
   
   where CRENoteID =@CRENoteID 
END
