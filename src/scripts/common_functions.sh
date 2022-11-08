#!/bin/bash 

# Functions used by more than one script 
# The calling scripts must provide SCRIPT_DIR as an environmental variable

import_csv() {
    local csv_filename=$1
    local mongo_collection=$2

    local csv_file_full_path=${SCRIPT_DIR}/../source_datafiles/${csv_filename}
    if [[ ! -f "${csv_file_full_path}" ]]; then  
        echo "CSV Input file ${csv_file_full_path} is not found, exiting script"
        exit 1
    fi 

    echo "Importing the CSV to Collection ${mongo_collection} with drop option used"
    mongoimport --uri="${SIC_CODE_API_MONGO_URL}" --db "${SIC_CODE_API_DATABASE}" --collection "${mongo_collection}" --file "${csv_file_full_path}" --drop --type=csv --headerline --columnsHaveTypes
}

run_mongo_javascript() {
    local javascript_file=$1
    local javascript_file_full_path=${SCRIPT_DIR}/${javascript_file}

    if [[ ! -f "${javascript_file_full_path}" ]]; then  
        echo "JavaScript file ${javascript_file_full_path} is not found, exiting script"
        exit 1
    fi 

    echo "Changing ${SIC_CODE_API_DATABASE} database with script $javascript_file_full_path"
    mongo "${SIC_CODE_API_MONGO_URL}/${SIC_CODE_API_DATABASE}" "${javascript_file_full_path}"

}

export_collection() {
    local mongo_collection=$1
    local output_file=${SCRIPT_DIR}/../import_files/${mongo_collection}.json

    echo "Exporting collection ${mongo_collection} to json file ${output_file}"
    mongoexport --uri="${SIC_CODE_API_MONGO_URL}" --db "${SIC_CODE_API_DATABASE}" --collection "${mongo_collection}" --jsonArray --pretty --out="${output_file}"
}