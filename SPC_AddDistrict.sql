USE [SentinelEduquaydb] 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddDistrict' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddDistrict
END
GO
CREATE PROCEDURE [dbo].[SPC_AddDistrict]
(	
	@StateID INT
	,@Districtname VARCHAR(100)
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Scope_output INT OUTPUT
) AS
DECLARE
	@districtCount INT
	,@ID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF @Districtname != '' OR @Districtname IS NOT NULL 		
		BEGIN
			SELECT @districtCount =  COUNT(ID) FROM Tbl_DistrictMaster WHERE Districtname= @Districtname
			SELECT @ID = ID FROM Tbl_DistrictMaster WHERE Districtname= @Districtname
			IF(@districtCount <= 0)
			BEGIN
				INSERT INTO Tbl_DistrictMaster (
					StateID
					,Districtname
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@StateID
				,@Districtname
				,1
				,@Comments
				,@Createdby
				,@Createdby 
				,GETDATE()
				,GETDATE()
				)
				SET @tempUserId = IDENT_CURRENT('Tbl_DistrictMaster')
				SET @Scope_output = 1
			END
			ELSE
			BEGIN
				UPDATE Tbl_DistrictMaster SET 
				StateID=@StateID
				,Isactive = 4
				,Comments = @Comments
				,Updatedby = @Createdby 
				,Updatedon = GETDATE()
				WHERE ID = @ID
			END
		END
		ELSE
		BEGIN
			SET @Scope_output = -1
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
