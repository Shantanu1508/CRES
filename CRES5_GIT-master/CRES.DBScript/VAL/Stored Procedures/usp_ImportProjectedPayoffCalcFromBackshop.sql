
CREATE PROCEDURE [VAL].[usp_ImportProjectedPayoffCalcFromBackshop]  	
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   


Declare @deallist nvarchar(max);

select  @deallist = STUFF((SELECT '|' + (CAST(credealid as nvarchar(MAX))) +''
               	From(							
						Select Distinct credealid 
						from cre.deal 
						Where isdeleted <> 1
						and [Status] = 323
                	)a
           	FOR XML PATH(''), TYPE
           	).value('.', 'NVARCHAR(MAX)') 
       	,1,1,'')



IF OBJECT_ID('tempdb..#tblProjectedPayoffCalc') IS NOT NULL         
DROP TABLE #tblProjectedPayoffCalc

CREATE TABLE #tblProjectedPayoffCalc(
ControlId	nvarchar(256)	,
DealName	nvarchar(256)	,
Client	nvarchar(256)	,
Sponsor	nvarchar(256)	,
Location	nvarchar(256)	,
PropertyType	nvarchar(256)	,
Banker	nvarchar(256)	,
Region	nvarchar(256)	,
AMOversight	nvarchar(256)	,
PrimaryAM	nvarchar(256)	,
AltAM	nvarchar(256)	,
Spread	decimal(28,15)	,
CurrentIndex	decimal(28,15)	,
Floor	decimal(28,15)	,
IndexCap	decimal(28,15)	,
CurrentCoupon	decimal(28,15)	,
OriginatonDate	Date	,
MaturityDate	Date	,
MaturityInMonth	int	,
FullExtendedMaturityDate	Date	,
RemainingFullyExtendedTermInMonths	int	,
FeesDueForNextExtension	decimal(28,15)	,
ExitFee	decimal(28,15)	,
CurrentInvestorBalance	decimal(28,15)	,
CurrentWholeLoanCommitment	decimal(28,15)	,
CurrentDelphiDebtCommitment	decimal(28,15)	,
KnownDate	Date	,
AuditUpdateUser	nvarchar(256)	,
MaturityAuditFullName	nvarchar(256)	,
OfficeOrgName	nvarchar(256)	,
PctCompleteCurrent	int	,
CompletionDateCurrent	Date	,
FHLB	nvarchar(256)	,
AMLoanStatus nvarchar(256)	,
XIRR	decimal(28,15)	,
OpenDate2	Date	,
RCPFN1	int	,
RCPFN2	int	,
CurrentSubDebtBalance	decimal(28,15)	,
CFTFile	nvarchar(256)	,
PctLeased	decimal(28,15)	,
ProjectedPayoffHeaderId	int	,
ControlId_F	nvarchar(256)	,
EarliestDate	date	,
LatestDate	date	,
Comment	nvarchar(MAX)	,
InActiveSW	int	,
AuditAddDate	DateTime	,
AuditUpdateDate	DateTime	,
AuditAddUserId	int	,
AuditUpdateUserId	int	,
CallProtectionDescription	nvarchar(256)	,
OpenDate	Date	,
PayOffExitPlanId_F	int	,
ExpectedDate	DateTIme	,
PendingMaturityPlanId_F	int	,
CommentMaturity	nvarchar(max)	,
MaturityAuditName	int	,
MaturityAuditDate	DateTime	,
CurrentWLIRR	decimal(28,15)	,
CurrentSubDebtIRR	decimal(28,15)	,
StabLTV	decimal(28,15)	,
ProjectedPayBankerActionId_F	int	,
Servicer	nvarchar(256)	,
ServicerLoanNum	nvarchar(256)	,
Column1_ProjectedPayoffDetailId	int	,
Column1Date	Date	,
Column1	int	,
OldColumn1	decimal(28,15)	,
Column2_ProjectedPayoffDetailId	int	,
Column2Date	Date	,
Column2	int	,
OldColumn2	decimal(28,15)	,
Column3_ProjectedPayoffDetailId	int	,
Column3Date	Date	,
Column3	int	,
OldColumn3	decimal(28,15)	,
Column4_ProjectedPayoffDetailId	int	,
Column4Date	Date	,
Column4	int	,
OldColumn4	decimal(28,15)	,
Column5_ProjectedPayoffDetailId	int	,
Column5Date	Date	,
Column5	int	,
OldColumn5	decimal(28,15)	,
Column6_ProjectedPayoffDetailId	int	,
Column6Date	Date	,
Column6	int	,
OldColumn6	decimal(28,15)	,
Column7_ProjectedPayoffDetailId	int	,
Column7Date	Date	,
Column7	int	,
OldColumn7	decimal(28,15)	,
Column8_ProjectedPayoffDetailId	int	,
Column8Date	Date	,
Column8	int	,
OldColumn8	decimal(28,15)	,
Column9_ProjectedPayoffDetailId	int	,
Column9Date	Date	,
Column9	int	,
OldColumn9	decimal(28,15)	,
Column10_ProjectedPayoffDetailId	int	,
Column10Date	Date	,
Column10	int	,
OldColumn10	decimal(28,15)	,
Column11_ProjectedPayoffDetailId	int	,
Column11Date	Date	,
Column11	int	,
OldColumn11	decimal(28,15)	,
Column12_ProjectedPayoffDetailId	int	,
Column12Date	Date	,
Column12	int	,
OldColumn12	decimal(28,15)	,
ShardName	nvarchar(256)	
	
)


Declare @query nvarchar(max)
SET @query = N'EXEC acore.spProjectedPayoffModalHeaderList 
@ControlIds='''+ @deallist +'''
,@UserId_Fs=''1332|1388|1333|1142|1392|1166|1269|1323|1103|1194|1202|1059|1316|1374|1152|1115|1060|1239|1090|1370|1398|1112|1071|1129|1237|1201|1244|1214|1213|1104|1372|1386|1130|1342|1079|1192|1317|1134|1105|1235|1207|1379|1095|1283|1335|1138|1069|1149|1206|1154|1391|1190|1193|1101|1224|1198|1234|1056|1098|1394|1177''
,@InvestorIds=''1|2|4|5|6|7|8|9|10|12|13|14|15|16|17|19''
,@ShowFHLB=0
,@OfficeIds=''1689|1643|1645|1644''
'

INSERT INTO #tblProjectedPayoffCalc(ControlId,DealName,Client,Sponsor,Location,PropertyType,Banker,Region,AMOversight,PrimaryAM,AltAM,Spread,CurrentIndex,Floor,IndexCap,CurrentCoupon,OriginatonDate,MaturityDate,MaturityInMonth,FullExtendedMaturityDate,RemainingFullyExtendedTermInMonths,FeesDueForNextExtension,ExitFee,CurrentInvestorBalance,CurrentWholeLoanCommitment,CurrentDelphiDebtCommitment,KnownDate,AuditUpdateUser,MaturityAuditFullName,OfficeOrgName,PctCompleteCurrent,CompletionDateCurrent,FHLB,AMLoanStatus,XIRR,OpenDate2,RCPFN1,RCPFN2,CurrentSubDebtBalance,CFTFile,PctLeased,ProjectedPayoffHeaderId,ControlId_F,EarliestDate,LatestDate,Comment,InActiveSW,AuditAddDate,AuditUpdateDate,AuditAddUserId,AuditUpdateUserId,CallProtectionDescription,OpenDate,PayOffExitPlanId_F,ExpectedDate,PendingMaturityPlanId_F,CommentMaturity,MaturityAuditName,MaturityAuditDate,CurrentWLIRR,CurrentSubDebtIRR,StabLTV,ProjectedPayBankerActionId_F,Servicer,ServicerLoanNum,Column1_ProjectedPayoffDetailId,Column1Date,Column1,OldColumn1,Column2_ProjectedPayoffDetailId,Column2Date,Column2,OldColumn2,Column3_ProjectedPayoffDetailId,Column3Date,Column3,OldColumn3,Column4_ProjectedPayoffDetailId,Column4Date,Column4,OldColumn4,Column5_ProjectedPayoffDetailId,Column5Date,Column5,OldColumn5,Column6_ProjectedPayoffDetailId,Column6Date,Column6,OldColumn6,Column7_ProjectedPayoffDetailId,Column7Date,Column7,OldColumn7,Column8_ProjectedPayoffDetailId,Column8Date,Column8,OldColumn8,Column9_ProjectedPayoffDetailId,Column9Date,Column9,OldColumn9,Column10_ProjectedPayoffDetailId,Column10Date,Column10,OldColumn10,Column11_ProjectedPayoffDetailId,Column11Date,Column11,OldColumn11,Column12_ProjectedPayoffDetailId,Column12Date,Column12,OldColumn12,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @query




IF EXISTS(Select ControlID from #tblProjectedPayoffCalc)
BEGIN
	Truncate table [IO].[L_ProjectedPayoffCalc] 

	INSERT INTO [IO].[L_ProjectedPayoffCalc] (ControlID,DealName,Client,PropertyType,OpenDate,CreatedBy,CreatedDate,UpdateBy,UpdatedDate,FullyExtendedMaturityDate)
	Select
	 p.ControlID
	,p.DealName
	,p.Client	
	,p.PropertyType	
	,p.OpenDate
	,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
	,getdate()
	,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
	,getdate()
	,p.FullExtendedMaturityDate
	from #tblProjectedPayoffCalc p

END





	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
