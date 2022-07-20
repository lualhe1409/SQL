----------------------------------------------------------------------------------------------------
------Identidicador de documentosSalida	que se encuentren en detalleTareaSurtido--------------------
----------------------------------------------------------------------------------------------------
select IDENTITY(int, 1,1) ID,IDDocumentoSalida into #tabla from DetalleSalida (NOLOCK)
where IDEmbarque in (select IDEmbarque from DetalleTareaSurtido (NOLOCK) group by IDEmbarque) group by IDDocumentoSalida

select * from #tabla
--------------------------------------------------------------------------------
---------------------Comienzan Joins y operaciones------------------------------
--------------------------------------------------------------------------------
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
--FILTROS---
where DoSa.IDDocumentoSalida in (
select IDDocumentoSalida from #tabla)
--Agrupado de datos--
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
--------------------------------------------------------
--------------------Cuenta registros--------------------
--------------------------------------------------------
select docto=IDDocumentoSalida ,conteo=count (IDDocumentoSalida) into #ctrl from #tabReporte (NOLOCK)
group by IDDocumentoSalida
select * from #ctrl
--------------------------------------------------------------------------------
-------------Valida Registros mayor a 2 osea que se estan trabajando--------------------
--------------------------------------------------------------------------------
select docto  into #trabajando from #ctrl (NOLOCK) where conteo>=2
select * from #trabajando
--------------------------------------------------------------------------------
-------------Valida Registros = a 1 osea que estan en Espera--------------------
--------------------------------------------------------------------------------
select docto  into #Espera from #ctrl (NOLOCK) where conteo=1
select * from #Espera
--------------------------------------------------------------------------------
-------------Reporte final--------------------
--------------------------------------------------------------------------------
select *  Into #final from #tabReporte (NOLOCK) where IDDocumentoSalida in (select docto from #trabajando (NOLOCK)) and IDUsuario is not null
UNION ALL
select * from #tabReporte (NOLOCK) where IDDocumentoSalida in (select docto from #Espera (NOLOCK)) 

select * from #final (NOLOCK) --where IDCompania=1 and IDBodega=1 and Anden=1 and IDUsuario='ADMIN22'

drop table #final
drop table #Espera
drop table #trabajando
drop table #tabReporte
drop table #tabla
drop table #ctrl



--DECLARE @IDBodega    VARCHAR(30) = '#IDbodega#'--#IDbodega# ---
--DECLARE @IDcompania    VARCHAR(30) = '#IDcompania#'--
--DECLARE @IDanden    VARCHAR(30) = '#IDanden#'
--DECLARE @IDuser    VARCHAR(30) = '#IDuser#'



-------------------------------
-------------------------------
