-- Foreign key checking deferred due to circular dependencies

BEGIN;
SET CONSTRAINTS ALL DEFERRED;

\copy public.input_agent_agent_role FROM './input_data/agent-agent-role.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_agent_identifier FROM './input_data/agent-identifier.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_agent FROM './input_data/agent.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_bibliographic_resource FROM './input_data/bibliographic-resource.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_event FROM './input_data/event.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_event_assertion FROM './input_data/event-assertion.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_event_provenance FROM './input_data/event-provenance.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_identification FROM './input_data/identification.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_material FROM './input_data/material.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_material_assertion FROM './input_data/material-assertion.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_material_media FROM './input_data/material-media.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_material_provenance FROM './input_data/material-provenance.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_media FROM './input_data/media.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_media_provenance FROM './input_data/media-provenance.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_media_usage_policy FROM './input_data/media-usage-policy.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_occurrence FROM './input_data/occurrence.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_protocol FROM './input_data/protocol.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_protocol_reference FROM './input_data/protocol-reference.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_provenance FROM './input_data/provenance.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_survey FROM './input_data/survey.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_survey_target FROM './input_data/survey-target.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
\copy public.input_usage_policy FROM './input_data/usage-policy.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');

COMMIT;
