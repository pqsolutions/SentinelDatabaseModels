USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateMotherProfile' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateMotherProfile
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateMotherProfile] 
(
	@MotherSubjectId VARCHAR(250)
	,@MotherFirstName VARCHAR(250)
	,@MotherLastName VARCHAR(250)
	,@DOB VARCHAR(250)
	,@Age INT
	,@Address1 VARCHAR(MAX)
	,@Address2 VARCHAR(MAX)
	,@Address3 VARCHAR(MAX)
	,@StateId INT
	,@Pincode VARCHAR(200)
	,@MotherContactNo VARCHAR(250)
	,@RCHID VARCHAR(MAX)
	,@ECNumber VARCHAR(MAX)
	,@MotherGovIdTypeId INT
	,@MotherGovIdDetail VARCHAR(500)
	,@FatherFirstName VARCHAR(250)
	,@FatherLastName VARCHAR(250)
	,@FatherContactNo VARCHAR(250)
	,@GuardianFirstName VARCHAR(250)
	,@GuardianLastName VARCHAR(250)
	,@GuardianContactNo VARCHAR(250)
	,@G INT
	,@P INT
	,@L INT
	,@A INT
	,@UserId INT
)
AS 
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM Tbl_MothersDetail WHERE MotherSubjectId = @MotherSubjectId)
		BEGIN
			UPDATE Tbl_MothersDetail SET
				  [MotherFirstName] = @MotherFirstName
				  ,[MotherLastName] = @MotherLastName
				  ,[DOB] = CONVERT(DATE,@DOB,103)
				  ,[Age] = @Age
				  ,[RCHID] = @RCHID
				  ,[G] = @G
				  ,[P] = @P
				  ,[L] = @L
				  ,[A] = @A
				  ,[MotherGovIdTypeId] = @MotherGovIdTypeId
				  ,[MotherGovIdDetail] = @MotherGovIdDetail
				  ,[MotherContactNo] = @MotherContactNo
				  ,[ECNumber] = @ECNumber
				  ,[Address1] = @Address1
				  ,[Address2] = @Address2
				  ,[Address3] = @Address3
				  ,[StateId] = @StateId
				  ,[Pincode] = @Pincode
				  ,[FatherFirstName] = @FatherFirstName
				  ,[FatherLastName] = @FatherLastName
				  ,[FatherContactNo] = @FatherContactNo
				  ,[GuardianFirstName] = @GuardianFirstName
				  ,[GuardianLastName] = @GuardianLastName
				  ,[GuardianContactNo] = @GuardianContactNo
				  ,[UpdatedOn] = GETDATE()
				  ,[UpdatedBy] = @UserId 
			WHERE MotherSubjectId  = @MotherSubjectId
			 SELECT  @MotherSubjectId AS MotherSubjectId, 'Mother Detail Updated Successfully' AS MSG, 1 AS Success
		END
		ELSE
		BEGIN
			 SELECT  @MotherSubjectId AS MotherSubjectId, 'Mother detail dies not exist' AS MSG, 0 AS Success
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