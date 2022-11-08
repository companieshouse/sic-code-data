#!/bin/bash

#
# Simple script to export the sic_code collections updated after a partial refresh
#

set -o errexit  # abort on nonzero exitstatus
set -o pipefail # don't hide errors within pipes

if [[ -z "${SIC_CODE_API_DATABASE}" ]]; then
    echo "ERROR: SIC_CODE_API_DATABASE environmental variable NOT set"
    exit 1
fi

if [[ -z "${SIC_CODE_API_MONGO_URL}" ]]; then
    echo "ERROR: SIC_CODE_API_MONGO_URL environmental variable NOT set"
    exit 1
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
export SCRIPT_DIR

# shellcheck source=/dev/null
source "${SCRIPT_DIR}"/common_functions.sh

export_collection ch_economic_activity_sic_codes
export_collection combined_sic_activities

echo "Finished OK"
