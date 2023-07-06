-- Function
CREATE FUNCTION [dbo].[fn_Split_Str](@input AS Varchar(max),@charIndex char(1) )
RETURNS
      @Result TABLE(Value varchar(50))
AS
BEGIN
      DECLARE @str VARCHAR(50)
      DECLARE @ind Int
      IF(@input is not null)
      BEGIN
            SET @ind = CharIndex(@charIndex,@input)
            WHILE @ind > 0
            BEGIN
                  SET @str = RTRIM(LTRIM(SUBSTRING(@input,1,@ind-1)))
                  SET @input = SUBSTRING(@input,@ind+1,LEN(@input)-@ind)
                  INSERT INTO @Result values (@str)
                  SET @ind = CharIndex(@charIndex,@input)
            END
            SET @str = @input
            INSERT INTO @Result values (@str)
      END
      RETURN
END