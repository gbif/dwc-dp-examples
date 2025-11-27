# BGBM test dataset for the DwC-DP publishing model

This is dataset is an example of a herbarium collection with media and genetic sequences.

Original data were shared via https://dwcdp-ipt.gbif-test.org/manage/resource?r=herbar_bgbm. The latest mapping uses the original files that were uploaded for version 12 of that dataset. These were copied into the [input data folder](../input_data) before processing, but are not kept in this repository (they are large).

The process to create the output dataset for the DwC-DP publishing model is as follows:

## Create a postgreSQL database to hold the input data and the output data mapped to the DwC-DP publishing model:
```cd material/bgbm```

(First time) ```createdb bgbm && psql bgbm -f ../../gbif/dwc_dp_schema.sql && psql bgbm -f ./schema_input_bgbm.sql```

(Subsequent times) ```dropdb bgbm && createdb bgbm && psql bgbm -f ../../gbif/dwc_dp_schema.sql && psql bgbm -f ./schema_input_bgbm.sql```

## Load the input data into the input tables in the database:
```psql bgbm -f load_input_bgbm.sql```

## Run the script to produce the publishing model tables within the same database:
```psql bgbm -f map_bgbm_input.sql```

## Run the script to export the publishing model tables as TSV files:
```psql bgbm -f export_bgbm_tsvs.sql```

The Darwin Core Data Package from the IPT was also copied and can be found in the [data package download folder](../input/datapackage-download).

Do the following to test the integrity of the IPT-produced Darwin Core Data Package directly against the [database schema](../../gbif/dwc_dp_schema.sql):

## Create a postgreSQL database to hold the DwC-DP data and the output data mapped to the DwC-DP publishing model:
```cd material/bgbm```

(First time) ```createdb bgbm && psql bgbm -f ../../gbif/dwc_dp_schema.sql```

(Subsequent times) ```dropdb bgbm && createdb bgbm && psql bgbm -f ../../gbif/dwc_dp_schema.sql```

## Load the DwC-DP data directly into the tables in the database:
```psql bgbm -f load_dwc-dp_bgbm.sql```
