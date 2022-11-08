#!/bin/bash 

#
# Simple script to initialise your the sic_code database from all the source datafiles (csv) file
#
# Use the scripts export_mongo_collections.sh to create files once you have checked the database 
#
# The datafiles have fields in the first line
#
  
set -o errexit # abort on non zero exit status
set -o pipefail  # don't hide errors within pipes


if [[ -z "${SIC_CODE_API_DATABASE}" ]]; then
    echo "ERROR: SIC_CODE_API_DATABASE environmental variable NOT set"
    exit 1
fi

if [[ -z "${SIC_CODE_API_MONGO_URL}" ]]; then
    echo "ERROR: SIC_CODE_API_MONGO_URL environmental variable NOT set"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export SCRIPT_DIR

# shellcheck source=/dev/null
source "${SCRIPT_DIR}"/common_functions.sh


import_csv condensed_sic_codes.csv condensed_sic_codes 

import_csv ons_economic_activities_alphabetic_index.csv ons_economic_activity_sic_codes

import_csv ch_created_activity_sic_codes.csv ch_economic_activity_sic_codes 


run_mongo_javascript  create_ons_combined_sic_activites.js

run_mongo_javascript  create_combined_sic_activites.js


echo "Finished OK"
