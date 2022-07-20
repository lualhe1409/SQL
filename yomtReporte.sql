select * from DetalleTareaSurtido where IDEmbarque='and1205'

select * from EtiquetaMaestra

select * from Destino








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
(select Nombre from Destino (nolock) where IDDestino=DoSa.IDDestino)as Destino,
(select count(IDDetalleSalida) from DetalleSalida (nolock) where IDDocumentoSalida=dosa.IDDocumentoSalida)as Lineas ,
(SELECT sum(CantidadRequerida) FROM DetalleSalida (nolock) WHERE IDDocumentoSalida=dosa.IDDocumentoSalida )as Requiere , 
(SELECT sum(CantidadSurtida)  FROM DetalleSalida (nolock) WHERE IDDocumentoSalida=dosa.IDDocumentoSalida ) as Surtido,
(SELECT (sum(CantidadRequerida))-(sum(CantidadSurtida))  FROM DetalleSalida (nolock) WHERE IDDocumentoSalida=dosa.IDDocumentoSalida) as NOsurtido,
(select count(IDTarea)  from DetalleTareaSurtido (nolock) WHERE IDEmbarque=DeTa.IDEmbarque )as NumeroTareas,
(select count(IDTarea)  from DetalleTareaSurtido (nolock) WHERE IDEstadoTarea=7 and  IDEmbarque=DeTa.IDEmbarque)as TareasCanceladas
from DocumentoSalida DoSa (nolock)
join detalleSalida detSa (nolock) on DoSa.iddocumentosalida=detSa.iddocumentosalida
join DetalleTareaSurtido  DeTa (nolock) on detSa.idembarque=DeTa.idembarque
where DoSa.IDDocumentoSalida in (
'Prueba1205')
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

--select IDBodega,IDCompania,FechaHoraRegistro,FechaInicio,FechaFin,IDDocumentoSalida,
--IDDestino from DocumentoSalida (nolock) WHERE IDDocumentoSalida='PID02'  
----Sldav2704
--select IDEmbarque from DetalleSalida (nolock) where IDDocumentoSalida='PID02' group by IDEmbarque

--SELECT IDAnden as Anden ,IDEmbarque as Embarque,IDUsuario FROM DetalleTareaSurtido (nolock) WHERE IDEmbarque='Sldav2704' 
--group by IDAnden,IDEmbarque,IDUsuario

--SELECT count (IDDetalleSalida) as Lineas FROM DetalleSalida (nolock) WHERE IDDocumentoSalida='Prueba1205'
--SELECT sum(CantidadRequerida) as Requiere FROM DetalleSalida (nolock) WHERE IDDocumentoSalida='Prueba1205' 
--SELECT sum(CantidadSurtida) as Surtido FROM DetalleSalida (nolock) WHERE IDDocumentoSalida='Prueba1205' 
--SELECT (sum(CantidadRequerida))-(sum(CantidadSurtida)) as NOsurtido FROM DetalleSalida (nolock) WHERE IDDocumentoSalida='Prueba1205'

--select count(IDTarea) as NumeroTareas from DetalleTareaSurtido (nolock) WHERE IDEmbarque='Sldav2704'
--select count(IDTarea) as TareasCanceladas from DetalleTareaSurtido (nolock) WHERE IDEmbarque='Sldav2704' and IDEstadoTarea=7


--select * from DetalleTareaSurtido where IDDocumentoSalida='29abri01'