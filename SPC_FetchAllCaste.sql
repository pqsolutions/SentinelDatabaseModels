USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllCaste' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllCaste
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllCaste]
AS
BEGIN
	SELECT [ID]
		 ,[Castename]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_CasteMaster]
	ORDER BY [ID]
END
