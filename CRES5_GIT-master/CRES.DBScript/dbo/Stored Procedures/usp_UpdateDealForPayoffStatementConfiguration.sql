CREATE PROCEDURE [dbo].[usp_UpdateDealForPayoffStatementConfiguration]          
(          
	 @DealID varchar(256)
	,@PrepayDate datetime 
	,@InternalRefi int 
	,@PortfolioLoan int
	,@AssigningLoanToTakeoutLender int
	,@NettingofReservesEscrows int

 )          
            
AS          
BEGIN          
          
	 Update CRE.Deal set
		 PrepayDate=@PrepayDate	  
		,InternalRefi = @InternalRefi
		,PortfolioLoan = @PortfolioLoan
		,AssigningLoanToTakeoutLender = @AssigningLoanToTakeoutLender
		,NettingofReservesEscrows = @NettingofReservesEscrows
		where DealID=@DealID           
          
END  