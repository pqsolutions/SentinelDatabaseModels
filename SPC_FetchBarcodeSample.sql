USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchBarcodeSample' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchBarcodeSample
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchBarcodeSample] (@Barcode VARCHAR(200))
AS
BEGIN
	SELECT TOP 1 BarcodeNo      
	FROM [dbo].[Tbl_BabySampleCollection]  WHERE BarcodeNo  = @Barcode		
END

