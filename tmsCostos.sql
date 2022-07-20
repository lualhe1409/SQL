
declare @IDReCob varchar (30) 
declare @Remitente varchar(30)
declare @FechaInicial varchar(30)
declare @FechaFinal varchar (30) 
set @FechaInicial ='2021-05-03' + ' 00:00:00' --#fechainicio#       
set @FechaFinal ='2022-05-05' + ' 23:59:59' --#fechafinal#
set @Remitente='17' --#Remitente#
set @IDReCob='#Cobranza#'  --#Cobranza# 4331

create table #TBcostos (
IDClienteRemitente VARCHAR(30),IDRelacionCobranza VARCHAR(30),Monto numeric,Nombre VARCHAR(50),
FechaDocumento DATETIME
)

declare @m_query as varchar(max)         
set @m_query=' select RD.IDClienteRemitente,CoEx.IDRelacionCobranza,CoEx.Monto,CobExtra.Nombre,
RD.FechaDocumento 
from CostosExtraordinarios (nolock) as CoEx
join CobranzasExtraordinarias as CobExtra (nolock) on CoEx.IDCobranzaExtraordinaria=CobExtra.IDCobranzaExtraordinaria
join BitacoraDetalle as BD (nolock) on CoEx.IDRelacionCobranza= BD.IDRelacionCobranza
join RegistroDocumento RD (nolock) on BD.IDDocumento=RD.IDDocumento '  


declare @m_filtro as varchar(MAX)  
    set @m_filtro=
    'where  Rd.FechaDocumento >= ''' + @FechaInicial + ''' and Rd.FechaDocumento <= '''+ @FechaFinal + '''   '
if @Remitente<>'#Remi'+'tente#'
	begin set @m_filtro=@m_filtro+' and Rd.IDClienteRemitente='+@Remitente
end
if @IDReCob<>'#Cobranza#'
		begin set @m_filtro=@m_filtro+' and CoEx.IDRelacionCobranza= '''+ @IDReCob +''' '
end
declare @m_order as varchar(max)
set @m_order='order by Rd.FechaDocumento'

Insert Into #TBcostos
Exec (@m_query+' '+@m_filtro+' '+@m_order)
--select * from #TBcostos
DECLARE @columns nvarchar(MAX);
DECLARE @sql nvarchar(MAX)
SELECT @columns= STUFF(
 (
SELECT
   ',' + QUOTENAME(LTRIM(Nombre))
 FROM
   (SELECT DISTINCT Nombre
    FROM #TBcostos
   ) AS T
ORDER BY
 Nombre
 FOR XML PATH('')
 ), 1, 1, '');

SET @sql = N'
 SELECT   *   FROM  (  
    SELECT IDClienteRemitente	
		   ,IDRelacionCobranza	
		   ,Monto	
		   ,Nombre
		   ,FechaDocumento
 FROM #TBcostos
  ) AS T
  PIVOT   
  (
  SUM(Monto)
  FOR Nombre IN (' + @columns + N')
  ) AS P order by FechaDocumento desc'; 
  --AS P;'; 
  EXEC sp_executesql @sql;
drop table #TBcostos


 