close all
clear

% Read File
raw_data = xlsread('muscle_data_2023.xlsx');
strain = raw_data(:, 3);
stress = raw_data(:, 4);

% Answer each task in the places shown. The code at the end checks that you
% have created the right variables requested

% Task 1
figure(1);
plot(strain, stress, 'b-', 'LineWidth', 3);
xlabel('Strain');
ylabel('Stress (kPa)');

% Task 2
m = 1:5;
sse_per_m = zeros(1, length(m));

for i = 1:length(m)
    p = polyfit(strain, stress, i);
    est_stress = polyval(p, strain);
    sse_per_m(i) = sum((stress - est_stress) .^ 2);
end

figure(2);
plot(m, sse_per_m, 'r-', 'LineWidth', 3);
xlabel('Model Order');
ylabel('Sum squared error');
my_m = 4;

% Task 3
my_p = polyfit(strain, stress, my_m);
est_stress = polyval(my_p, strain);
figure(1);
hold on;
plot(strain, est_stress, 'r-', 'LineWidth', 3);


% Task 4
error = (stress - est_stress);
figure(3);
hist(error, 20);
xlabel('Error in Polynomial fit');
ylabel('Frequency');

s_t = sum(stress - mean(stress)) ^ 2;
s_r = sum(stress - est_stress) ^ 2;
ccoef_p = (s_t - s_r) / s_t;

% Task 5
a = [0.2, 0.2, 0.2, 0.2, 0.2];
p_r = fminsearch(@(x) calcMae(x, strain, stress), a);
r_est_stress = polyval(p_r, strain);
figure(1);
plot(strain, r_est_stress, 'k--', 'LineWidth', 1);

% Task 6
mse_nl = mean((stress(25:70) - r_est_stress(25:70)) .^ 2);
mse_ls = mean((stress(25:70) - est_stress(25:70)) .^ 2);
fprintf('MSE of LS fit = = %f\n', mse_ls);
fprintf('MSE of Robust fit = %f\n', mse_nl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The lines below here just check that you have addressed the variables
% required in the assignment.
%% Check my variables
if (~exist('a'))
  fprintf('\nVariable "a" does not exist.')
end;
if (~exist('mse_nl'))
  fprintf('\nVariable "mse_nl" does not exist.')
end;
if (~exist('mse_ls'))
  fprintf('\nVariable "mse_ls" does not exist.')
end;
if (~exist('ccoef_p'))
  fprintf('\nVariable "ccoef_p" does not exist.')
end;
if (~exist('est_stress'))
  fprintf('\nVariable "est_stress" does not exist.')
end;
if (~exist('my_m'))
  fprintf('\nVariable "my_m" does not exist.')
end;
if (~exist('sse_per_m'))
  fprintf('\nVariable "sse_per_m" does not exist.')
end;
fprintf('\n');


function mae = calcMae(x, strain, stress)
    est_stress = polyval(x, strain);
    mae = mean(abs(est_stress - stress));
end