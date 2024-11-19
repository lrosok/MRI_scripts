#!/bin/bash

# Merge all zstat3.nii.gz files from each subdirectory (representing a specific subject or session) along the 4th dimension (time)
fslmerge -t allZ3stats.nii.gz `find . -type f -path "*/stats/zstat3.nii.gz" | sort -V`

# Create a single-voxel mask at the specified coordinates (-6, 62, 22) in MNI space
# The coordinates 36 78 40 correspond to the voxel coordinates in the resampled atlas image
fslmaths space-MNI152NLin2009cAsym_atlas-4S156Parcels_dseg_resampled.nii.gz -mul 0 -add 1 \
  -roi 36 1 78 1 40 1 0 1 Laura_ROI_rmPFC_-6_62_22_sphere.nii.gz -odt float

# Create a spherical region of interest (ROI) with a radius of 5 mm around the single-voxel mask
fslmaths Laura_ROI_rmPFC_-6_62_22_sphere.nii.gz -kernel sphere 5 -fmean Laura_rmPFC_-6_62_22_sphere.nii.gz -odt float

# Binarize the spherical ROI to create a mask for extraction
fslmaths Laura_rmPFC_-6_62_22_sphere.nii.gz -bin Laura_bin_rmPFC_-6_62_22_sphere.nii.gz

# Extract the mean time series from the input 4D fMRI data within the specified mask
fslmeants -i allZ3stats.nii.gz -m Laura_bin_rmPFC_-6_62_22_sphere.nii.gz
