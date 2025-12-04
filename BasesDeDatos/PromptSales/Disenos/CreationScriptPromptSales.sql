--
-- PostgreSQL database dump
--

\restrict DQoqLZ63AJ6JKMR97PlLqgaAMUsKMwdXnDgNE9u4VxEys6825sggKqg9iHhg2Qa

-- Dumped from database version 16.10 (Debian 16.10-1.pgdg13+1)
-- Dumped by pg_dump version 18.0

-- Started on 2025-12-03 12:34:08

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 36932)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 324 (class 1255 OID 38012)
-- Name: sp_processrawcampaigns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_processrawcampaigns() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO public."PSCampaigns" (
        "IdOrganization",
        "campaignName",
        "startDate",
        "endDate",
        "IdCampaignStatus",
        "totalBudget",
        "totalSpent",
        "totalRevenue",
        "ROI",
        "createdAt",
        "updatedAt",
        "lastETLupdate",
        "sourceServiceId",
        "sourceServiceName",
        "IdCurrency",
        "IdRunLog"
    )
    SELECT 
        1,
        'Campaign ' || "sourceRecordID",
        NOW(),
        NOW() + INTERVAL '30 days',
        1,
        0.00,
        0.00,
        0.00,
        0.0000,
        "createdAt",
        "updateAt",
        NOW(),
        1,
        1,
        1,
        "IdRunLog"
    FROM public."PSRawData"
    WHERE "sourceTable" = 'PACampaigns'
      AND "isProcessed" = FALSE;
    
    UPDATE public."PSRawData"
    SET "isProcessed" = TRUE
    WHERE "sourceTable" = 'PACampaigns'
      AND "isProcessed" = FALSE;
END;
$$;


ALTER FUNCTION public.sp_processrawcampaigns() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 255 (class 1259 OID 37160)
-- Name: PSAPICallLogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSAPICallLogs" (
    "IdAPICallLog" integer NOT NULL,
    "IdAPISetup" integer NOT NULL,
    "requestTimestamp" timestamp without time zone NOT NULL,
    "endPoint" character varying(200) NOT NULL,
    "httpMethod" character varying(10) NOT NULL,
    "requestHeaders" jsonb NOT NULL,
    "requestBody" jsonb NOT NULL,
    "requestSize" integer NOT NULL,
    "responseTimestamp" timestamp without time zone NOT NULL,
    statuscode integer NOT NULL,
    "responseHeaders" jsonb NOT NULL,
    "responseBody" jsonb NOT NULL,
    "responseSize" integer NOT NULL,
    "requestTimeMs" timestamp without time zone NOT NULL,
    "responseTimeMs" timestamp without time zone NOT NULL,
    "isSuccess" boolean NOT NULL,
    "errorMessage" text NOT NULL,
    "errorCode" character varying NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "IdControl" integer NOT NULL
);


ALTER TABLE public."PSAPICallLogs" OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 37546)
-- Name: PSAPICallLogs_IdAPICallLog_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSAPICallLogs" ALTER COLUMN "IdAPICallLog" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSAPICallLogs_IdAPICallLog_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 253 (class 1259 OID 37144)
-- Name: PSAPIConfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSAPIConfig" (
    "IdAPIConfig" integer NOT NULL,
    "apiName" character varying(100) NOT NULL,
    "apiProvider" character varying(100) NOT NULL,
    "apiVersion" character varying(20) NOT NULL,
    "baseURL" character varying(255) NOT NULL,
    "IdAuthMethod" integer NOT NULL,
    "apiKey" bytea NOT NULL,
    "clientId" bytea NOT NULL,
    "clientSecret" bytea NOT NULL,
    "accessToken" bytea NOT NULL,
    "tokenExpiresAt" timestamp without time zone NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "IdService" integer NOT NULL
);


ALTER TABLE public."PSAPIConfig" OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 37547)
-- Name: PSAPIConfig_IdAPIConfig_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSAPIConfig" ALTER COLUMN "IdAPIConfig" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSAPIConfig_IdAPIConfig_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 36961)
-- Name: PSAddresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSAddresses" (
    "IdAddress" integer NOT NULL,
    line1 character varying(200) NOT NULL,
    line2 character varying(200),
    zipcode character varying(10) NOT NULL,
    geolocation point NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "IdCity" integer NOT NULL
);


ALTER TABLE public."PSAddresses" OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 37548)
-- Name: PSAddresses_IdAddress_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSAddresses" ALTER COLUMN "IdAddress" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSAddresses_IdAddress_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 252 (class 1259 OID 37138)
-- Name: PSAuthMethods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSAuthMethods" (
    "IdAuthMethod" integer NOT NULL,
    "methodName" character varying(30) NOT NULL,
    description character varying(200) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSAuthMethods" OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 37549)
-- Name: PSAuthMethods_IdAuthMethod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSAuthMethods" ALTER COLUMN "IdAuthMethod" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSAuthMethods_IdAuthMethod_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 266 (class 1259 OID 37229)
-- Name: PSCRUDRawData; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSCRUDRawData" (
    "IdCrud" bigint NOT NULL,
    "targetTable" character varying(40) NOT NULL,
    "executionTimeMs" numeric(10,3) NOT NULL,
    "isProcessed" boolean DEFAULT false NOT NULL,
    "targetRecordID" character varying(100) NOT NULL,
    "IdRawData" bigint NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSCRUDRawData" OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 37550)
-- Name: PSCRUDRawData_IdCrud_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSCRUDRawData" ALTER COLUMN "IdCrud" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSCRUDRawData_IdCrud_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 245 (class 1259 OID 37092)
-- Name: PSCampaignMarkets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSCampaignMarkets" (
    "IdCampaignMarket" integer NOT NULL,
    "IdCampaign" integer NOT NULL,
    "IdCountry" integer,
    "IdState" integer,
    "IdCity" bigint,
    conversions integer NOT NULL,
    "totalRevenue" numeric(12,2) NOT NULL,
    leads integer NOT NULL,
    spent integer NOT NULL,
    "marketROI" numeric(10,4) NOT NULL,
    "conversionRate" numeric(5,4) NOT NULL,
    "averageOrderValie" numeric(10,2) NOT NULL,
    "targetPublicName" character varying NOT NULL,
    "targetPublicId" integer NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSCampaignMarkets" OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 37551)
-- Name: PSCampaignMarkets_IdCampaignMarket_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSCampaignMarkets" ALTER COLUMN "IdCampaignMarket" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSCampaignMarkets_IdCampaignMarket_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 37087)
-- Name: PSCampaignMetrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSCampaignMetrics" (
    "IdCampaignMetric" integer NOT NULL,
    "IdCampaign" integer NOT NULL,
    "metricDate" timestamp without time zone NOT NULL,
    "totalLeads" integer NOT NULL,
    "qualifiedLeads" integer,
    "totalConversions" integer,
    "conversionRate" numeric(5,4),
    "dailySpent" numeric(12,2),
    "dailyRevenue" numeric(12,2),
    "costPerLead" numeric(12,2),
    "costPerConversion" numeric(12,2),
    channels character varying(200) NOT NULL,
    "averageOrderValue" numeric(12,2),
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "dataSource" character varying(40) NOT NULL
);


ALTER TABLE public."PSCampaignMetrics" OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 37215)
-- Name: PSCampaignMetricsReactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSCampaignMetricsReactions" (
    "IdReactionType" integer NOT NULL,
    "IdCampaignMetric" integer NOT NULL,
    "reactionCount" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSCampaignMetricsReactions" OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 37553)
-- Name: PSCampaignMetricsReactions_IdReactionType_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSCampaignMetricsReactions" ALTER COLUMN "IdReactionType" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSCampaignMetricsReactions_IdReactionType_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 275 (class 1259 OID 37552)
-- Name: PSCampaignMetrics_IdCampaignMetric_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSCampaignMetrics" ALTER COLUMN "IdCampaignMetric" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSCampaignMetrics_IdCampaignMetric_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 249 (class 1259 OID 37116)
-- Name: PSCampaignStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSCampaignStatus" (
    "IdCampaignStatus" integer NOT NULL,
    "statusName" character varying(30) NOT NULL,
    description character varying(200) NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL
);


ALTER TABLE public."PSCampaignStatus" OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 37554)
-- Name: PSCampaignStatus_IdCampaignStatus_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSCampaignStatus" ALTER COLUMN "IdCampaignStatus" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSCampaignStatus_IdCampaignStatus_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 37081)
-- Name: PSCampaigns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSCampaigns" (
    "IdCampaign" integer NOT NULL,
    "IdOrganization" integer NOT NULL,
    "campaignName" character varying(40) NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone NOT NULL,
    "IdCampaignStatus" integer DEFAULT 1 NOT NULL,
    "totalBudget" numeric(12,2) NOT NULL,
    "totalSpent" numeric(12,2) NOT NULL,
    "totalRevenue" numeric(12,2) NOT NULL,
    "ROI" numeric(10,4) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "lastETLupdate" timestamp without time zone NOT NULL,
    "sourceServiceId" integer NOT NULL,
    "sourceServiceName" integer NOT NULL,
    "IdCurrency" integer NOT NULL,
    "IdRunLog" bigint NOT NULL
);


ALTER TABLE public."PSCampaigns" OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 37555)
-- Name: PSCampaigns_IdCampaign_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSCampaigns" ALTER COLUMN "IdCampaign" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSCampaigns_IdCampaign_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 36956)
-- Name: PSCities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSCities" (
    "IdCIty" integer NOT NULL,
    name character varying(30) NOT NULL,
    "IdState" integer NOT NULL
);


ALTER TABLE public."PSCities" OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 37556)
-- Name: PSCities_IdCIty_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSCities" ALTER COLUMN "IdCIty" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSCities_IdCIty_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 36972)
-- Name: PSContactInfoType; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSContactInfoType" (
    "IdContactInfoType" integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public."PSContactInfoType" OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 37557)
-- Name: PSContactInfoType_IdContactInfoType_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSContactInfoType" ALTER COLUMN "IdContactInfoType" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSContactInfoType_IdContactInfoType_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 248 (class 1259 OID 37109)
-- Name: PSContentUsage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSContentUsage" (
    "IdContentUsage" bigint NOT NULL,
    "IdCampaign" integer,
    "contentId" character varying(200) NOT NULL,
    "contentType" character varying(30) NOT NULL,
    "contentTitle" character varying(200),
    channel character varying(30) NOT NULL,
    hashtags text,
    "contentURL" character varying(500) NOT NULL,
    "usageCount" integer NOT NULL,
    "usedInAds" text NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSContentUsage" OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 37558)
-- Name: PSContentUsage_IdContentUsage_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSContentUsage" ALTER COLUMN "IdContentUsage" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSContentUsage_IdContentUsage_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 36946)
-- Name: PSCountries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSCountries" (
    "IdCountry" integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public."PSCountries" OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 37559)
-- Name: PSCountries_IdCountry_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSCountries" ALTER COLUMN "IdCountry" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSCountries_IdCountry_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 37027)
-- Name: PSCurrencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSCurrencies" (
    "IdCurrency" smallint NOT NULL,
    name character varying(30) NOT NULL,
    "isoCode" character varying(3) NOT NULL,
    "currencySymbol" character varying(5) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "IdCountry" integer NOT NULL
);


ALTER TABLE public."PSCurrencies" OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 37560)
-- Name: PSCurrencies_IdCurrency_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSCurrencies" ALTER COLUMN "IdCurrency" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSCurrencies_IdCurrency_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 250 (class 1259 OID 37122)
-- Name: PSETLConfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSETLConfig" (
    "IdConfig" integer NOT NULL,
    "IdConnection" integer NOT NULL,
    schedule character varying(100),
    "connectionString" text NOT NULL,
    priority integer NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSETLConfig" OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 37561)
-- Name: PSETLConfig_IdConfig_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSETLConfig" ALTER COLUMN "IdConfig" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSETLConfig_IdConfig_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 264 (class 1259 OID 37218)
-- Name: PSETLDelta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSETLDelta" (
    "IdETLDelta" integer NOT NULL,
    database character varying(30) NOT NULL,
    view character varying(50) NOT NULL,
    "lastInput" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "IdRunLog" integer
);


ALTER TABLE public."PSETLDelta" OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 37562)
-- Name: PSETLDelta_IdETLDelta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSETLDelta" ALTER COLUMN "IdETLDelta" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSETLDelta_IdETLDelta_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 251 (class 1259 OID 37130)
-- Name: PSETLErrors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSETLErrors" (
    "IdError" integer NOT NULL,
    "IdControl" integer NOT NULL,
    "errorTime" timestamp without time zone NOT NULL,
    "errorType" character varying(30) NOT NULL,
    "errorSeverity" character varying(30) NOT NULL,
    "errorMessage" text NOT NULL,
    "errorCode" character varying(20) NOT NULL,
    "sourceTable" character varying(100) NOT NULL,
    "sourceRecordId" character varying(100) NOT NULL,
    "failedOperation" character varying(20) NOT NULL,
    "errorData" character varying(200) NOT NULL,
    "isResolved" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSETLErrors" OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 37563)
-- Name: PSETLErrors_IdError_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSETLErrors" ALTER COLUMN "IdError" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSETLErrors_IdError_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 260 (class 1259 OID 37196)
-- Name: PSETLRunLog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSETLRunLog" (
    "IdRunLog" integer NOT NULL,
    "IdConfig" integer NOT NULL,
    "runStart" timestamp without time zone NOT NULL,
    "runEnd" timestamp without time zone NOT NULL,
    "rowsProcessed" integer NOT NULL,
    message text NOT NULL,
    "lastProcessedID" bigint NOT NULL,
    "recordsFailed" bigint NOT NULL,
    "recordsInserted" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSETLRunLog" OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 37564)
-- Name: PSETLRunLog_IdRunLog_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSETLRunLog" ALTER COLUMN "IdRunLog" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSETLRunLog_IdRunLog_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 37034)
-- Name: PSExchangeRates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSExchangeRates" (
    "IdExchangeRate" integer NOT NULL,
    "startDate" date NOT NULL,
    "endDate" date,
    "exchangeRate" numeric(10,4) NOT NULL,
    "IdCurrencyDestiny" integer NOT NULL,
    "IdCurrencySource" integer NOT NULL,
    current boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSExchangeRates" OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 37565)
-- Name: PSExchangeRates_IdExchangeRate_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSExchangeRates" ALTER COLUMN "IdExchangeRate" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSExchangeRates_IdExchangeRate_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 239 (class 1259 OID 37062)
-- Name: PSFeatures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSFeatures" (
    "IdFeature" integer NOT NULL,
    name character varying(40) NOT NULL,
    description character varying(150) NOT NULL,
    "dataType" character varying(30) NOT NULL,
    "Value" character varying(30) NOT NULL,
    "featurePrice" numeric(10,2),
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSFeatures" OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 37073)
-- Name: PSFeaturesPerSuscription; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSFeaturesPerSuscription" (
    "IdSubscription" integer NOT NULL,
    "IdFeature" integer NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSFeaturesPerSuscription" OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 37566)
-- Name: PSFeatures_IdFeature_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSFeatures" ALTER COLUMN "IdFeature" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSFeatures_IdFeature_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 37099)
-- Name: PSLeadsSumarry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSLeadsSumarry" (
    "IdLeadSumarry" integer NOT NULL,
    "IdCampaign" integer,
    "sumarryDate" timestamp without time zone NOT NULL,
    "totalLeads" integer NOT NULL,
    "currentLeads" integer NOT NULL,
    "qualifiedLeads" integer NOT NULL,
    "convertedLeads" integer NOT NULL,
    "rejectedLeads" integer NOT NULL,
    "qualificationRate" numeric(5,2) NOT NULL,
    "conversionRate" numeric(5,2) NOT NULL,
    "leadChannels" character varying(200),
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSLeadsSumarry" OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 37567)
-- Name: PSLeadsSumarry_IdLeadSumarry_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSLeadsSumarry" ALTER COLUMN "IdLeadSumarry" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSLeadsSumarry_IdLeadSumarry_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 37000)
-- Name: PSLogLevels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSLogLevels" (
    "IdLogLevel" integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public."PSLogLevels" OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 37568)
-- Name: PSLogLevels_IdLogLevel_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSLogLevels" ALTER COLUMN "IdLogLevel" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSLogLevels_IdLogLevel_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 37005)
-- Name: PSLogSources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSLogSources" (
    "IdLogSource" integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public."PSLogSources" OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 37569)
-- Name: PSLogSources_IdLogSource_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSLogSources" ALTER COLUMN "IdLogSource" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSLogSources_IdLogSource_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 36995)
-- Name: PSLogTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSLogTypes" (
    "IdLogType" integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public."PSLogTypes" OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 37570)
-- Name: PSLogTypes_IdLogType_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSLogTypes" ALTER COLUMN "IdLogType" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSLogTypes_IdLogType_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 37010)
-- Name: PSLogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSLogs" (
    "IdLog" integer NOT NULL,
    description character varying(500) NOT NULL,
    computer character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    "IdRef1" bigint,
    "IdRef2" bigint,
    value1 character varying(200),
    value2 character varying(200),
    checksum bytea NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "IdLogType" integer NOT NULL,
    "IdLogLevel" integer NOT NULL,
    "IdLogSource" integer NOT NULL
);


ALTER TABLE public."PSLogs" OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 37609)
-- Name: PSLogs_IdLogLevel_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSLogs" ALTER COLUMN "IdLogLevel" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."PSLogs_IdLogLevel_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 320 (class 1259 OID 37610)
-- Name: PSLogs_IdLogSource_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSLogs" ALTER COLUMN "IdLogSource" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."PSLogs_IdLogSource_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 318 (class 1259 OID 37608)
-- Name: PSLogs_IdLogType_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSLogs" ALTER COLUMN "IdLogType" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."PSLogs_IdLogType_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 294 (class 1259 OID 37571)
-- Name: PSLogs_IdLog_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSLogs" ALTER COLUMN "IdLog" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSLogs_IdLog_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 256 (class 1259 OID 37167)
-- Name: PSMCPRequestLogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSMCPRequestLogs" (
    "IdMCPRequestLog" integer NOT NULL,
    "IdMCPServer" integer NOT NULL,
    "requestTimeStamp" timestamp without time zone NOT NULL,
    "toolName" character varying(100) NOT NULL,
    "toolInput" jsonb NOT NULL,
    "responseTimestamp" timestamp without time zone NOT NULL,
    "responseTimeMs" timestamp without time zone NOT NULL,
    "isSuccess" boolean DEFAULT false NOT NULL,
    "errorMesagge" text NOT NULL,
    "errorType" character varying(50) NOT NULL,
    "tokenUsage" integer NOT NULL,
    "costEstimate" numeric(10,6) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "IdControl" integer NOT NULL
);


ALTER TABLE public."PSMCPRequestLogs" OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 37572)
-- Name: PSMCPRequestLogs_IdMCPRequestLog_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSMCPRequestLogs" ALTER COLUMN "IdMCPRequestLog" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSMCPRequestLogs_IdMCPRequestLog_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 254 (class 1259 OID 37152)
-- Name: PSMCPServerConfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSMCPServerConfig" (
    "IdMCPServer" integer NOT NULL,
    "serverName" character varying(100) NOT NULL,
    "serverType" character varying(50) NOT NULL,
    description character varying(300) NOT NULL,
    "serverURL" character varying(255) NOT NULL,
    "serverPort" integer NOT NULL,
    "IdAuthMethod" integer NOT NULL,
    "authToken" bytea NOT NULL,
    "availableTools" character varying(300) NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "IdService" integer NOT NULL
);


ALTER TABLE public."PSMCPServerConfig" OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 37573)
-- Name: PSMCPServerConfig_IdMCPServer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSMCPServerConfig" ALTER COLUMN "IdMCPServer" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSMCPServerConfig_IdMCPServer_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 37017)
-- Name: PSOrganizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSOrganizations" (
    "IdOrganization" integer NOT NULL,
    name character varying(40) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "cedulaJuridica" character varying(30) NOT NULL,
    "sociedadAnonima" character varying(40) NOT NULL,
    "addressNoFiscal" character varying(40) NOT NULL
);


ALTER TABLE public."PSOrganizations" OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 37574)
-- Name: PSOrganizations_IdOrganization_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSOrganizations" ALTER COLUMN "IdOrganization" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSOrganizations_IdOrganization_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 37050)
-- Name: PSPaymentMethods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSPaymentMethods" (
    "IdPaymentMethod" integer NOT NULL,
    name character varying(30) NOT NULL,
    description character varying(150) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSPaymentMethods" OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 37575)
-- Name: PSPaymentMethods_IdPaymentMethod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPaymentMethods" ALTER COLUMN "IdPaymentMethod" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSPaymentMethods_IdPaymentMethod_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 37040)
-- Name: PSPaymentStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSPaymentStatus" (
    "IdPaymentStatus" integer NOT NULL,
    name character varying(30) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSPaymentStatus" OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 37576)
-- Name: PSPaymentStatus_IdPaymentStatus_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPaymentStatus" ALTER COLUMN "IdPaymentStatus" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSPaymentStatus_IdPaymentStatus_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 37045)
-- Name: PSPaymentTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSPaymentTypes" (
    "IdPaymentType" integer NOT NULL,
    name character varying(40) NOT NULL,
    description character varying(200) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSPaymentTypes" OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 37577)
-- Name: PSPaymentTypes_IdPaymentType_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPaymentTypes" ALTER COLUMN "IdPaymentType" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSPaymentTypes_IdPaymentType_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 37055)
-- Name: PSPayments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSPayments" (
    "IdPayment" bigint NOT NULL,
    "transactionAmount" numeric(16,2) NOT NULL,
    "IdCurrency" integer NOT NULL,
    description character varying(200),
    "paymentDate" timestamp without time zone NOT NULL,
    "IdPaymentType" integer NOT NULL,
    "IdPaymentStatus" integer NOT NULL,
    "IdPaymentMethod" integer NOT NULL,
    checksum bytea NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "IdUser" integer NOT NULL
);


ALTER TABLE public."PSPayments" OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 37613)
-- Name: PSPayments_IdPaymentMethod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPayments" ALTER COLUMN "IdPaymentMethod" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."PSPayments_IdPaymentMethod_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 322 (class 1259 OID 37612)
-- Name: PSPayments_IdPaymentStatus_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPayments" ALTER COLUMN "IdPaymentStatus" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."PSPayments_IdPaymentStatus_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 321 (class 1259 OID 37611)
-- Name: PSPayments_IdPaymentType_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPayments" ALTER COLUMN "IdPaymentType" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."PSPayments_IdPaymentType_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 301 (class 1259 OID 37578)
-- Name: PSPayments_IdPayment_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPayments" ALTER COLUMN "IdPayment" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSPayments_IdPayment_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 36982)
-- Name: PSPermissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSPermissions" (
    "IdPermission" integer NOT NULL,
    name character varying(30) NOT NULL,
    description character varying(30) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone
);


ALTER TABLE public."PSPermissions" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 36987)
-- Name: PSPermissionsPerRole; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSPermissionsPerRole" (
    "IdRole" integer NOT NULL,
    "IdPermission" integer NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSPermissionsPerRole" OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 37579)
-- Name: PSPermissions_IdPermission_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPermissions" ALTER COLUMN "IdPermission" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSPermissions_IdPermission_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 267 (class 1259 OID 37235)
-- Name: PSPublishedAds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSPublishedAds" (
    "IdPublishedAd" bigint NOT NULL,
    "IdCampaign" integer,
    "channelName" character varying(30) NOT NULL,
    "channelType" character varying(20),
    "influencerName" character varying(50),
    "influencerFollowers" bigint,
    body text NOT NULL,
    "redirectURL" character varying(256) NOT NULL,
    budget numeric(12,2) NOT NULL,
    expenses numeric(12,2) NOT NULL,
    "adSentiment" character varying(30) NOT NULL,
    "publishedAt" timestamp without time zone NOT NULL,
    "adStatus" character varying(30) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSPublishedAds" OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 37242)
-- Name: PSPublishedAdsReactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSPublishedAdsReactions" (
    "IdReactionType" integer NOT NULL,
    "IdPublishedAd" bigint NOT NULL,
    "reactionCount" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSPublishedAdsReactions" OWNER TO postgres;

--
-- TOC entry 304 (class 1259 OID 37581)
-- Name: PSPublishedAdsReactions_IdReactionType_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPublishedAdsReactions" ALTER COLUMN "IdReactionType" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSPublishedAdsReactions_IdReactionType_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 303 (class 1259 OID 37580)
-- Name: PSPublishedAds_IdPublishedAd_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSPublishedAds" ALTER COLUMN "IdPublishedAd" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSPublishedAds_IdPublishedAd_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 265 (class 1259 OID 37223)
-- Name: PSRawData; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSRawData" (
    "IdRawData" bigint NOT NULL,
    "sourceService" character varying(30) NOT NULL,
    "sourceTable" character varying(60) NOT NULL,
    "sourceRecordID" character varying(100) NOT NULL,
    "operationType" character varying(30) NOT NULL,
    "isProcessed" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updateAt" timestamp without time zone NOT NULL,
    "IdRunLog" integer NOT NULL,
    "rawData" text
);


ALTER TABLE public."PSRawData" OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 37582)
-- Name: PSRawData_IdRawData_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSRawData" ALTER COLUMN "IdRawData" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSRawData_IdRawData_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 262 (class 1259 OID 37210)
-- Name: PSReactionTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSReactionTypes" (
    "IdReactionType" integer NOT NULL,
    name character varying(40) NOT NULL,
    description character varying(150) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSReactionTypes" OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 37583)
-- Name: PSReactionTypes_IdReactionType_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSReactionTypes" ALTER COLUMN "IdReactionType" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSReactionTypes_IdReactionType_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 36977)
-- Name: PSRoles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSRoles" (
    "IdRole" integer NOT NULL,
    name character varying(30) NOT NULL,
    description character varying(200) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSRoles" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 36991)
-- Name: PSRolesPerUser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSRolesPerUser" (
    "IdUser" integer NOT NULL,
    "IdRole" integer NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public."PSRolesPerUser" OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 37584)
-- Name: PSRoles_IdRole_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSRoles" ALTER COLUMN "IdRole" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSRoles_IdRole_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 247 (class 1259 OID 37104)
-- Name: PSSalesSumarry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSSalesSumarry" (
    "IdSaleSumarry" integer NOT NULL,
    "IdCampaign" integer NOT NULL,
    "saleDate" timestamp without time zone NOT NULL,
    "totalSales" integer NOT NULL,
    "totalRevenue" numeric(12,2) NOT NULL,
    "averageOrderValue" numeric(10,2) NOT NULL,
    "IdCurrency" integer NOT NULL,
    "productCategory" character varying(40) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSSalesSumarry" OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 37585)
-- Name: PSSalesSumarry_IdSaleSumarry_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSSalesSumarry" ALTER COLUMN "IdSaleSumarry" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSSalesSumarry_IdSaleSumarry_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 258 (class 1259 OID 37183)
-- Name: PSServiceConnectionConfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSServiceConnectionConfig" (
    "IdConnection" integer NOT NULL,
    "connectionName" character varying(100) NOT NULL,
    "connectionType" character varying(20) NOT NULL,
    credentials text NOT NULL,
    endpoint text NOT NULL,
    metadata jsonb,
    enabled boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "IdSourceService" integer NOT NULL,
    "IdTargetService" integer NOT NULL
);


ALTER TABLE public."PSServiceConnectionConfig" OWNER TO postgres;

--
-- TOC entry 309 (class 1259 OID 37586)
-- Name: PSServiceConnectionConfig_IdConnection_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSServiceConnectionConfig" ALTER COLUMN "IdConnection" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSServiceConnectionConfig_IdConnection_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 261 (class 1259 OID 37203)
-- Name: PSServiceConnectionLog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSServiceConnectionLog" (
    "IdServiceLog" integer NOT NULL,
    "IdConnection" integer NOT NULL,
    message text,
    "connectionResult" character varying(30) NOT NULL,
    "totalRequests" bigint NOT NULL,
    "succesfullRequests" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSServiceConnectionLog" OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 37587)
-- Name: PSServiceConnectionLog_IdServiceLog_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSServiceConnectionLog" ALTER COLUMN "IdServiceLog" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSServiceConnectionLog_IdServiceLog_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 259 (class 1259 OID 37191)
-- Name: PSServiceTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSServiceTypes" (
    "IdServiceType" integer NOT NULL,
    name character varying(40) NOT NULL,
    description character varying(150) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSServiceTypes" OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 37588)
-- Name: PSServiceTypes_IdServiceType_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSServiceTypes" ALTER COLUMN "IdServiceType" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSServiceTypes_IdServiceType_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 257 (class 1259 OID 37175)
-- Name: PSServices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSServices" (
    "IdService" integer NOT NULL,
    "serviceName" character varying(40) NOT NULL,
    "IdServiceType" integer NOT NULL,
    description character varying(200) NOT NULL,
    "databaseType" character varying(20) NOT NULL,
    "primaryURL" character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "currentVersion" character varying(20) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSServices" OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 37589)
-- Name: PSServices_IdService_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSServices" ALTER COLUMN "IdService" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSServices_IdService_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 36951)
-- Name: PSStates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSStates" (
    "IdState" integer NOT NULL,
    name character varying(30) NOT NULL,
    "IdCountry" integer NOT NULL
);


ALTER TABLE public."PSStates" OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 37590)
-- Name: PSStates_IdState_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSStates" ALTER COLUMN "IdState" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSStates_IdState_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 37067)
-- Name: PSSubscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSSubscriptions" (
    "IdSubscription" integer NOT NULL,
    name character varying(40) NOT NULL,
    description character varying(200) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "subAmount" numeric(15,2) NOT NULL,
    "IdCurrencyType" integer NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSSubscriptions" OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 37077)
-- Name: PSSubscriptionsPerUser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSSubscriptionsPerUser" (
    "IdSubscription" integer NOT NULL,
    "IdUser" integer NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public."PSSubscriptionsPerUser" OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 37591)
-- Name: PSSubscriptions_IdSubscription_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSSubscriptions" ALTER COLUMN "IdSubscription" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSSubscriptions_IdSubscription_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 36966)
-- Name: PSUserContactInfo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSUserContactInfo" (
    "IdUserContactInfo" integer NOT NULL,
    contact character varying(120) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "IdUser" integer NOT NULL,
    "IdContactInfoType" integer NOT NULL
);


ALTER TABLE public."PSUserContactInfo" OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 37592)
-- Name: PSUserContactInfo_IdUserContactInfo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSUserContactInfo" ALTER COLUMN "IdUserContactInfo" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSUserContactInfo_IdUserContactInfo_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 36941)
-- Name: PSUserStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSUserStatus" (
    "IdUserStatus" integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE public."PSUserStatus" OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 37593)
-- Name: PSUserStatus_IdUserStatus_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSUserStatus" ALTER COLUMN "IdUserStatus" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSUserStatus_IdUserStatus_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 36934)
-- Name: PSUsers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSUsers" (
    "IdUser" integer NOT NULL,
    "firstName" character varying(30) NOT NULL,
    "lastName" character varying(30) NOT NULL,
    "passwordHash" bytea NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "lastLogin" timestamp without time zone NOT NULL,
    checksum bytea NOT NULL,
    "IdUserStatus" integer NOT NULL
);


ALTER TABLE public."PSUsers" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 37023)
-- Name: PSUsersXOrganization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PSUsersXOrganization" (
    "IdOrganization" integer NOT NULL,
    "IdUser" integer NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public."PSUsersXOrganization" OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 37594)
-- Name: PSUsers_IdUser_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."PSUsers" ALTER COLUMN "IdUser" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."PSUsers_IdUser_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3628 (class 2606 OID 37166)
-- Name: PSAPICallLogs PSAPICallLogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSAPICallLogs"
    ADD CONSTRAINT "PSAPICallLogs_pkey" PRIMARY KEY ("IdAPICallLog");


--
-- TOC entry 3624 (class 2606 OID 37151)
-- Name: PSAPIConfig PSAPIConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSAPIConfig"
    ADD CONSTRAINT "PSAPIConfig_pkey" PRIMARY KEY ("IdAPIConfig");


--
-- TOC entry 3566 (class 2606 OID 36965)
-- Name: PSAddresses PSAddresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSAddresses"
    ADD CONSTRAINT "PSAddresses_pkey" PRIMARY KEY ("IdAddress");


--
-- TOC entry 3622 (class 2606 OID 37143)
-- Name: PSAuthMethods PSAuthMethods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSAuthMethods"
    ADD CONSTRAINT "PSAuthMethods_pkey" PRIMARY KEY ("IdAuthMethod");


--
-- TOC entry 3648 (class 2606 OID 37234)
-- Name: PSCRUDRawData PSCRUDRawData_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCRUDRawData"
    ADD CONSTRAINT "PSCRUDRawData_pkey" PRIMARY KEY ("IdCrud");


--
-- TOC entry 3608 (class 2606 OID 37098)
-- Name: PSCampaignMarkets PSCampaignMarkets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaignMarkets"
    ADD CONSTRAINT "PSCampaignMarkets_pkey" PRIMARY KEY ("IdCampaignMarket");


--
-- TOC entry 3606 (class 2606 OID 37091)
-- Name: PSCampaignMetrics PSCampaignMetrics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaignMetrics"
    ADD CONSTRAINT "PSCampaignMetrics_pkey" PRIMARY KEY ("IdCampaignMetric");


--
-- TOC entry 3616 (class 2606 OID 37121)
-- Name: PSCampaignStatus PSCampaignStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaignStatus"
    ADD CONSTRAINT "PSCampaignStatus_pkey" PRIMARY KEY ("IdCampaignStatus");


--
-- TOC entry 3604 (class 2606 OID 37086)
-- Name: PSCampaigns PSCampaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaigns"
    ADD CONSTRAINT "PSCampaigns_pkey" PRIMARY KEY ("IdCampaign");


--
-- TOC entry 3564 (class 2606 OID 36960)
-- Name: PSCities PSCities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCities"
    ADD CONSTRAINT "PSCities_pkey" PRIMARY KEY ("IdCIty");


--
-- TOC entry 3570 (class 2606 OID 36976)
-- Name: PSContactInfoType PSContactInfoType_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSContactInfoType"
    ADD CONSTRAINT "PSContactInfoType_pkey" PRIMARY KEY ("IdContactInfoType");


--
-- TOC entry 3614 (class 2606 OID 37115)
-- Name: PSContentUsage PSContentUsage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSContentUsage"
    ADD CONSTRAINT "PSContentUsage_pkey" PRIMARY KEY ("IdContentUsage");


--
-- TOC entry 3560 (class 2606 OID 36950)
-- Name: PSCountries PSCountries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCountries"
    ADD CONSTRAINT "PSCountries_pkey" PRIMARY KEY ("IdCountry");


--
-- TOC entry 3586 (class 2606 OID 37033)
-- Name: PSCurrencies PSCurrencies_IdCountry_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCurrencies"
    ADD CONSTRAINT "PSCurrencies_IdCountry_key" UNIQUE ("IdCountry");


--
-- TOC entry 3588 (class 2606 OID 37031)
-- Name: PSCurrencies PSCurrencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCurrencies"
    ADD CONSTRAINT "PSCurrencies_pkey" PRIMARY KEY ("IdCurrency");


--
-- TOC entry 3618 (class 2606 OID 37129)
-- Name: PSETLConfig PSETLConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSETLConfig"
    ADD CONSTRAINT "PSETLConfig_pkey" PRIMARY KEY ("IdConfig");


--
-- TOC entry 3644 (class 2606 OID 37222)
-- Name: PSETLDelta PSETLDelta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSETLDelta"
    ADD CONSTRAINT "PSETLDelta_pkey" PRIMARY KEY ("IdETLDelta");


--
-- TOC entry 3620 (class 2606 OID 37137)
-- Name: PSETLErrors PSETLErrors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSETLErrors"
    ADD CONSTRAINT "PSETLErrors_pkey" PRIMARY KEY ("IdError");


--
-- TOC entry 3638 (class 2606 OID 37202)
-- Name: PSETLRunLog PSETLRunLog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSETLRunLog"
    ADD CONSTRAINT "PSETLRunLog_pkey" PRIMARY KEY ("IdRunLog");


--
-- TOC entry 3590 (class 2606 OID 37039)
-- Name: PSExchangeRates PSExchangeRates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSExchangeRates"
    ADD CONSTRAINT "PSExchangeRates_pkey" PRIMARY KEY ("IdExchangeRate");


--
-- TOC entry 3600 (class 2606 OID 37066)
-- Name: PSFeatures PSFeatures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSFeatures"
    ADD CONSTRAINT "PSFeatures_pkey" PRIMARY KEY ("IdFeature");


--
-- TOC entry 3610 (class 2606 OID 37103)
-- Name: PSLeadsSumarry PSLeadsSumarry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSLeadsSumarry"
    ADD CONSTRAINT "PSLeadsSumarry_pkey" PRIMARY KEY ("IdLeadSumarry");


--
-- TOC entry 3578 (class 2606 OID 37004)
-- Name: PSLogLevels PSLogLevels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSLogLevels"
    ADD CONSTRAINT "PSLogLevels_pkey" PRIMARY KEY ("IdLogLevel");


--
-- TOC entry 3580 (class 2606 OID 37009)
-- Name: PSLogSources PSLogSources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSLogSources"
    ADD CONSTRAINT "PSLogSources_pkey" PRIMARY KEY ("IdLogSource");


--
-- TOC entry 3576 (class 2606 OID 36999)
-- Name: PSLogTypes PSLogTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSLogTypes"
    ADD CONSTRAINT "PSLogTypes_pkey" PRIMARY KEY ("IdLogType");


--
-- TOC entry 3582 (class 2606 OID 37016)
-- Name: PSLogs PSLogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSLogs"
    ADD CONSTRAINT "PSLogs_pkey" PRIMARY KEY ("IdLog", "IdLogType", "IdLogLevel", "IdLogSource");


--
-- TOC entry 3630 (class 2606 OID 37174)
-- Name: PSMCPRequestLogs PSMCPRequestLogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSMCPRequestLogs"
    ADD CONSTRAINT "PSMCPRequestLogs_pkey" PRIMARY KEY ("IdMCPRequestLog");


--
-- TOC entry 3626 (class 2606 OID 37159)
-- Name: PSMCPServerConfig PSMCPServerConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSMCPServerConfig"
    ADD CONSTRAINT "PSMCPServerConfig_pkey" PRIMARY KEY ("IdMCPServer");


--
-- TOC entry 3584 (class 2606 OID 37022)
-- Name: PSOrganizations PSOrganizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSOrganizations"
    ADD CONSTRAINT "PSOrganizations_pkey" PRIMARY KEY ("IdOrganization");


--
-- TOC entry 3596 (class 2606 OID 37054)
-- Name: PSPaymentMethods PSPaymentMethods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPaymentMethods"
    ADD CONSTRAINT "PSPaymentMethods_pkey" PRIMARY KEY ("IdPaymentMethod");


--
-- TOC entry 3592 (class 2606 OID 37044)
-- Name: PSPaymentStatus PSPaymentStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPaymentStatus"
    ADD CONSTRAINT "PSPaymentStatus_pkey" PRIMARY KEY ("IdPaymentStatus");


--
-- TOC entry 3594 (class 2606 OID 37049)
-- Name: PSPaymentTypes PSPaymentTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPaymentTypes"
    ADD CONSTRAINT "PSPaymentTypes_pkey" PRIMARY KEY ("IdPaymentType");


--
-- TOC entry 3598 (class 2606 OID 37061)
-- Name: PSPayments PSPayments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPayments"
    ADD CONSTRAINT "PSPayments_pkey" PRIMARY KEY ("IdPayment", "IdPaymentType", "IdPaymentStatus", "IdPaymentMethod");


--
-- TOC entry 3574 (class 2606 OID 36986)
-- Name: PSPermissions PSPermissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPermissions"
    ADD CONSTRAINT "PSPermissions_pkey" PRIMARY KEY ("IdPermission");


--
-- TOC entry 3650 (class 2606 OID 37241)
-- Name: PSPublishedAds PSPublishedAds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPublishedAds"
    ADD CONSTRAINT "PSPublishedAds_pkey" PRIMARY KEY ("IdPublishedAd");


--
-- TOC entry 3646 (class 2606 OID 37228)
-- Name: PSRawData PSRawData_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSRawData"
    ADD CONSTRAINT "PSRawData_pkey" PRIMARY KEY ("IdRawData");


--
-- TOC entry 3642 (class 2606 OID 37214)
-- Name: PSReactionTypes PSReactionTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSReactionTypes"
    ADD CONSTRAINT "PSReactionTypes_pkey" PRIMARY KEY ("IdReactionType");


--
-- TOC entry 3572 (class 2606 OID 36981)
-- Name: PSRoles PSRoles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSRoles"
    ADD CONSTRAINT "PSRoles_pkey" PRIMARY KEY ("IdRole");


--
-- TOC entry 3612 (class 2606 OID 37108)
-- Name: PSSalesSumarry PSSalesSumarry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSSalesSumarry"
    ADD CONSTRAINT "PSSalesSumarry_pkey" PRIMARY KEY ("IdSaleSumarry");


--
-- TOC entry 3634 (class 2606 OID 37190)
-- Name: PSServiceConnectionConfig PSServiceConnectionConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSServiceConnectionConfig"
    ADD CONSTRAINT "PSServiceConnectionConfig_pkey" PRIMARY KEY ("IdConnection");


--
-- TOC entry 3640 (class 2606 OID 37209)
-- Name: PSServiceConnectionLog PSServiceConnectionLog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSServiceConnectionLog"
    ADD CONSTRAINT "PSServiceConnectionLog_pkey" PRIMARY KEY ("IdServiceLog");


--
-- TOC entry 3636 (class 2606 OID 37195)
-- Name: PSServiceTypes PSServiceTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSServiceTypes"
    ADD CONSTRAINT "PSServiceTypes_pkey" PRIMARY KEY ("IdServiceType");


--
-- TOC entry 3632 (class 2606 OID 37182)
-- Name: PSServices PSServices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSServices"
    ADD CONSTRAINT "PSServices_pkey" PRIMARY KEY ("IdService");


--
-- TOC entry 3562 (class 2606 OID 36955)
-- Name: PSStates PSStates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSStates"
    ADD CONSTRAINT "PSStates_pkey" PRIMARY KEY ("IdState");


--
-- TOC entry 3602 (class 2606 OID 37072)
-- Name: PSSubscriptions PSSubscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSSubscriptions"
    ADD CONSTRAINT "PSSubscriptions_pkey" PRIMARY KEY ("IdSubscription");


--
-- TOC entry 3568 (class 2606 OID 36971)
-- Name: PSUserContactInfo PSUserContactInfo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSUserContactInfo"
    ADD CONSTRAINT "PSUserContactInfo_pkey" PRIMARY KEY ("IdUserContactInfo");


--
-- TOC entry 3558 (class 2606 OID 36945)
-- Name: PSUserStatus PSUserStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSUserStatus"
    ADD CONSTRAINT "PSUserStatus_pkey" PRIMARY KEY ("IdUserStatus");


--
-- TOC entry 3556 (class 2606 OID 36940)
-- Name: PSUsers PSUsers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSUsers"
    ADD CONSTRAINT "PSUsers_pkey" PRIMARY KEY ("IdUser");


--
-- TOC entry 3694 (class 2606 OID 37460)
-- Name: PSAPICallLogs PSAPICallLogs_IdAPISetup_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSAPICallLogs"
    ADD CONSTRAINT "PSAPICallLogs_IdAPISetup_fkey" FOREIGN KEY ("IdAPISetup") REFERENCES public."PSAPIConfig"("IdAPIConfig") NOT VALID;


--
-- TOC entry 3695 (class 2606 OID 37465)
-- Name: PSAPICallLogs PSAPICallLogs_IdControl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSAPICallLogs"
    ADD CONSTRAINT "PSAPICallLogs_IdControl_fkey" FOREIGN KEY ("IdControl") REFERENCES public."PSETLConfig"("IdConfig") NOT VALID;


--
-- TOC entry 3690 (class 2606 OID 37440)
-- Name: PSAPIConfig PSAPIConfig_IdAuthMethod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSAPIConfig"
    ADD CONSTRAINT "PSAPIConfig_IdAuthMethod_fkey" FOREIGN KEY ("IdAuthMethod") REFERENCES public."PSAuthMethods"("IdAuthMethod") NOT VALID;


--
-- TOC entry 3691 (class 2606 OID 37445)
-- Name: PSAPIConfig PSAPIConfig_IdService_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSAPIConfig"
    ADD CONSTRAINT "PSAPIConfig_IdService_fkey" FOREIGN KEY ("IdService") REFERENCES public."PSServices"("IdService") NOT VALID;


--
-- TOC entry 3654 (class 2606 OID 37260)
-- Name: PSAddresses PSAddresses_IdCity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSAddresses"
    ADD CONSTRAINT "PSAddresses_IdCity_fkey" FOREIGN KEY ("IdCity") REFERENCES public."PSCities"("IdCIty") NOT VALID;


--
-- TOC entry 3707 (class 2606 OID 37525)
-- Name: PSCRUDRawData PSCRUDRawData_IdRawData_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCRUDRawData"
    ADD CONSTRAINT "PSCRUDRawData_IdRawData_fkey" FOREIGN KEY ("IdRawData") REFERENCES public."PSRawData"("IdRawData") NOT VALID;


--
-- TOC entry 3683 (class 2606 OID 37405)
-- Name: PSCampaignMarkets PSCampaignMarkets_IdCampaign_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaignMarkets"
    ADD CONSTRAINT "PSCampaignMarkets_IdCampaign_fkey" FOREIGN KEY ("IdCampaign") REFERENCES public."PSCampaigns"("IdCampaign") NOT VALID;


--
-- TOC entry 3703 (class 2606 OID 37510)
-- Name: PSCampaignMetricsReactions PSCampaignMetricsReactions_IdCampaignMetric_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaignMetricsReactions"
    ADD CONSTRAINT "PSCampaignMetricsReactions_IdCampaignMetric_fkey" FOREIGN KEY ("IdCampaignMetric") REFERENCES public."PSCampaignMetrics"("IdCampaignMetric") NOT VALID;


--
-- TOC entry 3704 (class 2606 OID 37505)
-- Name: PSCampaignMetricsReactions PSCampaignMetricsReactions_IdReactionType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaignMetricsReactions"
    ADD CONSTRAINT "PSCampaignMetricsReactions_IdReactionType_fkey" FOREIGN KEY ("IdReactionType") REFERENCES public."PSReactionTypes"("IdReactionType") NOT VALID;


--
-- TOC entry 3682 (class 2606 OID 37400)
-- Name: PSCampaignMetrics PSCampaignMetrics_IdCampaign_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaignMetrics"
    ADD CONSTRAINT "PSCampaignMetrics_IdCampaign_fkey" FOREIGN KEY ("IdCampaign") REFERENCES public."PSCampaigns"("IdCampaign") NOT VALID;


--
-- TOC entry 3678 (class 2606 OID 37390)
-- Name: PSCampaigns PSCampaigns_IdCampaignStatus_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaigns"
    ADD CONSTRAINT "PSCampaigns_IdCampaignStatus_fkey" FOREIGN KEY ("IdCampaignStatus") REFERENCES public."PSCampaignStatus"("IdCampaignStatus") NOT VALID;


--
-- TOC entry 3679 (class 2606 OID 37385)
-- Name: PSCampaigns PSCampaigns_IdCurrency_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaigns"
    ADD CONSTRAINT "PSCampaigns_IdCurrency_fkey" FOREIGN KEY ("IdCurrency") REFERENCES public."PSCurrencies"("IdCurrency") NOT VALID;


--
-- TOC entry 3680 (class 2606 OID 37380)
-- Name: PSCampaigns PSCampaigns_IdOrganization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaigns"
    ADD CONSTRAINT "PSCampaigns_IdOrganization_fkey" FOREIGN KEY ("IdOrganization") REFERENCES public."PSOrganizations"("IdOrganization") NOT VALID;


--
-- TOC entry 3681 (class 2606 OID 37395)
-- Name: PSCampaigns PSCampaigns_IdRunLog_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCampaigns"
    ADD CONSTRAINT "PSCampaigns_IdRunLog_fkey" FOREIGN KEY ("IdRunLog") REFERENCES public."PSETLRunLog"("IdRunLog") NOT VALID;


--
-- TOC entry 3653 (class 2606 OID 37255)
-- Name: PSCities PSCities_IdState_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCities"
    ADD CONSTRAINT "PSCities_IdState_fkey" FOREIGN KEY ("IdState") REFERENCES public."PSStates"("IdState") NOT VALID;


--
-- TOC entry 3687 (class 2606 OID 37425)
-- Name: PSContentUsage PSContentUsage_IdCampaign_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSContentUsage"
    ADD CONSTRAINT "PSContentUsage_IdCampaign_fkey" FOREIGN KEY ("IdCampaign") REFERENCES public."PSCampaigns"("IdCampaign") NOT VALID;


--
-- TOC entry 3666 (class 2606 OID 37320)
-- Name: PSCurrencies PSCurrencies_IdCountry_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSCurrencies"
    ADD CONSTRAINT "PSCurrencies_IdCountry_fkey" FOREIGN KEY ("IdCountry") REFERENCES public."PSCountries"("IdCountry") NOT VALID;


--
-- TOC entry 3688 (class 2606 OID 37430)
-- Name: PSETLConfig PSETLConfig_IdConnection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSETLConfig"
    ADD CONSTRAINT "PSETLConfig_IdConnection_fkey" FOREIGN KEY ("IdConnection") REFERENCES public."PSServiceConnectionConfig"("IdConnection") NOT VALID;


--
-- TOC entry 3705 (class 2606 OID 37515)
-- Name: PSETLDelta PSETLDelta_IdRunLog_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSETLDelta"
    ADD CONSTRAINT "PSETLDelta_IdRunLog_fkey" FOREIGN KEY ("IdRunLog") REFERENCES public."PSETLRunLog"("IdRunLog") NOT VALID;


--
-- TOC entry 3689 (class 2606 OID 37435)
-- Name: PSETLErrors PSETLErrors_IdControl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSETLErrors"
    ADD CONSTRAINT "PSETLErrors_IdControl_fkey" FOREIGN KEY ("IdControl") REFERENCES public."PSETLConfig"("IdConfig") NOT VALID;


--
-- TOC entry 3701 (class 2606 OID 37495)
-- Name: PSETLRunLog PSETLRunLog_IdConfig_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSETLRunLog"
    ADD CONSTRAINT "PSETLRunLog_IdConfig_fkey" FOREIGN KEY ("IdConfig") REFERENCES public."PSETLConfig"("IdConfig") NOT VALID;


--
-- TOC entry 3667 (class 2606 OID 37325)
-- Name: PSExchangeRates PSExchangeRates_IdCurrencyDestiny_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSExchangeRates"
    ADD CONSTRAINT "PSExchangeRates_IdCurrencyDestiny_fkey" FOREIGN KEY ("IdCurrencyDestiny") REFERENCES public."PSCurrencies"("IdCurrency") NOT VALID;


--
-- TOC entry 3668 (class 2606 OID 37330)
-- Name: PSExchangeRates PSExchangeRates_IdCurrencySource_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSExchangeRates"
    ADD CONSTRAINT "PSExchangeRates_IdCurrencySource_fkey" FOREIGN KEY ("IdCurrencySource") REFERENCES public."PSCurrencies"("IdCurrency") NOT VALID;


--
-- TOC entry 3674 (class 2606 OID 37365)
-- Name: PSFeaturesPerSuscription PSFeaturesPerSuscription_IdFeature_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSFeaturesPerSuscription"
    ADD CONSTRAINT "PSFeaturesPerSuscription_IdFeature_fkey" FOREIGN KEY ("IdFeature") REFERENCES public."PSFeatures"("IdFeature") NOT VALID;


--
-- TOC entry 3675 (class 2606 OID 37360)
-- Name: PSFeaturesPerSuscription PSFeaturesPerSuscription_IdSubscription_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSFeaturesPerSuscription"
    ADD CONSTRAINT "PSFeaturesPerSuscription_IdSubscription_fkey" FOREIGN KEY ("IdSubscription") REFERENCES public."PSSubscriptions"("IdSubscription") NOT VALID;


--
-- TOC entry 3684 (class 2606 OID 37410)
-- Name: PSLeadsSumarry PSLeadsSumarry_IdCampaign_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSLeadsSumarry"
    ADD CONSTRAINT "PSLeadsSumarry_IdCampaign_fkey" FOREIGN KEY ("IdCampaign") REFERENCES public."PSCampaigns"("IdCampaign") NOT VALID;


--
-- TOC entry 3661 (class 2606 OID 37300)
-- Name: PSLogs PSLogs_IdLogLevel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSLogs"
    ADD CONSTRAINT "PSLogs_IdLogLevel_fkey" FOREIGN KEY ("IdLogLevel") REFERENCES public."PSLogLevels"("IdLogLevel") NOT VALID;


--
-- TOC entry 3662 (class 2606 OID 37305)
-- Name: PSLogs PSLogs_IdLogSource_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSLogs"
    ADD CONSTRAINT "PSLogs_IdLogSource_fkey" FOREIGN KEY ("IdLogSource") REFERENCES public."PSLogSources"("IdLogSource") NOT VALID;


--
-- TOC entry 3663 (class 2606 OID 37295)
-- Name: PSLogs PSLogs_IdLogType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSLogs"
    ADD CONSTRAINT "PSLogs_IdLogType_fkey" FOREIGN KEY ("IdLogType") REFERENCES public."PSLogTypes"("IdLogType") NOT VALID;


--
-- TOC entry 3696 (class 2606 OID 37475)
-- Name: PSMCPRequestLogs PSMCPRequestLogs_IdControl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSMCPRequestLogs"
    ADD CONSTRAINT "PSMCPRequestLogs_IdControl_fkey" FOREIGN KEY ("IdControl") REFERENCES public."PSETLConfig"("IdConfig") NOT VALID;


--
-- TOC entry 3697 (class 2606 OID 37470)
-- Name: PSMCPRequestLogs PSMCPRequestLogs_IdMCPServer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSMCPRequestLogs"
    ADD CONSTRAINT "PSMCPRequestLogs_IdMCPServer_fkey" FOREIGN KEY ("IdMCPServer") REFERENCES public."PSMCPServerConfig"("IdMCPServer") NOT VALID;


--
-- TOC entry 3692 (class 2606 OID 37450)
-- Name: PSMCPServerConfig PSMCPServerConfig_IdAuthMethod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSMCPServerConfig"
    ADD CONSTRAINT "PSMCPServerConfig_IdAuthMethod_fkey" FOREIGN KEY ("IdAuthMethod") REFERENCES public."PSAuthMethods"("IdAuthMethod") NOT VALID;


--
-- TOC entry 3693 (class 2606 OID 37455)
-- Name: PSMCPServerConfig PSMCPServerConfig_IdService_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSMCPServerConfig"
    ADD CONSTRAINT "PSMCPServerConfig_IdService_fkey" FOREIGN KEY ("IdService") REFERENCES public."PSServices"("IdService") NOT VALID;


--
-- TOC entry 3669 (class 2606 OID 37355)
-- Name: PSPayments PSPayments_IdCurrency_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPayments"
    ADD CONSTRAINT "PSPayments_IdCurrency_fkey" FOREIGN KEY ("IdCurrency") REFERENCES public."PSCurrencies"("IdCurrency") NOT VALID;


--
-- TOC entry 3670 (class 2606 OID 37345)
-- Name: PSPayments PSPayments_IdPaymentMethod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPayments"
    ADD CONSTRAINT "PSPayments_IdPaymentMethod_fkey" FOREIGN KEY ("IdPaymentMethod") REFERENCES public."PSPaymentMethods"("IdPaymentMethod") NOT VALID;


--
-- TOC entry 3671 (class 2606 OID 37340)
-- Name: PSPayments PSPayments_IdPaymentStatus_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPayments"
    ADD CONSTRAINT "PSPayments_IdPaymentStatus_fkey" FOREIGN KEY ("IdPaymentStatus") REFERENCES public."PSPaymentStatus"("IdPaymentStatus") NOT VALID;


--
-- TOC entry 3672 (class 2606 OID 37335)
-- Name: PSPayments PSPayments_IdPaymentType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPayments"
    ADD CONSTRAINT "PSPayments_IdPaymentType_fkey" FOREIGN KEY ("IdPaymentType") REFERENCES public."PSPaymentTypes"("IdPaymentType") NOT VALID;


--
-- TOC entry 3673 (class 2606 OID 37350)
-- Name: PSPayments PSPayments_IdUser_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPayments"
    ADD CONSTRAINT "PSPayments_IdUser_fkey" FOREIGN KEY ("IdUser") REFERENCES public."PSUsers"("IdUser") NOT VALID;


--
-- TOC entry 3657 (class 2606 OID 37280)
-- Name: PSPermissionsPerRole PSPermissionsPerRole_IdPermission_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPermissionsPerRole"
    ADD CONSTRAINT "PSPermissionsPerRole_IdPermission_fkey" FOREIGN KEY ("IdPermission") REFERENCES public."PSPermissions"("IdPermission") NOT VALID;


--
-- TOC entry 3658 (class 2606 OID 37275)
-- Name: PSPermissionsPerRole PSPermissionsPerRole_IdRole_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPermissionsPerRole"
    ADD CONSTRAINT "PSPermissionsPerRole_IdRole_fkey" FOREIGN KEY ("IdRole") REFERENCES public."PSRoles"("IdRole") NOT VALID;


--
-- TOC entry 3709 (class 2606 OID 37535)
-- Name: PSPublishedAdsReactions PSPublishedAdsReactions_IdPublishedAd_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPublishedAdsReactions"
    ADD CONSTRAINT "PSPublishedAdsReactions_IdPublishedAd_fkey" FOREIGN KEY ("IdPublishedAd") REFERENCES public."PSPublishedAds"("IdPublishedAd") NOT VALID;


--
-- TOC entry 3710 (class 2606 OID 37540)
-- Name: PSPublishedAdsReactions PSPublishedAdsReactions_IdReactionType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPublishedAdsReactions"
    ADD CONSTRAINT "PSPublishedAdsReactions_IdReactionType_fkey" FOREIGN KEY ("IdReactionType") REFERENCES public."PSReactionTypes"("IdReactionType") NOT VALID;


--
-- TOC entry 3708 (class 2606 OID 37530)
-- Name: PSPublishedAds PSPublishedAds_IdCampaign_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSPublishedAds"
    ADD CONSTRAINT "PSPublishedAds_IdCampaign_fkey" FOREIGN KEY ("IdCampaign") REFERENCES public."PSCampaigns"("IdCampaign") NOT VALID;


--
-- TOC entry 3706 (class 2606 OID 37520)
-- Name: PSRawData PSRawData_IdRunLog_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSRawData"
    ADD CONSTRAINT "PSRawData_IdRunLog_fkey" FOREIGN KEY ("IdRunLog") REFERENCES public."PSETLRunLog"("IdRunLog") NOT VALID;


--
-- TOC entry 3659 (class 2606 OID 37290)
-- Name: PSRolesPerUser PSRolesPerUser_IdRole_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSRolesPerUser"
    ADD CONSTRAINT "PSRolesPerUser_IdRole_fkey" FOREIGN KEY ("IdRole") REFERENCES public."PSRoles"("IdRole") NOT VALID;


--
-- TOC entry 3660 (class 2606 OID 37285)
-- Name: PSRolesPerUser PSRolesPerUser_IdUser_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSRolesPerUser"
    ADD CONSTRAINT "PSRolesPerUser_IdUser_fkey" FOREIGN KEY ("IdUser") REFERENCES public."PSUsers"("IdUser") NOT VALID;


--
-- TOC entry 3685 (class 2606 OID 37415)
-- Name: PSSalesSumarry PSSalesSumarry_IdCampaign_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSSalesSumarry"
    ADD CONSTRAINT "PSSalesSumarry_IdCampaign_fkey" FOREIGN KEY ("IdCampaign") REFERENCES public."PSCampaigns"("IdCampaign") NOT VALID;


--
-- TOC entry 3686 (class 2606 OID 37420)
-- Name: PSSalesSumarry PSSalesSumarry_IdCurrency_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSSalesSumarry"
    ADD CONSTRAINT "PSSalesSumarry_IdCurrency_fkey" FOREIGN KEY ("IdCurrency") REFERENCES public."PSCurrencies"("IdCurrency") NOT VALID;


--
-- TOC entry 3699 (class 2606 OID 37485)
-- Name: PSServiceConnectionConfig PSServiceConnectionConfig_IdSourceService_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSServiceConnectionConfig"
    ADD CONSTRAINT "PSServiceConnectionConfig_IdSourceService_fkey" FOREIGN KEY ("IdSourceService") REFERENCES public."PSServices"("IdService") NOT VALID;


--
-- TOC entry 3700 (class 2606 OID 37490)
-- Name: PSServiceConnectionConfig PSServiceConnectionConfig_IdTargetService_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSServiceConnectionConfig"
    ADD CONSTRAINT "PSServiceConnectionConfig_IdTargetService_fkey" FOREIGN KEY ("IdTargetService") REFERENCES public."PSServices"("IdService") NOT VALID;


--
-- TOC entry 3702 (class 2606 OID 37500)
-- Name: PSServiceConnectionLog PSServiceConnectionLog_IdConnection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSServiceConnectionLog"
    ADD CONSTRAINT "PSServiceConnectionLog_IdConnection_fkey" FOREIGN KEY ("IdConnection") REFERENCES public."PSServiceConnectionConfig"("IdConnection") NOT VALID;


--
-- TOC entry 3698 (class 2606 OID 37480)
-- Name: PSServices PSServices_IdServiceType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSServices"
    ADD CONSTRAINT "PSServices_IdServiceType_fkey" FOREIGN KEY ("IdServiceType") REFERENCES public."PSServiceTypes"("IdServiceType") NOT VALID;


--
-- TOC entry 3652 (class 2606 OID 37250)
-- Name: PSStates PSStates_IdCountry_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSStates"
    ADD CONSTRAINT "PSStates_IdCountry_fkey" FOREIGN KEY ("IdCountry") REFERENCES public."PSCountries"("IdCountry") NOT VALID;


--
-- TOC entry 3676 (class 2606 OID 37370)
-- Name: PSSubscriptionsPerUser PSSubscriptionsPerUser_IdSubscription_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSSubscriptionsPerUser"
    ADD CONSTRAINT "PSSubscriptionsPerUser_IdSubscription_fkey" FOREIGN KEY ("IdSubscription") REFERENCES public."PSSubscriptions"("IdSubscription") NOT VALID;


--
-- TOC entry 3677 (class 2606 OID 37375)
-- Name: PSSubscriptionsPerUser PSSubscriptionsPerUser_IdUser_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSSubscriptionsPerUser"
    ADD CONSTRAINT "PSSubscriptionsPerUser_IdUser_fkey" FOREIGN KEY ("IdUser") REFERENCES public."PSUsers"("IdUser") NOT VALID;


--
-- TOC entry 3655 (class 2606 OID 37265)
-- Name: PSUserContactInfo PSUserContactInfo_IdContactInfoType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSUserContactInfo"
    ADD CONSTRAINT "PSUserContactInfo_IdContactInfoType_fkey" FOREIGN KEY ("IdContactInfoType") REFERENCES public."PSContactInfoType"("IdContactInfoType") NOT VALID;


--
-- TOC entry 3656 (class 2606 OID 37270)
-- Name: PSUserContactInfo PSUserContactInfo_IdUser_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSUserContactInfo"
    ADD CONSTRAINT "PSUserContactInfo_IdUser_fkey" FOREIGN KEY ("IdUser") REFERENCES public."PSUsers"("IdUser") NOT VALID;


--
-- TOC entry 3664 (class 2606 OID 37310)
-- Name: PSUsersXOrganization PSUsersXOrganization_IdOrganization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSUsersXOrganization"
    ADD CONSTRAINT "PSUsersXOrganization_IdOrganization_fkey" FOREIGN KEY ("IdOrganization") REFERENCES public."PSOrganizations"("IdOrganization") NOT VALID;


--
-- TOC entry 3665 (class 2606 OID 37315)
-- Name: PSUsersXOrganization PSUsersXOrganization_IdUser_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSUsersXOrganization"
    ADD CONSTRAINT "PSUsersXOrganization_IdUser_fkey" FOREIGN KEY ("IdUser") REFERENCES public."PSUsers"("IdUser") NOT VALID;


--
-- TOC entry 3651 (class 2606 OID 37245)
-- Name: PSUsers PSUsers_IdUserStatus_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PSUsers"
    ADD CONSTRAINT "PSUsers_IdUserStatus_fkey" FOREIGN KEY ("IdUserStatus") REFERENCES public."PSUserStatus"("IdUserStatus") NOT VALID;


--
-- TOC entry 3859 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2025-12-03 12:34:08

--
-- PostgreSQL database dump complete
--

\unrestrict DQoqLZ63AJ6JKMR97PlLqgaAMUsKMwdXnDgNE9u4VxEys6825sggKqg9iHhg2Qa

