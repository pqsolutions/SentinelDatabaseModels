USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchShipmentReceiptInMolecularLab' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchShipmentReceiptInMolecularLab 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchShipmentReceiptInMolecularLab] 
(
	@MolecularLabId INT
)
AS
BEGIN
	SELECT S.[ID]
		,S.[GeneratedShipmentId] AS ShipmentID
		,S.[SenderName] 
		,(SH.[HospitalName] + ' & '+ DM.[DistrictName]) HospitalNameLocation
		,ML.[MLabName] AS MolecularLabName
		,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentDateTime
		,CONVERT(VARCHAR,S.[DateofShipment],103) DateOfShipment
		,CONVERT(VARCHAR(5),S.[TimeofShipment]) TimeOfShipment
		,CONVERT(DATETIME,(CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment])),103) AS ShipmentDate
		,SD.[BabySubjectId]
		,SD.[Barcode] AS BarcodeNo
		,BD.[BabyName]
		,MD.[RCHID]
		,(MD.[MotherFirstName] + ' ' + MD.[MotherLastName] ) AS MotherName
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionDateTime
	FROM [dbo].[Tbl_Shipment] S 
	LEFT JOIN [dbo].[Tbl_MolecularLabMaster] ML WITH (NOLOCK) ON S.MolecularLabId = ML.ID
	LEFT JOIN [dbo].[Tbl_SentinelHospitalMaster] SH WITH (NOLOCK) ON S.HospitalId = SH.ID
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.ID = SH.DistrictID
	LEFT JOIN [dbo].[Tbl_ShipmentDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON BD.BabySubjectId = SD.BabySubjectId
	LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId
	LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.Barcode
	WHERE ISNULL(S.[ReceivedDate],'') = '' AND S.[MolecularLabId] = @MolecularLabId   
	ORDER BY ShipmentDate DESC

END