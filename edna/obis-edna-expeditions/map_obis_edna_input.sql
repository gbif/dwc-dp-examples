BEGIN;
SET CONSTRAINTS ALL DEFERRED;

-- Events: one per sample
INSERT INTO event (
  event_id,
  event_category,
  event_type,
  dataset_name,
  field_number,
  event_conducted_by,
  event_date,
  habitat,
  event_remarks,
  higher_geography,
  locality,
  decimal_latitude,
  decimal_longitude,
  geodetic_datum,
  coordinate_uncertainty_in_meters
)
SELECT DISTINCT ON (o.sample_id)
  o.sample_id AS event_id,
  'material gathering' AS event_category,
  'sample' AS event_type,
  o.projectTitle AS dataset_name,
  o.eventID AS field_number,
  o.recordedBy AS event_conducted_by,
  o.date_time AS event_date,
  NULLIF(o.occurrenceRemarks, '') AS habitat,
  CASE
    WHEN NULLIF(o.replicate, '') IS NOT NULL THEN 'replicate: ' || o.replicate
    ELSE NULL
  END AS event_remarks,
  o.higherGeography AS higher_geography,
  o.locality AS locality,
  NULLIF(o.decimalLatitude, '')::NUMERIC AS decimal_latitude,
  NULLIF(o.decimalLongitude, '')::NUMERIC AS decimal_longitude,
  'EPSG:4326' AS geodetic_datum,
  NULLIF(o.coordinateUncertainty, '')::NUMERIC AS coordinate_uncertainty_in_meters
FROM input_occurrence o
ORDER BY o.sample_id, o.occurrenceID;

-- Material: one environmental sample per event
INSERT INTO material (
  material_entity_id,
  event_id,
  material_category,
  material_entity_type,
  collected_by,
  preparations
)
SELECT
  e.event_id AS material_entity_id,
  e.event_id AS event_id,
  'environmental DNA' AS material_category,
  'environmental DNA' AS material_entity_type,
  e.event_conducted_by AS collected_by,
  'filtered water sample' AS preparations
FROM event e;

-- Molecular protocols: one per distinct assay
INSERT INTO molecular_protocol (
  molecular_protocol_id,
  target_gene,
  pcr_primer_forward,
  pcr_primer_reverse,
  pcr_primer_reference,
  lib_layout,
  seq_meth,
  ref_db,
  tax_class,
  sop
)
SELECT DISTINCT ON (
  d.target_gene,
  d.pcr_primer_forward,
  d.pcr_primer_reverse,
  d.seq_meth,
  d.lib_layout,
  d.tax_class,
  d.ref_db,
  d.pcr_primer_reference
)
  md5(
    concat_ws('|',
      d.target_gene,
      d.pcr_primer_forward,
      d.pcr_primer_reverse,
      d.seq_meth,
      d.lib_layout,
      d.tax_class,
      d.ref_db,
      d.pcr_primer_reference
    )
  ) AS molecular_protocol_id,
  d.target_gene,
  d.pcr_primer_forward,
  d.pcr_primer_reverse,
  d.pcr_primer_reference,
  d.lib_layout,
  d.seq_meth,
  d.ref_db,
  d.tax_class,
  'https://github.com/iobis/edna-pipelines' AS sop
FROM input_dna_derived_data d
ORDER BY
  d.target_gene,
  d.pcr_primer_forward,
  d.pcr_primer_reverse,
  d.seq_meth,
  d.lib_layout,
  d.tax_class,
  d.ref_db,
  d.pcr_primer_reference,
  d.occurrenceID;

-- Nucleotide sequences: once per DNA_sequence
INSERT INTO nucleotide_sequence (
  nucleotide_sequence_id,
  nucleotide_sequence
)
SELECT DISTINCT ON (d.DNA_sequence)
  substring(d.occurrenceID FROM length(o.sample_id) + 2) AS nucleotide_sequence_id,
  d.DNA_sequence AS nucleotide_sequence
FROM input_dna_derived_data d
JOIN input_occurrence o ON o.occurrenceID = d.occurrenceID
ORDER BY d.DNA_sequence, d.occurrenceID;

-- Nucleotide analysis: sample x ASV sparse matrix (read counts)
INSERT INTO nucleotide_analysis (
  nucleotide_analysis_id,
  event_id,
  molecular_protocol_id,
  nucleotide_sequence_id,
  material_entity_id,
  read_count
)
SELECT
  o.occurrenceID AS nucleotide_analysis_id,
  o.sample_id AS event_id,
  md5(
    concat_ws('|',
      d.target_gene,
      d.pcr_primer_forward,
      d.pcr_primer_reverse,
      d.seq_meth,
      d.lib_layout,
      d.tax_class,
      d.ref_db,
      d.pcr_primer_reference
    )
  ) AS molecular_protocol_id,
  substring(d.occurrenceID FROM length(o.sample_id) + 2) AS nucleotide_sequence_id,
  o.sample_id AS material_entity_id,
  NULLIF(o.organismQuantity, '')::INTEGER AS read_count
FROM input_occurrence o
JOIN input_dna_derived_data d ON d.occurrenceID = o.occurrenceID;

-- Identification: one per sequence (taxonomy linked to nucleotide_sequence_id)
INSERT INTO identification (
  identification_id,
  nucleotide_sequence_id,
  is_accepted_identification,
  taxon_assignment_method,
  identification_remarks,
  taxon_id,
  scientific_name_id,
  scientific_name,
  taxon_rank,
  kingdom,
  phylum,
  "class",
  "order",
  family,
  genus
)
SELECT DISTINCT ON (ns.nucleotide_sequence_id)
  'id_' || ns.nucleotide_sequence_id AS identification_id,
  ns.nucleotide_sequence_id,
  TRUE AS is_accepted_identification,
  d.tax_class AS taxon_assignment_method,
  NULLIF(o.identificationRemarks, '') AS identification_remarks,
  NULLIF(o.taxonID, '') AS taxon_id,
  NULLIF(o.scientificNameID, '') AS scientific_name_id,
  NULLIF(o.scientificName, '') AS scientific_name,
  NULLIF(o.taxonRank, '') AS taxon_rank,
  NULLIF(o.kingdom, '') AS kingdom,
  NULLIF(o.phylum, '') AS phylum,
  NULLIF(o.class, '') AS "class",
  NULLIF(o."order", '') AS "order",
  NULLIF(o.family, '') AS family,
  NULLIF(o.genus, '') AS genus
FROM nucleotide_sequence ns
JOIN input_dna_derived_data d ON d.DNA_sequence = ns.nucleotide_sequence
JOIN input_occurrence o ON o.occurrenceID = d.occurrenceID
ORDER BY ns.nucleotide_sequence_id, o.occurrenceID;

-- Event assertions: sample size and replicate
INSERT INTO event_assertion (
  assertion_id,
  event_id,
  assertion_type,
  assertion_value_numeric,
  assertion_unit
)
SELECT DISTINCT ON (o.sample_id)
  o.sample_id || '_sampleSize' AS assertion_id,
  o.sample_id AS event_id,
  'sample size' AS assertion_type,
  NULLIF(o.sampleSizeValue, '')::NUMERIC AS assertion_value_numeric,
  NULLIF(o.sampleSizeUnit, '') AS assertion_unit
FROM input_occurrence o
WHERE NULLIF(o.sampleSizeValue, '') IS NOT NULL
ORDER BY o.sample_id, o.occurrenceID;

INSERT INTO event_assertion (
  assertion_id,
  event_id,
  assertion_type,
  assertion_value
)
SELECT DISTINCT ON (o.sample_id)
  o.sample_id || '_replicate' AS assertion_id,
  o.sample_id AS event_id,
  'replicate' AS assertion_type,
  o.replicate AS assertion_value
FROM input_occurrence o
WHERE NULLIF(o.replicate, '') IS NOT NULL
ORDER BY o.sample_id, o.occurrenceID;

INSERT INTO event_assertion (
  assertion_id,
  event_id,
  assertion_type,
  assertion_value
)
SELECT DISTINCT ON (o.sample_id)
  o.sample_id || '_env_medium' AS assertion_id,
  o.sample_id AS event_id,
  'env_medium' AS assertion_type,
  d.env_medium AS assertion_value
FROM input_occurrence o
JOIN input_dna_derived_data d ON d.occurrenceID = o.occurrenceID
WHERE NULLIF(d.env_medium, '') IS NOT NULL
ORDER BY o.sample_id, o.occurrenceID;

COMMIT;
