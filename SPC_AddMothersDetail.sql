--USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddMothersDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddMothersDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_AddMothersDetail] 
(
	  @MotherSubjectId VARCHAR(250)
      ,@DateOfRegistration VARCHAR(100)
      ,@DistrictId INT
      ,@HospitalId INT
      ,@HospitalNo VARCHAR(500)
      ,@CollectionSiteId INT
      ,@MotherFirstName VARCHAR(250)
      ,@MotherLastName VARCHAR(250)
      ,@DOB VARCHAR(100)
      ,@Age INT
      ,@RCHID VARCHAR(500)
      ,@MotherGovIdTypeId INT
      ,@MotherGovIdDetail VARCHAR(500)
      ,@MotherContactNo VARCHAR(250)
      ,@G INT
      ,@P INT
      ,@L INT
      ,@A INT
      ,@ECNumber VARCHAR(500)
      ,@Address1 VARCHAR(MAX)
      ,@Address2 VARCHAR(MAX)
      ,@Address3 VARCHAR(MAX)
      ,@StateId INT 
      ,@Pincode VARCHAR(200)
      ,@ReligionId INT
      ,@CasteId INT
      ,@CommunityId INT
      ,@FatherFirstName VARCHAR(250)
      ,@FatherLastName VARCHAR(250)
      ,@FatherContactNo VARCHAR(250)
      ,@GuardianFirstName  VARCHAR(250)
      ,@GuardianLastName VARCHAR(250)
      ,@GuardianContactNo VARCHAR(250)
      ,@UserId INT
)
As
DECLARE
	@NewUniqueSubjectID VARCHAR(200)
	,@DateOfBirth DATETIME
BEGIN
	BEGIN TRY
		IF @DOB = '' OR @DOB IS NULL
		BEGIN
			SET @DateOfBirth = NULL
		END
		ELSE
		BEGIN
			SET @DateOfBirth = CONVERT(DATE,@DOB,103)
		END
		IF @MotherSubjectId IS NULL OR @MotherSubjectId = ''
		BEGIN
			SET @NewUniqueSubjectID =(SELECT [dbo].[FN_GenerateMotherSubjectId] (@HospitalId))

			IF NOT EXISTS (SELECT 1 FROM [Tbl_MothersDetail] WHERE [HospitalNo] =  @HospitalNo)
			BEGIN
				INSERT INTO [Tbl_MothersDetail]  (
					  [DateOfRegistration]
					  ,[DistrictId]
					  ,[HospitalId]
					  ,[HospitalNo]
					  ,[CollectionSiteId]
					  ,[MotherSubjectId]
					  ,[MotherFirstName]
					  ,[MotherLastName]
					  ,[DOB]
					  ,[Age]
					  ,[RCHID]
					  ,[MotherGovIdTypeId]
					  ,[MotherGovIdDetail]
					  ,[MotherContactNo]
					  ,[G]
					  ,[P]
					  ,[L]
					  ,[A]
					  ,[ECNumber]
					  ,[Address1]
					  ,[Address2]
					  ,[Address3]
					  ,[StateId]
					  ,[Pincode]
					  ,[ReligionId]
					  ,[CasteId]
					  ,[CommunityId]
					  ,[FatherFirstName]
					  ,[FatherLastName]
					  ,[FatherContactNo]
					  ,[GuardianFirstName]
					  ,[GuardianLastName]
					  ,[GuardianContactNo]
					  ,[CreatedOn]
					  ,[CreatedBy]
					  ,[Isactive]
			  	
				)VALUES(
				  CONVERT(DATETIME,@DateOfRegistration,103)
				  ,@DistrictId
				  ,@HospitalId
				  ,@HospitalNo
				  ,@CollectionSiteId
				  ,@NewUniqueSubjectID
				  ,@MotherFirstName
				  ,@MotherLastName
				  ,@DateOfBirth
				  ,@Age
				  ,@RCHID
				  ,@MotherGovIdTypeId
				  ,@MotherGovIdDetail
				  ,@MotherContactNo
				  ,@G
				  ,@P
				  ,@L
				  ,@A
				  ,@ECNumber
				  ,@Address1
				  ,@Address2
				  ,@Address3
				  ,@StateId
				  ,@Pincode
				  ,@ReligionId
				  ,@CasteId
				  ,@CommunityId
				  ,@FatherFirstName
				  ,@FatherLastName
				  ,@FatherContactNo
				  ,@GuardianFirstName
				  ,@GuardianLastName
				  ,@GuardianContactNo
				  ,GETDATE() 
				  ,@UserId 
				  ,1)
			  SELECT  @NewUniqueSubjectID AS MotherSubjectId, 'Mother detail Registered Successfully' AS MSG
			END
			ELSE
			BEGIN
				SELECT  @NewUniqueSubjectID AS MotherSubjectId, 'The Hospital No. already exist for some other mother' AS MSG
			END
		
		END
		ELSE
		BEGIN
			UPDATE Tbl_MothersDetail SET
				  [DistrictId] = @DistrictId
				  ,[HospitalNo] = @HospitalNo
				  ,[MotherFirstName] = @MotherFirstName
				  ,[MotherLastName] = @MotherLastName
				  ,[DOB] = @DateOfBirth 
				  ,[Age] = @Age
				  ,[RCHID] = @RCHID
				  ,[MotherGovIdTypeId] = @MotherGovIdTypeId
				  ,[MotherGovIdDetail] = @MotherGovIdDetail
				  ,[MotherContactNo] = @MotherContactNo
				  ,[G] = @G
				  ,[P] = @P
				  ,[L] = @L
				  ,[A] = @A
				  ,[ECNumber] = @ECNumber
				  ,[Address1] = @Address1
				  ,[Address2] = @Address2
				  ,[Address3] = @Address3
				  ,[StateId] = @StateId
				  ,[Pincode] = @Pincode
				  ,[ReligionId] = @ReligionId
				  ,[CasteId] = @CasteId
				  ,[CommunityId] = @CommunityId
				  ,[FatherFirstName] = @FatherFirstName
				  ,[FatherLastName] = @FatherLastName
				  ,[FatherContactNo] = @FatherContactNo
				  ,[GuardianFirstName] = @GuardianFirstName
				  ,[GuardianLastName] = @GuardianLastName
				  ,[GuardianContactNo] = @GuardianContactNo
				  ,[UpdatedOn] = GETDATE()
				  ,[UpdatedBy] = @UserId 
			WHERE MotherSubjectId  = @MotherSubjectId
			
		  SELECT  @MotherSubjectId AS MotherSubjectId, 'Mother Detail Updated Successfully' AS MSG
		   
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