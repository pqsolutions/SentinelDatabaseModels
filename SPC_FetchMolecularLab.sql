USE [SentinelEduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMolecularLab' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMolecularLab
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMolecularLab]
AS
BEGIN
	SELECT [ID]
		 ,[MLabName] AS MolecularLabName	
	FROM [dbo].[Tbl_MolecularLabMaster] 
	ORDER BY [ID]
END
