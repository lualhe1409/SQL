select * from vUPInvProducto(nolock) where IDCompania=278
GROUP BY IDBodega, NombreBodega, IDUbicacion,  IDCompania, NombreCompania, IDProducto, NombreProducto,  IDEstadoInventario, 
NombreEstadoInventario, LoteProveedor, LoteFabricante, 
FechaCaducidad        
ORDER BY IDEstadoInventario ASC

select * from producto (nolock) where IDProducto in (
'10734127',
'10568622',
'10293798',
'10205616',
'1100736',
'10252367',
'10150404',
'1100733',
'1101027',
'IC00063',
'10001939',
'1101801',
'1100364',
'10001938',
'1123234',
'02858715',
'1100384',
'1123225',
'1100330',
'1123238',
'112')


SELECT IDUbicacion, IDProducto, NombreProducto,  LoteProveedor, LoteFabricante, FechaCaducidad, IDEstadoInventario, 
NombreEstadoInventario,    SUM(CantidadSis) CantidadSis,  SUM(CantidadCC) CantidadCC,  SUM(CantidadSis) - SUM(CantidadCC) Diferencia    
FROM vUPInvProducto (nolock)
WHERE 1 = 1    AND IDCompania like 4 AND IDBodega=2
AND IDProducto IN(SELECT IDProducto FROM Producto(Nolock))
GROUP BY IDBodega, NombreBodega, IDUbicacion,  IDCompania, NombreCompania, IDProducto, NombreProducto,  IDEstadoInventario, 
NombreEstadoInventario,    LoteProveedor, LoteFabricante, 
FechaCaducidad        
ORDER BY IDEstadoInventario ASC


select IDProducto, count(IDProducto)
from producto (nolock)
group by IDProducto
having count(IDProducto) > 1