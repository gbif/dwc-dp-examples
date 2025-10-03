-- For this dataset, every record in input_data/inat_interactions.csv represents an 
-- Occurrence and possibly also an OrganismInteration. Most Occurrences have Media.

-- Generate event_id and related occurrence_id for the input observations table records, 
-- The uuid will be used as the subject occurrence_id.
CREATE TABLE temp_ids AS 
SELECT 
  uuid AS event_id,
  id as local_occurrence_id,
  'https://inaturalist.org/observations/' || id AS occurrence_id,
  image_url AS media_id,
  CASE
    WHEN "field:associated observation" ILIKE '%observations%' THEN
      'https://inaturalist.org/observations/' || SUBSTRING(split_part("field:associated observation", ' | ', 1) FROM 'observations/([0-9]+)') 
    ELSE NULL
  END AS related_occurrence_id_1,

  CASE
    WHEN "field:associated observation" ILIKE '%observations%' THEN
      'https://inaturalist.org/observations/' || SUBSTRING(split_part("field:associated observation", ' | ', 2) FROM 'observations/([0-9]+)') 
    ELSE NULL
  END AS related_occurrence_id_2,

  CASE
    WHEN "field:associated observation" ILIKE '%observations%' THEN
      'https://inaturalist.org/observations/' || SUBSTRING(split_part("field:associated observation", ' | ', 3) FROM 'observations/([0-9]+)') 
    ELSE NULL
  END AS related_occurrence_id_3
FROM observations
WHERE quality_grade = 'research';
-- n = 916

-- Make the agent table with iNaturalist as an institution.
INSERT INTO agent (
  agent_id,
  agent_type,
  preferred_agent_name
)
(SELECT DISTINCT 
  'https://www.inaturalist.org' AS agent_id,
  'organization' AS agent_type,
  'iNaturalist' AS preferred_agent_name
);
-- n = 1

-- Add to the agent table with the distinct values of user_id, user_name.
INSERT INTO agent (
  agent_id,
  agent_type,
  preferred_agent_name
)
(SELECT DISTINCT 
  user_id AS agent_id,
  'person' AS agent_type,
  user_name AS preferred_agent_name
FROM observations
);
-- n = 25
-- total = 26

-- Make a media table with the distinct values of image metadata.
INSERT INTO media (
    media_id,
    derived_from_media_id,
    is_part_of_media_id,
    media_type,
    title,
    description,
    caption,
    subtype_literal,
    subtype_iri,
    collection_code,
    collection_id,
    create_date,
    time_of_day,
    digitization_date,
    capture_device,
    frame_rate,
    resource_creation_technique,
    sample_rate,
    modified,
    language,
    language_iri,
    metadata_date,
    metadata_language_literal,
    metadata_language_iri,
    provider_managed_id,
    available,
    has_service_access_point,
    service_expectation,
    access_uri,
    format,
    format_iri,
    variant_literal,
    variant_iri,
    variant_description,
    pixel_x_dimension,
    pixel_y_dimension,
    hash_function,
    hash_value,
    further_information_url,
    commenter_literal,
    commenter_id,
    comments,
    rating,
    reviewer_literal,
    reviewer_id,
    reviewer_comments,
    physical_setting,
    subject_category,
    subject_category_iri,
    subject_category_source,
    tag,
    subject_part_literal,
    subject_part_iri,
    subject_orientation_literal,
    subject_orientation_iri,
    start_time,
    end_time,
    start_timestamp,
    end_timestamp,
    media_duration,
    media_speed,
    freq_high,
    freq_low,
    x_frac,
    y_frac,
    height_frac,
    width_frac,
    radius
)
(SELECT DISTINCT 
    image_url AS media_id,
    NULL AS derived_from_media_id,
    NULL AS is_part_of_media_id,
    'StillImage' AS media_type,
    NULL AS title,
    NULL AS description,
    NULL AS caption,
    NULL AS subtype_literal,
    NULL AS subtype_iri,
    NULL AS collection_code,
    NULL AS collection_id,
    CASE WHEN time_observed_at IS NULL
      THEN ''
      ELSE SUBSTRING(time_observed_at FROM 1 FOR 10) || 'T' || SUBSTRING(time_observed_at FROM 12 FOR 8) || 'Z'
      END AS create_date,
    NULL AS time_of_day,
    NULL AS digitized_date,
    NULL AS capture_device,
    NULL::NUMERIC AS frame_rate,    
    NULL AS resource_creation_technique,
    NULL::NUMERIC AS sample_rate,
    NULL AS modified,
    NULL AS language,
    NULL AS language_iri,
    NULL AS metadata_date,
    NULL AS metadata_language_literal,
    NULL AS metadata_language_iri,
    NULL AS provider_managed_id,
    NULL AS available,
    NULL AS has_service_access_point,
    NULL AS service_expectation,
    image_url AS access_uri,
    'image/' || RIGHT(image_url, POSITION('.' IN REVERSE(image_url)) - 1) AS format,
    NULL AS format_iri,
    NULL AS variant_literal,
    NULL AS variant_iri,
    NULL AS variant_description,
    NULL::INTEGER AS pixel_x_dimension,
    NULL::INTEGER AS pixel_y_dimension,
    NULL AS hash_function,
    NULL AS hash_value,
    NULL AS further_information_url, 
    NULL AS commenter_literal,
    NULL AS commenter_id,
    NULL AS comments,
    NULL AS rating,
    NULL AS reviewer_literal,
    NULL AS reviewer_id,
    NULL AS reviewer_comments,
    NULL AS physical_setting,
    'occurrence event' AS subject_category,
    NULL AS subject_category_iri,
    NULL AS subject_category_source,
    NULL AS tag,
    NULL AS subject_part_literal,
    NULL AS subject_part_iri,
    NULL AS subject_orientation_literal,
    NULL AS subject_orientation_iri,
    NULL::NUMERIC AS start_time,
    NULL::NUMERIC AS end_time,
    NULL AS start_timestamp,
    NULL AS end_timestamp,
    NULL::NUMERIC AS media_duration,
    NULL::NUMERIC AS media_speed,
    NULL::NUMERIC AS freq_high,
    NULL::NUMERIC AS freg_low,
    NULL::NUMERIC AS x_frac,
    NULL::NUMERIC AS y_frac,
    NULL::NUMERIC AS height_frac,
    NULL::NUMERIC AS width_frac,
    NULL::NUMERIC AS radius
FROM observations
WHERE image_url IS NOT NULL
AND quality_grade = 'research'
);
-- n = 909

-- Prepare to generate provenance_id and usage_policy_id for the distinct media records.
CREATE TABLE temp_media AS 
SELECT DISTINCT
  image_url AS media_id,
  user_name,
  user_id,
  license
FROM observations
WHERE image_url IS NOT NULL
AND quality_grade = 'research';
-- n = 909

-- Generate provenance_id and usage_policy_id for the distinct media records, 
CREATE TABLE temp_media_ids AS 
SELECT
  media_id,
  user_name,
  user_id,
  license,
  gen_random_uuid() AS provenance_id,
  gen_random_uuid() AS usage_policy_id
FROM temp_media;
-- n = 909

-- Make a provenance table.
INSERT INTO provenance (
  provenance_id,
  dataset_id,
  funding_attribution,
  funding_attribution_id,
  source,
  source_iri,
  creator_literal,
  creator_id,
  provider_literal,
  provider_id,
  metadata_creator_literal,
  metadata_creator_id,
  metadata_provider_literal,
  metadata_provider_id,
  further_information_url,
  feedback_url,
  "references",
  bibliographic_citation,
  project_id,
  project_title
)
(SELECT
  provenance_id,
  NULL AS dataset_id,
  NULL AS funding_attribution,
  NULL AS funding_attribution_id,
  CASE
    WHEN a.media_id ILIKE '%/photos/%' THEN
      'https://www.inaturalist.org/photos/' || SUBSTRING('https://inaturalist-open-data.s3.amazonaws.com/photos/33820500/medium.jpeg' FROM '/photos/([0-9]+)/') 
    ELSE NULL
    END AS "source",
  NULL AS source_iri,
  user_name AS creator_literal,
  user_id AS creator_id,
  NULL AS provider_literal,
  NULL AS provider_id,
  NULL AS metadata_creator_literal,
  NULL AS metadata_creator_id,
  NULL AS metadata_provider_literal,
  NULL AS metadata_provider_id,
  NULL AS further_information_url,
  NULL AS feedback_url,
  NULL AS "references",
  NULL AS bibliographic_citation,
  '18530' AS project_id,
  'California Pollination Project' AS project_title
FROM temp_media_ids a JOIN media b ON  a.media_id=b.media_id
);
-- n = 909

-- Make a uage_policy table.
INSERT INTO usage_policy (
  usage_policy_id,
  rights,
  rights_iri,
  rights_holder,
  rights_holder_id,
  owner,
  owner_id,
  usage_terms,
  web_statement,
  access_rights,
  license,
  license_logo_url,
  licensing_exception,
  credit,
  attribution_logo_url,
  attribution_link_url
)
(SELECT
  usage_policy_id AS usage_policy_id,
  NULL AS rights,
  NULL AS rights_iri,
  NULL AS rights_holder,
  NULL AS rights_holder_id,
  user_name AS owner,
  NULL AS owner_id,
  NULL AS usage_terms,
  CASE
    WHEN license = 'CC0' THEN 'https://creativecommons.org/publicdomain/zero/1.0/'
    WHEN license = 'CC-BY' THEN 'https://creativecommons.org/licenses/by/4.0/'
    WHEN license = 'CC-BY-NC' THEN 'https://creativecommons.org/licenses/by-nc/4.0/'
    ELSE NULL
  END AS web_statement,
  NULL AS access_rights,
  NULL AS license,
  NULL AS license_logo_url,
  NULL AS licensing_exception,
  NULL AS credit,
  NULL AS attribution_logo_url,
  NULL AS attribution_link_url
FROM temp_media_ids a JOIN media b ON  a.media_id=b.media_id
);
-- n = 909

INSERT INTO media_provenance (
  provenance_id,
  media_id
)
(SELECT 
  provenance_id,
  media_id
FROM temp_media_ids
);
-- n = 909

INSERT INTO media_usage_policy (
  usage_policy_id,
  media_id
)
(SELECT 
  usage_policy_id,
  media_id
FROM temp_media_ids
);
-- n = 909

-- Make an event table with the project.
INSERT INTO event (
  event_id,
  parent_event_id,
  preferred_event_name,
  event_category,
  event_type,
  dataset_name,
  dataset_id,
  field_number,
  event_conducted_by,
  event_conducted_by_id,
  event_date,
  event_time,
  start_day_of_year,
  end_day_of_year,
  year,
  month,
  day, 
  verbatim_event_date,
  verbatim_locality,
  verbatim_elevation,
  verbatim_depth,
  verbatim_coordinates,
  verbatim_latitude,
  verbatim_longitude,
  verbatim_coordinate_system,
  verbatim_srs,
  georeference_verification_status,
  habitat,
  event_effort,
  field_notes,
  event_references,
  event_remarks,
  location_id,
  higher_geography_id,
  higher_geography,
  continent,
  water_body,
  island_group,
  island,
  country,
  country_code,
  state_province,
  county,
  municipality,
  locality,
  site_number,
  minimum_elevation_in_meters,
  maximum_elevation_in_meters,
  vertical_datum,
  minimum_depth_in_meters,
  maximum_depth_in_meters,
  minimum_distance_above_surface_in_meters,
  maximum_distance_above_surface_in_meters,
  location_remarks,
  decimal_latitude,
  decimal_longitude,
  geodetic_datum,
  coordinate_uncertainty_in_meters,
  coordinate_precision,
  point_radius_spatial_fit,
  footprint_wkt,
  footprint_srs,
  footprint_spatial_fit,
  georeferenced_by,
  georeferenced_by_id,
  georeferenced_date,
  georeference_protocol,
  georeference_protocol_id,
  georeference_sources,
  georeference_remarks,
  geological_context_id,
  preferred_spatial_representation,
  feedback_url,
  information_withheld,
  data_generalizations
)
(SELECT
  'https://www.inaturalist.org/projects/california-pollination-project' AS event_id,
  NULL AS parent_event_id,
  'California Pollination Project' AS preferred_event_name,
  'observation' AS event_category,
  'iNaturalist Project' AS event_type,
  NULL AS dataset_name,
  NULL AS dataset_id,
  NULL AS field_number,
  'iNaturalist' AS event_conducted_by,
  'https://www.inaturalist.org' AS event_conducted_by_id,
  NULL AS event_date,
  NULL AS event_time,
  NULL AS start_day_of_year,
  NULL AS end_day_of_year,
  NULL AS year,
  NULL AS month,
  NULL AS day,
  NULL AS verbatim_event_date,
  NULL AS verbatim_locality,
  NULL AS verbatim_elevation,
  NULL AS verbatim_depth,
  NULL AS verbatim_coordinates,
  NULL AS verbatim_latitude,
  NULL AS verbatim_longitude,
  NULL AS verbatim_coordinate_system,
  NULL AS verbatim_srs,
  NULL AS georeference_verification_status,
  NULL AS habitat,
  NULL AS event_effort,
  NULL AS field_notes,
  NULL AS event_references,
  NULL AS event_remarks,
  NULL AS location_id,
  NULL AS higher_geography_id,
  NULL AS higher_geography,
  NULL AS continent,
  NULL AS water_body,
  NULL AS island_group,
  NULL AS island,
  'United States' AS country,
  'US' AS country_code,
  'California' AS state_province,
  NULL AS county,
  NULL AS municipality,
  NULL AS locality,
  NULL AS site_number,
  NULL AS minimum_elevation_in_meters,
  NULL AS maximum_elevation_in_meters,
  NULL AS vertical_datum,
  NULL AS minimum_depth_in_meters,
  NULL AS maximum_depth_in_meters,
  NULL AS minimum_distance_above_surface_in_meters,
  NULL AS maximum_distance_above_surface_in_meters,
  NULL AS location_remarks,
  NULL AS decimal_latitude,
  NULL AS decimal_longitude,
  NULL AS geodetic_datum,
  NULL AS coordinate_uncertainty_in_meters,
  NULL AS coordinate_precision,
  NULL AS point_radius_spatial_fit,
  NULL AS footprint_wkt,
  NULL AS footprint_srs,
  NULL AS footprint_spatial_fit,
  NULL AS georeferenced_by,
  NULL AS georeferenced_by_id,
  NULL AS georeferenced_date,
  NULL AS georeference_protocol,
  NULL AS georeference_protocol_id,
  NULL AS georeference_sources,
  NULL AS georeference_remarks,
  NULL AS geological_context_id,
  NULL AS preferred_spatial_representation,
  NULL AS feedback_url,
  NULL AS information_withheld,
  NULL AS data_generalizations
);
-- n = 1

-- Append one event record per observation record.
INSERT INTO event (
  event_id,
  parent_event_id,
  preferred_event_name,
  event_category,
  event_type,
  dataset_name,
  dataset_id,
  field_number,
  event_conducted_by,
  event_conducted_by_id,
  event_date,
  event_time,
  start_day_of_year,
  end_day_of_year,
  year,
  month,
  day, 
  verbatim_event_date,
  verbatim_locality,
  verbatim_elevation,
  verbatim_depth,
  verbatim_coordinates,
  verbatim_latitude,
  verbatim_longitude,
  verbatim_coordinate_system,
  verbatim_srs,
  georeference_verification_status,
  habitat,
  event_effort,
  field_notes,
  event_references,
  event_remarks,
  location_id,
  higher_geography_id,
  higher_geography,
  continent,
  water_body,
  island_group,
  island,
  country,
  country_code,
  state_province,
  county,
  municipality,
  locality,
  site_number,
  minimum_elevation_in_meters,
  maximum_elevation_in_meters,
  vertical_datum,
  minimum_depth_in_meters,
  maximum_depth_in_meters,
  minimum_distance_above_surface_in_meters,
  maximum_distance_above_surface_in_meters,
  location_remarks,
  decimal_latitude,
  decimal_longitude,
  geodetic_datum,
  coordinate_uncertainty_in_meters,
  coordinate_precision,
  point_radius_spatial_fit,
  footprint_wkt,
  footprint_srs,
  footprint_spatial_fit,
  georeferenced_by,
  georeferenced_by_id,
  georeferenced_date,
  georeference_protocol,
  georeference_protocol_id,
  georeference_sources,
  georeference_remarks,
  geological_context_id,
  preferred_spatial_representation,
  feedback_url,
  information_withheld,
  data_generalizations
)
(SELECT
  b.event_id AS event_id,
  'https://www.inaturalist.org/projects/california-pollination-project' AS parent_event_id,
  NULL AS preferred_event_name,
  'observation' AS event_category,
  NULL AS event_type,
  'iNaturalist research-grade observations' AS dataset_name,
  NULL AS dataset_id,
  NULL AS field_number,
  user_name AS event_conducted_by,
  user_id AS event_conducted_by_id,
  CASE WHEN time_observed_at IS NULL 
    THEN ''
    ELSE SUBSTRING(time_observed_at FROM 1 FOR 10) || 'T' || SUBSTRING(time_observed_at FROM 12 FOR 8) || 'Z'
    END AS event_date,
  CASE WHEN time_observed_at IS NULL 
    THEN ''
    ELSE SUBSTRING(time_observed_at FROM 12 FOR 8)
    END AS event_time,
  NULL AS start_day_of_year,
  NULL AS end_day_of_year,
  CASE WHEN time_observed_at IS NULL 
    THEN NULL
    ELSE SUBSTRING(time_observed_at FROM 1 FOR 4)::smallint
    END AS year,
  CASE WHEN time_observed_at IS NULL 
    THEN NULL
    ELSE SUBSTRING(time_observed_at FROM 6 FOR 2)::smallint
    END AS month,
  CASE WHEN time_observed_at IS NULL
    THEN NULL
    ELSE SUBSTRING(time_observed_at FROM 9 FOR 2)::smallint
    END AS day,
  observed_on_string AS verbatim_event_date,
  place_guess AS verbatim_locality,
  NULL AS verbatim_elevation,
  NULL AS verbatim_depth,
  NULL AS verbatim_coordinates,
  NULL AS verbatim_latitude,
  NULL AS verbatim_longitude,
  NULL AS verbatim_coordinate_system,
  NULL AS verbatim_srs,
  NULL AS georeference_verification_status,
  NULL AS habitat,
  NULL AS event_effort,
  NULL AS field_notes,
  NULL AS event_references,
  NULL AS event_remarks,
  NULL AS location_id,
  NULL AS higher_geography_id,
  NULL AS higher_geography,
  NULL AS continent,
  NULL AS water_body,
  NULL AS island_group,
  NULL AS island,
  place_country_name AS country,
  NULL AS country_code,
  place_state_name AS state_province,
  place_county_name AS county,
  place_town_name AS municipality,
  place_guess AS locality,
  NULL AS site_number,
  NULL AS minimum_elevation_in_meters,
  NULL AS maximum_elevation_in_meters,
  NULL AS vertical_datum,
  NULL AS minimum_depth_in_meters,
  NULL AS maximum_depth_in_meters,
  NULL AS minimum_distance_above_surface_in_meters,
  NULL AS maximum_distance_above_surface_in_meters,
  NULL AS location_remarks,
  latitude AS decimal_latitude,
  longitude AS decimal_longitude,
  'epsg:4326' AS geodetic_datum,
  positional_accuracy AS coordinate_uncertainty_in_meters,
  NULL AS coordinate_precision,
  NULL AS point_radius_spatial_fit,
  NULL AS footprint_wkt,
  NULL AS footprint_srs,
  NULL AS footprint_spatial_fit,
  NULL AS georeferenced_by,
  NULL AS georeferenced_by_id,
  observed_on AS georeferenced_date,
  positioning_device AS georeference_protocol,
  NULL AS georeference_protocol_id,
  positioning_method AS georeference_sources,
  NULL AS georeference_remarks,
  NULL AS geological_context_id,
  'point-radius' AS preferred_spatial_representation,
  NULL AS feedback_url,
  NULL AS information_withheld,
  NULL AS data_generalizations
FROM observations a
JOIN temp_ids b ON a.uuid=b.event_id
WHERE quality_grade = 'research'
);
-- n = 916
-- total = 917

-- Fill the EventMedia table
INSERT INTO event_media (
  media_id,
  event_id,
  subject_category,
  subject_category_iri,
  subject_category_source,
  subject_part_literal,
  subject_part,
  subject_orientation_literal,
  subject_orientation,
  physical_setting
)
(SELECT
  a.media_id AS media_id,
  a.event_id AS event_id,
  'occurrence event' AS subject_category,
  NULL AS subject_category_iri,
  NULL AS subject_category_vocabulary,
  NULL AS subject_part_literal,
  NULL AS subject_part,
  NULL AS subject_orientation_literal,
  NULL AS subject_orientation,
  NULL AS physical_setting
FROM temp_ids a
JOIN event b ON a.event_id=b.event_id
);
-- n = 916

-- Fill the Occurrence table with the subject Occurrences
INSERT INTO occurrence (
  occurrence_id,
  event_id,
  is_part_of_occurrence_id,
  survey_target_id,
  recorded_by,
  recorded_by_id,
  organism_quantity,
  organism_quantity_type,
  sex,
  life_stage,
  reproductive_condition,
  caste,
  behavior,
  vitality,
  establishment_means,
  degree_of_establishment,
  pathway,
  substrate,
  occurrence_status,
  occurrence_references,
  information_withheld,
  data_generalizations,
  occurrence_remarks,
  organism_id,
  organism_scope,
  organism_name,
  cause_of_death,
  organism_remarks,
  verbatim_identification,
  taxon_formula,
  identified_by,
  identified_by_id,
  date_identified,
  identification_references,
  identification_verification_status,
  identification_remarks,
  taxon_id,
  scientific_name_id,
  scientific_name,
  scientific_name_authorship,
  vernacular_name,
  taxon_rank,
  external_classification_source,
  feedback_url
)
(SELECT
  b.occurrence_id AS occurrence_id,
  b.event_id AS event_id,
  NULL AS is_part_of_occurrence_id,
  NULL AS survey_target_id,
  user_name AS recorded_by,
  user_id AS recorded_by_id,
  NULL AS organism_quantity,
  NULL AS organism_quantity_type,
  NULL AS sex,
  NULL AS life_stage,
  NULL AS reproductive_condition,
  NULL AS caste,
  NULL AS behavior,
  NULL AS vitality,
  CASE
    WHEN captive_cultivated = FALSE THEN 'wild'
    ELSE 'captive/cultivated'
  END AS establishment_means,
  NULL AS degree_of_establishment,
  NULL AS pathway,
  NULL AS substrate,
  'detected' AS occurrence_status,
  NULL AS occurrence_references,
  NULL AS information_withheld,
  NULL AS data_generalizations,
  description AS occurrence_remarks,
  NULL AS organism_id,
  'multicellular organism' AS organism_scope,
  NULL AS organism_name,
  NULL AS cause_of_death,
  NULL AS organism_remarks,
  species_guess AS verbatim_identification,
  'A' AS taxon_formula,
  NULL AS identified_by,
  NULL AS identified_by_id,
  NULL AS date_identified,
  NULL AS identification_references,
  NULL AS identification_verification_status,
  NULL AS identification_remarks,
  taxon_id AS taxon_id,
  NULL AS scientific_name_id,
  NULL AS scientific_name_authorship,
  NULL AS vernacular_name,
  scientific_name AS scientific_name,
  NULL AS taxon_rank,
  NULL AS external_classification_source,
  NULL AS feedback_url
FROM observations a
JOIN temp_ids b ON a.uuid=b.event_id
WHERE quality_grade = 'research'
);
-- n = 916

-- Make OccurrenceAssertions with num_identification_agreements.
INSERT INTO occurrence_assertion (
  occurrence_id,
  assertion_id,
  verbatim_assertion_type,
  assertion_type,
  assertion_type_iri,
  assertion_type_source,
  assertion_made_date,
  assertion_effective_date,
  assertion_value,
  assertion_value_iri,
  assertion_value_source,
  assertion_value_numeric,
  assertion_unit,
  assertion_unit_iri,
  assertion_unit_source,
  assertion_error,
  assertion_by, 
  assertion_by_id,
  assertion_protocols,
  assertion_protocol_id,
  assertion_references,
  assertion_remarks
)
(SELECT
  a.occurrence_id,
  gen_random_uuid() AS assertion_id,
  NULL AS verbatim_assertion_type,
  'num_identification_agreements' AS assertion_type,
  NULL AS assertion_type_iri,
  NULL AS assertion_type_source,
  NULL AS assertion_made_date,
  NULL AS assertion_effective_date,
  NULL AS assertion_value,
  NULL AS assertion_value_iri,
  NULL AS assertion_value_source,
  num_identification_agreements AS assertion_value_numeric,
  NULL AS assertion_unit,
  NULL AS assertion_unit_iri,
  NULL AS assertion_unit_source,
  NULL AS assertion_error,
  NULL AS assertion_by,
  NULL AS assertion_by_id,
  NULL AS assertion_protocols,
  NULL AS assertion_protocol_id,
  NULL AS assertion_references,
  NULL AS assertion_remarks
FROM temp_ids a
JOIN observations b ON a.event_id=b.uuid
WHERE num_identification_agreements IS NOT NULL
AND quality_grade = 'research'
);
-- n = 916

-- Make OccurrenceAssertions with num_identification_disagreements.
INSERT INTO occurrence_assertion (
  occurrence_id,
  assertion_id,
  verbatim_assertion_type,
  assertion_type,
  assertion_type_iri,
  assertion_type_source,
  assertion_made_date,
  assertion_effective_date,
  assertion_value,
  assertion_value_iri,
  assertion_value_source,
  assertion_value_numeric,
  assertion_unit,
  assertion_unit_iri,
  assertion_unit_source,
  assertion_error,
  assertion_by, 
  assertion_by_id,
  assertion_protocols,
  assertion_protocol_id,
  assertion_references,
  assertion_remarks
)
(SELECT
  a.occurrence_id,
  gen_random_uuid() AS assertion_id,
  NULL AS verbatim_assertion_type,
 'num_identification_disagreements' AS assertion_type,
  NULL AS assertion_type_iri,
  NULL AS assertion_type_vocabulary,
  NULL AS assertion_made_date,
  NULL AS assertion_effective_date,
  NULL AS assertion_value,
  NULL AS assertion_value_iri,
  NULL AS assertion_value_source,
  num_identification_disagreements AS assertion_value_numeric,
  NULL AS assertion_unit,
  NULL AS assertion_unit_iri,
  NULL AS assertion_unit_source,
  NULL AS assertion_error,
  NULL AS assertion_by,
  NULL AS assertion_by_id,
  NULL AS assertion_protocols,
  NULL AS assertion_protocol_id,
  NULL AS assertion_references,
  NULL AS assertion_remarks
FROM temp_ids a
JOIN observations b ON a.event_id=b.uuid
WHERE num_identification_disagreements IS NOT NULL
AND quality_grade = 'research'
);
-- n = 916
-- total = 1832

-- Fill the OccurrenceMedia table
INSERT INTO occurrence_media (
  media_id,
  occurrence_id,
  subject_category,
  subject_category_iri,
  subject_category_source,
  subject_part_literal,
  subject_part,
  subject_orientation_literal,
  subject_orientation,
  physical_setting
)
(SELECT
  a.media_id AS media_id,
  a.occurrence_id AS occurrence_id,
  'organism occurrence' AS subject_category,
  NULL AS subject_category_iri,
  NULL AS subject_category_vocabulary,
  NULL AS subject_part_literal,
  NULL AS subject_part,
  NULL AS subject_orientation_literal,
  NULL AS subject_orientation,
  NULL AS physical_setting
FROM temp_ids a
JOIN occurrence b ON a.occurrence_id=b.occurrence_id
);
-- n = 916

-- Make OrganismInteractions with the first of the "field:associated observation"s.
INSERT INTO organism_interaction (
    organism_interaction_id,
    event_id,
    organism_interaction_description,
    subject_occurrence_id,
    subject_organism_part,
    organism_interaction_type,
    related_occurrence_id,
    external_related_occurrence_id,
    external_related_occurrence_source,
    related_organism_part,
    feedback_url
)
(SELECT
    gen_random_uuid() AS organism_interaction_id,
    event_id,
    NULL AS organism_interaction_description,
    occurrence_id AS subject_occurrence_id,
    NULL AS subject_organism_part,
    'visited flower of' AS organism_interaction_type,
    related_occurrence_id_1 AS related_occurrence_id,
    NULL AS external_related_occurrence_id,
    NULL AS external_related_occurrence_source,
    'flowers' AS related_organism_part,
    NULL AS feedback_url
FROM observations a
JOIN temp_ids b ON a.uuid=b.event_id
WHERE "field:interaction->visited flower of" IS NOT NULL
AND related_occurrence_id_1 IS NOT NULL
AND quality_grade = 'research'
AND related_occurrence_id_1 IN
(SELECT occurrence_id FROM temp_ids)
);
-- n = 93

-- Make OrganismInteractions with the second of the "field:associated observation"s.
INSERT INTO organism_interaction (
    organism_interaction_id,
    event_id,
    organism_interaction_description,
    subject_occurrence_id,
    subject_organism_part,
    organism_interaction_type,
    related_occurrence_id,
    external_related_occurrence_id,
    external_related_occurrence_source,
    related_organism_part,
    feedback_url
)
(SELECT
    gen_random_uuid() AS organism_interaction_id,
    event_id,
    NULL AS organism_interaction_description,
    occurrence_id AS subject_occurrence_id,
    NULL AS subject_organism_part,
    'visited flower of' AS organism_interaction_type,
    related_occurrence_id_2 AS related_occurrence_id,
    NULL AS external_related_occurrence_id,
    NULL AS external_related_occurrence_source,
    'flowers' AS related_organism_part,
    NULL AS feedback_url
FROM observations a
JOIN temp_ids b ON a.uuid=b.event_id
WHERE "field:interaction->visited flower of" IS NOT NULL
AND related_occurrence_id_2 IS NOT NULL
AND quality_grade = 'research'
AND related_occurrence_id_2 IN
(SELECT occurrence_id FROM temp_ids)
);
-- n = 0
-- total = 93

-- Make OrganismInteractions with the third of the "field:associated observation"s.
INSERT INTO organism_interaction (
    organism_interaction_id,
    event_id,
    organism_interaction_description,
    subject_occurrence_id,
    subject_organism_part,
    organism_interaction_type,
    related_occurrence_id,
    external_related_occurrence_id,
    external_related_occurrence_source,
    related_organism_part,
    feedback_url
)
(SELECT
    gen_random_uuid() AS organism_interaction_id,
    event_id,
    NULL AS organism_interaction_description,
    occurrence_id AS subject_occurrence_id,
    NULL AS subject_organism_part,
    'visited flower of' AS organism_interaction_type,
    related_occurrence_id_3 AS related_occurrence_id,
    NULL AS external_related_occurrence_id,
    NULL AS external_related_occurrence_source,
    'flowers' AS related_organism_part,
    NULL AS feedback_url
FROM observations a
JOIN temp_ids b ON a.uuid=b.event_id
WHERE "field:interaction->visited flower of" IS NOT NULL
AND related_occurrence_id_3 IS NOT NULL
AND quality_grade = 'research'
AND related_occurrence_id_3 IN
(SELECT occurrence_id FROM temp_ids)
);
-- n = 0
-- total = 93

-- Fill the OrganismInteractionMedia table
INSERT INTO organism_interaction_media (
  media_id,
  organism_interaction_id,
  subject_category,
  subject_category_iri,
  subject_category_source,
  subject_part_literal,
  subject_part,
  subject_orientation_literal,
  subject_orientation,
  physical_setting
)
(SELECT
  a.media_id AS media_id,
  b.organism_interaction_id AS organism_interaction_id,
  'organism interaction' AS subject_category,
  NULL AS subject_category_iri,
  NULL AS subject_category_source,
  NULL AS subject_part_literal,
  NULL AS subject_part,
  NULL AS subject_orientation_literal,
  NULL AS subject_orientation,
  NULL AS physical_setting
FROM temp_ids a
JOIN organism_interaction b ON a.event_id=b.event_id
);
-- n = 93

-- Make Identifications
INSERT INTO identification (
  identification_id,
  material_entity_id,
  media_id,
  nucleotide_analysis_id,
  nucleotide_sequence_id,
  occurrence_id,
  organism_id,
  verbatim_identification,
  is_accepted_identification,
  taxon_formula,
  type_status,
  type_designation_type,
  identified_by,
  identified_by_id,
  date_identified,
  identification_references,
  taxon_assignment_method,
  identification_verification_status,
  identification_remarks,
  taxon_id,
  scientific_name_id,
  geo_classification_code,
  geo_name,
  scientific_name,
  scientific_name_authorship,
  vernacular_name,
  taxon_rank,
  external_classification_source,
  kingdom,
  phylum,
  "class",
  "order",
  family,
  subfamily,
  genus,
  generic_name,
  subgenus,
  infrageneric_epithet,
  specific_epithet,
  infraspecific_epithet,
  cultivar_epithet,
  name_according_to,
  nomenclatural_code,
  nomenclatural_status,
  name_published_in,
  name_published_in_year,
  taxon_remarks,
  feedback_url
)
(SELECT
  gen_random_uuid() AS identification_id,
  NULL AS material_entity_id,
  a.media_id AS media_id,
  NULL AS nucleotide_analysis_id,
  NULL AS nucleotide_sequence_id,
  NULL AS occurrence_id,
  NULL AS organism_id,
  species_guess AS verbatim_identification,
  'TRUE' AS is_accepted_identification,
  'A' AS taxon_formula,
  NULL AS type_status,
  NULL AS type_designation_type,
  user_name AS identified_by,
  user_id AS identified_by_id,
  created_at AS date_identified,
  NULL AS identification_references,
  NULL AS taxon_assignment_method,
  NULL AS identification_verification_status,
  NULL AS identification_remarks,
  NULL AS taxon_id,
  NULL AS scientific_name_id,
  NULL AS geo_classification_code,
  NULL AS geo_name,
  scientific_name AS scientific_name,
  NULL AS scientific_name_authorship,
  common_name AS vernacular_name,
  NULL AS taxon_rank,
  NULL AS external_classification_source,
  taxon_kingdom_name AS kingdom,
  taxon_phylum_name AS phylum,
  taxon_class_name AS "class",
  taxon_order_name AS "order",
  taxon_family_name AS family,
  taxon_subfamily_name AS subfamily,
  taxon_genus_name AS genus,
  taxon_genus_name AS generic_name,
  NULL AS subgenus,
  NULL AS infrageneric_epithet,
  NULL AS specific_epithet,
  NULL AS infraspecific_epithet,
  NULL AS cultivar_epithet,
  NULL AS name_according_to,
  NULL AS nomenclatural_code,
  NULL AS nomenclatural_status,
  NULL AS name_published_in,
  NULL AS name_published_in_year,
  NULL AS taxon_remarks,
  NULL AS feedback_url
FROM temp_ids a
JOIN observations b ON a.event_id=b.uuid
WHERE quality_grade = 'research'
);
-- n = 916