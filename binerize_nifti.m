%% Binarize a NIfTI Image
% This script converts a NIfTI image into a binary mask.
% All voxels with values greater than zero are set to 1,
% and all remaining voxels are set to 0.
%
% Requirements:
%   - SPM toolbox

clc;
clear;
close all;

%% User-defined input and output files
input_nii  = 'input_image.nii';
output_nii = 'binary_mask.nii';

%% Load NIfTI image
V = spm_vol(input_nii);
img = spm_read_vols(V);

%% Binarize image
binary_img = img > 0;

%% Save binary mask
V.fname = output_nii;
spm_write_vol(V, binary_img);

fprintf('Binary mask saved as: %s\n', output_nii);