

USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddMolecularTestResult' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddMolecularTestResult 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddMolecularTestResult] 
(
	@BabySubjectId VARCHAR(250)
	,@Barcode VARCHAR(250)
	,@DiagnosisId INT
	,@ResultId INT
	,@UpdatedBy INT
	,@IsProcessed BIT
	
	,@Remarks VARCHAR(MAX)
)
AS
DECLARE
	@MolResult VARCHAR(100)
	,@CheckDamaged BIT
	,@DId INT
	,@RId INT
BEGIN
	BEGIN TRY
		SELECT @CheckDamaged = ISNULL(SampleDamaged,0) FROM Tbl_ShipmentDetail WHERE Barcode = @Barcode 
		
		IF @IsProcessed = 0
		BEGIN
			SET @DId = 0
			SET @RId = 0
			SET @MolResult = @Remarks
		END
		ELSE
		BEGIN
			SET @DId = @DiagnosisId 
			SET @RId = @ResultId 
			SET @MolResult = (SELECT ResultName FROM Tbl_MolecularResultMaster WHERE ID = @ResultId) 
		END
		
		IF NOT EXISTS (SELECT BabySubjectID FROM Tbl_MolecularResult WHERE BarcodeNo = @Barcode)
		BEGIN
			INSERT INTO Tbl_MolecularResult(
			   [BabySubjectID]
			   ,[BarcodeNo]
			   ,[DiagnosisId]
			   ,[ResultId]
			   ,[UpdatedBy]
			   ,[UpdatedOn]
			   ,[IsDamaged]
			   ,[IsProcessed] 
			   ,[Remarks]
			   ,[ReasonForClose] 
				)VALUES(
				@BabySubjectId 
				,@Barcode 
				,@DiagnosisId 
				,@ResultId  
				,@UpdatedBy 
				,GETDATE()
				,@CheckDamaged
				,@IsProcessed 
				,@Remarks
				,@Remarks)
		END
		ELSE
		BEGIN
			UPDATE Tbl_MolecularResult SET 
			   [DiagnosisId] = @DId 
			   ,[ResultId] = @RId 
			   ,[UpdatedBy] = @UpdatedBy 
			   ,[UpdatedOn] = GETDATE()
			   ,[IsProcessed]  = @IsProcessed 
			   ,[ReasonForClose] = @Remarks
			   ,[Remarks] = @Remarks
			WHERE BarcodeNo = @Barcode 
			
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