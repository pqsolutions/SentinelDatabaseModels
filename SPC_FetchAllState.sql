
USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllState' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllState
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllState]
AS
BEGIN
	SELECT [ID]
		 ,[StateName] AS Name
		
	FROM [dbo].[Tbl_StateMaster]
	ORDER BY [ID]
END
