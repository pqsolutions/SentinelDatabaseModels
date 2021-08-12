
USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchUserByUsername' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchUserByUsername
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchUserByUsername](@Username VARCHAR(150))
AS
BEGIN
	SELECT UM.[ID]
	  ,UM.[UserName]
	  ,UM.[Password]
      ,UM.[UserRoleId]
      ,UR.[UserRoleName] 
      ,UM.[HospitalId]
      ,SH.[HospitalName] 
      ,UM.[DistrictId]
      ,DM.[DistrictName] 
      ,UM.[StateId]
      ,SM.[StateName] 
      ,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName])AS  Name
      ,UM.[Email]
      ,UM.[ContactNo]
      ,UM.[Address]
      ,UM.[Pincode]
	  ,UM.[MolecularLabId]
	  ,M.[MLabName]
	FROM [dbo].[Tbl_UserMaster] UM
	LEFT JOIN [dbo].[Tbl_SentinelHospitalMaster]  SH WITH (NOLOCK) ON SH.[ID] = UM.[HospitalId]  
	LEFT JOIN [dbo].[Tbl_UserRoleMaster] UR WITH (NOLOCK) ON UR.[ID] = UM.[UserRoleId] 
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = UM.[DistrictId] 
	LEFT JOIN [dbo].[Tbl_StateMaster] SM WITH (NOLOCK) ON SM.[ID] = UM.[StateId]
	LEFT JOIN [dbo].[Tbl_MolecularLabMaster] M  WITH (NOLOCK) ON UM.[MolecularLabId] = M.[ID]
	WHERE UM.[UserName] = @Username OR UM.[Email] = @Username
END

   



