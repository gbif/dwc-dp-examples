BEGIN;
SET CONSTRAINTS ALL DEFERRED;

\copy public.input_occurrence FROM './input_data/occurrence.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, NULL '');
\copy public.input_dna_derived_data FROM './input_data/dnaderiveddata.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, NULL '');

COMMIT;
