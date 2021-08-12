--USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Update  for Baby detail
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateBabyProfile' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateBabyProfile
END
GO
CREATE PROCEDURE SPC_UpdateBabyProfile
(
	@BabySubjectId VARCHAR(250),
	@HospitalNo VARCHAR(500),
	@BabyFirstName VARCHAR(500),
	@BabyLastName VARCHAR(500),
	@Gender VARCHAR(20),
	@BirthWeight VARCHAR(100),
	@DeliveryDateTime VARCHAR(200),
	@StatusofBirth INT,
	@UserId INT
)
AS
	DECLARE @BabyName VARCHAR(500)
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM Tbl_BabyDetails WHERE BabySubjectId = @BabySubjectId)
		BEGIN
			IF ISNULL(@BabyFirstName,'') = ''  
			BEGIN
				SET @BabyName = (SELECT BabyName FROM Tbl_BabyDetails WHERE BabySubjectId = @BabySubjectId)
			END
			ELSE
			BEGIN
				SET @BabyName =  @BabyFirstName + ' ' + ISNULL(@BabyLastName,'')
			END

			UPDATE [dbo].[Tbl_BabyDetails] SET
				   
				  [HospitalNo] = @HospitalNo, 
				  [BabyName] = @BabyName, 
				  [BabyFirstName] = @BabyFirstName,
				  [BabyLastName] = @BabyLastName,
				  [Gender] = @Gender, 
				  [BirthWeight] = @BirthWeight, 
				  [DeliveryDateTime] = CONVERT(DATETIME,@DeliveryDateTime,103), 
				  [StatusofBirth] = @StatusofBirth, 
				  [UpdatedOn] = GETDATE(), 
				  [UpdatedBy] = @UserId 
			WHERE  [BabySubjectId] = @BabySubjectId
			SELECT  @BabySubjectId AS BabySubjectId, 'Baby Detail Updated Successfully' AS MSG, 1 AS Success
		END
		ELSE
		BEGIN
			 SELECT  @BabySubjectId AS BabySubjectId, 'Baby detail dies not exist' AS MSG, 0 AS Success
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