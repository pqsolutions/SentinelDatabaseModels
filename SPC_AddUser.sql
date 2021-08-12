USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddUser
END
GO
CREATE PROCEDURE [dbo].[SPC_AddUser] 
(
	@UserRoleId INT 
	,@HospitalId INT 
	,@FirstName VARCHAR(250) 
	,@MiddleName VARCHAR(250) 
	,@LastName VARCHAR(250)
	,@Email VARCHAR(250) 
	,@ContactNo VARCHAR(250) 
	,@Address VARCHAR(MAX)
	,@Pincode VARCHAR(150)	 
	,@DistrictId INT
	,@StateId INT
	,@UserName VARCHAR(150) 
	,@Password VARCHAR(150)
	,@Createdby INT 	
	,@Comments VARCHAR(max) 
	,@Scope_output INT OUTPUT
)
As
Declare
	@userCount INT
	,@ID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		If @Username IS NOT NULL OR @Username != ''
		BEGIN
			SELECT @userCount =  count(*) FROM [Tbl_UserMaster] WHERE Username = @Username
			SELECT @ID = ID FROM [Tbl_UserMaster] WHERE Username = @Username
			if(@userCount <= 0)
			BEGIN
				INSERT INTO [Tbl_UserMaster] (
					UserRoleId  
					,HospitalId  
					,FirstName
					,MiddleName
					,LastName
					,Email
					,ContactNo
					,Address
					,Pincode
					,DistrictId 
					,StateId 
					,UserName
					,Password
					,Createdby  	
					,Comments
					,CreatedOn
					,IsActive	
				) 
				VALUES(
				@UserRoleId  
				,@HospitalId  
				,@FirstName
				,@MiddleName
				,@LastName
				,@Email
				,@ContactNo
				,@Address
				,@Pincode
				,@DistrictId 
				,@StateId 
				,@UserName
				,@Password
				,@Createdby  	
				,@Comments
				,GETDATE()
				,1
				)
				SET @tempUserId = IDENT_CURRENT('Tbl_UserMaster')
				SET @SCOPE_OUTPUT = 1
			END
			ELSE
			BEGIN
				UPDATE [Tbl_UserMaster] SET 
				UserRoleId = @UserRoleId   
				,HospitalId = @HospitalId  
				,FirstName = @FirstName 
				,MiddleName = @MiddleName 
				,LastName = @LastName
				,Email = @Email 
				,ContactNo = @ContactNo 
				,Address = @Address
				,Pincode = @Pincode 
				,DistrictId =@DistrictId 
				,StateId = @StateId 
				,Password = @Password 
				,UpdatedBy =@Createdby   	
				,Comments = @Comments 
				,UpdatedOn = GETDATE()
				WHERE ID = @ID
			END
		END
		ELSE
		BEGIN
			SET @SCOPE_OUTPUT = -1
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
