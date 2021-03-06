USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllReligion' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllReligion
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllReligion]
AS
BEGIN
	SELECT [ID]
		 ,[Religionname]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_ReligionMaster]
	ORDER BY [ID]
END
