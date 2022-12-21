CREATE FUNCTION [dbo].[fn_Split_Pipe](@input AS nvarchar(max) )  
RETURNS  
      @Result TABLE(Value nvarchar(100))  
AS  
BEGIN  
      DECLARE @str nvARCHAR(50)  
      DECLARE @ind Int  
      IF(@input is not null)  
      BEGIN  
            SET @ind = CharIndex('|',@input)  
            WHILE @ind > 0  
            BEGIN  
                  SET @str = RTRIM(LTRIM(SUBSTRING(@input,1,@ind-1)))  
                  SET @input = SUBSTRING(@input,@ind+1,LEN(@input)-@ind)  
                  INSERT INTO @Result values (@str)  
                  SET @ind = CharIndex('|',@input)  
            END  
            SET @str = @input  
            INSERT INTO @Result values (@str)  
      END  
      RETURN  
END  
