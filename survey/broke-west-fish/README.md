# Broke West Fish test dataset for the DwC-DP publishing model

This is dataset is an example of a biotic survey with target organism scopes.

Originally mapped data were shared via https://github.com/biodiversity-aq/broke-west-fish-dwc-dp/tree/main/data/output/tsv. A copy of those data was made in the [input data folder](./input_data) for testing against the [database schema](https://github.com/gbif/model-dwc-dp/blob/master/gbif/dwc_dp_schema.sql).

Do the following to test the integrity of the Darwin Core Data Package directly against the [database schema](../../gbif/dwc_dp_schema.sql):

## Create a postgreSQL database to hold the input data and the output data mapped to the DwC-DP publishing model:
```cd survey/broke-west-fish```

(First time) ```createdb bw && psql bw -f ../../gbif/dwc_dp_schema.sql && psql bw -f ./schema_input_broke_west.sql```

(Subsequent times) ```dropdb bw && createdb bw && psql bw -f ../../gbif/dwc_dp_schema.sql && psql bw -f ./schema_input_broke_west.sql```

## Load the input data into the input tables in the database:
```psql bw -f load_input_broke_west.sql```

## Run the script to produce the publishing model tables within the same database:
```psql bw -f map_broke_west_input.sql```

## Run the script to export the publishing model tables as TSV files:
```psql bw -f export_broke_west_tsvs.sql```

