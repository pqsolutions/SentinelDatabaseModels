



USE [SentinelEduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GenerateShipmentId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GenerateShipmentId   
END
GO
CREATE FUNCTION [dbo].[FN_GenerateShipmentId]   
(
	@HospitalId INT
) 
RETURNS VARCHAR(250)        
AS    
BEGIN
	DECLARE
		@SenderCode  VARCHAR(100)
		,@Month VARCHAR(5)
		,@Year VARCHAR(5)
		,@MonthYear VARCHAR(5)
		,@LastShipmentId VARCHAR(MAX)
		,@LastShipmentId1 VARCHAR(MAX)
		,@ShipmentId VARCHAR(MAX)
		,@ReturnValue VARCHAR(200)
		,@Shipment VARCHAR(50)
		
	
	SET @Year = (SELECT CONVERT(VARCHAR,RIGHT(YEAR(GETDATE()),2)))
	
	IF (LEN(MONTH(GETDATE())) > 1)
	BEGIN
		SET @Month = (SELECT CONVERT(VARCHAR,MONTH(GETDATE())))
	END
	ELSE
	BEGIN
		SET @Month = (SELECT '0' + CAST(MONTH(GETDATE()) AS VARCHAR))
	END
	
	SET @MonthYear =@Year + @Month 
	
	
	SELECT @SenderCode = HospitalCode FROM Tbl_SentinelHospitalMaster WHERE ID = @HospitalId
	
	SET @LastShipmentId =(SELECT TOP 1 GeneratedShipmentId 
						FROM Tbl_Shipment WITH(NOLOCK) WHERE HospitalId = @HospitalId     
						AND GeneratedShipmentId LIKE @SenderCode +'/'+@MonthYear+'/%'   
						ORDER BY GeneratedShipmentId DESC)

	SET @LastShipmentId1 =(SELECT ISNULL(@LastShipmentId,''))

	SELECT @ShipmentId = @SenderCode + '/' + @MonthYear + '/' +     
		CAST(STUFF('0000',5-LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,4)),0)+1),        
		LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,4)),0)+1),        
		CONVERT(VARCHAR,ISNULL(MAX(RIGHT(@LastShipmentId1,4)),0)+1)) AS NVARCHAR(15))
	FROM Tbl_Shipment 
	WHERE  GeneratedShipmentId LIKE @SenderCode +'/'+@MonthYear+'/%'  
	
	SET  @ReturnValue = @ShipmentId

RETURN @ReturnValue
END
