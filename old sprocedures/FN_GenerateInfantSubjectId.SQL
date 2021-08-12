USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Generate the Infant SubjectID
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GenerateInfantSubjectId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GenerateInfantSubjectId
END
GO
CREATE FUNCTION [dbo].[FN_GenerateInfantSubjectId]   
(
	@MothersSubjectID VARCHAR(250)
	,@UniqueMothersID INT
	,@Gender VARCHAR(10)
) 
RETURNS VARCHAR(250)        
AS    
BEGIN
	DECLARE
		@InfantCount INT,@GenderShort CHAR(1),
		
		@ReturnValue VARCHAR(200)
		SET @GenderShort = 'M'
		IF @Gender = 'Female'
		BEGIN
			SET @GenderShort = 'F'
		END
		
		/* To get the Infant count - since the infant should be added to the subject id */

		SET @InfantCount= (SELECT Count(ID) FROM [dbo].[Tbl_InfantDetails] IFD WHERE IFD.[MothersId] = @UniqueMothersID)

		SET @InfantCount= @InfantCount+1

		SELECT @ReturnValue = LTRIM(RTRIM(@MothersSubjectID))+'/'+ LTRIM(RTRIM(@GenderShort)) +'/'+LTRIM(STR(@InfantCount))    
	
		RETURN @ReturnValue
END        
