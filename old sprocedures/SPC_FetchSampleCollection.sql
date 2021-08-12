USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSampleCollection' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSampleCollection
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSampleCollection] 
(
	@HospitalId INT
)
AS
BEGIN
	SELECT MD.[ID] AS MID
			,MD.[RCHID] 
			,MD.[MotherSubjectId]
			,MD.[HospitalId] 
			,(MD.[Mother_FirstName] + ' ' + MD.[Mother_LastName]) AS MotherName
			,MD.[Mother_ContactNo] AS ContactNo
			,(INF.[FirstName] + ' ' + INF.[LastName]) AS InfantName
			,INF.[UniqueSubjectId] 
			,INF.[Gender] 
			,INF.[InfantRCHID]
			,SC.[BarcodeNo]  
			,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		    ,CONVERT(DATETIME,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])),103) AS SDT
		FROM [dbo].[Tbl_SampleCollection] SC	
		LEFT JOIN [dbo].[Tbl_InfantDetails] INF WITH (NOLOCK) ON INF.[ID]  = SC.[InfantID]  
		LEFT JOIN [dbo].[Tbl_MothersDetails] MD WITH (NOLOCK) ON INF.[MothersId] = MD.[ID]
		WHERE SC.[HospitalId] = @HospitalId AND SC.SampleDamaged != 1
		AND SC.BarcodeNo NOT IN (SELECT BarcodeNo from Tbl_ShipmentDetail)
		ORDER BY SDT ASC
END
