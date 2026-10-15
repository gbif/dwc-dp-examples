-- Staging tables (DwC-A Occurrence + DNADerivedData)

CREATE TABLE input_occurrence (
  occurrenceID TEXT PRIMARY KEY,
  eventID TEXT,
  basisOfRecord TEXT,
  taxonID TEXT,
  kingdom TEXT,
  phylum TEXT,
  class TEXT,
  "order" TEXT,
  family TEXT,
  genus TEXT,
  species TEXT,
  identificationRemarks TEXT,
  organismQuantity TEXT,
  organismQuantityType TEXT,
  sample_id TEXT,
  associatedSequences TEXT,
  control TEXT,
  coordinateUncertainty TEXT,
  date_time TEXT,
  decimalLatitude TEXT,
  decimalLongitude TEXT,
  fieldNumber TEXT,
  higherGeography TEXT,
  locality TEXT,
  occurrenceRemarks TEXT,
  occurrenceStatus TEXT,
  projectTitle TEXT,
  recordedBy TEXT,
  replicate TEXT,
  sampleSizeUnit TEXT,
  sampleSizeValue TEXT,
  scientificName TEXT,
  scientificNameID TEXT,
  taxonRank TEXT
);
CREATE INDEX ON input_occurrence(sample_id);
CREATE INDEX ON input_occurrence(eventID);

CREATE TABLE input_dna_derived_data (
  occurrenceID TEXT PRIMARY KEY REFERENCES input_occurrence(occurrenceID),
  DNA_sequence TEXT,
  lib_layout TEXT,
  seq_meth TEXT,
  samp_name TEXT,
  samp_size TEXT,
  target_gene TEXT,
  ref_db TEXT,
  tax_class TEXT,
  pcr_primer_forward TEXT,
  pcr_primer_reverse TEXT,
  pcr_primer_reference TEXT,
  env_medium TEXT
);
CREATE INDEX ON input_dna_derived_data(DNA_sequence);
CREATE INDEX ON input_dna_derived_data(target_gene);
