-- Export the output table to TSV files
-- Table Checklist (from https://gbif.github.io/dwc-dp/data-mapping-guide/)
-- +4. Media
-- +5. Provenance
-- +5.1 MediaProvenance
-- +6. UsagePolicy
-- +6.1 MediaUsagePolicy
-- +9. Event
-- +9.4 EventMedia
-- +9.10 Occurrence
-- +9.10.1 OccurrenceAssertion
-- +9.10.4 OccurrenceMedia
-- +9.10.7 OrganismInteraction
-- +9.10.7.3 OrganismInteractionMedia
-- +14. Identification

\COPY agent TO './output_data/agent.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY media TO './output_data/media.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY provenance TO './output_data/provenance.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY media_provenance TO './output_data/media_provenance.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY usage_policy TO './output_data/usage_policy.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY media_usage_policy TO './output_data/media_usage_policy.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY event TO './output_data/event.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY event_media TO './output_data/event-media.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY occurrence TO './output_data/occurrence.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY occurrence_assertion TO './output_data/occurrence-assertion.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY occurrence_media TO './output_data/occurrence-media.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY organism_interaction TO './output_data/organism-interaction.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY organism_interaction_media TO './output_data/organism-interaction-media.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY ( SELECT identification_id, material_entity_id, media_id, nucleotide_analysis_id, nucleotide_sequence_id, occurrence_id, organism_id, verbatim_identification, CASE WHEN is_accepted_identification THEN 'true' ELSE 'false' END AS is_accepted_identification, taxon_formula, type_status, type_designation_type, identified_by, identified_by_id, date_identified, identification_references, taxon_assignment_method, identification_verification_status, identification_remarks, taxon_id, scientific_name_id, geo_classification_code, geo_name, scientific_name, scientific_name_authorship, vernacular_name, taxon_rank, external_classification_source, kingdom, phylum, "class", "order", family, subfamily, genus, generic_name, subgenus, infrageneric_epithet, specific_epithet, infraspecific_epithet, cultivar_epithet, name_according_to, nomenclatural_code, nomenclatural_status, name_published_in, name_published_in_year, taxon_remarks, feedback_url FROM identification ) TO './output_data/identification.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);