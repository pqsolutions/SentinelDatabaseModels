USE [SentinelEduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchHospitalByUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchHospitalByUser
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchHospitalByUser](@UserId INT)
AS
BEGIN
	SELECT SH.[ID]
		 ,SH.[HospitalCode] 
		 ,(SH.[HospitalCode]+ ' - ' + SH.[HospitalName]) AS HospitalName
	FROM [dbo].[Tbl_SentinelHospitalMaster] SH
	LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON SH.ID = U.HospitalId	
	WHERE U.ID = @UserId AND SH.[Isactive] = 1
	ORDER BY SH.[ID]
END
