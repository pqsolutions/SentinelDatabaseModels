USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchInfantDetailbyMother' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchInfantDetailbyMother  
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchInfantDetailbyMother] 
(
	@HospitalId INT
	,@MothersInput VARCHAR(50)
)
AS
BEGIN
	SELECT MD.[ID] AS MID
		,MD.[RCHID] 
		,MD.[MotherSubjectId]
		,MD.[HospitalFileId] 
		,(MD.[Mother_FirstName] + ' ' + MD.[Mother_LastName]) AS MotherName
		,MD.[Mother_ContactNo] AS ContactNo
		,(INF.[FirstName] + ' ' + INF.[LastName]) AS InfantName
		,INF.[MothersId] 
		,INF.[UniqueSubjectId] 
		,INF.[Gender] 
		,INF.[InfantRCHID] 
		,(CONVERT(VARCHAR,INF.[DateOFDelivery],103) + ' ' + CONVERT(VARCHAR(5),INF.[TimeOfDelivery])) AS DeliveryDateTime
		,CASE WHEN (SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = INF.[UniqueSubjectID]) > 0 THEN 0
		ELSE 1 END AS AllowCollect
	FROM [dbo].[Tbl_MothersDetails] MD
	LEFT JOIN [dbo].[Tbl_InfantDetails] INF WITH (NOLOCK) ON INF.[MothersId] = MD.[ID] 
	WHERE MD.[HospitalId] = @HospitalId AND
	(MD.RCHID = @MothersInput OR MD.[MotherSubjectId]  = @MothersInput OR MD.[HospitalFileId] = @MothersInput)
END