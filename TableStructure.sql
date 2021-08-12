
USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularLabInchargeDetails' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_MolecularLabInchargeDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Designation] [varchar](max) NULL,
	[Department] [varchar](max) NULL,
	[Incharge] [varchar](max) NULL,
	[MolAddress] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL
	PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END	
---------------------------------------

USE [SentinelEduquaydb]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_BirthStatusMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_BirthStatusMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BirthStatus] [varchar](150) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
------------------------------------------------------------------------------------------------------

USE [SentinelEduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_StateMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_StateMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StateName] [varchar](150) NOT NULL,
	[ShortName] [varchar](10) NOT NULL,	
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
------------------------------------------------------------------------------------------------------
USE [SentinelEduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_DistrictMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_DistrictMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StateID] [int] NOT NULL,
	[DistrictName] [varchar](150) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
---------------------------------------------------------------------------------



USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SentinelHospitalMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_SentinelHospitalMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DistrictID] [int] NOT NULL,
	[HospitalCode] [varchar](100) NULL,
	[HospitalName] [varchar](150) NOT NULL,
	[HNIN] [varchar](250) NULL,
	[Pincode] [varchar] (100) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	[MolecularLabId] [int] NULL,
	[HospitalAddress] [varchar](max) NULL,
	[HospitalContactNo] [varchar] (max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
---------------------------------------------------------------------------------


USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularLabMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MolecularLabMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DistrictID] [int] NOT NULL,
	[MLabCode] [varchar](100) NOT NULL,
	[MLabName] [varchar](100) NOT NULL,
	[Pincode] [varchar](150) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---------------------------------------------------------------------------------------------------------------


USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_UserRoleMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_UserRoleMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserRoleName] [varchar] (200) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---------------------------------------------------------------------------------------------------------------


USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_UserMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_UserMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserRoleId] [int] NOT NULL,
	[HospitalId] [int] NOT NULL,
	[FirstName] [varchar] (250) NOT NULL,
	[MiddleName] [varchar] (250)  NULL,
	[LastName] [varchar] (250)  NULL,
	[Email] [varchar] (250)  NULL,
	[ContactNo] [varchar] (250)  NULL,
	[Address] [varchar] (max)  NULL,
	[Pincode] [varchar] (250)  NULL,
	[DistrictId] [int] NOT NULL,
	[StateId][int] NULL,
	[UserName] [varchar] (250) NOT NULL,
	[Password] [varchar] (250) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[MolecularLabId] [int] NULL, 
	[OTP] [varchar](max) NULL,
	[OTPCreatedOn] [datetime] NULL,
	[OTPExpiredOn] [datetime] NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---------------------------------------------------------------------------------------------------------------

USE [SentinelEduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_GovIdTypeMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_GovIdTypeMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GovIdType] [varchar](250) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
---------------------------------------------------------------------------------


USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ReligionMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ReligionMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReligionName] [varchar](150) NOT NULL,	
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


---------------------------------------------------------------------------------

USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CasteMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CasteMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CasteName] [varchar](150) NOT NULL,	
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

--------------------------------------------------------------------------------------------

USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CommunityMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_CommunityMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CasteID] [int] NOT NULL,
	[CommunityName] [varchar](150) NOT NULL,	
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
------------------------------------------------------------------------------------------



USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ClinicalDiagnosisMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ClinicalDiagnosisMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DiagnosisName] [varchar](250) NOT NULL,	
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------------------------------------------------

USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ResultMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ResultMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Result] [varchar](250) NOT NULL,	
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------------------------------------------------


USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ConstantValues' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ConstantValues](
	[ID] [int] IDENTITY(1,1) NOT NULL,	
	[CommonName] [varchar] (200) NOT NULL,
	[comments][varchar] (150) NULL,	
	[CreatedOn] [datetime] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

--------------------------------------------------------------------------------------------------------



USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MothersDetail' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_MothersDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateOfRegistration] [datetime]NOT  NULL,
	[DistrictId] [int] NOT NULL,
	[HospitalId] [int] NOT NULL,
	[HospitalNo] [varchar](500) NULL,
	[CollectionSiteId] [int] NULL,
	[MotherSubjectId] [varchar] (250)  NULL,
	[MotherFirstName] [varchar] (250) NOT NULL,
	[MotherLastName] [varchar](250) NULL,
	[DOB] [date] NULL,
	[Age] [int] NULL,
	[RCHID] [varchar] (max) NULL,
	[MotherGovIdTypeId] [int] NULL,
	[MotherGovIdDetail] [varchar](500) NULL,
	[MotherContactNo] [varchar](250) NULL,
	[G][int] NULL,
	[P][int] NULL,
	[L][int] NULL,
	[A][int] NULL,
	[ECNumber] [varchar] (max) NULL,
	[Address1] [varchar] (max) NULL,
	[Address2] [varchar] (max) NULL,
	[Address3] [varchar] (max) NULL,
	[StateId] [int] NULL,
	[Pincode] [varchar] (200) NULL,
	[ReligionId] [int] NULL,
	[CasteId] [int] NULL,
	[CommunityId] [int] NULL,
	[FatherFirstName] [varchar](250) NULL,
	[FatherLastName] [varchar](250) NULL,
	[FatherContactNo] [varchar](250) NULL,
	[GuardianFirstName] [varchar](250) NULL,
	[GuardianLastName] [varchar](250) NULL,
	[GuardianContactNo] [varchar](250) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


---------------------------------------------------------------------------------------------------------------------------------


USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_BabyDetails' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_BabyDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MothersSubjectId] [varchar](250) NOT NULL,
	[TypeofBaby] [int] NOT NULL, -- Single / Twins etc...
	[BabySubjectId][varchar](250) NOT NULL,
	[DateOfRegistration] [datetime] NOT NULL,
	[HospitalId] [int] NULL,
	[HospitalNo] [varchar] (500) NULL,
	[BabyName] [varchar] (500) NULL,
	[Gender] [varchar] (10) NULL,
	[BirthWeight] [varchar] (100) NULL,
	[DeliveryDateTime] [datetime] NULL,
	[StatusofBirth] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	[BabyFirstName] [varchar](250)  NULL,
	[BabyLastName] [varchar](250)  NULL,

PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

---------------------------------------------------------------------------------------------------------------------------------

USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_BabySampleCollection' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_BabySampleCollection](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BabySubjectId][varchar](250) NOT NULL,
	[HospitalId] [int] NOT NULL,
	[BarcodeNo] [varchar](200) NOT NULL,
	[SampleCollectionDate] [date] NOT NULL,
	[SampleCollectionTime] [time](2) NOT NULL,
	[BarcodeDamaged] [bit] NULL,
	[SampleDamaged] [bit] NULL,
	[IsAccept] [bit] NULL,
	[CollectedBy] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
------------------------------------------------------------------------------------------------------------


USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SampleCollection' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_SampleCollection](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[InfantID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[HospitalId] [int] NULL,
	[BarcodeNo] [varchar](200) NOT NULL,
	[SampleCollectionDate] [date] NOT NULL,
	[SampleCollectionTime] [time](2) NOT NULL,
	[BarcodeDamaged] [bit] NULL,
	[SampleDamaged] [bit] NULL,
	[IsAccept] [bit] NULL,
	[Reason_Id] [int] NOT NULL,
	[CollectedBy] [int] NULL,
	[IsRecollected] [char](1) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
------------------------------------------------------------------------------------------------------------



USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON  
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_Shipment' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_Shipment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GeneratedShipmentId] [varchar](200) NOT NULL,
	[HospitalId] [int] NULL,
	[MolecularLabId] [int] NULL,
	[SenderName] [varchar](250) NULL,
	[ContactNo] [varchar] (150) NULL,
	[DateofShipment] [date] NULL,
	[TimeofShipment] [time](2)NULL,	
	[ReceivedDate] [date] NULL,
	[ProcessingDate] [date] NULL,
	[ProcessingTime] [time](2) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


---------------------------------------------------------------------------------------------------------------------



USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON  
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ShipmentDetail' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ShipmentDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentId] [int] NOT NULL,
	[BabySubjectId] [varchar](250) NOT NULL,
	[Barcode] [varchar](250) NOT NULL,
	[IsAccept] [bit] NULL,
	[SampleDamaged] [bit] NULL,
	[BarcodeDamaged] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
-------------------------------------------------------------------------------------------------------



USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON  
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularResult' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MolecularResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BabySubjectID] [varchar](250) NOT NULL,
	[BarcodeNo] [varchar](250) NOT NULL,
	[DiagnosisId] [int] NULL,
	[ResultId] [int] NULL,
	[Remarks] [varchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsDamaged] [bit] NULL,
	[IsProcessed] [bit] NULL,
	[ReasonForClose] [varchar] (max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------------------------------
USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularResultMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MolecularResultMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ResultName] [varchar](250) NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

--------------------------------------------------------------------------------


USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularSampleStatusMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MolecularSampleStatusMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](250) NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

---------------------------------------------------------------------------------------------------------------------------------



--USE [SentinelEduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ZygosityMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ZygosityMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ZygosityName] [varchar](max) NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


-------------------------------------------------------------------


--USE [SentinelEduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MutationMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MutationMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Mutation] [varchar](max) NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


------------------------------------------------------------------


--USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularBloodTestResult' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_MolecularBloodTestResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BabySubjectID] [varchar](250) NOT NULL,
	[BarcodeNo] [varchar] (200) NOT NULL,
	[ZygosityId] [int] NULL,
	[Mutation1Id] [int] NULL,
	[Mutation2Id] [int] NULL,
	[Mutation3] [varchar](max) NULL,
	[TestResult] [varchar] (max) NULL,
	[IsDamaged] [bit] NULL,
	[IsProcessed] [bit] NULL,
	[IsComplete] [bit] NULL,
	[ReasonForClose] [varchar] (max) NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[Remarks] [varchar](max) NULL,
	[MolecularLabId] [int] NULL,
	[TestDate] [date] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[OrderPhysicianId] [int] NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END	

-------------------------------------------------------------------------------------------
