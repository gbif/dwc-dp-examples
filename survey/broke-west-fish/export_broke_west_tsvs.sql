-- Export the output table to TSV files
\COPY agent TO './output_data/agent.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY agent_agent_role TO './output_data/agent_agent_role.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY agent_identifier TO './output_data/agent_identifier.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY bibliographic_resource TO './output_data/bibliographic_resource.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY event TO './output_data/event.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY event_assertion TO './output_data/event_assertion.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY event_provenance TO './output_data/event_provenance.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY identification TO './output_data/identification.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY material TO './output_data/material.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY material_assertion TO './output_data/material_assertion.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY material_media TO './output_data/material_media.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY material_provenance TO './output_data/material_provenance.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY media TO './output_data/media.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY media_provenance TO './output_data/media_provenance.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY media_usage_policy TO './output_data/media_usage_policy.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY occurrence TO './output_data/occurrence.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY protocol TO './output_data/protocol.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY protocol_reference TO './output_data/protocol_reference.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY provenance TO './output_data/provenance.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
--\COPY survey TO './output_data/survey.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);
\COPY ( SELECT survey_id, event_id, site_count, site_nesting_description, verbatim_site_descriptions, verbatim_site_names, geospatial_scope_area_value, geospatial_scope_area_unit, total_area_sampled_value, total_area_sampled_unit, reported_extreme_conditions, reported_weather, event_duration_value, event_duration_unit, taxon_completeness_reported, taxon_completeness_protocols, (CASE WHEN is_absence_reported THEN 'true' ELSE 'false' END) AS is_absence_reported, absent_taxa, (CASE WHEN has_non_target_taxa THEN 'true' ELSE 'false' END) AS has_non_target_taxa, non_target_taxa, (CASE WHEN are_non_target_taxa_fully_reported THEN 'true' ELSE 'false' END) AS are_non_target_taxa_fully_reported, (CASE WHEN has_non_target_organisms THEN 'true' ELSE 'false' END) AS has_non_target_organisms, verbatim_target_scope, identified_by, identified_by_id, identification_references, compilation_types, compilation_source_types, inventory_types, protocol_names, protocol_descriptions, protocol_references, (CASE WHEN is_abundance_reported THEN 'true' ELSE 'false' END) AS is_abundance_reported, (CASE WHEN is_abundance_cap_reported THEN 'true' ELSE 'false' END) AS is_abundance_cap_reported, abundance_cap, (CASE WHEN is_vegetation_cover_reported THEN 'true' ELSE 'false' END) AS is_vegetation_cover_reported, (CASE WHEN is_least_specific_target_category_quantity_inclusive THEN 'true' ELSE 'false' END) AS is_least_specific_target_category_quantity_inclusive, (CASE WHEN has_vouchers THEN 'true' ELSE 'false' END) AS has_vouchers, voucher_institutions, (CASE WHEN has_material_samples THEN 'true' ELSE 'false' END) AS has_material_samples, material_sample_types, sample_size_value, sample_size_unit, sampling_performed_by, sampling_performed_by_id, (CASE WHEN is_sampling_effort_reported THEN 'true' ELSE 'false' END) AS is_sampling_effort_reported, sampling_effort_protocol, sampling_effort_protocol_id, sampling_effort_value, sampling_effort_unit, information_withheld, data_generalizations, feedback_url FROM survey) TO './output_data/survey.tsv' WITH DELIMITER E'\t' NULL '' HEADER;
\COPY ( SELECT survey_target_id, survey_id, survey_target_type, survey_target_type_iri, survey_target_type_source, survey_target_value, survey_target_value_iri, survey_target_value_source, survey_target_unit, survey_target_unit_iri, survey_target_unit_source, include_or_exclude, (CASE WHEN is_survey_target_fully_reported THEN 'true' ELSE 'false' END) AS is_survey_target_fully_reported FROM survey_target) TO './output_data/survey_target.tsv' WITH DELIMITER E'\t' NULL '' HEADER;
\COPY usage_policy TO './output_data/usage_policy.tsv' WITH (FORMAT TEXT, DELIMITER E'\t', NULL '', HEADER);

