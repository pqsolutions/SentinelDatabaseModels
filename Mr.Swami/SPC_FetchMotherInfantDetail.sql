USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Fetch Details of particular subject for sample collection
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMotherInfantDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMotherInfantDetail --'SH01/MOM/000001'
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMotherInfantDetail]
(	
	@HospitalId INT
	,@MothersRchSubHospID VARCHAR(250)
)
AS
BEGIN
	Set @MothersRchSubHospID = ISNULL(UPPER(@MothersRchSubHospID),'')
	/* MothersRchSubHospID Input Parameter will have any of the IDs, HospitalfileID, RCHID or SubjectID
	Getting MothersUniqueID from MothersDetails for the given Input parameter*/

	SELECT MD.[ID] AS MotherId
		,LTRIM(RTRIM(MD.[MotherSubjectId])) AS MotherSubjectId
		,LTRIM(RTRIM(ISNULL(MD.RCHID,''))) AS RCHID 
		,(LTRIM(RTRIM(ISNULL(MD.Mother_FirstName,'')))+' '+ LTRIM(RTRIM(ISNULL(MD.Mother_MiddleName,'')))+' '+	
		LTRIM(RTRIM(ISNULL(MD.Mother_LastName,'')))) AS MothersName
		,MD.DistrictID
		,MD.HospitalID, IFD.[UniqueSubjectId], IFD.[Gender],IFD.[MothersId] 
		,(IFD.[FirstName]+ ' '+ IFD.[MiddleName]+' '+IFD.[LastName]) AS InfantName
		,CONVERT(VARCHAR,IFD.[DateofDelivery],103)+' '+CONVERT(VARCHAR(5),IFD.[TimeofDelivery]) AS DeliveryDatetime
		,IFD.[InfantRCHID] 
		,CASE WHEN (SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = IFD.[UniqueSubjectID]) > 0 THEN 0
		ELSE 1 END AS AllowCollect
	FROM [dbo].[Tbl_MothersDetails] MD
	LEFT JOIN [dbo].[Tbl_InfantDetails] IFD WITH (NOLOCK) ON IFD.MothersID  = MD.ID  
    WHERE MD.[HospitalId] = @HospitalId AND ( UPPER(MotherSubjectId)  = @MothersRchSubHospID OR UPPER(HospitalFileId) = @MothersRchSubHospID)
	-- OR UPPER(RCHId) = @MothersRchSubHospID   -- RCHID is nonmandatory
	ORDER BY IFD.[UniqueSubjectId]
END