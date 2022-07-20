--select * from DocumentoSalida where IDDocumentoSalida ='Pruebavv27'
--select IDEstadoSurtido,CantidadSurtida from DetalleSalida where IDDetalleSalida=1 and IDDocumentoSalida ='Pruebavv27'

--estado surtido y cantidad surtida sea null

--select * from EstadoSurtido

----declare @FechaInicial varchar(30)
--declare @DocSalida varchar(30)
--set @DocSalida='Pruebavv27'
--set @FechaInicial ='2021-05-03' + ' 00:00:00' --#fechainicio#      

--declare @R1  as varchar(max)       
--set @R1 = 'select IDEstadoSurtido from DetalleSalida where IDDetalleSalida=1 and IDDocumentoSalida = ''' +@DocSalida 
--declare @R2  as varchar(max)       
--set @R2 = 'select CantidadSurtida from DetalleSalida (nolock) where IDDetalleSalida=1 and IDDocumentoSalida = ''' + @DocSalida 
-------------------------------------
-------------------------------------
begin tran
declare @Fecha varchar(30)
declare @DocSalida varchar(30)
set @DocSalida='Pru'
set @Fecha ='2022-05-20' + ' 00:00:00' --#fechainicio#      

--estadosurtido numeric, cantSurtida decimal
declare @R1  as varchar(max)
declare @R2  as varchar(max)
select @R1=IDEstadoSurtido,@R2=CantidadSurtida from DetalleSalida where IDDetalleSalida=1 and IDDocumentoSalida =@DocSalida

select @R1 as EdoSurtido, @R2 as CanSurtida
if @R1='1' and  @R2 is  null
	begin   update  DocumentoSalida set FechaFin=@Fecha   where IDDocumentoSalida= @DocSalida
			select FechaFin,IDDocumentoSalida from DocumentoSalida where  IDDocumentoSalida =@DocSalida
end
else
	begin SELECT 'ERROR valide si es correcto el DoctoSalida/Verifique si no se ha empezado a surtir' as Notificacion
end
rollback


--Select  * from information_schema.columns WHERE TABLE_NAME='DetalleSalida' AND COLUMN_NAME='CantidadSurtida'

