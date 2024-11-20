#!/bin/bash

# Define variables
AUTH_TOKEN=$(gcloud auth print-access-token)
PROJECT_ID="ct-foundation-testing"
LOCATION="us-central1"
DATASET_ID="my-dataset"
DICOM_STORE_ID="my-dicom-store"
FOLDER_PATH="data/dicom/healthy/BDMAP_00000002"  # Update this to the actual folder path

# Iterate over all .dcm files in the folder
for file in "$FOLDER_PATH"/*.dcm; do
    echo "Uploading $file to DICOM store..."
    
    # Perform the curl upload
    curl -X POST \
        -H "Authorization: Bearer $AUTH_TOKEN" \
        -H "Content-Type: application/dicom" \
        --data-binary @"$file" \
        "https://healthcare.googleapis.com/v1/projects/$PROJECT_ID/locations/$LOCATION/datasets/$DATASET_ID/dicomStores/$DICOM_STORE_ID/dicomWeb/studies"
    
    # Check if the upload was successful
    if [ $? -eq 0 ]; then
        echo "$file uploaded successfully."
    else
        echo "Error uploading $file. Skipping..."
    fi
done

echo "All files processed."