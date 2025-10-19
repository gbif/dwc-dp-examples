---
-- Schema for input data to be mapped to dwc-dp publishing model.
--

-- agentID,relatedAgentID,agentRole,agentRoleOrder
CREATE TABLE input_agent_agent_role (
  agentID TEXT NOT NULL,
  relatedAgentID TEXT NOT NULL,
  agentRole TEXT,
  agentRoleOrder SMALLINT NOT NULL CHECK (agentRoleOrder >= 1) DEFAULT 1
);

-- agentID,identifier,identifierType,identifierLanguage
CREATE TABLE input_agent_identifier (
  agentID TEXT NOT NULL,
  identifier TEXT NOT NULL,
  identifierType TEXT NOT NULL,
  identifierLanguage TEXT
);

-- agentID,agentType,preferredAgentName,agentRemarks
CREATE TABLE input_agent (
  agentID TEXT PRIMARY KEY,
  agentType TEXT NOT NULL,
  preferredAgentName TEXT,
  agentRemarks TEXT
);

-- referenceID,referenceType,bibliographicCitation,title,authorID,volume,issue,pages,
-- issued
CREATE TABLE input_bibliographic_resource (
  referenceID TEXT PRIMARY KEY,
  referenceType TEXT,
  bibliographicCitation TEXT,
  title TEXT,
  authorID TEXT,
  volume TEXT,
  issue TEXT,
  pages TEXT,
  issued TEXT
);

-- eventID,assertionID,assertionType,assertionTypeIRI,assertionValue,assertionValueIRI,
-- assertionValueNumeric,assertionUnit,assertionUnitIRI,assertionProtocols,
-- assertionProtocolID
CREATE TABLE input_event_assertion (
  eventID TEXT NOT NULL,
  assertionID TEXT,
  assertionType TEXT NOT NULL,
  assertionTypeIRI TEXT,
  assertionValue TEXT,
  assertionValueIRI TEXT,
  assertionValueNumeric TEXT,
  assertionUnit TEXT,
  assertionUnitIRI TEXT,
  assertionProtocols TEXT,
  assertionProtocolID TEXT
);

-- provenanceID,eventID
CREATE TABLE input_event_provenance (
  provenanceID TEXT NOT NULL,
  eventID TEXT NOT NULL
);

-- eventID,parentEventID,preferredEventName,eventType,eventConductedBy,
-- eventConductedByID,eventDate,year,month,day,verbatimLocality,eventReferences,
-- eventRemarks,locationID,waterBody,countryCode,minimumDepthInMeters,
-- maximumDepthInMeters,decimalLatitude,decimalLongitude,geodeticDatum,footprintWKT,
-- footprintSRS
CREATE TABLE input_event (
  eventID TEXT PRIMARY KEY,
  parentEventID TEXT,
  preferredEventName TEXT,
  eventType TEXT NOT NULL,
  eventConductedBy TEXT,
  eventConductedByID TEXT,
  eventDate TEXT,
  year SMALLINT,
  month SMALLINT CHECK (month BETWEEN 1 AND 12),
  day SMALLINT CHECK (day BETWEEN 1 and 31), 
  verbatimLocality TEXT,
  eventReferences TEXT,
  eventRemarks TEXT,
  locationID TEXT,
  waterBody TEXT,
  countryCode CHAR(2),
  minimumDepthInMeters NUMERIC CHECK (minimumDepthInMeters BETWEEN 0 AND 11000),
  maximumDepthInMeters NUMERIC CHECK (maximumDepthInMeters BETWEEN 0 AND 11000),
  decimalLatitude TEXT,
  decimalLongitude TEXT,
  geodeticDatum TEXT,
  footprintWKT TEXT,
  footprintSRS TEXT
);

-- identificationID,materialEntityID,verbatimIdentification,identifiedBy,identifiedByID,
-- identificationReferences,identificationRemarks,taxonID,scientificName,taxonRank,kingdom
CREATE TABLE input_identification (
  identificationID TEXT PRIMARY KEY,
  materialEntityID TEXT,
  verbatimIdentification TEXT,
  identifiedBy TEXT,
  identifiedByID TEXT,
  identificationReferences TEXT,
  identificationRemarks TEXT,
  taxonID TEXT,
  scientificName TEXT,
  taxonRank TEXT,
  kingdom TEXT
);

-- materialEntityID,assertionID,assertionType,assertionTypeIRI,assertionValue,
-- assertionValueIRI,assertionValueNumeric,assertionUnit,assertionUnitIRI
CREATE TABLE input_material_assertion (
  materialEntityID TEXT NOT NULL,
  assertionID TEXT,
  assertionType TEXT NOT NULL,
  assertionTypeIRI TEXT,
  assertionValue TEXT,
  assertionValueIRI TEXT,
  assertionValueNumeric TEXT,
  assertionUnit TEXT,
  assertionUnitIRI TEXT
);

-- mediaID,materialEntityID
CREATE TABLE input_material_media (
  mediaID TEXT,
  materialEntityID TEXT
);

-- provenanceID,materialEntityID
CREATE TABLE input_material_provenance (
  provenanceID TEXT NOT NULL,
  materialEntityID TEXT NOT NULL
);

-- materialEntityID,eventID,materialCategory,materialEntityType,collectedBy,collectedByID,
-- preparations,disposition,materialEntityRemarks,evidenceForOccurrenceID,
-- derivedFromMaterialEntityID,derivationType,verbatimIdentification,identifiedBy,
-- identifiedByID,identificationRemarks,taxonID,scientificName,taxonRank
CREATE TABLE input_material (
  materialEntityID TEXT PRIMARY KEY,
  eventID TEXT,
  materialCategory TEXT,
  materialEntityType TEXT,
  collectedBy TEXT,
  collectedByID TEXT,
  preparations TEXT,
  disposition TEXT,
  materialEntityRemarks TEXT,
  evidenceForOccurrenceID TEXT,
  derivedFromMaterialEntityID TEXT,
  derivationType TEXT,
  verbatimIdentification TEXT,
  identifiedBy TEXT,
  identifiedByID TEXT,
  identificationRemarks TEXT,
  taxonID TEXT,
  scientificName TEXT,
  taxonRank TEXT
);

-- provenanceID,mediaID
CREATE TABLE input_media_provenance (
  provenanceID TEXT NOT NULL,
  mediaID TEXT NOT NULL
);

--usagePolicyID,mediaID
CREATE TABLE input_media_usage_policy (
  usagePolicyID TEXT NOT NULL,
  mediaID TEXT NOT NULL
);

-- mediaID,mediaType,description,language,accessURI,format
CREATE TABLE input_media (
  mediaID TEXT PRIMARY KEY,
  mediaType TEXT,
  description TEXT,
  language TEXT,
  accessURI TEXT,
  format TEXT
);

-- occurrenceID,eventID,surveyTargetID,recordedBy,recordedByID,organismQuantity,
-- organismQuantityType,lifeStage,occurrenceStatus,verbatimIdentification,identifiedBy,
-- identifiedByID,taxonID,scientificName,taxonRank
CREATE TABLE input_occurrence (
  occurrenceID TEXT PRIMARY KEY,
  eventID TEXT,
  surveyTargetID TEXT,
  recordedBy TEXT,
  recordedByID TEXT,
  organismQuantity TEXT,
  organismQuantityType TEXT,
  lifeStage TEXT,
  occurrenceStatus TEXT,
  verbatimIdentification TEXT,
  identifiedBy TEXT,
  identifiedByID TEXT,
  taxonID TEXT,
  scientificName TEXT,
  taxonRank TEXT
);

-- protocolID,referenceID
CREATE TABLE input_protocol_reference (
  protocolID TEXT NOT NULL,
  referenceID TEXT NOT NULL
);

-- protocolID,protocolType,protocolName,protocolDescription
CREATE TABLE input_protocol (
  protocolID TEXT PRIMARY KEY,
  protocolType TEXT,
  protocolName TEXT,
  protocolDescription TEXT
);

--provenanceID,fundingAttribution,fundingAttributionID,references,projectID,projectTitle
CREATE TABLE input_provenance (
  provenanceID TEXT PRIMARY KEY,
  fundingAttribution TEXT,
  fundingAttributionID TEXT,
  "references" TEXT,
  projectID TEXT,
  projectTitle TEXT
);

-- surveyTargetID,surveyID,surveyTargetType,surveyTargetTypeIRI,surveyTargetValue,
-- surveyTargetValueIRI,surveyTargetUnit,surveyTargetUnitIRI,includeOrExclude,
-- isSurveyTargetFullyReported
CREATE TABLE input_survey_target (
  surveyTargetID TEXT NOT NULL,
  surveyID TEXT NOT NULL,
  surveyTargetType TEXT,
  surveyTargetTypeIRI TEXT,
  surveyTargetValue TEXT,
  surveyTargetValueIRI TEXT,
  surveyTargetUnit TEXT,
  surveyTargetUnitIRI TEXT,
  includeOrExclude TEXT,
  isSurveyTargetFullyReported TEXT
);

-- surveyID,eventID,siteCount,siteNestingDescription,verbatimSiteDescriptions,
-- verbatimSiteNames,isAbsenceReported,areNonTargetTaxaFullyReported,compilationTypes,
-- inventoryTypes,protocolNames,protocolReferences,
-- isLeastSpecificTargetCategoryQuantityInclusive,sampleSizeValue,sampleSizeUnit,
-- samplingPerformedBy,samplingPerformedByID,isSamplingEffortReported,
-- samplingEffortProtocol,samplingEffortValue,samplingEffortUnit
CREATE TABLE input_survey (
  surveyID TEXT PRIMARY KEY,
  eventID TEXT NOT NULL,
  siteCount TEXT,
  siteNestingDescription TEXT,
  verbatimSiteDescriptions TEXT,
  verbatimSiteNames TEXT,
  isAbsenceReported TEXT,
  areNonTargetTaxaFullyReported TEXT,
  compilationTypes TEXT,
  inventoryTypes TEXT,
  protocolNames TEXT,
  protocolReferences TEXT,
  isLeastSpecificTargetCategoryQuantityInclusive TEXT,
  sampleSizeValue TEXT,
  sampleSizeUnit TEXT,
  samplingPerformedBy TEXT,
  samplingPerformedByID TEXT,
  isSamplingEffortReported TEXT,
  samplingEffortProtocol TEXT,
  samplingEffortValue TEXT,
  samplingEffortUnit TEXT
);

-- usagePolicyID,rights,rightsIRI,license,credit
CREATE TABLE input_usage_policy (
  usagePolicyID TEXT PRIMARY KEY,
  rights TEXT,
  rightsIRI TEXT,
  license TEXT,
  credit TEXT
);

