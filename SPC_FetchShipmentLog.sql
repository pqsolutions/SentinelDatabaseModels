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
		  ,S.[SenderName]
		  ,S.[ContactNo]
		  ,ML.[MLabName] ReceivingMolecularLab
		  ,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment],108) AS ShipmentDateTime
		  ,CONVERT(DATETIME,(CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment],108)),103) AS ShipmentDate
		  ,SD.[BabySubjectId]
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
		FROM [dbo].[Tbl_Shipment] S 
		LEFT JOIN [dbo].[Tbl_SentinelHospitalMaster] SM WITH (NOLOCK) ON SM.ID = S.HospitalId
		LEFT JOIN [dbo].[Tbl_MolecularLabMaster]  ML WITH (NOLOCK) ON ML.ID = S.MolecularLabId
		LEFT JOIN [dbo].[Tbl_ShipmentDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.Barcode
		LEFT JOIN [dbo].[Tbl_BabyDetails]  BD   WITH (NOLOCK) ON BD.BabySubjectId = SC.BabySubjectId
		LEFT JOIN [dbo].[Tbl_MothersDetail] MD WITH (NOLOCK) ON MD.MotherSubjectId = BD.MothersSubjectId 
		WHERE S.[HospitalId] = @HospitalId 
		ORDER BY ShipmentDate  DESC 
END


