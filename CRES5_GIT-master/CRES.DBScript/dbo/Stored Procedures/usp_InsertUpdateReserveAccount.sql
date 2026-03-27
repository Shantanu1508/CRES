CREATE PROCEDURE [dbo].[usp_InsertUpdateReserveAccount]  
@tblTypeReserveAccount TableTypeReserveAccount readonly,
@UserID UNIQUEIDENTIFIER
AS  
BEGIN  
    SET NOCOUNT ON;  
	Declare @DealID UNIQUEIDENTIFIER;


SET @DealID = (Select top 1 DealID from @tblTypeReserveAccount)



INSERT INTO [CRE].[ReserveAccount]
           (
           [CREReserveAccountID]
           ,[DealID]
		   ,[ReserveAccountMasterID]
           --,[ReserveAccountName]
           ,[InitialBalanceDate]
           ,[InitialFundingAmount]
           ,[EstimatedReserveBalance]
		   ,FloatInterestRate
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
   Select CREReserveAccountID,DealID,ReserveAccountMasterID,InitialBalanceDate,InitialFundingAmount,EstimatedReserveBalance,FloatInterestRate,@UserID,GetDate(),@UserID,getdate()
			from @tblTypeReserveAccount
			where  ReserveAccountGUID ='00000000-0000-0000-0000-000000000000'
			




	UPDATE CRE.ReserveAccount SET CREReserveAccountID =a.CREReserveAccountID,
						--ReserveAccountName =a.ReserveAccountName,
						ReserveAccountMasterID=a.ReserveAccountMasterID,
						InitialBalanceDate =a.InitialBalanceDate,
						InitialFundingAmount =a.InitialFundingAmount,
						EstimatedReserveBalance =a.EstimatedReserveBalance,
						FloatInterestRate = a.FloatInterestRate,
						UpdatedBy=@UserID,
						UpdatedDate=getdate()
	FROM(Select ReserveAccountGUID,CREReserveAccountID,DealID,ReserveAccountMasterID,InitialBalanceDate,InitialFundingAmount,EstimatedReserveBalance,FloatInterestRate
			from @tblTypeReserveAccount
			where DealID=@DealID 
			and ReserveAccountGUID<>'00000000-0000-0000-0000-000000000000'  
	)a
	WHERE CRE.ReserveAccount.ReserveAccountGUID = a.ReserveAccountGUID
	and  CRE.ReserveAccount.DealID=a.DealID

		

	END