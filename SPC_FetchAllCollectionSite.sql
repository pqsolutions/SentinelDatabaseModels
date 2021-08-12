
USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllCollectionSite' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllCollectionSite
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllCollectionSite]
AS
BEGIN
	SELECT [ID]
		 ,[CommonName]	AS Name
		
	FROM [dbo].[Tbl_ConstantValues] WHERE comments = 'CollectionSite'
	ORDER BY [ID]
END
