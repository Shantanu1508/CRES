-- Procedure
-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================   
CREATE PROCEDURE [dbo].[usp_AddUpdateScenarioParaMeters] 
(   
	@AnalysisID nvarchar(256),    
	@MaturityScenarioOverrideID int,  
	@MaturityAdjustment int , 	        
	@UserName nvarchar(256) ,	 

	@FunctionName nvarchar(256) ,
	@IndexScenarioOverride int,  
	@CalculationMode int,  
	@ExcludedForcastedPrePayment int,
	@AutoCalcFreq int,
	@UseActuals int,
	@UseBusinessDayAdjustment int,
	@JsonTemplateMasterID int,
	@CalculationFrequency	int,
	@CalcEngineType			int,
	@AllowCalcOverride		int,
	@AllowCalcAlongWithDefault int,
	@AccountingClose int,
	@IncludeProjectedPrincipalWriteoff int,
	@CalculateLiability int,
	@UseFinancingMaturityDateOverride int,
	@UseMaturityAdjustmentMonths int = NULL,
	@IncludeInDiscrepancy int = NULL,
	
	@OperationMode nvarchar(256) = NULL,
	@EqDelayMonths int = NULL,
	@FinDelayMonths int = NULL,
	@MinEqBalForFinStart decimal(28,15) = NULL,
	@SublineEqApplyMonths int = NULL,
	@SublineFinApplyMonths int = NULL,
	@DebtCallDaysOfTheMonth int = NULL,
	@CapitalCallDaysOfTheMonth int = NULL
)    
     
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
 Declare @NextExecuteTime  DateTime

if(@AutoCalcFreq=584)--Daily
BEGIN
	Set @NextExecuteTime = convert(date,getdate()+1)
END
if(@AutoCalcFreq=585)--Weekly
BEGIN
	Set @NextExecuteTime = DATEADD(day, DATEDIFF(day, 6, getdate()-1) /7*7 + 7, 6)
END
if(@AutoCalcFreq=586)--Monthly
BEGIN
	Set @NextExecuteTime = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, getdate()) + 1, 0))
END
if(@AutoCalcFreq=587)--Quarterly
BEGIN
	Set @NextExecuteTime = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) +1, 0))
END

IF @CalculationFrequency is null
BEGIN
	SET @CalculationFrequency = 793
END

IF @CalcEngineType is null
BEGIN
	SET @CalcEngineType = 797
END
IF @AllowCalcOverride is null
BEGIN
	SET @AllowCalcOverride = 4
END

IF @AllowCalcAlongWithDefault is null
BEGIN
	SET @AllowCalcAlongWithDefault = 4
END

IF @AccountingClose is null
BEGIN
	SET @AccountingClose = 4
END


    
update Core.AnalysisParameter    
set MaturityAdjustment = @MaturityAdjustment,		
MaturityScenarioOverrideID = @MaturityScenarioOverrideID,
AnalysisID=@AnalysisID,		 
UpdatedBy=@UserName,
UpdatedDate=getdate(),					

FunctionName = @FunctionName,
IndexScenarioOverride = @IndexScenarioOverride,
CalculationMode = @CalculationMode,
ExcludedForcastedPrePayment = @ExcludedForcastedPrePayment,
AutoCalculationFrequency=@AutoCalcFreq,
NextExecuteTime=@NextExecuteTime,
UseActuals = @UseActuals,
UseBusinessDayAdjustment = @UseBusinessDayAdjustment	,
JsonTemplateMasterID=@JsonTemplateMasterID,		
CalculationFrequency = @CalculationFrequency,
CalcEngineType	 = @CalcEngineType,
AllowCalcOverride	 = @AllowCalcOverride,
AllowCalcAlongWithDefault = @AllowCalcAlongWithDefault,
AccountingClose = @AccountingClose,
IncludeProjectedPrincipalWriteoff=@IncludeProjectedPrincipalWriteoff,
CalculateLiability=@CalculateLiability,
UseFinancingMaturityDateOverride=@UseFinancingMaturityDateOverride,
UseMaturityAdjustmentMonths=@UseMaturityAdjustmentMonths,
IncludeInDiscrepancy = @IncludeInDiscrepancy,
OperationMode	= @OperationMode	,
EqDelayMonths	= @EqDelayMonths	,
FinDelayMonths	= @FinDelayMonths	,
MinEqBalForFinStart	= @MinEqBalForFinStart	,
SublineEqApplyMonths	= @SublineEqApplyMonths	,
SublineFinApplyMonths	= @SublineFinApplyMonths	,
DebtCallDaysOfTheMonth	= @DebtCallDaysOfTheMonth	,
CapitalCallDaysOfTheMonth= @CapitalCallDaysOfTheMonth
where AnalysisID=@AnalysisID   
	

IF @@ROWCOUNT =0     
BEGIN

	Insert into Core.AnalysisParameter 
	(    
	[AnalysisID],
	[MaturityScenarioOverrideID],
	[MaturityAdjustment]	,	   
	CreatedBy ,    
	CreatedDate ,    
	UpdatedBy ,    
	UpdatedDate,
	FunctionName,
	IndexScenarioOverride,
	CalculationMode,
	ExcludedForcastedPrePayment,
	AutoCalculationFrequency,
	NextExecuteTime,
	UseActuals,
	UseBusinessDayAdjustment,
	JsonTemplateMasterID,
	CalculationFrequency,
	CalcEngineType,
	AllowCalcOverride,
	AllowCalcAlongWithDefault,
	AccountingClose,
	IncludeProjectedPrincipalWriteoff,
	CalculateLiability,
	UseFinancingMaturityDateOverride,
	UseMaturityAdjustmentMonths,
	IncludeInDiscrepancy,
	OperationMode,
	EqDelayMonths,	
	FinDelayMonths,	
	MinEqBalForFinStart,	
	SublineEqApplyMonths,	
	SublineFinApplyMonths,	
	DebtCallDaysOfTheMonth,	
	CapitalCallDaysOfTheMonth
	)        

	values    
	(    
	@AnalysisID,
	@MaturityScenarioOverrideID,
	@MaturityAdjustment,		
	@UserName ,    
	getdate(),    
	@UserName,    
	getdate() ,
	@FunctionName,
	@IndexScenarioOverride,
	@CalculationMode,
	@ExcludedForcastedPrePayment,
	@AutoCalcFreq,
	@NextExecuteTime,
	@UseActuals,
	@UseBusinessDayAdjustment,
	@JsonTemplateMasterID,
	@CalculationFrequency,
	@CalcEngineType,
	@AllowCalcOverride,
	@AllowCalcAlongWithDefault,
	@AccountingClose,
	@IncludeProjectedPrincipalWriteoff,
	@CalculateLiability,
	@UseFinancingMaturityDateOverride,
	@UseMaturityAdjustmentMonths,
	@IncludeInDiscrepancy,
	@OperationMode,
	@EqDelayMonths,	
	@FinDelayMonths,	
	@MinEqBalForFinStart,	
	@SublineEqApplyMonths,	
	@SublineFinApplyMonths,	
	@DebtCallDaysOfTheMonth,	
	@CapitalCallDaysOfTheMonth
	)    
END
	 
      
END
GO

