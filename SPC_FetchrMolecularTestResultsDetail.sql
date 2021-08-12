USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchrMolecularTestResultsDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchrMolecularTestResultsDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchrMolecularTestResultsDetail] 
(
	@MolecularLabId INT
)
AS
BEGIN
	SELECT MR.[BabySubjectId]
		  ,MR.[BarcodeNO]
		  ,BD.[BabyName]
		  ,BD.[Gender]
		  ,BD.[BirthWeight]
		  ,MD.[MotherSubjectId]
		  ,(MD.[MotherFirstName] + ' '+ MD.[MotherLastName] ) AS MotherName
		  ,(MD.[FatherFirstName] + ' '+ MD.[FatherLastName] ) AS FatherName
		  ,(MD.[GuardianFirstName] + ' '+ MD.[GuardianLastName] ) AS GuardianName
		  ,(MD.[Address1] + ' ' + MD.[Address2] + ' ' + MD.[Address3]) Address
		  ,(CONVERT(VARCHAR,BD.[DeliveryDateTime],103) + ' ' + CONVERT(VARCHAR(5),BD.[DeliveryDateTime],108)) AS DeliveryDateTime
		  ,MD.[HospitalNo] AS MotherHospitalNo
		  ,BD.[HospitalNo] AS BabyHospitalNo
		  ,MD.[RCHID]
		  ,MD.[MotherContactNo]
		  ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime],108) AS SampleCollectionDateTime
		  ,CD.[DiagnosisName]  AS GeniticDiagnosis
		  ,RM.[ResultName] AS GeneticTestResults
		  ,DM.[Districtname]
		  ,MR.[DiagnosisId]
		  ,MR.[ResultId]
		  ,MR.[IsDamaged]
		  ,MR.[IsProcessed]
		  ,MR.[Remarks] AS PathologistRemarks
	FROM [dbo].[Tbl_MolecularResult] MR 
	LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON MR.BabySubjectId = BD.BabySubjectId
	LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId
	LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = MR.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = MD.DistrictID
	LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CD WITH (NOLOCK) ON CD.[ID] = MR.[DiagnosisId] 
	LEFT JOIN [dbo].[Tbl_MolecularResultMaster] RM WITH (NOLOCK) ON RM.[ID] = MR.[ResultId]
	ORDER BY MR.[ID] DESC
END