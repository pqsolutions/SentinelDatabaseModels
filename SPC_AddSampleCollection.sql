--USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddSampleCollection' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddSampleCollection
END
GO
CREATE PROCEDURE [dbo].[SPC_AddSampleCollection]
(	
	@BabySubjectID VARCHAR(250)
	,@HospitalId INT
	,@BarcodeNo VARCHAR(200)
	,@SampleCollectionDate VARCHAR(100)
	,@SampleCollectionTime VARCHAR(100)
	,@CollectedBy INT
) AS
	DECLARE @ROWCOUNT INT, @IsCollect BIT
BEGIN
	BEGIN TRY
		SET @ROWCOUNT=0
		SET @IsCollect = 0
		IF NOT EXISTS(SELECT BarcodeNo FROM Tbl_BabySampleCollection WHERE BarcodeNo = @BarcodeNo )
		BEGIN
			INSERT INTO Tbl_BabySampleCollection
			(BabySubjectId
			,HospitalId
			,BarcodeNo
			,SampleCollectionDate
			,SampleCollectionTime     
			,CollectedBy
			,CreatedBy
			,CreatedOn
			,BarcodeDamaged 
			,SampleDamaged
			)VALUES
			(@BabySubjectID
			,@HospitalId 
			,@BarcodeNo
			,CONVERT(DATE,@SampleCollectionDate,103)
			,CONVERT(TIME(0),@SampleCollectionTime)     
			,@CollectedBy
			,@CollectedBy 
			,GETDATE()
			,0
			,0)
			SET @ROWCOUNT=@@ROWCOUNT
			SET @IsCollect = 1
		END
		IF @ROWCOUNT > 0
		BEGIN
			SELECT 'Sample collected successfully' AS MSG, @IsCollect AS CollectStatus
		END
		ELSE
		BEGIN
			SELECT ('This barcode no- '+ @BarcodeNo +' is already associated with another infant subject') AS MSG, @IsCollect AS CollectStatus
		END
	
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
			DECLARE @ErrorNumber INT = ERROR_NUMBER();
			DECLARE @ErrorLine INT = ERROR_LINE();
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
			DECLARE @ErrorState INT = ERROR_STATE();
			PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
			PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));
			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);		
	END CATCH
END