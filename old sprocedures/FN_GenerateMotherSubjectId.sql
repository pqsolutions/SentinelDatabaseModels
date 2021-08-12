USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GenerateMotherSubjectId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GenerateMotherSubjectId
END
GO
CREATE FUNCTION [dbo].[FN_GenerateMotherSubjectId]   
(
	@HospitalId INT
)
RETURNS VARCHAR(250)        
AS    
BEGIN
	DECLARE
		@HospitalCode  VARCHAR(100)
		,@UniqueSubjectId VARCHAR(250)
		,@LastUniqueId VARCHAR(250)
	
	SELECT @HospitalCode = HospitalCode FROM Tbl_SentinelHospitalMaster WHERE ID = @HospitalId
	
	SET @LastUniqueId = (SELECT TOP 1 MotherSubjectId 
			FROM Tbl_MothersDetail WITH(NOLOCK) WHERE HospitalID = @HospitalId  AND  MotherSubjectId LIKE @HospitalCode+'/MOM/%'      
			ORDER BY MotherSubjectId DESC)
			
	SELECT @UniqueSubjectId = @HospitalCode + '/MOM/' +    
			CAST(STUFF('000000',7-LEN(ISNULL(MAX(RIGHT(@LastUniqueId,6)),0)+1),        
			LEN(ISNULL(MAX(RIGHT(@LastUniqueId,6)),0)+1),        
			CONVERT(VARCHAR,ISNULL(MAX(RIGHT(@LastUniqueId,6)),0)+1)) AS NVARCHAR(250))
			FROM Tbl_MothersDetail WHERE HospitalId = @HospitalId AND  MotherSubjectId LIKE  @HospitalCode+'/MOM/%' 
			
	RETURN @UniqueSubjectId
END 