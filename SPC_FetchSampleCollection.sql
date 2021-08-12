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

	SELECT BD.[BabyName]
		,BD.[BabySubjectId]
		,CONVERT(VARCHAR,BD.[DeliveryDateTime],103) AS DateOfBirth
		,BD.[Gender]
		,BD.[HospitalNo] AS BabysHospitalNo
		,MD.[RCHID]
		,CONVERT(VARCHAR,BD.[DateOfRegistration],103) AS RegistrationDate
		,MD.[MotherSubjectId]
		,(MD.[MotherFirstName] + ' ' + MD.[MotherLastName] ) AS MotherName
		,(MD.[FatherFirstName] + ' ' + MD.[FatherLastName] ) AS FatherName
		,MD.[MotherContactNo]
		,MD.[HospitalNo] AS MotherHospitalNo
		,SC.[BarcodeNo]  
		,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		,CONVERT(DATETIME,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])),103) AS SDT

	FROM [dbo].[Tbl_BabySampleCollection] SC
	LEFT JOIN [dbo].[Tbl_BabyDetails] BD WITH (NOLOCK) ON BD.[BabySubjectId] = SC.[BabySubjectId]
	LEFT JOIN [dbo].[Tbl_MothersDetail] MD WITH (NOLOCK) ON MD.[MotherSubjectId] = BD.[MothersSubjectId]
	WHERE SC.[HospitalId] = @HospitalId
	AND SC.BarcodeNo NOT IN (SELECT Barcode from Tbl_ShipmentDetail)
	ORDER BY SDT ASC
END
