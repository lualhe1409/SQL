
DECLARE @FechaInicio AS VARCHAR(30) = '2022-05-01' + ' 00:00:00.000'
DECLARE @FechaFin    AS VARCHAR(30) = '2022-05-31' + ' 23:59:59.000'
DECLARE @IDCompania  AS VARCHAR(30) = '2' --#Compania#
DECLARE @IDBodega    AS VARCHAR(30) = '1' --#Bodega#

SELECT DS.IDDocumentoSalida 'Documento Salida',
CONVERT(VARCHAR(30), CONVERT(VARCHAR(30), MAX(FechaHora),103),131) + ' ' + CONVERT(VARCHAR(8), MAX(FechaHora), 108) 'Fecha de Surtido',
DS.IDEmbarque 'Embarque', IDAnden 'Anden', S.IDDestino 'ID Destino', D.Nombre 'Destino', Ds.IDProducto 'Producto', P.Nombre 'Descripción',

COUNT(DISTINCT(ds.IDDetalleSalida)) AS 'Lineas Surtidas',  

((SELECT COUNT(DISTINCT(iddetallesalida)) FROM detallesalida dets (NOLOCK) WHERE dets.iddocumentosalida = ds.iddocumentosalida AND dets.IDEmbarque=Ds.IDEmbarque AND 
cantidadsurtida=0 and dets.IDProducto=Ds.IDProducto) +
 (SELECT COUNT(DISTINCT(iddetallesalida)) FROM detallesalida dets (NOLOCK) WHERE dets.iddocumentosalida = ds.iddocumentosalida AND dets.IDProducto=Ds.IDProducto
  and dets.IDEmbarque=Ds.IDEmbarque AND 
 cantidadsurtida IS NULL)) 'Lineas No Surtidas',

 (SELECT COUNT(DISTINCT(iddetallesalida)) FROM detallesalida detsal (NOLOCK) WHERE
  CantidadSurtida < CantidadRequerida AND detsal.IDEmbarque=Ds.IDEmbarque AND 
  detsal.iddocumentosalida = DS.IDDocumentoSalida and detsal.IDProducto=Ds.IDProducto ) AS 'Lineas Parcialmente Surtidas',
  
 
CONVERT(VARCHAR, CONVERT(MONEY, (SELECT SUM(CantidadRequerida) FROM detallesalida (NOLOCK) 
WHERE iddocumentosalida = ds.iddocumentosalida AND IDProducto = DS.IDProducto AND IDEmbarque=Ds.IDEmbarque)), 1) 'Cantidad Requerida',
isnull (CONVERT(VARCHAR, CONVERT(MONEY, (SELECT SUM(CantidadSurtida) FROM detallesalida (NOLOCK) 
WHERE iddocumentosalida = ds.iddocumentosalida AND IDProducto = DS.IDProducto AND IDEmbarque=Ds.IDEmbarque)), 1),'0') 'Cantidad Surtida',

isnull(convert(numeric(9,2),round((((SELECT SUM(CantidadSurtida)   FROM detallesalida (NOLOCK) WHERE iddocumentosalida = ds.iddocumentosalida 
		AND IDProducto = DS.IDProducto AND IDEmbarque=Ds.IDEmbarque) /
	   (SELECT SUM(CantidadRequerida) FROM detallesalida (NOLOCK) WHERE iddocumentosalida = ds.iddocumentosalida 
	   AND IDProducto = DS.IDProducto AND IDEmbarque=Ds.IDEmbarque)) * 100),2,1)),'0') AS  'FillRate (%)'


FROM DetalleSalida AS DS (NOLOCK)  
INNER JOIN DocumentoSalida AS S (NOLOCK) ON s.IDDocumentoSalida = ds.IDDocumentoSalida
INNER JOIN DetalleEmbarque AS DE (NOLOCK) ON DE.IDEmbarque = DS.IDEmbarque AND DE.IDEstadoEmbarque = 7 
INNER JOIN Destino AS D (NOLOCK) ON D.IDDestino=S.IDDestino
INNER JOIN HistTransConjunto AS HTC (NOLOCK) ON HTC.IDDocumentoSalida = DS.IDDocumentoSalida AND HTC.IDTipoTransaccion = 7
INNER JOIN Producto P (NOLOCK) ON P.IDProducto = DS.IDProducto
WHERE 
DS.IDSubDetalleSalida=1 and
1 = 1 AND 
S.IDCompania LIKE @IDCompania
AND S.IDBodega LIKE @IDBodega
AND FechaHora BETWEEN @FechaInicio AND @FechaFin
GROUP BY DS.IDDocumentoSalida, DS.IDEmbarque, IDAnden, S.IDDestino, d.nombre, ds.IdProducto, P.Nombre, DE.Observacion

 