
declare @IDBodega as varchar(100)      
declare @IDCompania as varchar (100)    
declare @FechaInicial varchar(30)      
declare @FechaFinal varchar (30)
declare @producto varchar (30)      
declare @m_query as varchar(max)        
set @IDBodega='#bodega#'    
set @IDCompania='#compania#'    
set @FechaInicial='#fechainicio#'       
set @FechaFinal='#fechafinal#'
set @Producto='#Producto#'     
set @m_query='           select  Di.IDBodega ''IDbodega'', BG.Nombre ''Bodega'', CM.IDCompania ''IDCompania'', CM.Nombre ''Compania'',  CONVERT(VARCHAR(20),  
di.FechaDocumento, 103)''Fecha Documento'', di.IDDocumentoIngreso ''Documento Ingreso'',    ORI.Nombre ''Origen'',   
di.DocumentoReferencia ''Documento Referencia'', dti.IDDetalleIngreso ''Detalle Ingreso'', dti.IDProducto ''Producto'',      
p.Nombre ''Descripción'',dti.CantidadPedida ''Cantidad Pedida'', dti.CantidadAduana ''Cantidad Recibida'', dti.LoteProveedor,   
dti.LoteFabricante ''Lote Fabricante'',    CONVERT(VARCHAR(20),  dti.FechaCaducidad, 103)  ''Caducidad'', a.UnidadXCaja ''Unidad por Caja'',   
CONVERT(varchar, convert(money,       (case when round ((dti.CantidadAduana/a.UnidadXCaja),0,1) =0 then 0 when 
round ((dti.CantidadAduana/a.UnidadXCaja),0,1) >0 then round       
((dti.CantidadAduana/a.UnidadXCaja),0,1) end)), 1) ''Total de Cajas''     
from detalleingreso     as dti         inner join  DocumentoIngreso as di on di.IDDocumentoingreso=dti.IDDocumentoingreso       
inner join Producto as p on p.IDProducto= dti.IDProducto and di.IDCompania=p.IDCompania       
inner join Armado as a on a.IDProducto=dti.IDProducto        
left join Bodega BG on BG.IDBodega=DI.IDBodega       
left join Compania CM on CM.IDCompania=DI.IDCompania       
inner join Origen ORI on ORI.IDOrigen=DI.IDOrigen '                
declare @IDDocumentoIngreso as varchar(100)        
set @IDDocumentoIngreso='#doctoingreso#'                

declare @m_filtro as varchar(MAX)          
set @m_filtro='where 1=1      and Di.FechaDocumento >= '''+@FechaInicial+''' and Di.FechaDocumento <= '''+@FechaFinal+''''        

if @IDBodega<>'#bode'+'ga#' 
begin 
set @m_filtro=@m_filtro+' and Di.IDBodega='''+@IDBodega+'''' 
end 
else   
set @m_filtro=@m_filtro+' and Di.IDBodega in (select IDBodega from  Bodega (Nolock))'        

if @IDCompania<>'#compa'+'nia#'     
begin 
set @m_filtro=@m_filtro+' and Di.idcompania='''+@IDCompania+''''       
end    
else   
set @m_filtro=@m_filtro+' and Di.IDCompania in (select IDCompania from  Compania (Nolock))'        

if @IDDocumentoIngreso<>'#docto'+'ingreso#'     
begin 
set @m_filtro=@m_filtro+' and Di.iddocumentoingreso='''+@IDDocumentoIngreso+''''  
end    
else   
set @m_filtro=@m_filtro+' and Di.IDDocumentoIngreso in (select IDDocumentoIngreso from  DocumentoIngreso (Nolock))'               

if @producto<>'#Prod'+'ucto#'     
begin 
set @m_filtro=@m_filtro+' and dti.idProducto='''+@producto+''''  
end    


declare @gpb as varchar (600)     
set @gpb=  '      group by Di.IDBodega,cm.IDCompania, cm.Nombre,di.FechaDocumento, di.IDDocumentoIngreso, di.DocumentoReferencia,   
dti.IDDetalleINgreso, dti.idProducto,ORI.Nombre, p.Nombre,     dti.CantidadPedida, dti.CantidadAduana, a.UnidadXCaja, BG.Nombre,
dti.LoteProveedor,  dti.LoteFabricante,dti.FechaCaducidad   
order by di.FechaDocumento,  di.IDDocumentoIngreso  '      

exec (@m_query+' '+@m_filtro+' '+@gpb)


