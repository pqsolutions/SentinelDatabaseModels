USE [SentinelEduquaydb] 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDistrictByUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDistrictByUser
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDistrictByUser](@UserId INT)
AS
BEGIN
	SELECT D.[ID]
		,D.[Districtname]
	FROM [dbo].[Tbl_DistrictMaster] D
	LEFT JOIN [dbo].[Tbl_UserMaster] U WITH (NOLOCK) ON D.ID = U.DistrictID	
	WHERE U.ID = @UserId AND D.[Isactive] = 1
	ORDER BY D.[ID]
END
