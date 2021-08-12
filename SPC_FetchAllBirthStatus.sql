USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllBirthStatus' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllBirthStatus
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllBirthStatus]
AS
BEGIN
	SELECT [ID]
		 ,[BirthStatus]	
		 ,[Isactive]
		 ,[Comments] 
		      
	FROM [dbo].[Tbl_BirthStatusMaster]
	ORDER BY [ID]
END
