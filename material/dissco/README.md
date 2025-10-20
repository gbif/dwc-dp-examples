# DiSSCo test dataset for the DwC-DP publishing model

This dataset has been automatically generated from the DiSSCo test dataset, which is available at https://dev.dissco.tech/ (the DiSSCo test environment).
DiSSCo created classes based on the Darwin Core Data Package (DwC-DP) model.
We collect data from our own environment, parse it to DwC-DP classes and deduplicate it.
We then export the classes to zipped csv-files and store the result.
For any new identifiers we use the MD-5 hash of the class.

The generation of DwC-DP files for DiSSCo data will become available in DiSSCover in the future.
DiSSCo will also implement a DwC-DP download for all datasets provided to DiSSCo.

For any question, please contact Sam Leeflang (sam.leeflang@naturalis.nl)

Scripts for integrity testing use the data provided by DISSCo in the output_data folder.

The process to test the dataset integrity for the DwC-DP publishing model is as follows:

## Create a postgreSQL database to hold the input data and the output data mapped to the DwC-DP publishing model:
```cd material/dissco```

(First time) ```createdb dissco && psql dissco -f ../../gbif/dwc_dp_schema.sql && psql dissco -f ./schema_input_dissco.sql```

(Subsequent times) ```dropdb dissco && createdb dissco && psql dissco -f ../../gbif/dwc_dp_schema.sql && psql dissco -f ./schema_input_dissco.sql```

## Load the input data into the input tables in the database:
```psql dissco -f load_input_dissco.sql```

## Run the script to produce the publishing model tables within the same database:
```psql dissco -f map_dissco_input.sql```

