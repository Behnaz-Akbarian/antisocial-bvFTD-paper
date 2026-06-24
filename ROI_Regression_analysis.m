%% ROI-Behavior Regression Analysis
%
% This script performs ROI-wise linear regression analyses between
% neuroimaging measurements and a behavioral/clinical outcome variable.
%
% Model:
% ROI ~ Age + Sex + ICV + Outcome
%
% Outputs:
%   - Regression coefficients
%   - p-values
%   - Confidence intervals
%   - R²
%   - Adjusted R²
%   - Cohen's f² effect size
%
% Requirements:
%   Statistics and Machine Learning Toolbox

clc;
clear;
close all;

%% ============================================================
% USER INPUTS
%% ============================================================

% Subject information table
subjectTable = readtable('subject_data.csv');

% ROI measurements
% Rows = subjects
% Columns = ROIs
roiData = readmatrix('roi_values.csv');

% ROI names
roiNames = {
    'ROI_1'
    'ROI_2'
    'ROI_3'
    'ROI_4'
    };

% Outcome variable
Outcome = subjectTable.ClinicalScore;

% Covariates
Age    = subjectTable.Age;
Sex    = subjectTable.Sex;
ICV    = subjectTable.ICV;

%% ============================================================
% INITIALIZE OUTPUT VARIABLES
%% ============================================================

numROIs = size(roiData,2);

pValues      = nan(numROIs,1);
betaValues   = nan(numROIs,1);
CI_low       = nan(numROIs,1);
CI_high      = nan(numROIs,1);

R2           = nan(numROIs,1);
AdjR2        = nan(numROIs,1);
EffectSizeF2 = nan(numROIs,1);

%% ============================================================
% ROI-WISE REGRESSION
%% ============================================================

for roi = 1:numROIs

    fprintf('Processing ROI %d/%d\n',roi,numROIs);

    y = roiData(:,roi);

    %% Remove missing values

    validIdx = ...
        ~isnan(y) & ...
        ~isnan(Age) & ...
        ~isnan(Sex) & ...
        ~isnan(ICV) & ...
        ~isnan(Outcome);

    T = table( ...
        y(validIdx), ...
        Age(validIdx), ...
        Sex(validIdx), ...
        ICV(validIdx), ...
        Outcome(validIdx), ...
        'VariableNames', ...
        {'ROI','Age','Sex','ICV','Outcome'});

    %% Full model

    mdl = fitlm(T,'ROI ~ Age + Sex + ICV + Outcome');

    %% Outcome coefficient

    betaValues(roi) = mdl.Coefficients.Estimate(end);
    pValues(roi)    = mdl.Coefficients.pValue(end);

    %% Confidence intervals

    C = coefCI(mdl);

    CI_low(roi)  = C(end,1);
    CI_high(roi) = C(end,2);

    %% Model fit

    R2(roi)    = mdl.Rsquared.Ordinary;
    AdjR2(roi) = mdl.Rsquared.Adjusted;

    %% Effect size (Outcome)

    mdlReduced = fitlm(T,'ROI ~ Age + Sex + ICV');

    R2_full    = mdl.Rsquared.Ordinary;
    R2_reduced = mdlReduced.Rsquared.Ordinary;

    EffectSizeF2(roi) = ...
        (R2_full - R2_reduced) / ...
        (1 - R2_full);

end

%% ============================================================
% SAVE RESULTS
%% ============================================================

Results = table( ...
    roiNames(:), ...
    betaValues, ...
    pValues, ...
    CI_low, ...
    CI_high, ...
    R2, ...
    AdjR2, ...
    EffectSizeF2, ...
    'VariableNames', ...
    {'ROI',...
     'Beta',...
     'Pvalue',...
     'CI_Low',...
     'CI_High',...
     'R2',...
     'AdjustedR2',...
     'Cohens_f2'});

writetable(Results,'ROI_Regression_Results.csv');

fprintf('\nResults saved to ROI_Regression_Results.csv\n');