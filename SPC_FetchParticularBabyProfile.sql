--USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Fetch Details of particular baby subject 
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchParticularBabyProfile' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchParticularBabyProfile
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchParticularBabyProfile]
(	
	@HospitalId INT
	,@BabySubHosNameId VARCHAR(250)
)
AS
BEGIN
		SELECT CONVERT(VARCHAR,MD.[DateOfRegistration],103) AS DateOfRegistration
			,MD.[DistrictId]
			,MD.[HospitalId]
			,MD.[HospitalNo]
			,MD.[CollectionSiteId]
			,MD.[MotherSubjectId]
			,MD.[MotherFirstName]
			,MD.[MotherLastName]
			,CASE WHEN ISNULL(MD.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,MD.[DOB],103)	END AS DOB		
			,MD.[Age]
			,MD.[RCHID]
			,MD.[MotherGovIdTypeId]
			,MD.[MotherGovIdDetail]
			,MD.[MotherContactNo]
			,MD.[G]
			,MD.[P]
			,MD.[L]
			,MD.[A]
			,('G'+CONVERT(VARCHAR,MD.[G])+'-P'+CONVERT(VARCHAR,MD.[P])+'-L'+CONVERT(VARCHAR,MD.[L])+'-A'+CONVERT(VARCHAR,MD.[A])) AS GPLA
			,MD.[ECNumber]
			,MD.[Address1]
			,MD.[Address2]
			,MD.[Address3]
			,MD.[StateId]
			,SM.[StateName]
			,MD.[Pincode]
			,MD.[ReligionId]
			,RM.[ReligionName]
			,MD.[CasteId]
			,CM.[CasteName]
			,MD.[CommunityId]
			,COM.[CommunityName]
			,DM.[DistrictName]
			,MD.[FatherFirstName]
			,MD.[FatherLastName]
			,MD.[FatherContactNo]
			,MD.[GuardianFirstName]
			,MD.[GuardianLastName]
			,MD.[GuardianContactNo]
			,BD.[BabySubjectId]
			,BD.[BabyName] 
			,BD.[Gender]
			,BD.[BirthWeight]
			,BD.[StatusofBirth]
			,BM.[BirthStatus]
			,MBT.[TestResult] AS GeniticResult
			,'' AS GeniticDiagnosis
			,'' PathologistRemarks
			,(CONVERT(VARCHAR,BD.[DeliveryDateTime],103) + ' ' + CONVERT(VARCHAR(5),BD.[DeliveryDateTime],108)) AS DeliveryDateTime
			,SHM1.[HospitalName] AS MotherHospitalName
			,SHM1.[HospitalAddress] AS MotherHospitalAddress
			,SHM1.[HospitalContactNo] AS MotherHospitalContactNo
			,(SHM1.[HospitalName]+ ' ' + SHM1.[HospitalAddress] + ' ' + SHM1.[HospitalContactNo]) AS MotherHospital
			,SHM.[HospitalName] AS BabyHospitalName
			,SHM.[HospitalAddress] AS BabyHospitalAddress
			,SHM.[HospitalContactNo] AS BabyHospitalContactNo
			,BD.[HospitalNo] AS BabyHospital
			,BSC.[BarcodeNo]
			,BD.[BabyFirstName]
			,BD.[BabyLastName]
			,BM.[ID] AS BirthStatusId
		FROM  [dbo].[Tbl_BabyDetails] BD
		LEFT JOIN [dbo].[Tbl_MothersDetail] MD WITH (NOLOCK) ON BD.[MothersSubjectId] = MD.[MotherSubjectId]
		LEFT JOIN [dbo].[Tbl_StateMaster] SM WITH (NOLOCK) ON SM.[ID] = MD.[StateId]
		LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = MD.[DistrictId]
		LEFT JOIN [dbo].[Tbl_ReligionMaster] RM WITH (NOLOCK) ON RM.[ID] = MD.[ReligionId]
		LEFT JOIN [dbo].[Tbl_CasteMaster] CM WITH (NOLOCK) ON CM.[ID] = MD.[CasteId]
		LEFT JOIN [dbo].[Tbl_CommunityMaster] COM WITH (NOLOCK) ON COM.[ID] = MD.[CommunityId]
		LEFT JOIN [dbo].[Tbl_BirthStatusMaster] BM WITH (NOLOCK) ON BM.[ID] = BD.[StatusofBirth]
		LEFT JOIN [dbo].[Tbl_MolecularBloodTestResult] MBT WITH (NOLOCK) ON MBT.[BabySubjectID] = BD.[BabySubjectId]
		--LEFT JOIN [dbo].[Tbl_MolecularResult] MR WITH (NOLOCK) ON MR.[BabySubjectID] = BD.[BabySubjectId]
		--LEFT JOIN [dbo].[Tbl_MolecularResultMaster] MRM WITH (NOLOCK) ON MRM.[ID]=MR.[ResultId]
		--LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CD WITH (NOLOCK) ON CD.[ID]=MR.[DiagnosisId]
		LEFT JOIN [dbo].[Tbl_SentinelHospitalMaster] SHM WITH (NOLOCK) ON SHM.[ID] = BD.[HospitalId]
		LEFT JOIN [dbo].[Tbl_SentinelHospitalMaster] SHM1 WITH (NOLOCK) ON SHM1.[ID] = MD.[HospitalId]
		LEFT JOIN [dbo].[Tbl_BabySampleCollection] BSC WITH (NOLOCK) ON BSC.[BabySubjectId] = BD.[BabySubjectId]
		WHERE MD.[HospitalId] = @HospitalId AND
		(BD.[BabySubjectId]  LIKE '%'+ @BabySubHosNameId + '%'  OR BD.[HospitalNo] LIKE '%'+ @BabySubHosNameId + '%'
		OR BD.[BabyName] LIKE '%'+ @BabySubHosNameId + '%')			  
END