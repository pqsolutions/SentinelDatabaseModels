USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddMothersDetails' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddMothersDetails
END
GO
CREATE PROCEDURE [dbo].[SPC_AddMothersDetails] 
(
	@DistrictID INT
	,@HospitalId INT
	,@HospitalFileId VARCHAR(MAX)
	,@MotherSubjectId VARCHAR(250)
	,@DateofRegistration VARCHAR(250)
	,@Mother_FirstName VARCHAR(200)
	,@Mother_MiddleName VARCHAR(200)
	,@Mother_LastName VARCHAR(200)
	,@Mother_GovIdTypeId INT
	,@Mother_GovIdDetail VARCHAR(MAX)
	,@Mother_ContactNo VARCHAR(200)
	,@Father_FirstName VARCHAR(200)
	,@Father_MiddleName VARCHAR(200)
	,@Father_LastName VARCHAR(200)
	,@Father_GovIdTypeId INT
	,@Father_GovIdDetail VARCHAR(MAX)
	,@Father_ContactNo VARCHAR(200)
	,@Guardian_FirstName VARCHAR(200)
	,@Guardian_MiddleName VARCHAR(200)
	,@Guardian_LastName VARCHAR(200)
	,@Guardian_GovIdTypeId INT
	,@Guardian_GovIdDetail VARCHAR(MAX)
	,@Guardian_ContactNo VARCHAR(200)
	,@ReligionId INT
	,@CasteId INT
	,@CommunityId INT
	,@ECNumber  VARCHAR(250)
	,@RCHID  VARCHAR(MAX)
	,@Address1 VARCHAR(MAX)
	,@Address2 VARCHAR(MAX)
	,@Address3 VARCHAR(MAX)
	,@State VARCHAR(250)
	,@Pincode VARCHAR(200)
	,@CreatedBy INT
	,@Comments VARCHAR(MAX)
)
As
Declare
	@NewUniqueSubjectID VARCHAR(200)
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT ID FROM Tbl_MothersDetails  WHERE MotherSubjectId  = ISNULL(@MotherSubjectId,''))
		BEGIN
			SET @NewUniqueSubjectID =(SELECT [dbo].[FN_GenerateMotherSubjectId] (@HospitalId))
			INSERT INTO [Tbl_MothersDetails]  (
				DistrictID
			   ,HospitalId
			   ,MotherSubjectId
			   ,HospitalFileId
			   ,DateofRegistration
			   ,Mother_FirstName
			   ,Mother_MiddleName
			   ,Mother_LastName
			   ,Mother_GovIdTypeId
			   ,Mother_GovIdDetail
			   ,Mother_ContactNo
			   ,Father_FirstName
			   ,Father_MiddleName
			   ,Father_LastName
			   ,Father_GovIdTypeId
			   ,Father_GovIdDetail
			   ,Father_ContactNo
			   ,Guardian_FirstName
			   ,Guardian_MiddleName
			   ,Guardian_LastName
			   ,Guardian_GovIdTypeId
			   ,Guardian_GovIdDetail
			   ,Guardian_ContactNo
			   ,ReligionId
			   ,CasteId
			   ,CommunityId
			   ,ECNumber
			   ,RCHID
			   ,Address1
			   ,Address2
			   ,Address3
			   ,State
			   ,Pincode
			   ,CreatedOn
			   ,CreatedBy
			   ,Comments
			   ,Isactive	
			) 
			VALUES(
			@DistrictID
		   ,@HospitalId
		   ,@NewUniqueSubjectID
		   ,@HospitalFileId
		   ,CONVERT(DATETIME,@DateofRegistration,103)
		   ,@Mother_FirstName
		   ,@Mother_MiddleName
		   ,@Mother_LastName
		   ,@Mother_GovIdTypeId
		   ,@Mother_GovIdDetail
		   ,@Mother_ContactNo
		   ,@Father_FirstName
		   ,@Father_MiddleName
		   ,@Father_LastName
		   ,@Father_GovIdTypeId
		   ,@Father_GovIdDetail
		   ,@Father_ContactNo
		   ,@Guardian_FirstName
		   ,@Guardian_MiddleName
		   ,@Guardian_LastName
		   ,@Guardian_GovIdTypeId
		   ,@Guardian_GovIdDetail
		   ,@Guardian_ContactNo
		   ,@ReligionId
		   ,@CasteId
		   ,@CommunityId
		   ,@ECNumber
		   ,@RCHID
		   ,@Address1
		   ,@Address2
		   ,@Address3
		   ,@State
		   ,@Pincode
		   ,GETDATE()
		   ,@CreatedBy
		   ,@Comments
		   ,1)
		  SELECT  @NewUniqueSubjectID AS MotherSubjectId, 'Mother Registered Successfully' AS MSG
		
		END
		ELSE
		BEGIN
			UPDATE [Tbl_MothersDetails]  SET 
				DistrictID = @DistrictID 
			   ,HospitalId = @HospitalId 
			   ,HospitalFileId = @HospitalFileId 
			   ,DateofRegistration = CONVERT(DATETIME,@DateofRegistration,103)
			   ,Mother_FirstName = @Mother_FirstName 
			   ,Mother_MiddleName = @Mother_MiddleName
			   ,Mother_LastName = @Mother_LastName 
			   ,Mother_GovIdTypeId = @Mother_GovIdTypeId 
			   ,Mother_GovIdDetail = @Mother_GovIdDetail 
			   ,Mother_ContactNo = @Mother_ContactNo 
			   ,Father_FirstName = @Father_FirstName 
			   ,Father_MiddleName = @Father_MiddleName
			   ,Father_LastName = @Father_LastName
			   ,Father_GovIdTypeId = @Father_GovIdTypeId
			   ,Father_GovIdDetail = @Father_GovIdDetail
			   ,Father_ContactNo = @Father_ContactNo 
			   ,Guardian_FirstName = @Guardian_FirstName
			   ,Guardian_MiddleName = @Guardian_MiddleName
			   ,Guardian_LastName = @Guardian_LastName
			   ,Guardian_GovIdTypeId = @Guardian_GovIdTypeId
			   ,Guardian_GovIdDetail = @Guardian_GovIdDetail
			   ,Guardian_ContactNo = @Guardian_ContactNo 
			   ,ReligionId = @ReligionId 
			   ,CasteId = @CasteId 
			   ,CommunityId = @CommunityId 
			   ,ECNumber = @ECNumber 
			   ,Address1 = @Address1 
			   ,Address2 = @Address2 
			   ,Address3 = @Address3 
			   ,State = @State 
			   ,Pincode = @Pincode 
			   ,Comments = @Comments 
			   ,UpdatedBy = @CreatedBy 
			   ,UpdatedOn = GETDATE()
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