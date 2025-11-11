-- Vista del ETL para PromptCRM
-- Contiene todos los datos necesarios para PromptSales

CREATE VIEW vw_ETL_MasterData AS
SELECT 

    -- Campana 
    c.IdCampaign,
    c.CampaignCode,
    c.IdOrganization,
    c.IdStatus AS campaignStatusId,
    cs.StatusDescription AS campaignStatus,
    c.CreatedAt AS campaignCreatedAt,
    c.UpdatedAt AS campaignUpdatedAt,
    
    -- Leads
    l.IdLead,
    l.LeadCode,
    l.IdStatus AS leadStatusId,
    ls.StatusDescription AS leadStatus,
    l.CreatedAt AS leadCreatedAt,
    l.UpdatedAt AS leadUpdatedAt,
    l.Enabled AS leadEnabled,
    
 	-- Conversion de Lead a Comprador 
    cpc.IdClient,
    cpc.CreatedAt AS conversionDate,
    cpc.Enabled AS conversionEnabled,
    CASE WHEN cpc.IdClient IS NOT NULL THEN 1 ELSE 0 END AS isConverted,
    

    -- Cliente
    cl.ClientCode,
    cl.IdStatus AS clientStatusId,
    clst.StatusDescription AS clientStatus,
    

    -- Usuario 
    u.IdUser,
    u.FirstName,
    u.LastName,
    u.Email,
    u.PhoneNumber,
    u.IdAddress,
    

    -- Geografia
    a.IdAddress,
    a.IdCity,
    ci.CityName,
    ci.IdState,
    st.StateName,
    st.IdCountry,
    co.CountryName,
    a.Geolocation,
    
  	-- Eventos Interacciones
    e.IdEvent,
    e.IdEventType,
    et.TypeName AS eventType,
    e.IdEventSources AS eventSourceId,
    es.SourceName AS eventSource,
    e.IdEventMedium AS eventMediumId,
    em.MediumName AS eventMedium,
    e.EventDate,
    e.CreatedAt AS eventCreatedAt,
    

    -- Transacciones de Pago

    pt.IdPaymentTransaction,
    pt.Amount AS paymentAmount,
    pt.IdPaymentMethod,
    pm.MethodName AS paymentMethod,
    pt.Description AS paymentDescription,
    pt.IdType AS paymentTypeId,
    ptt.TypeName AS paymentType,
    pt.CreatedAt AS paymentDate,
    pt.UpdatedAt AS paymentUpdatedAt,
    
	-- Features de los Leads Clientes
    fpl.IdFeatureType AS leadFeatureTypeId,
    fpl.Value AS leadFeatureValue,
    fpc.IdFeatureType AS clientFeatureTypeId,
    fpc.FeatureValue AS clientFeatureValue

FROM PCRCampaigns c
LEFT JOIN PCRCampaignStatuses cs ON c.IdStatus = cs.IdStatus

-- Leads de la campaña
LEFT JOIN PCRLeads l ON c.IdCampaign = l.IdCampaign
LEFT JOIN PCRLeadStatuses ls ON l.IdStatus = ls.IdStatus

-- Conversi0n Lead - Client
LEFT JOIN PCRClientsPerCampaigns cpc ON c.IdCampaign = cpc.IdCampaign 
    AND l.IdLead = cpc.IdClient  -- Asumiendo que IdLead = IdClient tras conversion
    AND cpc.Enabled = 1

-- Cliente
LEFT JOIN PCRClients cl ON cpc.IdClient = cl.IdClient
LEFT JOIN PCRClientStatuses clst ON cl.IdStatus = clst.IdStatus

-- Usuario asociado (puede ser lead o client)
LEFT JOIN PCRUsers u ON u.IdUser = COALESCE(cl.IdClient, l.IdLead)

-- Geografia del usuario
LEFT JOIN PCRAddresses a ON u.IdAddress = a.IdAddress
LEFT JOIN PCRCities ci ON a.IdCity = ci.IdCity
LEFT JOIN PCRStates st ON ci.IdState = st.IdState
LEFT JOIN PCRCountries co ON st.IdCountry = co.IdCountry

-- Eventos/Interacciones del lead
LEFT JOIN PCREvents e ON l.IdLead = e.IdLead
LEFT JOIN PCREventTypes et ON e.IdEventType = et.IdEventType
LEFT JOIN PCREventSources es ON e.IdEventSources = es.IdEventSource
LEFT JOIN PCREventMediums em ON e.IdEventMedium = em.IdEventMedium

-- Pagos (solo de clientes convertidos)
LEFT JOIN PCRPaymentTransactions pt ON pt.IdUser = cl.IdClient
LEFT JOIN PCRPaymentMethods pm ON pt.IdPaymentMethod = pm.IdPaymentMethod
LEFT JOIN PCRPaymentTransactionTypes ptt ON pt.IdType = ptt.IdType

-- Features de Leads
LEFT JOIN PCRFeaturesPerLeads fpl ON l.IdLead = fpl.IdLead 
    AND fpl.Enabled = 1

-- Features de Clients
LEFT JOIN PCRFeaturesPerClients fpc ON cl.IdClient = fpc.IdClient 
    AND fpc.Enabled = 1

WHERE c.UpdatedAt > @lastETLDate
   OR l.UpdatedAt > @lastETLDate
   OR pt.CreatedAt > @lastETLDate
   OR e.CreatedAt > @lastETLDate;