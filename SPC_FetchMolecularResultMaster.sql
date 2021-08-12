USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMolecularResultMaster' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMolecularResultMaster 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMolecularResultMaster] 

AS
BEGIN
	SELECT [ID] 
		,[ResultName] AS Name
	FROM [dbo].[Tbl_MolecularResultMaster] WHERE IsActive = 1
	
END

