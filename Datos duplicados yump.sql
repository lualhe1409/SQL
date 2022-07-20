--Ejecuta consulta sacar datos
select IDEmbarque,IDDocumentoSalida,IDProducto,IDDetalleSalida,CantidadSurtida,CantidadRequerida
from detallesalida where CantidadSurtida>CantidadRequerida


DECLARE @embarque VARCHAR(50)
SET @embarque=''
DECLARE @Dsalida VARCHAR(50)
SET @Dsalida=''
DECLARE @Producto VARCHAR(50)
SET @Producto=''
DECLARE @Cantidad INT
SET @Cantidad=0

update detallesalida set CantidadSurtida=@Cantidad where IDEmbarque=@embarque and IDDocumentoSalida=@Dsalida and IDProducto=@Producto 
--select * from detalletareasurtido where IDembarque=@embarque and IDProducto=@Producto 
update detalletareasurtido set IDEstadoTarea=8 where IDembarque=@embarque and IDProducto=@Producto
--select * from tarea where idtarea='TG2022020202189'
update tarea set IDEstadoTarea=8 where IDTarea in (select IDTarea from detalletareasurtido where IDembarque=@embarque and IDProducto=@Producto )
----------------
----------------

select * INTO #tc from transconjunto where IDDocumentoSalida='PID02'
select * from #tc order by FechaHora
select FechaHora INTO #fecha from #tc 
select * from #fecha
select * from #tc
DECLARE @Cont as INT;
SET @Cont = (select COUNT (*) from #tc) --where IDDocumentoSalida=@Dsalida and IDProducto=@Producto and IDTipoTransaccion=5)
select @Cont
WHILE(@Cont >= 1) BEGIN	
	--delete from transconjunto where IDDocumentoSalida=@Dsalida and IDProducto=@Producto and IDTipoTransaccion=5
   delete #tc
   select * from #tc
   set @Cont -= 1;
END
select * from #tc

DROP TABLE #tc
DROP TABLE #fecha

delete from transconjunto where IDDocumentoSalida=@Dsalida and IDProducto=@Producto and IDTipoTransaccion=5 and fechahora>='2022-02-02 18:50:07.667'
--select * from RegistroSurtido where IDembarque=@embarque and IDProducto=@Producto and IDDetalleSalida=4
delete RegistroSurtido where IDembarque=@embarque AND IDDocumentoSalida=@Dsalida and IDProducto=@Producto and IDDetalleSalida=4 and 
fechahorasurtido>='2022-02-02 19:00:26.000'