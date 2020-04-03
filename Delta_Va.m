clear all; close all; clc;
%% Parameters
M_C=0.6;
F_HR_min=2/3;%Hz -the minimal heart rat  
F_HR_max=3;%Hz the maximal heart rate
R_TPR_min = 1.2;%0.5335;%mm Hg s/ml - the minimal periferal resistance
R_TPR_max = 2.7;%2.134;%mm Hg s/ml  -the minimal periferal resistance
V_ED_0=7.1441;%ml % ventricular pressure volume relationship (Eq. 7)

%% Inputs:
S           = linspace(0,1,4);  % S is bounded between 0 and 1
V_S         = 0 : 2 : 60;       % [ml]
Delta_Pav   = 0 : 1 : 140;      % [mmHg]

%% calcs:
DeltaVa = zeros(numel(S), numel(Delta_Pav), numel(V_S));
DeltaVa_hr = zeros(numel(S), numel(Delta_Pav), numel(V_S));

for S_idx = 1:numel(S)
    S_val = S(S_idx);
    for V_S_idx = 1:numel(V_S)
        V_S_val = V_S(V_S_idx);        
        for Delta_Pav_idx = 1:numel(Delta_Pav)
            Delta_Pav_val = Delta_Pav(Delta_Pav_idx);
            
            f_HR = S_val*(F_HR_max - F_HR_min) + F_HR_min;
            reflex = S_val - M_C;
            R_TPR = reflex*(R_TPR_max - R_TPR_min) + R_TPR_min;
            
            DeltaVa(S_idx, Delta_Pav_idx, V_S_idx) = -Delta_Pav_val/R_TPR + V_S_val*f_HR;
            DeltaVa_hr(S_idx, Delta_Pav_idx, V_S_idx) = DeltaVa(S_idx, Delta_Pav_idx, V_S_idx) * (1/f_HR);
        end
    end
end

%% plots
x = V_S;
y = Delta_Pav;
[X,Y] = meshgrid(x,y);

figure; 
for S_idx = 1:numel(S)
    S_val = S(S_idx);
    Z = squeeze(DeltaVa_hr(S_idx, :, :));
    subplot(2, 2, S_idx); contour(X,Y,Z,'ShowText','on'); hold on; xlabel('V_{S} [ml]'); ylabel('\Delta P_{a,v} [mmHg]'); title(['$$\dot{V}_{a}$$ $$\left[ \frac{ml}{\tau_{HR}} \right]$$; S=',num2str(S_val)],'interpreter','latex'); grid on;
end
