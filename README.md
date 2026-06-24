# antisocial-bvFTD-paper

Create_composite_ROIs.m
Create ROI-Specific Atlas from the HCPex (Glasser) Atlas

This script generates a new NIfTI atlas containing only user-selected regions from the HCPex (Glasser-based) atlas. Users specify ROI names (as listed in LabelID(:,4)), and the script automatically identifies the corresponding atlas labels, removes all other regions, and saves a new atlas file. The output can be used for ROI-based neuroimaging analyses, mask generation, or visualization of specific cortical regions.
