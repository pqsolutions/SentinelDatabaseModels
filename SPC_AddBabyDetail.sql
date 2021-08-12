USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Add Detail for Baby Registration
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddBabyDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddBabyDetail
END
GO
CREATE PROCEDURE SPC_AddBabyDetail
(
	@MothersSubjectId VARCHAR(250),
	@TypeofBaby INT, -- Single / Twins etc...
	@BabySubjectId VARCHAR (200),
	@DateOfRegistration  VARCHAR(200),
	@HospitalID INT,
	@HospitalNo VARCHAR(500),
	@BabyName VARCHAR(500),
	@Gender VARCHAR(20),
	@BirthWeight VARCHAR(100),
	@DeliveryDateTime VARCHAR(200),
	@StatusofBirth INT,
	@CreatedBy INT
)
As
DECLARE
	@NewUniqueSubjectID VARCHAR(200),
	@MSG VARCHAR(250),
	@ROWCOUNT INT
BEGIN
	BEGIN TRY
	
		IF EXISTS (SELECT MotherSubjectId FROM Tbl_MothersDetail WHERE MotherSubjectId = @MothersSubjectId)
		BEGIN
			SET @NewUniqueSubjectID = @BabySubjectId

			SET @ROWCOUNT=0

			UPDATE [dbo].[Tbl_BabyDetails]
				  SET [MothersSubjectId] = @MothersSubjectId, 
				  [TypeofBaby] = @TypeofBaby, 
				  [DateOfRegistration] =  CONVERT(DATETIME,@DateOfRegistration,103), 
				  [HospitalNo] = @HospitalNo, 
				  [BabyName] = @BabyName, 
				  [Gender] = @Gender, 
				  [BirthWeight] = @BirthWeight, 
				  [DeliveryDateTime] = CONVERT(DATETIME,@DeliveryDateTime,103), 
				  [StatusofBirth] = @StatusofBirth, 
				  [UpdatedOn] = GETDATE(), 
				  [UpdatedBy] = @CreatedBy 
			WHERE  [BabySubjectId] = @BabySubjectId
		
			SET @ROWCOUNT=@@ROWCOUNT
		
			IF (@ROWCOUNT > 0)
				SET @MSG =  'Baby Detail Updated Successfully'
		
			ELSE
			BEGIN
			

				SET @NewUniqueSubjectID =(SELECT [dbo].[FN_GenerateBabySubjectId] (@MothersSubjectID,@Gender))
			
				INSERT INTO[dbo].[Tbl_BabyDetails]
					   ([MothersSubjectId]
					   ,[TypeofBaby]
					   ,[BabySubjectId]
					   ,[DateOfRegistration]
					   ,[HospitalId]
					   ,[HospitalNo]
					   ,[BabyName]
					   ,[Gender]
					   ,[BirthWeight]
					   ,[DeliveryDateTime]
					   ,[StatusofBirth]
					   ,[CreatedOn]
					   ,[CreatedBy]
					   ,[Isactive])
					VALUES( 
							@MothersSubjectId
						   ,@TypeofBaby
						   ,@NewUniqueSubjectID
						   ,CONVERT(DATETIME,@DateOfRegistration,103)
						   ,@HospitalId
						   ,@HospitalNo
						   ,@BabyName
						   ,@Gender
						   ,@BirthWeight
						   ,CONVERT(DATETIME,@DeliveryDateTime,103)
						   ,@StatusofBirth
						   ,GETDATE()
						   ,@CreatedBy
						   ,1)
			  SET @MSG = 'Baby Registered Successfully' 
	
			END

			SELECT  @NewUniqueSubjectID AS BabySubjectId, @MSG AS MSG
		END
		ELSE
		BEGIN
			SELECT  '' AS BabySubjectId, 'Invalid Mother SubjectId' AS MSG
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