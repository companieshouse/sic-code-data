# sic-code-data

## Summary

This repository contain the all files used to create the `combined_sic_activities` Mongo collection that the `sic-code-api` uses. When this collection is updated then it is released into the Mongo database so that the `sic-code-api` uses the latest data. It also has export and import utility scripts to support this work.

The SIC Code data is quite small and rarely changes so it is ideal to place all the files required to build the `combined_sic_activities` Mongo collection configuration management

## file types

### source data (CSV)

These files are stored in the `src/source_datafiles` path.

- `condensed_sic_codes.csv`: this is a list of SIC Codes with descriptions and the CSV file is available from [Standard industrial classification of economic activities]((https://www.gov.uk/government/publications/standard-industrial-classification-of-economic-activities-sic)). This contains 731 SIC codes. This external file was adjusted to add a header record to enable the data load.

- `ons_economic_activities_alphabetic_index.csv` - this is the ONS Economic Activity SIC codes formatted as an alphabetic index; this list adds economic activities for each SIC Code which enables a better search for SIC Codes. This list was last created in 2007 and the CSV file contains 15955 SIC related economic activities. Note that after 2007 there has been a few updates for high profile events such as new economic activities related to COVID-19. This spreadsheet is available from [Indexes with addendum (November 2020)](https://www.ons.gov.uk/file?uri=/methodology/classificationsandstandards/ukstandardindustrialclassificationofeconomicactivities/uksic2007/uksic2007indexeswithaddendumnovember2020.xlsx). This external file was adjusted to add a header record to enable the data load.

- `ch_created_activity_sic_codes.csv`. This is a new list supplied by Companies House business teams who create this from user queries where Companies House staff have to find the appropriate economic activity for an activity that was not on the 2007 ONS list (e.g. Amazon Seller, YouTuber). This file was provided to the business with a header record since it is more often updated than other files.

### Build scripts

These files are stored in the `src/scripts` path.

The Scripts that are used to create the `combined_sic_activities` Mongo collection from the source CSV files (and the intermediate collections). These scripts are just run in the development environment using the following [environmental variables](docs/environmental-variables.md).

### Mongo import files

These files are stored in the TODO path.

These are created by the build scripts but only the `combined_sic_activities` Mongo collection is imported into the AWS environments

## Build types

There will be two types of data refresh builds (both run in the Docker CHS Development environment):

- Total Refresh of the SIC Code Database. The  `combined_sic_activities` Mongo collection is recreated from all CSV files and this is done both for the initial deployment and also when either the `condensed_sic_codes.csv` or / and `ons_economic_activities_alphabetic_index.csv` files change. From history, this is likely to be required every five years. More details in [Total refresh page](docs/total_refresh_sic_code_database.md)

- Partial Update of just the CH Economic  (TODO - reference sub page with diagram). The  `combined_sic_activities` Mongo collection is recreated from just the changes from the `ch_created_activity_sic_codes.csv`. This will probably happen six times after the initial release (from user feedback) and then less frequently after that.
