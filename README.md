# antisocial-bvFTD-paper

## *Create_composite_ROIs.m*

Create ROI-Specific Atlas from the HCPex (Glasser) Atlas: This script generates a new NIfTI atlas containing only user-selected regions from the HCPex (Glasser-based) atlas. Users specify ROI names (as listed in LabelID(:,4)), and the script automatically identifies the corresponding atlas labels, removes all other regions, and saves a new atlas file. The output can be used for ROI-based neuroimaging analyses, mask generation, or visualization of specific cortical regions.

## *binerize_nifti.m*

Binarize NIfTI Image: This script converts a NIfTI image into a binary mask using SPM. Voxels with values greater than zero are assigned a value of 1, while all other voxels are assigned a value of 0. The resulting binary mask is saved as a new NIfTI file and can be used for ROI analyses, masking procedures, or neuroimaging visualization workflows.

## *Calculate_volume.m*

ROI Volume Extraction: This script calculates ROI-wise volume measurements from a set of NIfTI images using a labeled atlas. For each subject image, the script identifies voxels belonging to each atlas-defined region and computes the sum of voxel intensities within that ROI. The resulting ROI volume vector is saved for each subject as a MATLAB (.mat) file.

Inputs
Subject images (*.nii): Structural MRI images, tissue probability maps, or other voxel-wise measurements.
Atlas file (*.nii): A labeled atlas where each ROI is assigned a unique integer label.
Output directory: Location where ROI volume results will be saved.

## *ROI_Regression_analysis.m*

ROI-Behavior Regression Analysis: This script is used for performing ROI-wise regression analyses between neuroimaging measurements and behavioral or clinical variables. The workflow is designed for studies in which regional brain measurements (e.g., volume, cortical thickness, perfusion, texture, connectivity metrics) are related to behavioral outcomes while accounting for demographic and anatomical covariates.

Features
* ROI-wise linear regression
* Covariate adjustment (Age, Sex, ICV, etc.)
* Confidence intervals for regression coefficients
* R² and adjusted R² statistics
* Cohen's f² effect size calculation
* Automatic handling of missing values

Inputs: 
  A spreadsheet or table containing: Subject ID, Outcome variable and Covariates (e.g., age, sex, ICV)
  ROI Measurements: For each subject for example ROI volume
  ICV Files: MATLAB (.mat) files containing intracranial volume estimates.

Statistical Model: For each ROI:  Volume ~ Age + Sex + ICV + ClinicalScore

The script reports: Regression coefficients, p-values, Confidence intervals, R², Adjusted R², Cohen's f² effect size

