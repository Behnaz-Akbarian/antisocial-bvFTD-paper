%% Create ROI-Specific Atlas from HCPex Atlas
% This script extracts one or more regions from the HCPex atlas and creates
% a new NIfTI atlas containing only the selected ROIs.
%
% Requirements:
%   - HCPex.nii
%   - HCPex_LabelID.mat
%   - NIfTI toolbox (load_nii, save_nii)

clc;
clear;
close all;

%% Load atlas and labels
atlas_nii = load_nii('HCPex.nii');
load('HCPex_LabelID.mat');

atlas_data = atlas_nii.img;
num_regions = 426;

%% User-defined ROI names
% Enter any ROI names exactly as they appear in LabelID(:,4)
% for example for right composite interior insula (Supplementry Table 2)
     roi_names = {
    'AAIC R'
    'AVI R'
    'Ig R'
    'MI R'
    'PI R'
    'PoI1 R'
    'PoI2 R'
    };


%% Find ROI indices
labels = LabelID(:,4);

[~, roi_indices] = ismember(roi_names, labels);

% Remove ROIs that were not found
roi_indices = roi_indices(roi_indices > 0);

if isempty(roi_indices)
    error('None of the specified ROI names were found in the atlas.');
end

%% Keep only selected ROIs
all_indices = 1:num_regions;
regions_to_remove = setdiff(all_indices, roi_indices);

for region = regions_to_remove
    atlas_data(atlas_data == region) = 0;
end

%% Save output atlas
atlas_nii.img = atlas_data;

output_filename = 'Custom_ROI_Atlas.nii';
save_nii(atlas_nii, output_filename);

fprintf('ROI atlas saved as: %s\n', output_filename);