USE [SentinelEduquaydb] 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchInfantNotSampleCollected' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchInfantNotSampleCollected  
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchInfantNotSampleCollected] 
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
	
	SELECT MD.[ID] AS MID
		,MD.[RCHID] 
		,MD.[MotherSubjectId]
		,MD.[HospitalFileId] 
		,(MD.[Mother_FirstName] + ' ' + MD.[Mother_LastName]) AS MotherName
		,MD.[Mother_ContactNo] AS ContactNo
		,(INF.[FirstName] + ' ' + INF.[LastName]) AS InfantName
		,INF.[MothersId] 
		,INF.[UniqueSubjectId] 
		,INF.[Gender] 
		,INF.[InfantRCHID] 
		,(CONVERT(VARCHAR,INF.[DateOFDelivery],103) + ' ' + CONVERT(VARCHAR(5),INF.[TimeOfDelivery])) AS DeliveryDateTime
		,(CONVERT(VARCHAR,INF.[DateofRegister],103)) AS RegistrationDate
		,CASE WHEN (SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = INF.[UniqueSubjectID]) > 0 THEN 'R'
		ELSE 'F' END AS SampleType
		,CASE WHEN (SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = INF.[UniqueSubjectID]) > 0 THEN 'Damaged Sample'
		ELSE 'First Time Collection' END AS Reason
	FROM [dbo].[Tbl_MothersDetails] MD
	LEFT JOIN [dbo].[Tbl_InfantDetails] INF WITH (NOLOCK) ON INF.[MothersId] = MD.[ID] 
	WHERE MD.[HospitalId] = @HospitalId 
	AND (CONVERT(DATE,INF.[DateofRegister],103) BETWEEN CONVERT(DATE,@StartDate ,103) AND CONVERT(DATE,@EndDate,103))	
	AND INF.[ID] NOT IN (SELECT InfantID  FROM Tbl_SampleCollection WHERE SampleDamaged != 1)		
	
END
      

