function plotdensity1(xy, celltypeA, celltypeB, frame)
    % xy: Coordinates of the subset of cells to plot (active, quiescent, or inactive cells)
    % celltypeA, celltypeB: Structures containing active, inactive, and quiescent cell counts
    % frame: The time step to plot

    % Calculate the total number of cells (active + inactive + quiescent) at the specified frame
    total_cells = celltypeA.Num(frame) + celltypeA.NumI(frame) + celltypeA.NumQ(frame) + ...
                  celltypeB.Num(frame) + celltypeB.NumI(frame) + celltypeB.NumQ(frame);

    % Extract the coordinates for the specified subset of cells at the given frame
    xyp = xy{frame}; % Coordinates of the specific subset (e.g., active A cells)

    % Create histogram for density
    H = hist3(xyp, 'Nbins', [100, 100]); % Create a 100x100 bin density grid

    % Normalize the histogram by the total number of cells at this frame
    H_normalized = H / total_cells;

    % Normalize the histogram to have values between 0 and 1
    H_normalized = H_normalized / max(H_normalized(:));


    %H_normalized = H_normalized * 0.5;
    % Plot the normalized density
    figure;
    contourf(flip(H_normalized'), 20, 'LineStyle', 'none'); % Filled contour plot
    colorbar; % Display color bar for normalized density
    caxis([0, 1]); % Set color axis to range from 0 to 1


    % Add plot labels and title
    xlabel('Lx', FontSize=12, FontWeight='bold' );
    ylabel('Ly', FontSize=12,FontWeight='bold');
    %title(['Active LT-HSCs Density at Frame ', num2str(frame)]);
    title("Active ST-HSCs (aQ=0.25, aD=0.25)", FontSize=15,FontWeight='bold')
    colormap("jet");
    

end
