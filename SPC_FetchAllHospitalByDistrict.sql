USE [SentinelEduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllHospitalByDistrict' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllHospitalByDistrict
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllHospitalByDistrict](@DistrictId INT)
AS
BEGIN
	SELECT SH.[ID]
		 ,SH.[DistrictID]
		 ,SH.[HospitalCode] 
		 ,DM.[DistrictName] 
		 ,(SH.[HospitalCode] + ' - ' + 	SH.[HospitalName])AS [HospitalName]
		 ,SH.[Isactive]
		 ,SH.[Comments] 
	FROM [dbo].[Tbl_SentinelHospitalMaster] SH
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = SH.[DistrictID] 
	WHERE SH.[DistrictID]  = @DistrictId 
	ORDER BY SH.[ID]
END
