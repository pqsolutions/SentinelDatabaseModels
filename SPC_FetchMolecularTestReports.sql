USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMolecularTestReports' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMolecularTestReports 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMolecularTestReports] 
(
	@SampleStatus INT
	,@MolecularLabId INT
	,@HospitalId INT
	,@FromDate VARCHAR(100)
	,@ToDate VARCHAR(100)
)
AS
	DECLARE @StatusName VARCHAR(200),@StartDate VARCHAR(50), @EndDate VARCHAR(50)
BEGIN
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
	SET  @StatusName = (SELECT StatusName FROM Tbl_MolecularSampleStatusMaster WHERE ID = @SampleStatus)
	
	IF @StatusName =  'Test Pending' 
	BEGIN
		SELECT SD.[BabySubjectId]
			  ,SD.[Barcode] AS BarcodeNo
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
			  ,'' AS GeniticDiagnosis
			  ,'' AS GeneticTestResults
			  ,DM.[Districtname]
			  ,'' AS PathologistRemarks
			  ,'Test Pending' AS SampleStatus
		FROM  [dbo].[Tbl_ShipmentDetail]  SD
		LEFT JOIN [dbo].[Tbl_Shipment]  S WITH (NOLOCK) ON S.ID = SD.ShipmentId
		LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON SD.BabySubjectId = BD.BabySubjectId
		LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId
		LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.Barcode 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = MD.DistrictID
		WHERE S.[ReceivedDate] IS NOT NULL AND S.[MolecularLabId] = @MolecularLabId 
		AND SD.[Barcode]   NOT IN (SELECT BarcodeNo FROM Tbl_MolecularResult)
		AND (@hospitalId = 0 OR BD.[HospitalId] = @HospitalId)
		AND (CONVERT(DATE,S.[DateofShipment],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		
	END
	IF @StatusName =  'Test Completed' OR @SampleStatus = 0
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
			  ,RM.[ResultName] AS SampleStatus
			  ,MR.[Remarks] AS PathologistRemarks
		FROM [dbo].[Tbl_MolecularResult] MR 
		LEFT JOIN [dbo].[Tbl_ShipmentDetail]  SD WITH (NOLOCK) ON SD.Barcode = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_Shipment]  S WITH (NOLOCK) ON S.ID = SD.ShipmentId
		LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON MR.BabySubjectId = BD.BabySubjectId
		LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId
		LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = MR.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = MD.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CD WITH (NOLOCK) ON CD.[ID] = MR.[DiagnosisId] 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] RM WITH (NOLOCK) ON RM.[ID] = MR.[ResultId]
		WHERE  S.[MolecularLabId] = @MolecularLabId 
		AND (@hospitalId = 0 OR BD.[HospitalId] = @HospitalId)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		
	END
	IF @StatusName =  'DNA Positive'
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
			  ,RM.[ResultName] AS SampleStatus
			  ,MR.[Remarks] AS PathologistRemarks
		FROM [dbo].[Tbl_MolecularResult] MR 
		LEFT JOIN [dbo].[Tbl_ShipmentDetail]  SD WITH (NOLOCK) ON SD.Barcode = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_Shipment]  S WITH (NOLOCK) ON S.ID = SD.ShipmentId
		LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON MR.BabySubjectId = BD.BabySubjectId
		LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId
		LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = MR.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = MD.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CD WITH (NOLOCK) ON CD.[ID] = MR.[DiagnosisId] 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] RM WITH (NOLOCK) ON RM.[ID] = MR.[ResultId]
		WHERE  S.[MolecularLabId] = @MolecularLabId 
		AND MR.[ResultId] = (SELECT ID FROM Tbl_MolecularResultMaster WHERE ResultName = 'DNA Test Positive') 
		AND (@hospitalId = 0 OR BD.[HospitalId] = @HospitalId)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
	END
	
	IF @StatusName =  'Normal'
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
			  ,RM.[ResultName] AS SampleStatus
			  ,MR.[Remarks] AS PathologistRemarks
		FROM [dbo].[Tbl_MolecularResult] MR 
		LEFT JOIN [dbo].[Tbl_ShipmentDetail]  SD WITH (NOLOCK) ON SD.Barcode = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_Shipment]  S WITH (NOLOCK) ON S.ID = SD.ShipmentId
		LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON MR.BabySubjectId = BD.BabySubjectId
		LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId
		LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = MR.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = MD.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CD WITH (NOLOCK) ON CD.[ID] = MR.[DiagnosisId] 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] RM WITH (NOLOCK) ON RM.[ID] = MR.[ResultId]
		WHERE  S.[MolecularLabId] = @MolecularLabId 
		AND MR.[ResultId] = (SELECT ID FROM Tbl_MolecularResultMaster WHERE ResultName = 'Normal') 
		AND (@hospitalId = 0 OR BD.[HospitalId] = @HospitalId)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
	END
	
	IF @StatusName =  'Damaged & Processed'
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
			  ,'Damaged and Processed' AS SampleStatus
			  ,MR.[Remarks] AS PathologistRemarks
		FROM [dbo].[Tbl_MolecularResult] MR 
		LEFT JOIN [dbo].[Tbl_ShipmentDetail]  SD WITH (NOLOCK) ON SD.Barcode = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_Shipment]  S WITH (NOLOCK) ON S.ID = SD.ShipmentId
		LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON MR.BabySubjectId = BD.BabySubjectId
		LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId
		LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = MR.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = MD.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CD WITH (NOLOCK) ON CD.[ID] = MR.[DiagnosisId] 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] RM WITH (NOLOCK) ON RM.[ID] = MR.[ResultId]
		WHERE  S.[MolecularLabId] = @MolecularLabId 
		AND MR.[IsDamaged] = 1 AND MR.[IsProcessed] = 1
		AND (@hospitalId = 0 OR BD.[HospitalId] = @HospitalId)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
	END
	
	IF @StatusName =  'Damaged & Unprocessed'
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
			  ,'Damaged and UnProcessed' AS SampleStatus
			  ,MR.[Remarks] AS PathologistRemarks
		FROM [dbo].[Tbl_MolecularResult] MR 
		LEFT JOIN [dbo].[Tbl_ShipmentDetail]  SD WITH (NOLOCK) ON SD.Barcode = MR.BarcodeNo
		LEFT JOIN [dbo].[Tbl_Shipment]  S WITH (NOLOCK) ON S.ID = SD.ShipmentId
		LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON MR.BabySubjectId = BD.BabySubjectId
		LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId
		LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = MR.BarcodeNo 
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = MD.DistrictID
		LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CD WITH (NOLOCK) ON CD.[ID] = MR.[DiagnosisId] 
		LEFT JOIN [dbo].[Tbl_MolecularResultMaster] RM WITH (NOLOCK) ON RM.[ID] = MR.[ResultId]
		WHERE  S.[MolecularLabId] = @MolecularLabId 
		AND MR.[IsDamaged] = 1 AND MR.[IsProcessed] = 0
		AND (@hospitalId = 0 OR BD.[HospitalId] = @HospitalId)
		AND (CONVERT(DATE,MR.[UpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
	END
	
END