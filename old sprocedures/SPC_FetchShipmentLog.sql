USE [SentinelEduquaydb] 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Shipment Details (Log) of particular hospital

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchShipmentLog' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchShipmentLog 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchShipmentLog] 
(
	@userId INT
)
AS
DECLARE @HospitalId INT
BEGIN
	SELECT @HospitalId = HospitalId FROM Tbl_UserMaster WHERE ID = @userId
	
		SELECT S.[ID]
		  ,SD.[ShipmentId]
		  ,S.[GeneratedShipmentID]
		  ,SM.[HospitalName] AS SentinalHospitalName
		  ,S.[LogisticsProvider]
		  ,S.[ContactNo]
		  ,ML.[MLabName] ReceivingMolecularLab
		  ,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentDateTime
		  ,CONVERT(DATETIME,(CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment])),103) AS ShipmentDate
		  ,SD.[InfantUniqueSubjectId] AS InfantSubjectID
		  ,SD.[Barcode]
		  ,(ID.[FirstName] + ' ' + ID.[MiddleName] + ' '+ ID.[LastName] ) AS InfantName
		  ,(MD.[Mother_FirstName] + ' ' + MD.[Mother_MiddleName] + ' '+ MD.[Mother_LastName] ) AS MotherName
		  ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionDateTime
		FROM [dbo].[Tbl_Shipment] S 
		LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.HospitalId = S.HospitalId
		LEFT JOIN [dbo].[Tbl_SentinelHospitalMaster] SM WITH (NOLOCK) ON SM.ID = S.HospitalId
		LEFT JOIN [dbo].[Tbl_MolecularLabMaster]  ML WITH (NOLOCK) ON ML.ID = S.MolecularLabId
		LEFT JOIN [dbo].[Tbl_ShipmentDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_InfantDetails]  ID   WITH (NOLOCK) ON ID.UniqueSubjectID = SD.InfantUniqueSubjectId
		LEFT JOIN [dbo].[Tbl_MothersDetails] MD WITH (NOLOCK) ON MD.ID = ID.MothersId 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.Barcode
		WHERE S.[HospitalId] = @HospitalId 
		ORDER BY ShipmentDate  DESC 
END


