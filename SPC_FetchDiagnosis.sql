USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDiagnosis' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDiagnosis 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDiagnosis] 

AS
BEGIN
	SELECT [ID] 
		,[DiagnosisName] AS Name
	FROM [dbo].[Tbl_ClinicalDiagnosisMaster] WHERE IsActive = 1
	
END

