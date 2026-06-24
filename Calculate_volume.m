%% ROI Volume Extraction from NIfTI Images
% This script calculates ROI-wise volume values from a set of subject
% images using a labeled atlas.
%
% Requirements:
%   - NIfTI toolbox (load_nii, save_nii)
%   - Atlas and subject images must be in the same space and resolution

clc;
clear;
close all;

%% User Inputs

% Directory containing subject NIfTI images
subjectDir = 'path/to/subject_images';

% ROI atlas NIfTI file
atlasPath = 'path/to/atlas.nii';

% Output directory
outputDir = 'path/to/output_folder';

%% Create output directory if it does not exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% Load atlas
fprintf('Loading atlas...\n');

atlasNii = load_nii(atlasPath);
atlasData = atlasNii.img;

roiLabels = unique(atlasData(:));
roiLabels(roiLabels == 0) = [];   % Remove background

fprintf('Found %d ROIs.\n', length(roiLabels));

%% Find subject files
subjectFiles = dir(fullfile(subjectDir, '*.nii'));

fprintf('Found %d subjects.\n', length(subjectFiles));

%% Process subjects

for i = 1:length(subjectFiles)

    subjectName = erase(subjectFiles(i).name,'.nii');

    fprintf('\nProcessing: %s\n', subjectName);

    %% Load subject image
    subjectNii = load_nii(fullfile(subjectDir, subjectFiles(i).name));
    subjectData = double(subjectNii.img);

    %% Check dimensions
    if ~isequal(size(subjectData), size(atlasData))
        warning('Dimension mismatch for %s. Skipping.', subjectName);
        continue;
    end

    %% Initialize output vector
    volumeMatrix = nan(length(roiLabels),1);

    %% Calculate ROI volumes

    for r = 1:length(roiLabels)

        currentROI = roiLabels(r);

        roiMask = (atlasData == currentROI);

        % Sum voxel values inside ROI
        volumeMatrix(r) = nansum(subjectData(roiMask));

    end

    %% Save results

    save(fullfile(outputDir,...
        [subjectName '_volume.mat']),...
        'volumeMatrix','roiLabels');

    fprintf('Saved ROI volumes for %s\n', subjectName);

end

fprintf('\nProcessing completed.\n');