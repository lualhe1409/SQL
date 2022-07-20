declare @m_query as varchar(max)         
set @m_query='  
select IDENTITY(int, 1,1) ID,IDDocumentoSalida into #tabla from DetalleSalida (NOLOCK)
where IDEmbarque in (select IDEmbarque from DetalleTareaSurtido (NOLOCK) group by IDEmbarque) group by IDDocumentoSalida

select 
DoSa.IDBodega,
(select Nombre from Bodega (nolock) where IDBodega=DoSa.IDBodega)as Bodega,
DoSa.IDCompania,
(select Nombre from Compania (nolock) where IDCompania=DoSa.IDCompania)as Compania,
DoSa.FechaHoraRegistro,
DoSa.FechaInicio,
DoSa.FechaFin,
DoSa.IDDocumentoSalida,
DoSa.IDDestino,
(select Nombre from Destino (nolock) where IDDestino=DoSa.IDDestino)as Destino,
DeTa.IDAnden as Anden ,
DeTa.IDEmbarque as Embarque,
DeTa.IDUsuario,
(select Nombre from usuario (nolock) where IDUsuario=DeTa.IDUsuario)as Usuario,
(select count(IDDetalleSalida) from DetalleSalida (nolock) where IDDocumentoSalida=dosa.IDDocumentoSalida)as Lineas ,
(SELECT sum(CantidadRequerida) FROM DetalleSalida (nolock) WHERE IDDocumentoSalida=dosa.IDDocumentoSalida )as Requiere , 
(SELECT sum(CantidadSurtida)  FROM DetalleSalida (nolock) WHERE IDDocumentoSalida=dosa.IDDocumentoSalida ) as Surtido,
(SELECT (sum(CantidadRequerida))-(sum(CantidadSurtida))  FROM DetalleSalida (nolock) WHERE IDDocumentoSalida=dosa.IDDocumentoSalida) as NOsurtido,
(select count(IDTarea)  from DetalleTareaSurtido (nolock) WHERE IDEmbarque=DeTa.IDEmbarque )as NumeroTareas,
(select count(IDTarea)  from DetalleTareaSurtido (nolock) WHERE IDEstadoTarea=7 and  IDEmbarque=DeTa.IDEmbarque)as TareasCanceladas
into #tabReporte from DocumentoSalida DoSa (nolock)
 join detalleSalida detSa (nolock) on DoSa.iddocumentosalida=detSa.iddocumentosalida
left join DetalleTareaSurtido  DeTa (nolock) on detSa.idembarque=DeTa.idembarque
where DoSa.IDDocumentoSalida in (
select IDDocumentoSalida from #tabla)
group by 
DoSa.IDBodega,
DoSa.IDCompania,
DoSa.FechaHoraRegistro,
DoSa.FechaInicio,
DoSa.FechaFin,
DoSa.IDDocumentoSalida,
DoSa.IDDestino,
DeTa.IDAnden,
DeTa.IDEmbarque,
DeTa.IDUsuario

select docto=IDDocumentoSalida ,conteo=count (IDDocumentoSalida) into #ctrl from #tabReporte (NOLOCK)
group by IDDocumentoSalida

select docto  into #trabajando from #ctrl (NOLOCK) where conteo>=2

select docto  into #Espera from #ctrl (NOLOCK) where conteo=1

select *  Into #final from #tabReporte (NOLOCK) where IDDocumentoSalida in (select docto from #trabajando (NOLOCK) ) and IDUsuario is not null
UNION ALL
select * from #tabReporte (NOLOCK) where IDDocumentoSalida in (select docto from #Espera (NOLOCK))     
'

DECLARE @IDBodega    VARCHAR(30) = '#IDbodega#' --#IDbodega#
DECLARE @IDanden    VARCHAR(30) = '#IDanden#' --#IDanden#
DECLARE @IDuser    VARCHAR(30) = '#IDuser#' -- #IDuser#

declare @m_filtro as varchar(MAX)  
set @m_filtro=' 
select * from #final (NOLOCK) where IDCompania=1 '

if @IDBodega<>'#IDbo'+'dega#'
	begin set @m_filtro=@m_filtro+' and IDBodega= '+@IDBodega
end
if @IDanden<>'#IDa'+'nden#'
	begin set @m_filtro=@m_filtro+' and Anden= '+@IDanden
end
if @IDuser<>'#IDu'+'ser#'
	begin set @m_filtro=@m_filtro+' and IDUsuario= '''+@IDuser+''' '
end

declare @m_order as varchar(max)
set @m_order='
drop table #final
drop table #Espera
drop table #trabajando
drop table #tabReporte
drop table #tabla
drop table #ctrl '

Exec (@m_query+' '+@m_filtro+' '+@m_order)





