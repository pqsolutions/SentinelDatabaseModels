--USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsForMolecularTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsForMolecularTest
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsForMolecularTest] 
(
	@MolecularLabId INT
)
AS
BEGIN
	SELECT SD.[BabySubjectId]
		  ,SD.[Barcode]
		  ,BD.[BabyName]
		  ,BD.[Gender]
		  ,MD.[MotherSubjectId]
		  ,(MD.[MotherFirstName] + ' '+ MD.[MotherLastName] ) AS MotherName
		  ,(MD.[FatherFirstName] + ' '+ MD.[FatherLastName] ) AS FatherName
		  ,CONVERT(VARCHAR,BD.[DeliveryDateTime],103) AS DateOfBirth
		  ,MD.[HospitalNo] AS MotherHospitalNo
		  ,BD.[HospitalNo] AS BabyHospitalNo
		  ,MD.[RCHID]
		  ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime],108) AS SampleCollectionDateTime
		  ,DM.[Districtname]
		  ,ISNULL(SD.[SampleDamaged],0) AS SampleDamaged
	FROM [dbo].[Tbl_Shipment] S 
	LEFT JOIN [dbo].[Tbl_ShipmentDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON SD.BabySubjectId = BD.BabySubjectId
	LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId
	LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.Barcode 
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = MD.DistrictID
	WHERE S.[ReceivedDate] IS NOT NULL AND S.[MolecularLabId] = @MolecularLabId 
	AND SD.[Barcode]   NOT IN (SELECT BarcodeNo FROM Tbl_MolecularBloodTestResult)
END