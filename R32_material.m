% MATLAB Code for Plotting Temp45, Temp90, VF45, and VF90 for Different E Values
clc;
clear all;
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

% Font size multiplier (doubling the font size)
fontSizeMultiplier = 2;
baseFontSize = 12;  % Set a base font size to multiply

% Iterate through each file name to generate plots
for f = 1:length(fileNames)
    % Initialize a figure for each file
    figure;
    hold on;
    
    % Iterate through each folder and process the current file
    for i = 1:length(subfolders)
         if strcmp(fileNames{f},'Wall Heat Flux.csv') && strcmp(subfolders{i},'Nusselt Theory')
            continue;
         end
        % Construct file path
        folderPath = fullfile(outputDataFolder, subfolders{i});
        filePath = fullfile(folderPath, fileNames{f});

        % Check if the file exists in the folder
        if exist(filePath, 'file') == 2
            % Read the file using the helper function
            data = read_data(filePath);
            
            % Extract data
            x = data(:, 1); % Chart Count
            y = data(:, 2); % Values (Temperature or Volume Fraction)
            
            % Plot the data with different line styles and markers
            plot(x/100, y, 'DisplayName', subfolders{i}, ...
                'LineWidth', 2.5, 'Color', colors(i, :), ...
                'LineStyle', lineStyles{i}, 'Marker', markers{i});
        else
            warning('File %s does not exist.', filePath);
        end
    end

    % Configure plot
    if strcmp(fileNames{f}, 'Wall Heat Flux.csv')
        % If the file is 'Wall Heat Flux.csv', change x-label
        xlabel('Cylinder Wall', 'Interpreter', 'latex', 'FontSize', baseFontSize * fontSizeMultiplier);  % Set x-label font size
    else
        % Otherwise, use the default x-label
        xlabel('Radial Position', 'Interpreter', 'latex', 'FontSize', baseFontSize * fontSizeMultiplier);  % Set x-label font size
    end
    
    ylabel(fileNames{f}(1:end-4), 'Interpreter', 'latex', 'FontSize', baseFontSize * fontSizeMultiplier);  % Set y-label font size
    title(sprintf('R32-a %s ', fileNames{f}(1:end-4)), 'Interpreter', 'latex', 'FontSize', baseFontSize * fontSizeMultiplier); % Set title font size
    legend('show', 'Location', 'best', 'FontSize', baseFontSize * fontSizeMultiplier);  % Set legend font size
    grid on;

    % Save the plot as a PNG file in the specified folder
    save_plot_as_png(gcf, fullfile(saveFolder, sprintf('%s_Profiles.png', fileNames{f}(1:end-4))));

    hold off;
end

function save_plot_as_png(figHandle, filePath)
    % Function to save the figure as a PNG file
    saveas(figHandle, filePath, 'png');
end

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
