% MATLAB Code for Plotting Temp45, Temp90, VF45, and VF90 for Different E Values
clc;
clearvars;
close all;

% Set the folder path
outputDataFolder = 'R32a_Data';

% List of subfolders corresponding to different E values
subfolders = {'E = 0.2','E = 0.4', 'E = 0.6', 'E = 0.8','Nusselt Theory'};

% Define file names to process
fileNames = {'Temp45.csv', 'Temp90.csv', 'VF45.csv', 'VF90.csv','Wall Heat Flux.csv'};

% Set LaTeX formatting for plots
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');
set(0, 'DefaultLegendInterpreter', 'latex');

% Define colors for differentiation
colors = lines(length(subfolders));

% Define line styles and markers
lineStyles = {'-', '--', ':', '-.', '-'}; 
markers = {'o', 's', 'd', '^', 'none'}; % The last one for solid line (theory)

% Folder to save PNG files 
saveFolder = 'SavedFigures';

% Create the folder if it doesn't exist
if ~exist(saveFolder, 'dir')
    mkdir(saveFolder);
end

% Iterate through each file name to generate plots
for f = 1:length(fileNames)
    % Skip 'Wall Heat Flux.csv' entirely
    if strcmp(fileNames{f}, 'Wall Heat Flux.csv')
        continue; 
    end
    
    % Initialize a figure for each file with subplots
    figure;
    
    % First Subplot: Original Data (Larger plot)
    subplot('Position', [0.05 0.1 0.6 0.8]); % Adjust position to make it larger
    hold on;
    for i = 1:length(subfolders)
        % Construct file path
        folderPath = fullfile(outputDataFolder, subfolders{i});
        filePath = fullfile(folderPath, fileNames{f});

        % Check if the file exists
        if exist(filePath, 'file') == 2
            % Read data
            data = read_data(filePath);

            % Extract x and y
            x = data(:, 1);
            y = data(:, 2);

            % Plot data with style
            plot(x/100, y, 'DisplayName', subfolders{i}, ...
                'LineWidth', 3, 'Color', colors(i, :), ...  % Set line width to 2.5
                'LineStyle', lineStyles{i}, 'Marker', markers{i});
        else
            warning('File %s does not exist.', filePath);
        end
    end
    hold off;
    
    % Configure first subplot
    xlabel('Radial Position', 'Interpreter', 'latex', 'FontSize', 16);  % Set x-axis label size to 16
    ylabel(fileNames{f}(1:end-4), 'Interpreter', 'latex', 'FontSize', 16);  % Set y-axis label size to 16
    title(sprintf('R32-a %s (Original)', fileNames{f}(1:end-4)), 'Interpreter', 'latex', 'FontSize', 18); % Set title font size to 18
    legend('show', 'Location', 'best');
    grid on;

    % Second Subplot: Adjusted x-limits [0, 0.2] (Smaller plot)
    subplot('Position', [0.7 0.1 0.25 0.8]); % Adjust position to make it smaller
    hold on;
    for i = 1:length(subfolders)
        % Construct file path
        folderPath = fullfile(outputDataFolder, subfolders{i});
        filePath = fullfile(folderPath, fileNames{f});

        % Check if the file exists
        if exist(filePath, 'file') == 2
            % Read data
            data = read_data(filePath);

            % Extract x and y
            x = data(:, 1);
            y = data(:, 2);

            % Plot data with style
            plot(x/100, y, 'DisplayName', subfolders{i}, ...
                'LineWidth', 3, 'Color', colors(i, :), ...  % Set line width to 2.5
                'LineStyle', lineStyles{i}, 'Marker', markers{i});
        end
    end
    hold off;

    % Configure second subplot
    xlabel('Radial Position', 'Interpreter', 'latex', 'FontSize', 16);  % Set x-axis label size to 16
    ylabel(fileNames{f}(1:end-4), 'Interpreter', 'latex', 'FontSize', 16);  % Set y-axis label size to 16
    title(sprintf('R32-a %s (Zoomed)', fileNames{f}(1:end-4)), 'Interpreter', 'latex', 'FontSize', 18); % Set title font size to 18
    legend('show', 'Location', 'best');
    xlim([0 0.2]); % Adjust x-limits
    grid on;

    % Save the figure as a PNG file
    save_plot_as_png(gcf, fullfile(saveFolder, sprintf('%s_Profiles.png', fileNames{f}(1:end-4))));
end

% Function to save the plot as a PNG file
function save_plot_as_png(figHandle, filePath)
    saveas(figHandle, filePath, 'png');
end

% Function to read the data from CSV files
function data = read_data(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open file: %s', filename);
    end

    % Skip header lines until reaching the [Data] section
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, '[Data]')
            break; % Stop when [Data] section is found
        end
    end

    % Read the data after [Data]
    data = [];
    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line)
            % Attempt to parse two comma-separated values
            line_data = sscanf(line, '%f,%f');
            if numel(line_data) == 2
                data = [data; line_data'];
            else
                % Ignore malformed or non-numerical lines without a warning
                continue;
            end
        end
    end

    fclose(fid);

    % Check if data was read successfully
    if isempty(data)
        error('No valid data found in file: %s', filename);
    end
end
