USE [SentinelEduquaydb] 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddCommunity' AND [type] = 'p')
 BEGIN
	DROP PROCEDURE SPC_AddCommunity
 END
GO
CREATE PROCEDURE [dbo].[SPC_AddCommunity]
(	
	@CasteID INT
	,@Communityname VARCHAR(100)
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Scope_output INT OUTPUT
) AS
DECLARE
	@FCount INT
	,@ID INT
	,@tempUserId INT
 BEGIN
	 BEGIN  TRY
		IF @Communityname IS NOT NULL
		 BEGIN
			SELECT @FCount =  COUNT(ID) FROM Tbl_CommunityMaster WHERE CommunityName = @CommunityName
			SELECT @ID =  ID FROM Tbl_CommunityMaster WHERE CommunityName = @Communityname
			IF(@FCount <= 0)
			 BEGIN
				INSERT INTO Tbl_CommunityMaster (
					CasteID
					,Communityname
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@CasteID
				,@Communityname
				,1
				,@Comments
				,@Createdby
				,@Createdby 
				,GETDATE()
				,GETDATE()
				)
				SET @tempUserId = IDENT_CURRENT('Tbl_CommunityMaster')
				SET @Scope_output = 1
			 END
			ELSE
			 BEGIN
				UPDATE Tbl_CommunityMaster SET 
				CasteID = @CasteID
				,Isactive = 1
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
	 END  TRY
	 BEGIN  CATCH
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
	 END  CATCH
 END
