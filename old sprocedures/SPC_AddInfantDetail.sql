USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Fetch Details of particular subject for sample collection
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddInfantDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddInfantDetail
END
GO
CREATE PROCEDURE SPC_AddInfantDetail
(
	@MothersID INT,
	@DistrictId INT,
	@HospitalId INT,
	@UniqueSubjectId VARCHAR (200),
	@TypeofInfant INT, -- Single / Twins etc...
	@SubTitle VARCHAR(10),
	@FirstName VARCHAR(200),
	@MiddleName VARCHAR(200),
	@LastName VARCHAR(200),
	@Gender VARCHAR(10),
	@InfantRCHID VARCHAR(200),
	@DateofDelivery VARCHAR(200),
	@TimeofDelivery VARCHAR(200),
	@StatusofBirth INT,
	@DateofRegister VARCHAR(200),
	@CreatedBy INT,
	@Comments VARCHAR(MAX)
	
)
As
Declare
	@NewUniqueSubjectID VARCHAR(200),
	@MothersSubjectID VARCHAR(250),
	@MSG VARCHAR(250),
	@ROWCOUNT INT
BEGIN
	BEGIN TRY

	
		SET @NewUniqueSubjectID = @UniqueSubjectId

		SET @ROWCOUNT=0

		UPDATE [dbo].[Tbl_InfantDetails]  SET 
						MothersId = @MothersID,
						DistrictId= @DistrictId,
						HospitalId=@HospitalId,
						TypeofInfant=@TypeofInfant,
						SubTitle =@SubTitle ,
						FirstName =@FirstName ,
						MiddleName = @MiddleName  ,
						LastName = @LastName ,
						Gender = @Gender  ,
						InfantRCHID = @InfantRCHID  ,
						DateofDelivery = CONVERT(DATE,@DateofDelivery,103) ,
						TimeofDelivery = CONVERT(TIME(0),@TimeofDelivery ),
						StatusofBirth = @StatusofBirth,
						DateofRegister = CONVERT(DATE,@DateofRegister,103) ,
						UpdatedOn = GetDate(),
						UpdatedBy = @CreatedBy,
						Comments = @Comments
						WHERE ISNULL(UPPER(UniqueSubjectId),'') = @UniqueSubjectId
		
		SET @ROWCOUNT=@@ROWCOUNT
		
		IF (@ROWCOUNT > 0)
			SET @MSG =  'Infant Detail Updated Successfully'
		
		ELSE
		BEGIN
			
			SET @MothersSubjectID = (SELECT MotherSubjectId FROM [dbo].[Tbl_MothersDetails] WHERE ID = @MOTHERSID)

			SET @NewUniqueSubjectID =(SELECT [dbo].[FN_GenerateInfantSubjectId] (@MothersSubjectID,@MOTHERSID,@GENDER))
			
			INSERT INTO [dbo].[Tbl_InfantDetails]  (

						MothersId ,
						DistrictId,
						HospitalId,
						TypeofInfant,
						UniqueSubjectId,
						SubTitle  ,
						FirstName ,
						MiddleName ,
						LastName   ,
						Gender   ,
						InfantRCHID    ,
						DateofDelivery   ,
						TimeofDelivery  ,
						StatusofBirth  ,
						DateofRegister ,
						CreatedOn  ,
						CreatedBy,
						Comments,
						IsActive) 
				VALUES( 
						@MothersID,
						@DistrictId,
						@HospitalId,
						@TypeofInfant,
						@NewUniqueSubjectID,
						@SubTitle,
						@FirstName,
						@MiddleName,
						@LastName,
						@Gender ,
						@InfantRCHID,
						CONVERT(DATE,@DateofDelivery,103) ,
						CONVERT(TIME(0),@TimeofDelivery ),
						@StatusofBirth,
						CONVERT(DATE,@DateofRegister,103) ,
						GetDate(),
						@CreatedBy,
						@Comments,
						1)
		  
		  SET @MSG = 'Infant Registered Successfully' 
	
		END

		SELECT  @NewUniqueSubjectID AS InfantSubjectId, @MSG AS MSG

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