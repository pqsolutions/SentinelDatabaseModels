USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Fetch Details of particular mother subject 
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMotherDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMotherDetail --'SH01/MOM/000001'
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMotherDetail]
(	
	@HospitalId INT
	,@MothersRchSubHospID VARCHAR(250)
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
			,MD.[ECNumber]
			,MD.[Address1]
			,MD.[Address2]
			,MD.[Address3]
			,MD.[StateId]
			,MD.[Pincode]
			,MD.[ReligionId]
			,MD.[CasteId]
			,MD.[CommunityId]
			,MD.[FatherFirstName]
			,MD.[FatherLastName]
			,MD.[FatherContactNo]
			,MD.[GuardianFirstName]
			,MD.[GuardianLastName]
			,MD.[GuardianContactNo]
			,BD.[BabySubjectId]
			,BD.[BabyName] 
			,BD.[Gender]
			,(CONVERT(VARCHAR,BD.[DeliveryDateTime],103) + ' ' + CONVERT(VARCHAR(5),BD.[DeliveryDateTime],108)) AS DeliveryDateTime
			,CASE WHEN (SELECT COUNT(ID) FROM Tbl_BabySampleCollection WHERE BabySubjectId = BD.[BabySubjectId]) > 0 THEN 0
			ELSE 1 END AS AllowCollect
		FROM [dbo].[Tbl_MothersDetail] MD
		LEFT JOIN [dbo].[Tbl_BabyDetails] BD WITH (NOLOCK) ON BD.[MothersSubjectId] = MD.[MotherSubjectId]
		WHERE MD.[HospitalId] = @HospitalId AND (MD.[MotherSubjectId]  = @MothersRchSubHospID OR MD.[HospitalNo] = @MothersRchSubHospID
		OR MD.[RCHID] = @MothersRchSubHospID) 			  
END