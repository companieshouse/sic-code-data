#!/bin/bash 

#
# Simple script to upddte the sic_code database from with a new Companies house Economic Activities (csv) file.
#
# Before running this script on a local database, you need to import the latest import files
#
# Use partial_refresh_sic_code_database.sh to create files once you have checked them
#
# The source datafiles have fields in the first line
#
  
set -o errexit # abort on nonzero exitstatus
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

import_csv ch_created_activity_sic_codes.csv ch_economic_activity_sic_codes 

run_mongo_javascript  create_combined_sic_activites.js


echo "Finished OK"
