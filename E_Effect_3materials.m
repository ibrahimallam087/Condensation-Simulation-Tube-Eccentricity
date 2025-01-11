clc
clear 
close all

% Define data for eccentricity and wall average heat flux Coefficinet

eccentricity = [0.2, 0.4, 0.6, 0.8];

% Wall average heat flux values (example data, replace with your values)
heat_flux_R32a = -[     -63409.9,     -64326.8,  -64812.6, -64812.6]/1000/50; %Kw/K
heat_flux_R134a =- [  -49402,   -50138.3, -50656.5 ,   -50677.6]/1000/50;%Kw/K
heat_flux_R410a = -[    -57302.4,    -58375.3,   -58844.9 ,   -59011 ]/1000/50;%Kw/K

% Create the plot
figure;
plot(eccentricity, heat_flux_R32a, '-o', 'LineWidth', 1.5, 'MarkerSize', 8, 'Color', [0.850, 0.325, 0.098], 'DisplayName', 'R32a');
hold on;
plot(eccentricity, heat_flux_R134a, '-s', 'LineWidth', 1.5, 'MarkerSize', 8, 'Color', [0.466, 0.674, 0.188], 'DisplayName', 'R134a');
plot(eccentricity, heat_flux_R410a, '-^', 'LineWidth', 1.5, 'MarkerSize', 8, 'Color', [0.000, 0.447, 0.741], 'DisplayName', 'R410a');
hold off;

% Add labels, legend, and title
xlabel('$Eccentricity$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$ Heat Flux Coefficient  kW/m^{2}/K$', 'Interpreter','latex', 'FontSize',14);
title('$Wall\ Average\ Heat\ Flux\ for\ Different\ Refrigerants$', 'Interpreter', 'latex', 'FontSize', 16);
legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 12);
grid on;

% Customize axis limits if needed
xlim([0.2 0.8]);

% Set additional options if desired, such as font size, etc.
set(gca, 'FontSize', 12);
