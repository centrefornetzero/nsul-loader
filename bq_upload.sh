#!/bin/bash

if [ -z "$BUCKET_PATH" ]; then
    echo "BUCKET_PATH must be set to GCS path to decompressed data."
    echo "e.g. gs://bucket-name/nsul/decompressed/2021-01-01"
    exit 1
fi;

if [ -z "$EDITION_YEAR_MONTH" ]; then
    echo "EDITION_YEAR_MONTH must be set to YYYY-MM of NSUL edition."
    exit 1
fi;

set -eu

LOCATION="EU"
DATASET="nsul"

bq --location "$LOCATION" --project_id "$PROJECT_ID" load \
    --source_format=CSV --skip_leading_rows=1 \
    "${DATASET}.src_${EDITION_YEAR_MONTH}_addresses" \
    "$BUCKET_PATH/Data/*.csv" \
    schemas/addresses.json

bq --location "$LOCATION" --project_id "$PROJECT_ID" load \
    --source_format=CSV --skip_leading_rows=1 \
    "${DATASET}.src_${EDITION_YEAR_MONTH}_local_authority_districts" \
    "$BUCKET_PATH/Documents/LAD names and codes UK as at 12_20.csv" \
    schemas/local_authority_districts.json
