USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCommunityByCaste' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCommunityByCaste
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCommunityByCaste] (@CasteId INT)
AS
BEGIN
	SELECT  CO.[ID]
		 ,CO.[Communityname]	
	FROM [dbo].[Tbl_CommunityMaster] CO
	LEFT JOIN [dbo].[Tbl_CasteMaster] CA WITH (NOLOCK) ON CA.[ID] = CO.[CasteID] 
	WHERE CO.[CasteID] = @CasteId AND CO.[Isactive]  = 1
END

