# nsul-loader

Tooling to help load address and local authority district tables from the [ONS National Statistics UPRN Lookup](https://www.ons.gov.uk/methodology/geography/geographicalproducts/nationalstatisticsaddressproducts) (NSUL) dataset into BigQuery.

## 1. Downloading the data to Google Cloud Storage

The file is about 400MB compressed but 12.5GB decompressed.
You can use Cloud Build to download the data from ONS and upload it to GCS on GCP.
No local download required!

```
gcloud builds submit --no-source --config download_to_gcs.yaml \
    --substitutions=_NSUL_URL="$NSUL_URL",_BUCKET_NAME="$BUCKET_NAME",_PUBLICATION_DATE="$PUBLICATION_DATE"
```

Parameters:

* `NSUL_URL`: URL to file. For example, in the [January 2022 edition](https://geoportal.statistics.gov.uk/datasets/national-statistics-uprn-lookup-january-2022/about), the URL is `https://www.arcgis.com/sharing/rest/content/items/fc5902488a044b58a4e7b1444f6e2d05/data`.
* `BUCKET_NAME`: name of the datasets bucket. See the output of the latest `terraform apply` in the [`infrastructure`](https://github.com/centrefornetzero/infrastructure) repo.
* `PUBLICATION_DATE`: in `YYYY-MM-DD` format, e.g. `2022-01-21` for the January 2022 edition.

## 2. Uploading to BigQuery

Before uploading:

1. Update schemas for any changes to column names.
2. Update filenames in `bq_upload.sh`.

Then to upload:

```
BUCKET_PATH="gs://..." EDITION_YEAR_MONTH="YYYY-MM" ./bq_upload.sh
```

Parameters:
* `BUCKET_PATH`: path to the decompressed files on GCS (no trailing slash).
* `EDITION_YEAR_MONTH`: edition of NSUL, e.g. `2022-01` for January 2022.
