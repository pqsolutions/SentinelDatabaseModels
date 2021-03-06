USE [SentinelEduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllGovIDType' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllGovIDType
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllGovIDType]
AS
BEGIN
	SELECT [ID]
		 ,[GovIDType]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_GovIDTypeMaster]
	ORDER BY [ID]
END
