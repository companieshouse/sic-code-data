# The total refresh of the SIC Code Mongo database

## Summary

For the initial release a set of Mongo DB import files will be created for each Mongo Collection and stored in the GitHub repository.

The following collections will be sourced from `csv` files (in the `src/source_datafiles` directory):

- `condensed_sic_codes` from src/source_datafiles/condensed_sic_codes.csv,
- `ons_economic_activity_sic_codes` from src/source_datafiles/ons_economic_activities_alphabetic_index.csv,
- `ch_economic_activity_sic_codes` from src/source_datafiles/ch_created_activity_sic_codes.csv.

The collection `ons_combined_sic_activities`, is created by merging the the `condensed_sic_codes` and `ons_economic_activity_sic_codes`collections via a mongo script (it also removes any bracket characters that caused misses in the search match). This collection is created so that we can just update the `src/source_datafiles/ch_created_activity_sic_codes.csv file`.

The collection, `combined_sic_activities`, is created by merging by merging the `ons_combined_sic_activities` and the `ch_economic_activity_sic_codes` collections via a mongo script (it also removes any bracket characters that caused misses in the search match). This collection is used for the full-text Mongo search as describe in the `sic-code-api` docs.  This collection will then be imported in each test environment via a manually triggered concourse job. For staging and live this will be deployed via a CHS release note.

## Diagram

![Total Refresh SIC Code Diagram](sic-code-db-total-refresh.png)

## Import the standard `sic-code` import files and transform

First set the following [environmental variables](environmental-variables.md).

``` bash
src/scripts/total_refresh_sic_code_database.sh
# Check the sic_code database
src/scripts/export_mongo_collections.sh
```

## Configuration Manage the Mongo Collection export files

These files are in `src/import_files` and need to be stored in this projects GitHub repository.
