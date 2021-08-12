USE [SentinelEduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddShipments' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddShipments
END
GO
CREATE PROCEDURE [dbo].[SPC_AddShipments]
(	
	@BarcodeNo VARCHAR(MAX)	
	,@HospitalId INT
	,@MolecularLabId INT
	,@LogisticsProvider VARCHAR(250)
	,@ContactNo VARCHAR(150)
	,@DateofShipment VARCHAR(100)
	,@TimeofShipment VARCHAR(100)
	,@CreatedBy INT
) AS
DECLARE
	@UniqueSubjectId VARCHAR(250)
	,@GeneratedShipmentID VARCHAR(200)
	,@ShipmentID INT
	
DECLARE @Indexvar INT  
DECLARE @TotalCount INT  
DECLARE @CurrentIndexBarcode NVARCHAR(200)
DECLARE @BNO VARCHAR(MAX)=''
BEGIN
	BEGIN TRY
		IF @BarcodeNo IS NOT NULL
		BEGIN
			IF EXISTS (SELECT Value FROM [dbo].[FN_Split](@BarcodeNo,',') WHERE Value  in (SELECT Barcode FROM Tbl_ShipmentDetail))
			BEGIN
				SET @IndexVar = 0  
				SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@BarcodeNo,',')  
				WHILE @Indexvar < @TotalCount  
				BEGIN
					SELECT @IndexVar = @IndexVar + 1
					SELECT @CurrentIndexBarcode = Value FROM  [dbo].[FN_Split](@BarcodeNo,',') WHERE id = @Indexvar
					IF EXISTS( SELECT Barcode FROM Tbl_ShipmentDetail WHERE Barcode = @CurrentIndexBarcode)
					BEGIN
						SELECT @BNO += @CurrentIndexBarcode + ','
					END
				END
				SELECT @BNO =  LEFT(@BNO, LEN(@BNO) - 1)
				
				SELECT 'The BarcodeNo''s '+ @BNO +' already exist in previous shipment' AS ErrorMessage
				PRINT 'x'
			END
			ELSE
			BEGIN
				SET @GeneratedShipmentID = (SELECT  [dbo].[FN_GenerateShipmentId](@HospitalId))
				INSERT INTO Tbl_Shipment(
					GeneratedShipmentId
					,HospitalId
					,MolecularLabId
					,LogisticsProvider
					,ContactNo
					,DateofShipment
					,TimeofShipment
					,CreatedBy
					,CreatedOn)
				VALUES(
					@GeneratedShipmentID
					,@HospitalId
					,@MolecularLabId
					,@LogisticsProvider
					,@ContactNo
					,CONVERT(DATE,@DateofShipment,103)
					,CONVERT(TIME(0),@TimeofShipment) 
					,@CreatedBy 
					,GETDATE())
					
				SET @ShipmentID = (SELECT SCOPE_IDENTITY())
				
				CREATE  TABLE #TempTable(TempCol NVARCHAR(250), ArrayIndex INT)
				INSERT INTO #TempTable(TempCol,ArrayIndex) (SELECT Value,id FROM dbo.FN_Split(@BarcodeNo,','))
				
				SET @IndexVar = 0  
				SELECT @TotalCount= COUNT(*) FROM #TempTable  
				WHILE @Indexvar < @TotalCount  
				BEGIN 
					 SELECT @Indexvar  = @Indexvar + 1 
					 SELECT @CurrentIndexBarcode = TempCol FROM #TempTable WHERE ArrayIndex = @Indexvar
					 SELECT @UniqueSubjectId = UniqueSubjectID FROM Tbl_SampleCollection WHERE BarcodeNo = @CurrentIndexBarcode 
					 BEGIN  
						INSERT INTO Tbl_ShipmentDetail (ShipmentId,InfantUniqueSubjectId,Barcode)  
						VALUES(@ShipmentID,@UniqueSubjectId,@CurrentIndexBarcode)
					END 
				END
				DROP TABLE #TempTable
				
				SELECT @GeneratedShipmentID AS ShipmentID
				
				PRINT 'y'
			END
			
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