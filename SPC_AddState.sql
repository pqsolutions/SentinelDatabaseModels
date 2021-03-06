USE [SentinelEduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddState]    Script Date: 03/25/2020 23:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddState' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddState
END
GO
CREATE PROCEDURE [dbo].[SPC_AddState] 
(	
	@StateName VARCHAR(100)
	,@ShortName VARCHAR(10)
	,@IsActive  Bit
	,@Comments VARCHAR(150)
	,@CreatedBy INT
	,@Scope_output INT OUTPUT
) AS
DECLARE
	@stateCount INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF @StateName != '' OR @StateName IS NOT NULL 
		BEGIN
			SELECT @stateCount =  COUNT(ID) FROM Tbl_StateMaster WHERE StateName = @StateName 
			IF(@stateCount <= 0)
			BEGIN
				INSERT INTO Tbl_StateMaster (
					StateName
					,ShortName
					,Isactive
					,Comments
					,CreatedBy
					,UpdatedBy
					,CreatedOn
					,UpdatedOn
				) 
				VALUES(
				@StateName
				,@ShortName
				,@IsActive
				,@Comments
				,@CreatedBy
				,@CreatedBy
				,GETDATE()
				,GETDATE()
				)
				SET @tempUserId = IDENT_CURRENT('Tbl_StateMaster')
				SET @Scope_output = 1
			END
			ELSE
			BEGIN
				UPDATE Tbl_StateMaster SET 
				StateName = @StateName
				,ShortName=@ShortName
				,Isactive = @IsActive
				,Comments = @Comments
				,UpdatedBy = @CreatedBy  
				,Updatedon = GETDATE()
				WHERE StateName = @StateName
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
