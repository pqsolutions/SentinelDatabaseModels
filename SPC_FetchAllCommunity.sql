USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllCommunity' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllCommunity
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllCommunity]
AS
BEGIN
	SELECT CO.[ID]
		 ,CO.[CasteID] 
		 ,CA.[Castename] 
		 ,CO.[Communityname]	
		 ,CO.[Isactive]
		 ,CO.[Comments] 
		 ,CO.[Createdby] 
		 ,CO.[Updatedby]      
	FROM [dbo].[Tbl_CommunityMaster] CO
	LEFT JOIN [dbo].[Tbl_CasteMaster] CA WITH (NOLOCK) ON CA.[ID] = CO.[CasteID] 
	ORDER BY [ID]
END
