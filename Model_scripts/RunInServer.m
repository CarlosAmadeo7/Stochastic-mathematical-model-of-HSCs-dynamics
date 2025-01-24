function RunInServer(seedk)
    % Set a fixed seed for reproducibility
    rng(123456789);
    
    % Number of runs with different seeds
    numruns = 30;  
    
    % Generate random seeds for each run
    seed = floor(1e4 * rand(1, numruns));
    
    % Run the main model with the specific seed
    [cellstypeA, cellstypeB, cellstypeC, params] = cellmodel_diff_spaQD(seed(seedk));
    
    % Save the output to a file with the seed in the filename
    namesave = ['Output_seed_' num2str(seed(seedk)) '.mat'];
    save(namesave, 'cellstypeA', 'cellstypeB', 'cellstypeC', 'params');
    
    % Print completion message
    fprintf('Job completed for seed: %d\n', seed(seedk));
end