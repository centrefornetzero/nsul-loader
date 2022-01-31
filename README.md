# nsul-loader

Load address and local authority district tables from the [ONS National Statistics UPRN Lookup](https://www.ons.gov.uk/methodology/geography/geographicalproducts/nationalstatisticsaddressproducts) (NSUL) dataset into BigQuery.

## 1. Downloading the data to Google Cloud Storage

The file is about 400MB compressed but 12.5GB decompressed.
You can use Cloud Build to download the data from ONS and upload it to GCS on GCP.
No local download required!

```
gcloud builds submit --no-source --config download_to_gcs.yaml \
    --substitutions=_NSUL_URL="$NSUL_URL",_BUCKET_NAME="$BUCKET_NAME",_PUBLICATION_DATE="$PUBLICATION_DATE"
```

Parameters:

* `NSUL_URL`: URL to file. For example, in the [November 2021 edition](https://geoportal.statistics.gov.uk/datasets/national-statistics-uprn-lookup-november-2021/about), the URL is `https://www.arcgis.com/sharing/rest/content/items/c9405798d9fa41fcb52e07cb79b431d5/data`.
* `BUCKET_NAME`: name of the datasets bucket. See the output of the latest `terraform apply` in the [`infrastructure`](https://github.com/centrefornetzero/infrastructure) repo.
* `PUBLICATION_DATE`: in `YYYY-MM-DD` format, e.g. `2021-11-01` for the November 2021 edition.

## 2. Uploading to BigQuery

```
BUCKET_PATH="gs://..." EDITION_YEAR_MONTH="YYYY-MM" ./bq_upload.sh
```

Parameters:
* `BUCKET_PATH`: path to the decompressed files on GCS.
* `EDITION_YEAR_MONTH`: edition of NSUL, e.g. `2021-11` for November 2021.
