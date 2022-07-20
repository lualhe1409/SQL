DECLARE @m_query    AS VARCHAR(max)    
SET @m_query = '  SELECT IDUbicacion, IDProducto, NombreProducto,  LoteProveedor, LoteFabricante, FechaCaducidad, IDEstadoInventario, 
NombreEstadoInventario,    SUM(CantidadSis) CantidadSis,  SUM(CantidadCC) CantidadCC,  SUM(CantidadSis) - SUM(CantidadCC) Diferencia    
FROM vUPInvProducto    '  
DECLARE @m_filtro   AS VARCHAR(MAX)  
DECLARE @SKU  AS VARCHAR(50) = '#SKU#'     
DECLARE @IDCompania AS VARCHAR(50) = '#Compania#'  
SET @m_filtro =  '    
WHERE 1 = 1    AND IDCompania LIKE ' + @IDCompania + '  '  
IF @SKU <>'#SK'+'U#' BEGIN SET @m_filtro=@m_filtro+' AND IDProducto = ''' + @IDCompania + ''''  
END ELSE SET @m_filtro = @m_filtro+' AND IDProducto IN(SELECT IDProducto FROM Producto(Nolock))'    
declare @gpb as varchar (600)   
set @gpb= '  
GROUP BY IDBodega, NombreBodega, IDUbicacion,  IDCompania, NombreCompania, IDProducto, NombreProducto,  
IDEstadoInventario, NombreEstadoInventario,    LoteProveedor, LoteFabricante, 
FechaCaducidad        ORDER BY IDEstadoInventario ASC  '  
EXEC(@m_query+' '+@m_filtro+' '+@gpb)