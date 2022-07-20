
DECLARE @FechaInicio AS VARCHAR(30) = '2022-05-01' + ' 00:00:00.000'
DECLARE @FechaFin    AS VARCHAR(30) = '2022-05-30' + ' 23:59:59.000'
DECLARE @IDCompania  AS VARCHAR(30) = '4' --#Compania#4
DECLARE @IDBodega    AS VARCHAR(30) = '2' --#Bodega#2

SELECT DS.IDDocumentoSalida 'Documento Salida',Ds.IDSubDetalleSalida,
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
  
 
CONVERT(VARCHAR, CONVERT(numeric, (SELECT SUM(CantidadRequerida) FROM detallesalida (NOLOCK) 
WHERE iddocumentosalida = ds.iddocumentosalida AND IDProducto = DS.IDProducto AND IDEmbarque=Ds.IDEmbarque)), 1) 'Cantidad Requerida',
isnull (CONVERT(VARCHAR, CONVERT(numeric, (SELECT SUM(CantidadSurtida) FROM detallesalida (NOLOCK) 
WHERE iddocumentosalida = ds.iddocumentosalida AND IDProducto = DS.IDProducto AND IDEmbarque=Ds.IDEmbarque)), 1),'0') 'Cantidad Surtida'


into #RepFillinicial FROM DetalleSalida AS DS (NOLOCK)  
INNER JOIN DocumentoSalida AS S (NOLOCK) ON s.IDDocumentoSalida = ds.IDDocumentoSalida
INNER JOIN DetalleEmbarque AS DE (NOLOCK) ON DE.IDEmbarque = DS.IDEmbarque AND DE.IDEstadoEmbarque = 7 
INNER JOIN Destino AS D (NOLOCK) ON D.IDDestino=S.IDDestino
INNER JOIN HistTransConjunto AS HTC (NOLOCK) ON HTC.IDDocumentoSalida = DS.IDDocumentoSalida AND HTC.IDTipoTransaccion = 7
INNER JOIN Producto P (NOLOCK) ON P.IDProducto = DS.IDProducto
WHERE 
1 = 1 AND 
S.IDCompania LIKE @IDCompania
AND S.IDBodega LIKE @IDBodega
AND FechaHora BETWEEN @FechaInicio AND @FechaFin
And ds.IDDocumentoSalida='80013015'
GROUP BY DS.IDDocumentoSalida, DS.IDEmbarque, IDAnden, S.IDDestino, d.nombre, ds.IdProducto, P.Nombre, DE.Observacion,Ds.IDSubDetalleSalida

select * from #RepFillinicial
select IDENTITY(int, 1,1) ID,* into #Backs from #RepFillinicial where IDSubDetalleSalida<>1

DECLARE @COUNTER INT
set @COUNTER= (select count(*) from #Backs)

DECLARE @suma numeric
DECLARE @v1 numeric
DECLARE @v2 numeric
WHILE @COUNTER > 0
Begin  

  set  @suma=((
  select cast([Cantidad Surtida] as numeric(18,2)) from #RepFillinicial  where [Documento Salida]=(select [Documento Salida] from #Backs where ID=@COUNTER) 
  and Producto=(select [Producto] from #Backs where ID=@COUNTER)
  and IDSubDetalleSalida=1)+(select cast([Cantidad Surtida] as numeric(18,2)) from #Backs where ID=@COUNTER))
 
  update  #RepFillinicial  set [Cantidad Surtida]=@suma
  where [Documento Salida]=(select [Documento Salida] from #Backs where ID=@COUNTER) and Producto=(select [Producto] from #Backs where ID=@COUNTER)
  and IDSubDetalleSalida=1

  delete #RepFillinicial where [Documento Salida]=(select [Documento Salida] from #Backs where ID=@COUNTER) and Producto=(select [Producto] from #Backs where ID=@COUNTER)
  and IDSubDetalleSalida=(select IDSubDetalleSalida from #Backs where ID=@COUNTER)

  set @v1=(select cast([Cantidad Surtida]as numeric(18,2)) from #RepFillinicial where [Documento Salida]=(select [Documento Salida] from #Backs where ID=@COUNTER) and Producto=(select [Producto] from #Backs where ID=@COUNTER)
  and IDSubDetalleSalida=1)
  set @v2=(select cast([Cantidad Requerida]as numeric(18,2)) from #RepFillinicial where [Documento Salida]=(select [Documento Salida] from #Backs where ID=@COUNTER) and Producto=(select [Producto] from #Backs where ID=@COUNTER)
  and IDSubDetalleSalida=1)

  if @v1=@v2
	  begin update #RepFillinicial set [Lineas Parcialmente Surtidas]=0 , [Lineas No Surtidas]=0 where [Documento Salida]=(select [Documento Salida] from #Backs where ID=@COUNTER) and Producto=(select [Producto] from #Backs where ID=@COUNTER)
  and IDSubDetalleSalida=1
  end
  if @v1<@v2
	  begin update #RepFillinicial set [Lineas Parcialmente Surtidas]=1 , [Lineas No Surtidas]=0 where [Documento Salida]=(select [Documento Salida] from #Backs where ID=@COUNTER) and Producto=(select [Producto] from #Backs where ID=@COUNTER)
  and IDSubDetalleSalida=1
  end

  set @COUNTER=@COUNTER-1
End

select *,convert(numeric(9,2),round(((cast([Cantidad Surtida]as decimal)*100)/(cast([Cantidad Requerida]as decimal))),2,1)) 
as 'FILLRATE%' from #RepFillinicial order by [Fecha de Surtido]
drop table #RepFillinicial
drop table #Backs


