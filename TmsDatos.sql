-------------------REPORTE TMS Datos----------------------------
----------------------------------------------------------------
declare @Shipment varchar(30)
declare @Docto varchar(30)
declare @Remitente varchar(30)
declare @FechaInicial varchar(30)
declare @FechaFinal varchar (30) 
set @FechaInicial ='2021-06-18' + ' 00:00:00' --#fechainicio#       
set @FechaFinal ='2022-06-06' + ' 23:59:59' --#fechafinal#
set @Remitente='#Remitente#' --#Remitente#
set @Shipment='#Ship#'  --#Ship#
set @Docto='#Docto#'  --#Docto#

declare @m_query as varchar(max)       

set @m_query=' select  Cr.Nombre as Cliente,Rd.IDClienteRemitente as ClienteRemitente,Rd.FechaDocumento as Fecha_Documento,
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
left join Transportista as Tr	on bi.IDTransportista = tr.IDTransportista
left join RelacionCobranza as RCo on bd.IDRelacionCobranza= RCo.IDRelacionCobranza '
--'join '

declare @m_filtro as varchar(MAX)  
    set @m_filtro=
    'where  Rd.FechaDocumento >= ''' + @FechaInicial + ''' and Rd.FechaDocumento <= '''+ @FechaFinal + '''   '
if @Remitente<>'#Remi'+'tente#'
	begin set @m_filtro=@m_filtro+' and Rd.IDClienteRemitente='+@Remitente
end
if @Shipment<>'#Ship#'
		begin set @m_filtro=@m_filtro+' and Rd.Shipment= '''+ @Shipment +''' '
end
if @Docto<>'#Docto#'
		begin set @m_filtro=@m_filtro+' and Rd.Documento= '''+ @Docto +''' '
end
exec (@m_query+' '+@m_filtro)
  
----------------------------------------------------------