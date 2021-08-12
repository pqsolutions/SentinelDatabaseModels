USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Generate the baby SubjectID
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GenerateBabySubjectId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GenerateBabySubjectId
END
GO
CREATE FUNCTION [dbo].[FN_GenerateBabySubjectId]   
(
	@MothersSubjectID VARCHAR(250)
	,@Gender VARCHAR(10)
) 
RETURNS VARCHAR(250)        
AS    
BEGIN
	DECLARE
		@BabyCount INT,@GenderShort CHAR(1),
		
		@ReturnValue VARCHAR(200)
		SET @GenderShort = 'M'
		IF @Gender = 'Female'
		BEGIN
			SET @GenderShort = 'F'
		END
		
		/* To get the Baby count - since the baby should be added to the subject id */

		SET @BabyCount= (SELECT COUNT(ID) FROM [dbo].[Tbl_BabyDetails] BD WHERE BD.[MothersSubjectId] = @MothersSubjectID)

		SET @BabyCount= @BabyCount+1

		SELECT @ReturnValue = LTRIM(RTRIM(@MothersSubjectID))+'-B/'+ LTRIM(RTRIM(@GenderShort)) +'/'+LTRIM(STR(@BabyCount))    
	
		RETURN @ReturnValue
END        
