select * from CostosExtraordinarios order by IDRelacionCobranza
select * from CobranzasExtraordinarias
select * from ClienteRemitente(nolock)

select FechaDocumento,* from RegistroDocumento (nolock) where IDDocumento in (--'sldav10',
'41742',
'41743')
select * from RegistroDocumento (nolock) where Documento in ()
SELECT * from RegistroDocumento 
select * from ClienteRemitente 
select * from BitacoraDetalle 
select * from Localidad  
select * from Destinatario 
select * from DetalleDocumento WHERE Documento IN (
'pebex01')
select * from BitacoraDetalle where IDDocumento in(
'41717')
select * from RegistroDocumento where IDDocumento in(
'41717')

--filtrar por cliente remitente y traer toda la informacion
--solo fechas obligatorio 
--filtrado por perido de fechas
--2021-06-18
--2021-06-21
----------------------------------------------------------------
-------------------REPORTE TMS Datos----------------------------
----------------------------------------------------------------
--declare @Docto varchar(30)
--declare @Remitente varchar(30)
--declare @FechaInicial varchar(30)
--declare @FechaFinal varchar (30) 
--set @FechaInicial ='2021-06-18' + ' 00:00:00' --#fechainicio#       
--set @FechaFinal ='2021-06-22' + ' 23:59:59' --#fechafinal#
--set @Remitente='33' --#Remitente#
--set @Docto='PE01'  --#Docto#

--declare @m_query as varchar(max)       

--set @m_query=' select  Cr.Nombre as Cliente,Rd.IDClienteRemitente as ClienteRemitente,Rd.FechaDocumento as Fecha_Documento,
--Rd.Shipment as Shipment,Rd.Documento as OD,
--Bt.factura as Factura, Lc.Nombre as Lugar, Dt.Nombre as Destino, Dd.cantidadreal as Cajas, 
--tr.RazonSocial as Transportista, bd.IDRelacionCobranza as Relacioncobranza,
--Bt.FechaEntregaDocumentos as FechaDeEntregaAEbex,Bt.FechaHoraLlegadaCliente as FechaEntregaCliente,
--Bt.FechaEntregaDocumentos as FechaCapturaSAP,Bi.FacturaTransportista
--from RegistroDocumento as Rd (nolock)

--join ClienteRemitente as Cr on Rd.IDClienteRemitente=Cr.IDClienteRemitente
--join BitacoraDetalle as Bt on Bt.IDDocumento = Rd.IDDocumento
--join Localidad as Lc on Rd.IDLocalidad=Lc.IDLocalidad 
--join Destinatario as Dt	on Dt.IDDestinatario = Rd.IDDestinatario
--join DetalleDocumento as Dd	on Rd.IDDocumento = Dd.IDDocumento
--join BitacoraDetalle as Bd	on Rd.IDDocumento = Bd.IDDocumento
--join Bitacora as Bi	on bi.IDBitacora = Bd.IDBitacora
--join Transportista as Tr	on bi.IDTransportista = tr.IDTransportista'

--declare @m_filtro as varchar(MAX)  
--    set @m_filtro=
--    'where  Rd.FechaDocumento >= ''' + @FechaInicial + ''' and Rd.FechaDocumento <= '''+ @FechaFinal + '''   '
--if @Remitente<>'#Remi'+'tente#'
--	begin set @m_filtro=@m_filtro+' and Rd.IDClienteRemitente='+@Remitente
--end
--if @Docto<>'#Docto#'
--		begin set @m_filtro=@m_filtro+' and Rd.Documento= '''+ @Docto +''' '
--end
--exec (@m_query+' '+@m_filtro)
select * from ClienteRemitente
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
-----------------------------------------------------------------
-------------------REPORTE TMS COSTOS----------------------------
-----------------------------------------------------------------
declare @Docto varchar(30)
declare @Remitente varchar(30)
declare @FechaInicial varchar(30)
declare @FechaFinal varchar (30) 
set @FechaInicial ='2022-05-03' + ' 00:00:00' --#fechainicio#       
set @FechaFinal ='2022-05-04' + ' 23:59:59' --#fechafinal#
set @Remitente='120' --#Remitente#
set @Docto='#Docto#'  --#Docto#

create table #TBcostos (
Documento VARCHAR(30),IDClienteRemitente VARCHAR(30),IDRelacionCobranza numeric,Monto numeric,Nombre VARCHAR(50),
FechaDocumento DATETIME
)
declare @m_query as varchar(max)        

 
set @m_query='select RD.Documento,RD.IDClienteRemitente,CoEx.IDRelacionCobranza,CoEx.Monto,CobExtra.Nombre,RD.FechaDocumento 
from CostosExtraordinarios (nolock) as CoEx
join CobranzasExtraordinarias as CobExtra (nolock) on CoEx.IDCobranzaExtraordinaria=CobExtra.IDCobranzaExtraordinaria
join BitacoraDetalle as BD (nolock) on CoEx.IDRelacionCobranza= BD.IDRelacionCobranza
join RegistroDocumento RD (nolock) on BD.IDDocumento=RD.IDDocumento'  

declare @m_filtro as varchar(MAX)  
    set @m_filtro=
    'where  Rd.FechaDocumento >= ''' + @FechaInicial + ''' and Rd.FechaDocumento <= '''+ @FechaFinal + '''   '
if @Remitente<>'#Remi'+'tente#'
	begin set @m_filtro=@m_filtro+' and Rd.IDClienteRemitente='+@Remitente
end
if @Docto<>'#Docto#'
		begin set @m_filtro=@m_filtro+' and Rd.Documento= '''+ @Docto +''' '
end


Insert Into #TBcostos
Exec (@m_query+' '+@m_filtro)

DECLARE @columns nvarchar(MAX);
DECLARE @sql nvarchar(MAX)
 
SELECT @columns= STUFF(
 (
SELECT
   ',' + QUOTENAME(LTRIM(Nombre))
 FROM
   (SELECT DISTINCT Nombre
    FROM #TBcostos
   ) AS T
ORDER BY
 Nombre
 FOR XML PATH('')
 ), 1, 1, '');
--SELECT @columns
--41703

SET @sql = N'
 SELECT   *   FROM  (  
    SELECT Documento	
		   ,IDClienteRemitente	
		   ,IDRelacionCobranza	
		   ,Monto	
		   ,Nombre
		   ,FechaDocumento
 FROM #TBcostos
  ) AS T
  PIVOT   
  (
  SUM(Monto)
  FOR Nombre IN (' + @columns + N')
  ) AS P;'; 

  EXEC sp_executesql @sql;
drop table #TBcostos




-----------------------------------------------------------------
-------------------REPORTE TMS COSTOS----------------------------
-----------------------------------------------------------------

SELECT FechaDocumento,* from RegistroDocumento  where IDDocumento in(
'41703',
'41717',
'41739',
'41740',
'41741')
select IDRelacionCobranza,* from BitacoraDetalle where IDRelacionCobranza in (
select IDRelacionCobranza from CostosExtraordinarios )
SELECT * FROM #TBcostos
select * from RelacionCobranza
select * from CobranzasExtraordinarias
--filtro por clienteremitente
--idrelacaioncobranza
--fechaDocumento filtro
select * from ClienteRemitente
--41739
4336



declare @Docto varchar(30)
declare @Remitente varchar(30)
declare @FechaInicial varchar(30)
declare @FechaFinal varchar (30) 
set @FechaInicial ='2022-05-03' + ' 00:00:00' --#fechainicio#       
set @FechaFinal ='2022-05-03' + ' 23:59:59' --#fechafinal#
set @Remitente='#Remitente#' --#Remitente#
set @Docto='#Docto#'  --#Docto#

declare @m_query as varchar(max)        
set @m_query='
select RD.Documento,RD.IDClienteRemitente,CoEx.IDRelacionCobranza,CoEx.Monto,CobExtra.Nombre,RD.FechaDocumento INTO #TBcostos 
from CostosExtraordinarios (nolock) as CoEx
join CobranzasExtraordinarias as CobExtra (nolock) on CoEx.IDCobranzaExtraordinaria=CobExtra.IDCobranzaExtraordinaria
join BitacoraDetalle as BD (nolock) on CoEx.IDRelacionCobranza= BD.IDRelacionCobranza
join RegistroDocumento RD (nolock) on BD.IDDocumento=RD.IDDocumento'

declare @m_filtro as varchar(MAX)  
    set @m_filtro=
    'where  Rd.FechaDocumento >= ''' + @FechaInicial + ''' and Rd.FechaDocumento <= '''+ @FechaFinal + '''   '
if @Remitente<>'#Remi'+'tente#'
	begin set @m_filtro=@m_filtro+' and Rd.IDClienteRemitente='+@Remitente
end
if @Docto<>'#Docto#'
		begin set @m_filtro=@m_filtro+' and Rd.Documento= '''+ @Docto +''' '
end

declare @m_queryPivot as varchar(MAX)
set @m_queryPivot='
DECLARE @columns nvarchar(MAX);
DECLARE @sql nvarchar(MAX)
 
SELECT @columns= STUFF(
 (
SELECT
   ',' + QUOTENAME(LTRIM(Nombre))
 FROM
   (SELECT DISTINCT Nombre
    FROM #TBcostos
   ) AS T
ORDER BY
 Nombre
 FOR XML PATH('')
 ), 1, 1, '');
--SELECT @columns
--41703

SET @sql = N'
 SELECT   *   FROM  (  
    SELECT Documento	
		   ,IDClienteRemitente	
		   ,IDRelacionCobranza	
		   ,Monto	
		   ,Nombre
		   ,FechaDocumento
 FROM #TBcostos
  ) AS T
  PIVOT   
  (
  SUM(Monto)
  FOR Nombre IN (' + @columns + N')
  ) AS P;'; 

  EXEC sp_executesql @sql;
drop table #TBcostos
'

exec (@m_query+' '+@m_filtro+' '+@m_queryPivot)



--where RD.Documento=@Docto

select RD.Documento,RD.IDClienteRemitente,CoEx.IDRelacionCobranza,CoEx.Monto,CobExtra.Nombre,RD.FechaDocumento INTO #TBcostos 
from CostosExtraordinarios (nolock) as CoEx
join CobranzasExtraordinarias as CobExtra (nolock) on CoEx.IDCobranzaExtraordinaria=CobExtra.IDCobranzaExtraordinaria
join BitacoraDetalle as BD (nolock) on CoEx.IDRelacionCobranza= BD.IDRelacionCobranza
join RegistroDocumento RD (nolock) on BD.IDDocumento=RD.IDDocumento
where RD.FechaDocumento>='2022-05-03 00:00:00.000' and RD.FechaDocumento<='2022-05-03 23:59:59.000'
--and RD.IDClienteRemitente =33
--and RD.Documento=33
select * from #TBcostos 

DECLARE @columns nvarchar(MAX);
DECLARE @sql nvarchar(MAX)
 
SELECT @columns= STUFF(
 (
SELECT
   ',' + QUOTENAME(LTRIM(Nombre))
 FROM
   (SELECT DISTINCT Nombre
    FROM #TBcostos
   ) AS T
ORDER BY
 Nombre
 FOR XML PATH('')
 ), 1, 1, '');
--SELECT @columns
--41703

SET @sql = N'
 SELECT   *   FROM  (  
    SELECT Documento	
		   ,IDClienteRemitente	
		   ,IDRelacionCobranza	
		   ,Monto	
		   ,Nombre
		   ,FechaDocumento
 FROM #TBcostos
  ) AS T
  PIVOT   
  (
  SUM(Monto)
  FOR Nombre IN (' + @columns + N')
  ) AS P;'; 

  EXEC sp_executesql @sql;
drop table #TBcostos
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------

--select * from RelacionCobranza

select  Cr.Nombre as Cliente,Rd.IDClienteRemitente as ClienteRemitente,Rd.FechaDocumento as Fecha_Documento,
Rd.Shipment as Shipment,Rd.Documento as OD,
Bt.factura as Factura, Lc.Nombre as Lugar, Dt.Nombre as Destino, Dd.cantidadreal as Cajas, 
tr.RazonSocial as Transportista, bd.IDRelacionCobranza as Relacioncobranza,RCo.FechaEnvioPaqueteria as ENVIOMARS,
Bt.FechaEntregaDocumentos as FechaDeEntregaAEbex,Bt.FechaHoraLlegadaCliente as FechaEntregaCliente,
Bt.FechaEntregaDocumentos as FechaCapturaSAP,Bi.FacturaTransportista
from RegistroDocumento as Rd (nolock)
join ClienteRemitente as Cr on Rd.IDClienteRemitente=Cr.IDClienteRemitente
join BitacoraDetalle as Bt on Bt.IDDocumento = Rd.IDDocumento
join Localidad as Lc on Rd.IDLocalidad=Lc.IDLocalidad 
join Destinatario as Dt	on Dt.IDDestinatario = Rd.IDDestinatario
join DetalleDocumento as Dd	on Rd.IDDocumento = Dd.IDDocumento
join BitacoraDetalle as Bd	on Rd.IDDocumento = Bd.IDDocumento
join Bitacora as Bi	on bi.IDBitacora = Bd.IDBitacora
join Transportista as Tr	on bi.IDTransportista = tr.IDTransportista
left join RelacionCobranza as RCo on bd.IDRelacionCobranza= RCo.IDRelacionCobranza




---------------------------
---------------------------
--select  Cr.Nombre as Cliente,Rd.IDClienteRemitente as ClienteRemitente,Rd.FechaDocumento as Fecha_Documento,
--Rd.Shipment as Shipment,Rd.Documento as OD,
--Bt.factura as Factura, Lc.Nombre as Lugar, Dt.Nombre as Destino, Dd.cantidadreal as Cajas, 
--tr.RazonSocial as Transportista, bd.IDRelacionCobranza as Relacioncobranza,
--Bt.FechaEntregaDocumentos as FechaDeEntregaAEbex,Bt.FechaHoraLlegadaCliente as FechaEntregaCliente,
--Bt.FechaEntregaDocumentos as FechaCapturaSAP,Bi.FacturaTransportista
--from RegistroDocumento as Rd (nolock)
--join ClienteRemitente as Cr on Rd.IDClienteRemitente=Cr.IDClienteRemitente
--join BitacoraDetalle as Bt on Bt.IDDocumento = Rd.IDDocumento
--join Localidad as Lc on Rd.IDLocalidad=Lc.IDLocalidad 
--join Destinatario as Dt	on Dt.IDDestinatario = Rd.IDDestinatario
--join DetalleDocumento as Dd	on Rd.IDDocumento = Dd.IDDocumento
--join BitacoraDetalle as Bd	on Rd.IDDocumento = Bd.IDDocumento
--join Bitacora as Bi	on bi.IDBitacora = Bd.IDBitacora
--join Transportista as Tr	on bi.IDTransportista = tr.IDTransportista