USE [SentinelEduquaydb] 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchBabiesNotSampleCollected' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchBabiesNotSampleCollected  
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchBabiesNotSampleCollected] 
(
	@HospitalId INT
	,@FromDate VARCHAR(50)
	,@ToDate VARCHAR(50)
)
AS
BEGIN
	DECLARE  @StartDate VARCHAR(50), @EndDate VARCHAR(50)
	
	IF @FromDate = NULL OR @FromDate = ''
	BEGIN
		SET @StartDate = (SELECT CONVERT(VARCHAR,DATEADD(YEAR ,-1,GETDATE()),103))
	END
	ELSE
	BEGIN
		SET @StartDate = @FromDate
	END
	
	IF @ToDate = NULL OR @ToDate = ''
	BEGIN
		SET @EndDate = (SELECT CONVERT(VARCHAR,GETDATE(),103))
	END
	ELSE
	BEGIN
		SET @EndDate = @ToDate
	END
	
	SELECT 
		BD.[BabyName]
		,BD.[BabySubjectId]
		,CONVERT(VARCHAR,BD.[DeliveryDateTime],103) AS DateOfBirth
		,BD.[Gender]
		,BD.[HospitalNo]
		,MD.[RCHID]
		,CONVERT(VARCHAR,BD.[DateOfRegistration],103) AS RegistrationDate
		,MD.[MotherSubjectId]
		,(MD.[MotherFirstName] + ' ' + MD.[MotherLastName] ) AS MotherName
		,(MD.[FatherFirstName] + ' ' + MD.[FatherLastName] ) AS FatherName
		,MD.[MotherContactNo]
	FROM  [dbo].[Tbl_BabyDetails] BD
	LEFT JOIN [dbo].[Tbl_MothersDetail] MD WITH (NOLOCK) ON MD.[MotherSubjectId] = BD.[MothersSubjectId]
	WHERE (CONVERT(DATE,BD.[DateOfRegistration],103) BETWEEN CONVERT(DATE,@StartDate ,103) AND CONVERT(DATE,@EndDate,103))
	AND BD.[BabySubjectId] NOT IN (SELECT BabySubjectId  FROM Tbl_BabySampleCollection)
END
      

