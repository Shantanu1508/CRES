CREATE PROCEDURE [VAL].[usp_GetNoteMatrixData_Valuation]   --'AllTableData','16-1024'  
	@MarkedDate date,
	@NoteMatrixType nvarchar(256),  
	@CREDealID nvarchar(256) = null  
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
  
  	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


IF(@NoteMatrixType = 'Delphi')  
BEGIN  
 Select   
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as Pool  
 ,null as FinancingSource  
 ,null as DebtType  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm.Commitment  
 ,null as Spread  
 ,null as IndexforStub  
 ,null as Floor  
 ,null as AllInRate  
 ,null as Type  
 ,nm.InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,CurrentMaturity_Date as CurrentMaturityDate  
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as FeesStart  
 ,null as RSLIC  
 ,null as SNCC  
 ,null as PIIC  
 ,null as TMR  
 ,null as HCC  
 ,null as USSIC  
 ,null as TMDDL  --as TMNF
 ,null as HAIH  
 ,null as [Check]  
 ,null as CAMRA  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as PremDisc  
 ,nm.OriginationFee  
 ,null as FutureFundings  --as FutureFundingsatParor99 
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as x  
 ,null as NoteClassification  
 ,null as ClearwaterMortgageLoanTrancheType  
 ,null as WholeLoanSpread  
 ,null as SeniorLoanSpread  
 ,null as SubLoanSpread  
 ,nm.ExtensionFee1  
 ,nm.ExtensionFee2  
 ,nm.ExtensionFee3  
 ,null as ExtensionFee4  
 ,null as 'empty'  
 ,nm.ProductType  
 ,null as MSA  
 ,null as [State]  
 ,null as DealType  
 ,null  as VintageYear  --as InquiryYear
 ,null as [Location]  
 ,null as Composite  
 ,null as SubDebtInitiaMaturity  
 ,null as WLInitialMaturity  
 ,null as SubDebtFullyExtended  
 ,null as WLFullyExtended  
  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'Delphi'  
 and nm.DealID = @CREDealID  
 and MarkedDateMasterID = @MarkedDateMasterID
END  
  
IF(@NoteMatrixType = 'TRE ACR')  
BEGIN  
 Select   
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID as ACOREID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as [Pool]  
 ,null as FinancingSource  
 ,null as DebtType  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm.Commitment  
 ,null as Spread  
 ,null as IndexforStub  
 ,null as [Floor]  
 ,null as AllInRate  
 ,null as [Type]  
 ,nm.InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,null as CurrentMaturity  
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as Client  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as Empty1  
 ,null as Empty2  
 ,null as Empty3  
 ,null as Empty4  
 ,null as WholeLoanSpread  
 ,nm.ExtensionFee1  
 ,nm.ExtensionFee2  
 ,nm.ExtensionFee3  
 ,null as ExtensionFee4  
 ,nm.AcoreOrig as ACOREOrigFee  
 ,null as Empty5  
 ,null as Empty6  
 ,nm.ProductType  
 ,null as MSA  
 ,null as [State]  
 ,null as DealType  
 ,null as VintageYear  
 ,null as [Location]  
 ,null as Composite  
 ,null as WLInitialMaturity  
 ,null as WLFullyExtended  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'TRE ACR'  
 and nm.DealID = @CREDealID 
 and MarkedDateMasterID = @MarkedDateMasterID 
END  
  
IF(@NoteMatrixType = 'ACORE Credit IV')  
BEGIN  
 Select   
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID as ACOREID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as [Pool]  
 ,null as FinancingSource  
 ,null as CurrentEntity  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm. Commitment   
 ,null as Spread  
 ,null as IndexforStub  
 ,null as [Floor]  
 ,null as AllInRate  
 ,null as [Type]  
 ,nm.InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,CurrentMaturity_Date as CurrentMaturityDate  
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as FeesStart  
 ,null as RSLIC  
 ,null as SNCC  
 ,null as PIIC  
 ,null as TMR  
 ,null as HCC  
 ,null as USSIC  
 ,null as TMDDL  --as TMNF 
 ,null as HAIH  
 ,null as [Check]  
 ,null as CAMRA  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as  PremDisc  
 ,nm.OriginationFee  
 ,nm.ExitFee  
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as Empty1  
 ,null as Empty2  
 ,null as Empty3  
 ,null as WholeLoanSpread  
 ,nm.ExtensionFee1  
 ,nm.ExtensionFee2  
 ,nm.ExtensionFee3  
 ,null as ExtensionFee4  
 ,nm.AcoreOrig as ACOREOrigFee  
 ,null as x  
 ,null as Empty4  
 ,nm.ProductType  
 ,null as MSA  
 ,null as [State]  
 ,null as DealType  
 ,null as VintageYear  
 ,null as [Location]  
 ,null as Composite  
 ,null as WLInitialMaturity  
 ,null as WLFullyExtended  
 ,null as SDFullyExtended  
  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'ACORE Credit IV'  
 and nm.DealID = @CREDealID  
 and MarkedDateMasterID = @MarkedDateMasterID
END  
  
IF(@NoteMatrixType = 'ACP II')  
BEGIN  
 Select   
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as [Pool]  
 ,null as FinancingSource  
 ,null as CurrentEntity  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm.Commitment  
 ,null as Spread  
 ,null as IndexforStub  
 ,null as [Floor]  
 ,null as AllInRate  
 ,null as [Type]  
 ,null as InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,CurrentMaturity_Date as CurrentMaturityDate  
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as FeesStart  
 ,null as RSLIC  
 ,null as SNCC  
 ,null as PIIC  
 ,null as TMR  
 ,null as HCC  
 ,null as USSIC  
 ,null as TMDDL  --
 ,null as HAIH  
 ,null as [Check]  
 ,null as CAMRA  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as  PremDisc  
 ,nm.OriginationFee  
 ,nm.ExitFee  
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as x  
 ,null as Empty1  
 ,null as Empty2  
 ,null as WholeLoanSpread  
 ,nm.ExtensionFee1  
 ,nm.ExtensionFee2  
 ,nm.ExtensionFee3  
 ,null as ExtensionFee4  
 ,nm.AcoreOrig as ACPIIDealOrigFee  
 ,null as Empty3  
 ,null as Empty4  
 ,nm.ProductType  
 ,null as MSA  
 ,null as State  
 ,null as DealType  
 ,null as VintageYear  
 ,null as Location  
 ,null as Composite  
 ,null as SubDebtInitiaMaturity  
 ,null as WLInitialMaturity  
 ,null as SubDebtFullyExtended  
 ,null as WLFullyExtended  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'ACP II'  
 and nm.DealID = @CREDealID  
 and MarkedDateMasterID = @MarkedDateMasterID
END  
  
IF(@NoteMatrixType = 'ACSS')  
BEGIN  
 Select   
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as Pool  
 ,null as FinancingSource  
 ,null as Entity  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm.Commitment  
 ,null as Spread  
 ,null as IndexforStub  
 ,null as [Floor]  
 ,null as AllInRate  
 ,null as [Type]  
 ,nm.InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,CurrentMaturity_Date as CurrentMaturityDate  
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as FeesStart  
 ,null as RSLIC  
 ,null as SNCC  
 ,null as PIIC  
 ,null as TMR  
 ,null as HCC  
 ,null as USSIC  
 ,null as TMDDL  --as TMNF 
 ,null as HAIH  
 ,null as [Check]  
 ,null as CAMRA  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as PremDisc   
 ,nm.OriginationFee  
 ,null as FutureFunding  --as FutureFundingsatParor99 
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as x  
 ,null as Empty1  
 ,null as Empty2  
 ,null as WholeLoanSpread  
 ,nm.ExtensionFee1  
 ,nm.ExtensionFee2  
 ,nm.ExtensionFee3  
 ,null as ExtensionFee4  
 ,null as Empty3  
 ,null as Empty4  
 ,null as Empty5  
 ,nm.ProductType  
 ,null as MSA  
 ,null as State  
 ,null as DealType  
 ,null as VintageYear  
 ,null as Location  
 ,null as Composite  
 ,null as SubDebtInitiaMaturity  
 ,null as WLInitialMaturity  
 ,null as SubDebtFullyExtended  
 ,null as WLFullyExtended  
  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'ACSS'  
 and nm.DealID = @CREDealID  
 and MarkedDateMasterID = @MarkedDateMasterID
END  
  
IF(@NoteMatrixType = 'AHIP')  
BEGIN  
 Select  
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as [Pool]  
 ,null as FinancingSource  
 ,null as AHIPStructure  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm.Commitment  
 ,null as Spread  
 ,null as IndexforStub  
 ,null as [Floor]  
 ,null as AllInRate  
 ,null as Type  
 ,nm.InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,CurrentMaturity_Date as CurrentMaturityDate  
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as FeesStart  
 ,null as RSLIC  
 ,null as SNCC  
 ,null as PIIC  
 ,null as TMR  
 ,null as HCC  
 ,null as USSIC  
 ,null as TMDDL  --as TMNF 
 ,null as HAIH  
 ,null as [Check]  
 ,null as CAMRA  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as PremDisc  
 ,nm.OriginationFee  
 ,null as FutureFundings  --as FutureFundingsatParor99 
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as x  
 ,null as Empty1  
 ,null as Empty2  
 ,null as WholeLoanSpread  
 ,nm.ExtensionFee1  
 ,nm.ExtensionFee2  
 ,nm.ExtensionFee3  
 ,null as ExtensionFee4  
 ,null as Empty3  
 ,null as Empty4  
 ,null as Empty5  
 ,nm.ProductType  
 ,null as MSA  
 ,null as [State]  
 ,null as DealType  
 ,null as VintageYear  
 ,null as [Location]  
 ,null as Composite  
 ,null as SubDebtInitiaMaturity  
 ,null as WLInitialMaturity  
 ,null as SubDebtFullyExtended  
 ,null as WLFullyExtended  
  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'AHIP'  
 and nm.DealID = @CREDealID 
 and MarkedDateMasterID = @MarkedDateMasterID 
END  
  
IF(@NoteMatrixType = 'Delaware Life')  
BEGIN  
 Select   
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as Pool  
 ,null as FinancingSource  
 ,null as DebtType  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm.Commitment  
 ,null as Spread  
 ,null as IndexforStub  
 ,null as [Floor]  
 ,null as AllInRate  
 ,null as [Type]  
 ,nm.InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,CurrentMaturity_Date as CurrentMaturityDate  
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as FeesStart  
 ,null as RSLIC  
 ,null as SNCC  
 ,null as PIIC  
 ,null as TMR  
 ,null as HCC  
 ,null as USSIC  
 ,null as TMDDL  --as TMNF  
 ,null as HAIH  
 ,null as [Check]  
 ,null as CAMRA  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as  PremDisc  
 ,nm.OriginationFee  
 ,null as FutureFundings  --as FutureFundingsatParor99 
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as x  
 ,null as Empty1  
 ,null as Empty2  
 ,null as WholeLoanSpread  
 ,null as SeniorLoanSpread  
 ,null as SubLoanSpread  
 ,nm.ExtensionFee1  
 ,nm.ExtensionFee2  
 ,nm.ExtensionFee3  
 ,null as ExtensionFee4  
 ,null as Empty3  
 ,nm.ProductType  
 ,null as MSA  
 ,null as [State]  
 ,null as DealType  
 ,null as VintageYear  
 ,null as [Location]  
 ,null as Composite  
 ,null as SubDebtInitiaMaturity  
 ,null as WLInitialMaturity  
 ,null as SubDebtFullyExtended  
 ,null as WLFullyExtended  
  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'Delaware Life'  
 and nm.DealID = @CREDealID  
 and MarkedDateMasterID = @MarkedDateMasterID
END  
  
IF(@NoteMatrixType = 'Harel')  
BEGIN  
 Select  
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as Pool  
 ,null as FinancingSource  
 ,null as DebtType  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm.Commitment  
 ,null as Spread  
 ,null as IndexforStub  
 ,null as Floor  
 ,null as AllInRate  
 ,null as Type  
 ,nm.InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,CurrentMaturity_Date as CurrentMaturityDate  
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as FeesStart  
 ,null as RSLIC  
 ,null as SNCC  
 ,null as PIIC  
 ,null as TMR  
 ,null as HCC  
 ,null as USSIC  
 ,null as TMDDL  --as TMNF  
 ,null as HAIH  
 ,null as [Check]  
 ,null as CAMRA  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as  PremDisc  
 ,nm.OriginationFee  
 ,null as FutureFundings  --as FutureFundingsatParor99 
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as x  
 ,null as Empty1  
 ,null as Empty2  
 ,null as WholeLoanSpread  
 ,null as SeniorLoanSpread  
 ,null as SubLoanSpread  
 ,nm.ExtensionFee1  
 ,nm.ExtensionFee2  
 ,nm.ExtensionFee3  
 ,null as ExtensionFee4  
 ,null as Empty4  
 ,nm.ProductType  
 ,null as MSA  
 ,null as State  
 ,null as DealType  
 ,null as VintageYear  
 ,null as Location  
 ,null as Composite  
 ,null as SubDebtInitiaMaturity  
 ,null as WLInitialMaturity  
 ,null as SubDebtFullyExtended  
 ,null as WLFullyExtended  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'Harel'  
 and nm.DealID = @CREDealID  
 and MarkedDateMasterID = @MarkedDateMasterID
END  
  
IF(@NoteMatrixType = 'SILAC')  
BEGIN  
 Select  
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as Pool  
 ,null as FinancingSource  
 ,null as DebtType  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm.Commitment  
 ,null as Spread  
 ,null as IndexforStub  
 ,null as Floor  
 ,null as AllInRate  
 ,null as Type  
 ,nm.InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,CurrentMaturity_Date as CurrentMaturityDate  
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as FeesStart  
 ,null as RSLIC  
 ,null as SNCC  
 ,null as PIIC  
 ,null as TMR  
 ,null as HCC  
 ,null as USSIC  
 ,null as TMDDL  --as TMNF 
 ,null as HAIH  
 ,null as [Check]  
 ,null as CAMRA  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as  PremDisc  
 ,nm.OriginationFee  
 ,null as FutureFundings  --as FutureFundingsatParor99 
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as x  
 ,null as Empty1  
 ,null as Empty2  
 ,null as WholeLoanSpread  
 ,null as SeniorLoanSpread  
 ,null as SubLoanSpread  
 ,null as ExtensionFee1  
 ,null as ExtensionFee2  
 ,null as ExtensionFee3  
 ,null as ExtensionFee4  
 ,null as Empty4  
 ,nm.ProductType  
 ,null as MSA  
 ,null as State  
 ,null as DealType  
 ,null as VintageYear  
 ,null as Location  
 ,null as Composite  
 ,null as SubDebtInitiaMaturity  
 ,null as WLInitialMaturity  
 ,null as SubDebtFullyExtended  
 ,null as WLFullyExtended  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'SILAC'  
 and nm.DealID = @CREDealID  
 and MarkedDateMasterID = @MarkedDateMasterID
END  
  
IF(@NoteMatrixType = 'Equitrust')  
BEGIN  
 Select  
 nm.DealID  
 ,nm.DealGroupID  
 ,nm.NoteID  
 ,null as Pri  
 ,nm.DealName  
 ,nm.NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Fund  
 ,null as AssetManager  
 ,null as Banker  
 ,null as Credit  
 ,null as Pool  
 ,null as FinancingSource  
 ,null as CurrentEntity  
 ,null as CapStack  
 ,null as BillingNote  
 ,nm.Commitment  
 ,null as Spread  
 ,null as IndexforStub  
 ,null as Floor  
 ,null as AllInRate  
 ,null as Type  
 ,nm.InitialFunding  
 ,null as InitialMaturity  
 ,null as ExtendedMaturity1  
 ,null as ExtendedMaturity2  
 ,null as ExtendedMaturity3  
 ,null as ExtendedMaturity4  
 ,null as FullyExtendedMaturity  
 ,CurrentMaturity_Date as CurrentMaturityDate   
 ,null as CurrentMaturity  
 ,null as PaidOffSold  
 ,null as FeesStart  
 ,null as RSLIC  
 ,null as SNCC  
 ,null as PIIC  
 ,null as TMR  
 ,null as HCC  
 ,null as USSIC  
 ,null as TMDDL  --as TMNF  
 ,null as HAIH  
 ,null as [Check]  
 ,null as CAMRA  
 ,null as Servicer  
 ,null as ServicerID  
 ,null as PremDisc  
 ,nm.OriginationFee  
 ,nm.ExitFee  
 ,null as PaydownPayoffConvention  
 ,null as PaymentDate  
 ,null as [Index]  
 ,null as x  
 ,null as Empty1  
 ,null as Empty2  
 ,null as WholeLoanSpread  
 ,nm.ExtensionFee1  
 ,nm.ExtensionFee2  
 ,nm.ExtensionFee3  
 ,null as ExtensionFee4  
 ,nm.AcoreOrig as ACOREUpfrontFee  
 ,null as Empty3  
 ,null as Empty4  
 ,nm.ProductType  
 ,null as MSA  
 ,null as State  
 ,null as DealType  
 ,null as VintageYear  
 ,null as Location  
 ,null as Composite  
 ,null as SubDebtInitiaMaturity  
 ,null as WLInitialMaturity  
 ,null as SubDebtFullyExtended  
 ,null as WLFullyExtended  
 from [VAL].[NoteMatrixData] nm  
 Where NoteMatrixSheetName = 'Equitrust'  
 and nm.DealID = @CREDealID  
 and MarkedDateMasterID = @MarkedDateMasterID
END  
  
IF(@NoteMatrixType = 'Fee')  
BEGIN   
 Select   
 DealID  
 ,DealGroupID  
 ,NoteID  
 ,Pri  
 ,DealName  
 ,NoteName  
 ,null as LoanStatus  
 ,null as Client  
 ,null as Pool  
 ,null as FinancingSource  
 ,null as DebtType  
 ,null as CapStack  
 ,null as BillingNote  
 ,null as Commitment  
 ,null as Spread  
 ,null as IndexFloor  
 ,null as InitialFunding  
 ,null as PaidOffSold  
 ,null as OriginationFee  
 ,null as ExitFee1StartDate  
 ,ExitFee1  
 ,null as ExitFee2StartDate  
 ,null as ExitFee2  
 ,null as ExitFeeBaseAmount   
 ,null as ExitFeeTrueUp  
 ,null as ExitFeeStripping  
 ,null as ExtensionBaseAmount   
 ,null as ExtensionFee1StartDate  
 ,null as ExtensionFee1  
 ,null as ExtensionFee2StartDate  
 ,null as ExtensionFee2  
 ,null as ExtensionFee3StartDate  
 ,null as ExtensionFee3  
 ,null as ExtensionFee4StartDate  
 ,null as ExtensionFee4  
 ,null as ExtensionFeeStripping  
 ,null as CallProtectionType  
 ,null as Amount   
 ,null as EstimatedOpenPeiod  
 ,null as UsedFee  
 ,null as ModificationFee  
 ,null as OriginatyionFeeSenior  
 ,null as OriginationFeeSub  
 ,null as ExitFeeStrippingFactor  
 ,null as ExitFeeSenior  
 ,null as ExitFeeSub  
 From dw.[NoteMatrixBI_FeeTab]  
 Where DealID = @CREDealID  
END  
  
IF(@NoteMatrixType = 'AllTableData')  
BEGIN   

	Select   
	NoteMatrixSheetName as NoteMatrixType
	,DealID  
	,DealGroupID  
	,NoteID 
	,DealName  
	,NoteName  
	,Commitment  
	,InitialFunding 
	,CurrentMaturity_Date as CurrentMaturityDate
	,OriginationFee 
	,ExtensionFee1  
	,ExtensionFee2  
	,ExtensionFee3
	,ExitFee 
	,ProductType  
	,AcoreOrig      
	from [VAL].[NoteMatrixData]  
	where MarkedDateMasterID = @MarkedDateMasterID
	order by NoteMatrixSheetName  
END  
 
   
IF(@NoteMatrixType = 'NoteMatrixDataFromM61')  
BEGIN   

	Select   
	SheetName as NoteMatrixType
	,DealID  
	,DealGroupID  
	,NoteID 
	,DealName  
	,NoteName  
	,Commitment  
	,InitialFunding 
	,CurrentMaturityDate as CurrentMaturityDate
	,OriginationFee 
	,ExtensionFee1  
	,ExtensionFee2  
	,ExtensionFee3
	,ExitFee 
	,ProductType  
	,AcoreOrig      
	from [DW].[NoteMatrixBI] 
	order by SheetName  
END  

  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END 
