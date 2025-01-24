function CalcPRCC_PAV_with_zscores(params, output, titleplot)

%%% Mode of use 
% CalcPRCC_PAV_with_zscores(params, output, titleplot)
% Example
%params = dataPRCC(:,1:16);
%output = dataPRCCval_a(:,3);
%title = 'Active A'

    load("dataPRCC_ab_all.mat");

    % Rank the input data and output
    for i = 1:size(params, 2)
        X_rank(:, i) = tiedrank(params(:, i));
    end
    Y_rank = tiedrank(output);

    % Calculate Spearman correlations (PRCCs)
    for i = 1:size(params, 2)
        rho(i) = corr(X_rank(:, i), Y_rank, 'type', 'Spearman');
    end

    % Number of samples
    n = size(params, 1);

    % Calculate z-scores for each correlation
    z_scores = rho .* sqrt((n - 2) ./ (1 - rho .^ 2));
    p_values = 2 * (1 - normcdf(abs(z_scores))); % Two-tailed test

    % Significance threshold (e.g., p < 0.05)
    significance_threshold = 0.05;
    significant = p_values < significance_threshold;

    % Parameter labels
    param_labels = {'P1A', 'P2A', 'P3A', 'P1B', 'P2B', 'P3B', 'PQA', 'PQB', ...
                    'PAA', 'PAB', 'meanCCA', 'stdCCA', 'meanCCB', 'stdCCB', ...
                    'divA', 'divB'};

    % Plot all PRCCs
    figure('Position', [100, 500, 1500, 500]);
    bar(rho);
    hold on;

    % Add stars above bars for significant parameters
    for i = 1:length(rho)
        if significant(i)
            % Adjust star position based on whether the bar is positive or negative
            if rho(i) >= 0
                star_position = rho(i) + 0.05; % Place above positive bars
            else
                star_position = rho(i) - 0.1; % Place above (less negative) for negative bars
            end
            text(i, star_position, '*', 'HorizontalAlignment', 'center', ...
                 'FontSize', 35, 'Color', 'black', 'FontWeight', 'bold');
        end
    end

    % Customize axes
    ax = gca;
    ax.XTick = 1:length(rho);
    ax.XTickLabel = param_labels;
    ax.LineWidth = 1.5;
    ax.FontSize = 22;
    title([titleplot]);
       % Adjust as needed for better visibility
    ylabel('PRCC');
    xlabel('Parameters');
    ylim([-1,1]);
    print(gcf, 'Quiescent_ST-HSCs.svg', '-dsvg');

    hold off;
end

