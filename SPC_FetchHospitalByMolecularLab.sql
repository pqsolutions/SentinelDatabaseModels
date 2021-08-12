USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchHospitalByMolecularLab' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchHospitalByMolecularLab 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchHospitalByMolecularLab] 
(@MolecularLabId INT)
AS
BEGIN
	SELECT [ID] 
		,[HospitalName] AS Name
	FROM [dbo].[Tbl_SentinelHospitalMaster] WHERE IsActive = 1 AND MolecularLabId = @MolecularLabId
	
END