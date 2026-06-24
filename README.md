# antisocial-bvFTD-paper

#*Create_composite_ROIs.m*

Create ROI-Specific Atlas from the HCPex (Glasser) Atlas: This script generates a new NIfTI atlas containing only user-selected regions from the HCPex (Glasser-based) atlas. Users specify ROI names (as listed in LabelID(:,4)), and the script automatically identifies the corresponding atlas labels, removes all other regions, and saves a new atlas file. The output can be used for ROI-based neuroimaging analyses, mask generation, or visualization of specific cortical regions.

#*binerize_nifti.m*

Binarize NIfTI Image: This script converts a NIfTI image into a binary mask using SPM. Voxels with values greater than zero are assigned a value of 1, while all other voxels are assigned a value of 0. The resulting binary mask is saved as a new NIfTI file and can be used for ROI analyses, masking procedures, or neuroimaging visualization workflows.
