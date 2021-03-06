USE [SentinelEduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllHospital' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllHospital
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllHospital]
AS
BEGIN
	SELECT SH.[ID]
		 ,SH.[DistrictID]
		 ,SH.[HospitalCode] 
		 ,DM.[DistrictName] 
		 ,SH.[HospitalName]	
		 ,SH.[Isactive]
		 ,SH.[Comments] 
	FROM [dbo].[Tbl_SentinelHospitalMaster] SH
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = SH.[DistrictID]  
	ORDER BY SH.[ID]
END
