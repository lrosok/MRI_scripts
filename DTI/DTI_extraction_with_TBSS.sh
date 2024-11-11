#!/bin/bash

# Run this script on terminal by navigating to file directory and typing ./name_of_file.sh

# This script is an example of batch processing diffusion tensor imaging (DTI) data using FSL.
# To run this script, you need to have FSL installed on your system. 
# Make sure to update the paths to the relevant directories and files before running the script.
# This script assumes that fractional anisotropy (FA) and mean diffusivity (MD) images are already preprocessed and registered to the MNI space.
# The JHU Atlas is used to extract the Uncinate Fasciculus (Label 5) and Cingulum (Label 3) ROIs.
# The mean FA and MD values are extracted for these ROIs and saved to a CSV file.

# Directory where your DTI images are located
DTI_DIR="/Users/laurarosok/Desktop/LB_MR/DTI/"

# Path to the JHU Atlas (now located within the DTI directory)
JHU_ATLAS="${DTI_DIR}JHU-ICBM-labels-2mm.nii.gz"

# Output directory to save the results
OUTPUT_DIR="/Users/laurarosok/Desktop/LB_MR/DTI/output/"

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Create a CSV file to store the FA and MD values
CSV_FILE="${OUTPUT_DIR}/fa_md_values.csv"

# Add headers to the CSV file (if it doesn't exist already)
if [ ! -f "$CSV_FILE" ]; then
  echo "Subject_ID,FA_Uncinate,FA_Cingulum,MD_Uncinate,MD_Cingulum" > $CSV_FILE
fi

# Generate the list of subject IDs (113, 114, 115, ..., 176) without gaps
subject_ids=$(seq 113 176)

# Start processing subjects
for subject_id in $subject_ids
do
  # Create the subject's specific file paths
  fa_file="FA_TBSS/sub-LiBra${subject_id}_ses-A_run-1_space-T1w_desc-preproc_model-tensor_mdp-fa_dwimap.nii.gz"
  md_file="MD_TBSS/sub-LiBra${subject_id}_ses-A_run-1_space-T1w_desc-preproc_model-tensor_mdp-md_dwimap.nii.gz"

  # Check if the FA and MD files exist
  if [[ -f "$fa_file" && -f "$md_file" ]]; then
    echo "Processing Subject ${subject_id}..."

    # Register FA and MD to MNI space
    flirt -in $fa_file -ref MNI152_T1_2mm.nii.gz -out ${OUTPUT_DIR}/sub-LiBra${subject_id}_fa_mni.nii.gz -omat ${OUTPUT_DIR}/sub-LiBra${subject_id}_fa_to_mni.mat
    flirt -in $md_file -ref MNI152_T1_2mm.nii.gz -out ${OUTPUT_DIR}/sub-LiBra${subject_id}_md_mni.nii.gz -omat ${OUTPUT_DIR}/sub-LiBra${subject_id}_md_to_mni.mat

    # Extract Uncinate Fasciculus ROI (Label 5) and Cingulum ROI (Label 3) from JHU Atlas
    fslmaths ${JHU_ATLAS} -thr 5 -uthr 5 -bin ${OUTPUT_DIR}/sub-LiBra${subject_id}_uncinate_roi.nii.gz
    fslmaths ${JHU_ATLAS} -thr 3 -uthr 3 -bin ${OUTPUT_DIR}/sub-LiBra${subject_id}_cingulum_roi.nii.gz

    # Extract mean FA and MD values for both ROIs (Uncinate and Cingulum)
    fa_uncinate=$(fslstats ${OUTPUT_DIR}/sub-LiBra${subject_id}_fa_mni.nii.gz -k ${OUTPUT_DIR}/sub-LiBra${subject_id}_uncinate_roi.nii.gz -M)
    fa_cingulum=$(fslstats ${OUTPUT_DIR}/sub-LiBra${subject_id}_fa_mni.nii.gz -k ${OUTPUT_DIR}/sub-LiBra${subject_id}_cingulum_roi.nii.gz -M)
    md_uncinate=$(fslstats ${OUTPUT_DIR}/sub-LiBra${subject_id}_md_mni.nii.gz -k ${OUTPUT_DIR}/sub-LiBra${subject_id}_uncinate_roi.nii.gz -M)
    md_cingulum=$(fslstats ${OUTPUT_DIR}/sub-LiBra${subject_id}_md_mni.nii.gz -k ${OUTPUT_DIR}/sub-LiBra${subject_id}_cingulum_roi.nii.gz -M)

    # Write the values to the CSV file
    echo "${subject_id},${fa_uncinate},${fa_cingulum},${md_uncinate},${md_cingulum}" >> $CSV_FILE

    echo "Subject ${subject_id} processing complete."
  else
    echo "FA or MD file missing for Subject ${subject_id}. Skipping..."
    echo "${subject_id}" >> missing_subjects.txt
  fi
done

echo "Batch processing complete!"
