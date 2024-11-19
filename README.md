# MRI Scripts

This repository contains scripts for processing and analyzing **MRI** data, focusing on **DTI** and **fMRI** analysis. The scripts are designed to extract brain imaging features such as **Mean Diffusivity (MD)** and **Fractional Anisotropy (FA)** for **DTI**, and **ROI activation** for **task-based fMRI**.

## Setup and Dependencies

Ensure you have the necessary software for processing DTI and fMRI data, including:
- **FSL** (for TBSS and fMRI processing)
- **Python** (for any auxiliary processing)
- Additional **MRI toolboxes** as required

## DTI Analysis

1. Place your **DTI data** in the appropriate directory.
2. Run the `extract_task_ROI_activation.sh` script in the **DTI** folder to extract the **Mean Diffusivity (MD)** and **Fractional Anisotropy (FA)** values for the regions specified:
   - **Uncinate Fasciculus**
   - **Cingulum**
   
   These regions can be updated to match your specific areas of interest by modifying the script.

## fMRI ROI Extraction

1. Place your **task-based fMRI data** in the appropriate directory.
2. Run the script in the **fMRI** folder to extract activation data from the designated **Regions of Interest (ROIs)**.

## Notes

- **DTI Analysis**:  
  The current script is set to extract **MD** and **FA** values from the **Uncinate Fasciculus** and **Cingulum**. Users can modify the regions of interest (ROIs) as necessary by editing the script.

- **Atlas Files**:  
  The atlas files:
  - **JHU-ICBM-labels-2mm.nii.gz**
  - **MNI152_T1_2mm.nii.gz**
  
  These are required for alignment and ROI extraction. Ensure that these files are in the correct format and resolution for your data.

- **fMRI Analysis**:  
  The script in the **fMRI** folder is designed for **task-based fMRI analysis**. Modifications may be required for different tasks or research goals.

## Contributing

Feel free to fork this repository, make modifications, and submit pull requests. Contributions are welcome!

## License

This repository is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


