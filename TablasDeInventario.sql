
select * from  UbicacionProductoInventario  where IDUbicacion='3017'
select * from  UbicacionProductoInventariosis  where IDUbicacion='3017'
select * from  ubicacioninventario where IDUbicacion='3017' 
select * from  UsuarioInventario  where IDUbicacion='3017' 
select idubicacion,idbloqueo,* from  Ubicacion  where IDUbicacion='3017'

begin tran
delete UbicacionProductoInventario  where IDUbicacion='3017'
delete UbicacionProductoInventariosis  where IDUbicacion='3017'
delete ubicacioninventario where IDUbicacion='3017' 
delete from  UsuarioInventario  where IDUbicacion='3017' 
update Ubicacion set IDBloqueo='1'  where IDUbicacion='3017'
rollback


select*from DetalleTareaSurtido where IDEmbarque='550148251' and IDEstadoTarea <>8