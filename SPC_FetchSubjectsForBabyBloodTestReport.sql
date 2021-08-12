--USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsForBabyBloodTestReport' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsForBabyBloodTestReport --1,'11/11/2020','11/06/2021'
END
GO
CREATE PROCEDURE [dbo].SPC_FetchSubjectsForBabyBloodTestReport 
(
	@MolecularLabId INT
	,@FromDate VARCHAR(250)
	,@ToDate VARCHAR(250)
)
AS
BEGIN
	SELECT MSTR.[BabySubjectID]
		  ,SC.[BarcodeNo] AS Barcode
		  ,BD.[BabyName]
		  ,BD.[Gender] AS BabyGender
		  ,MD.[MotherSubjectId]
		  ,MD.[Age] AS MotherAge
		  ,MD.[MotherContactNo]
		  ,(MD.[Address1] + ' ' + MD.[Address2] + ' ' + MD.[Address3]) AS Address
		  ,CONVERT(VARCHAR,MD.[DateOfRegistration],103) AS RegistrationDate
		  ,(MD.[MotherFirstName] + ' '+ MD.[MotherLastName] ) AS MotherName
		  ,(MD.[FatherFirstName] + ' '+ MD.[FatherLastName] ) AS FatherName
		  ,CONVERT(VARCHAR,BD.[DeliveryDateTime],103) AS DateOfBirth
		  ,MD.[HospitalNo] AS MotherHospitalNo
		  ,BD.[HospitalNo] AS BabyHospitalNo
		  ,MD.[RCHID]
		  ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS SampleCollectionDate
		  ,DM.[Districtname]
		  ,MSTR.[TestResult]
		  ,CONVERT(VARCHAR,MSTR.[TestDate],103) AS TestDate
		  ,OP.[OrderPhysician]  AS OrderingPhysician
		  ,UM.[FirstName] AS LabInchargeName
		  ,MLI.[Designation] AS LabIchargeDesignation
		  ,MLI.[Department] AS LabIchargeDepartment
		  ,MLI.[Incharge] AS Incharge 
		  ,MLI.[MolAddress] AS LabInchargeAddress
		  ,MM.[MLabName] AS MolecularLabName
		  ,HM.[HospitalName]
		  ,(LT.[FirstName] + ' ' + LT.[LastName] )AS LabTechnician
	FROM [dbo].[Tbl_MolecularBloodTestResult] MSTR
	LEFT JOIN [dbo].[Tbl_BabyDetails]  BD WITH (NOLOCK) ON MSTR.[BabySubjectId] = BD.[BabySubjectId]
	LEFT JOIN [dbo].[Tbl_MothersDetail]  MD WITH (NOLOCK) ON MD.[MotherSubjectId] = BD.[MothersSubjectId]
	LEFT JOIN [dbo].[Tbl_BabySampleCollection] SC WITH (NOLOCK) ON SC.[BarcodeNo] = MSTR.[BarcodeNo] 
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON  DM.[ID] = MD.[DistrictId]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = MSTR.[UpdatedBy]
	LEFT JOIN [dbo].[Tbl_MolecularLabMaster] MM WITH (NOLOCK) ON MM.[ID] = MSTR.[MolecularLabId]
	LEFT JOIN [dbo].[Tbl_SentinelHospitalMaster] HM WITH (NOLOCK) ON HM.[ID] = BD.[HospitalId]
	LEFT JOIN [dbo].[Tbl_MolecularLabOrderPhysicianDetails] OP WITH (NOLOCK) ON MSTR.[MolecularLabId] = OP.[MolecularLabId]
	LEFT JOIN [dbo].[Tbl_MolecularLabInchargeDetails] MLI  WITH (NOLOCK)ON  MLI.[UserId]= UM.[ID]
	LEFT JOIN [dbo].[Tbl_ShipmentDetail] SD WITH (NOLOCK) ON MSTR.[BabySubjectID] = SD.[BabySubjectId]
	LEFT JOIN [dbo].[Tbl_Shipment] S WITH (NOLOCK) ON S.[ID] = SD.[ShipmentID] AND S.[ReceivedDate] IS NOT NULL
	LEFT JOIN [dbo].[Tbl_UserMaster] LT  WITH (NOLOCK)ON  LT.[ID]= S.[UpdatedBy]
	WHERE MSTR.[MolecularLabId] = @MolecularLabId AND MSTR.[IsComplete] = 1
	AND (MSTR.[TestDate] BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103))
	ORDER BY   MSTR.[TestDate] DESC
END