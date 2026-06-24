function plot_SBQ_volume_relationship( ...
    volume_hc, volume_pat, ...
    age_hc, age_pat, ...
    gender_hc, gender_pat, ...
    icv_hc, icv_pat, ...
    sbq, region_names, roi_idx)

% ============================================================
% SBQ–Volume relationship (covariate-corrected + z-scored)
% Clean version with consistent notation
% ============================================================

roi_name = region_names{roi_idx};

%% -----------------------------
% Combine data across groups
% -----------------------------
volume_all = [volume_hc(roi_idx,:), volume_pat(roi_idx,:)];
volume_all = volume_all(:);

age_all    = [age_hc; age_pat]';
gender_all = [gender_hc; gender_pat]';
icv_all    = [icv_hc; icv_pat]';

n_hc  = length(age_hc);
n_all = length(volume_all);

%% -----------------------------
% Step 1: Covariate correction
% Volume ~ Age + Gender + ICV
% -----------------------------
valid_idx = isfinite(volume_all);

X_cov = [age_all' gender_all' icv_all'];

mdl_cov = fitlm(X_cov(valid_idx,:), volume_all(valid_idx));

beta_cov = mdl_cov.Coefficients.Estimate;

volume_resid = nan(size(volume_all));

for i = 1:n_all
    volume_resid(i) = volume_all(i) - ...
        (beta_cov(1) + ...
         beta_cov(2)*age_all(i) + ...
         beta_cov(3)*gender_all(i) + ...
         beta_cov(4)*icv_all(i));
end

%% -----------------------------
% Step 2: Z-score using controls
% -----------------------------
hc_mean = mean(volume_resid(1:n_hc));
hc_std  = std(volume_resid(1:n_hc));

volume_z = (volume_resid - hc_mean) ./ hc_std;

sbq_pat = sbq;

volume_pat_z = volume_z(n_hc+1:end);

%% -----------------------------
% Step 3: Plot SBQ vs volume
% -----------------------------
figure;

scatter(sbq_pat, volume_pat_z, 120, 'k', 'filled');
hold on;

yline(0, 'k', 'LineWidth', 1.5);

% regression
p = polyfit(sbq_pat, volume_pat_z, 1);
x_fit = linspace(min(sbq_pat), max(sbq_pat), 50);
y_fit = polyval(p, x_fit);

plot(x_fit, y_fit, 'r', 'LineWidth', 3);

grid on;
box on;
axis square;

xlabel('SBQ score');
ylabel('Volume (z-score, covariate corrected)');
title(roi_name, 'Interpreter', 'none');

end