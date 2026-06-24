clc;
clear;

%% ============================================================
% ANCOVA: HC vs Low SBQ vs High SBQ
% Volume ~ Group + Age + Gender + ICV
% FULL reproducible pipeline (load + split + stats + effect size)
%% ============================================================

Region_name = {'here put the name of your ROIs'};

numROIs = length(Region_name);

th_Sbq = 10;  % based on paper, you can change it

%% ============================================================
% 1. LOAD DATA 
% ============================================================

% ---- LOAD YOUR PRECOMPUTED DATA ----
% These must exist in workspace OR be loaded from files

% volume_bvFTD : patients ROI matrix (subjects x ROIs)
% volume_HC    : healthy ROI matrix (subjects x ROIs)
% age_pat, age_HC
% gender_pat, gender_HC
% ICV_pat, ICV_HC
% SBQ

%% ============================================================
% 2. SPLIT PATIENTS INTO LOW / HIGH USING SBQ
% ============================================================

SBQ_low_idx  = find(SBQ <= th_Sbq);
SBQ_high_idx = find(SBQ > th_Sbq);

volume_low  = volume_bvFTD(SBQ_low_idx,:);
volume_high = volume_bvFTD(SBQ_high_idx,:);

%% ============================================================
% 3. PREALLOCATE OUTPUTS
% ============================================================

p_values   = nan(numROIs,3);
cohen_all  = nan(numROIs,3);
eta_p_sq   = nan(numROIs,1);

%% ============================================================
% 4. ANCOVA LOOP
% ============================================================

for j = 1:numROIs

    %% -----------------------------
    % LOAD ROI DATA (explicit + reproducible)
    %% -----------------------------
    y = [volume_HC(:,j); volume_low(:,j); volume_high(:,j)];

    group = [ones(size(volume_HC,1),1); ...
             2*ones(size(volume_low,1),1); ...
             3*ones(size(volume_high,1),1)];

    age_all = [age_HC; age_pat(SBQ_low_idx); age_pat(SBQ_high_idx)];
    gender_all = [gender_HC; gender_pat(SBQ_low_idx); gender_pat(SBQ_high_idx)];
    icv_all = [ICV_HC; ICV_pat(SBQ_low_idx); ICV_pat(SBQ_high_idx)];

    %% -----------------------------
    % ANCOVA model
    %% -----------------------------
    [~, tbl, stats] = anovan(y, {group, age_all, gender_all, icv_all}, ...
        'model','linear', ...
        'continuous',[2 4], ...
        'varnames',{'Group','Age','Gender','ICV'}, ...
        'display','off');

    results = multcompare(stats,'Display','off');

    p_values(j,:) = results(:,6);

    %% ========================================================
    % 5. EFFECT SIZE: Cohen's d (all pairwise comparisons)
    %% ========================================================

    cohens_d = zeros(size(results,1),1);

    for c = 1:size(results,1)

        g1 = results(c,1);
        g2 = results(c,2);

        x1 = y(group==g1);
        x2 = y(group==g2);

        n1 = length(x1);
        n2 = length(x2);

        m1 = mean(x1);
        m2 = mean(x2);

        s1 = std(x1);
        s2 = std(x2);

        pooled_sd = sqrt(((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2));

        cohens_d(c) = (m1 - m2) / pooled_sd;
    end

    cohen_all(j,1:length(cohens_d)) = cohens_d';

    %% ========================================================
    % 6. PARTIAL ETA SQUARED
    %% ========================================================

    row_group = find(strcmp(tbl(:,1),'Group'));
    row_error = find(strcmp(tbl(:,1),'Error'));

    SS_group = cell2mat(tbl(row_group,2));
    SS_error = cell2mat(tbl(row_error,2));

    eta_p_sq(j) = SS_group / (SS_group + SS_error);

end

%% ============================================================
% SAVE OUTPUT
%% ============================================================

results_table.p_values = p_values;
results_table.cohen_d = cohen_all;
results_table.eta_sq = eta_p_sq;

save('ANCOVA_results.mat','results_table');