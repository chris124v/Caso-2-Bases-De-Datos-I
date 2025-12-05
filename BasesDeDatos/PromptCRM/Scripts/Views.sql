WITH SalesCTE AS (
    SELECT
        s.IdSale,
        s.IdClient,
        c.ClientCode,
        u.UTMCampaign,
        YEAR(s.CreatedAt)  AS SaleYear,
        MONTH(s.CreatedAt) AS SaleMonth,
        s.SaleTotal,

        -- total monto de ventas
        SUM(s.SaleTotal) OVER (PARTITION BY YEAR(s.CreatedAt), MONTH(s.CreatedAt), u.UTMCampaign) AS TotalSalesByPeriod,

        -- cantidad de transacciones
        COUNT(*) OVER (PARTITION BY YEAR(s.CreatedAt), MONTH(s.CreatedAt), u.UTMCampaign) AS TotalTransactionsByPeriod,

        -- ordena por fecha y luego nombre de campana
        RANK() OVER (PARTITION BY YEAR(s.CreatedAt), MONTH(s.CreatedAt), u.UTMCampaign
        ORDER BY s.SaleTotal DESC) AS SaleRank
    FROM dbo.PCRSalesHistory s
    INNER JOIN dbo.PCRClients c
    ON s.IdClient = c.IdClient
    INNER JOIN dbo.PCRUTMData u
    ON s.IdUTM = u.IdUTM
)
SELECT *
FROM SalesCTE
ORDER BY SaleYear, SaleMonth, UTMCampaign, SaleRank
/*
CREATE NONCLUSTERED INDEX index_idutm_saleshistory
ON dbo.PCRSalesHistory (IdUTM)

CREATE NONCLUSTERED INDEX index_idclient_saleshistory
ON dbo.PCRSalesHistory (IdClient);
*/
/*
GO
CREATE OR ALTER VIEW dbo.SalesVista AS
    SELECT
        s.IdSale,
        s.IdClient,
        c.ClientCode,
        u.UTMCampaign,
        YEAR(s.CreatedAt)  AS SaleYear,
        MONTH(s.CreatedAt) AS SaleMonth,
        s.SaleTotal,

        -- total monto de ventas
        SUM(s.SaleTotal) OVER ( PARTITION BY YEAR(s.CreatedAt), MONTH(s.CreatedAt), u.UTMCampaign) AS TotalSalesByPeriod,

        -- cantidad de transacciones
        COUNT(*) OVER (PARTITION BY YEAR(s.CreatedAt), MONTH(s.CreatedAt), u.UTMCampaign) AS TotalTransactionsByPeriod,

        -- ordena por fecha y luego nombre de campana
        RANK() OVER (PARTITION BY YEAR(s.CreatedAt), MONTH(s.CreatedAt), u.UTMCampaign
        ORDER BY s.SaleTotal DESC) AS SaleRank
    FROM dbo.PCRSalesHistory s
    INNER JOIN dbo.PCRClients c
    ON s.IdClient = c.IdClient
    INNER JOIN dbo.PCRUTMData u
    ON s.IdUTM = u.IdUTM
GO*/

SELECT * FROM dbo.SalesVista