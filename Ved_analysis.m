clear all; close all; clc;
%% Parameters
P_th=0;%3; % thoracic pressure
P_0_LV=2.03;%+P_th;%  % ventricular pressure volume relationship (Eq. 7)
k_E_LV=0.0657;% 1/ml % ventricular pressure volume relationship 
V_ED_0=7.1441;%ml % ventricular pressure volume relationship (Eq. 7)
R_valve=0.0025;% mm Hg s/ml % atrial resistance
k1=- P_0_LV/R_valve*exp(-k_E_LV*V_ED_0);
k2=k_E_LV;
F_HR_min=2/3;%Hz -the minimal heart rat  
F_HR_max=3;%Hz the maximal heart rate 
T_Sys=4/15;% s % "time of systole" - 80% of cardiac cycle in a maximal heart rate*

%% Inputs:
S       = linspace(0,1,4);      % S is bounded between 0 and 1
V_ES    = V_ED_0 : 2 : 60;  % [ml]
P_cvp     = 1 : 0.5 : 40;     % [mmHg]

%% calcs:
f_HR = S*(F_HR_max - F_HR_min) + F_HR_min;
td = f_HR.^(-1) - T_Sys;
k3 = (P_cvp+P_0_LV)./R_valve;
P_LV_ES = P_th + P_0_LV*( exp(k_E_LV*(V_ES - V_ED_0)) - 1 );

%% hat_V_ED
hat_V_ED = zeros(numel(S), numel(P_cvp), numel(V_ES));
tilde_V_ED = zeros(numel(S), numel(P_cvp), numel(V_ES));

for td_idx = 1:numel(S)
    td_val = td(td_idx);
    for V_ES_idx = 1:numel(V_ES)
        V_ES_val = V_ES(V_ES_idx);
        P_LV_ES_val = P_LV_ES(V_ES_idx);
        for P_cvp_idx = 1:numel(P_cvp)
            P_cvp_val = P_cvp(P_cvp_idx);
            k3_val = k3(P_cvp_idx);
            hat_V_ED(td_idx, P_cvp_idx, V_ES_idx) = -1/k2 * log(k1/k3_val*(exp(-k2*k3_val*td_val)-1) + exp(-k2*(V_ES_val+k3_val*td_val)));
            
            if P_cvp_val > P_LV_ES_val
                tilde_V_ED(td_idx, P_cvp_idx, V_ES_idx) = hat_V_ED(td_idx, P_cvp_idx, V_ES_idx);
            else
                tilde_V_ED(td_idx, P_cvp_idx, V_ES_idx) = V_ES_val;
            end
            
        end
    end
end

P_cvp_zero_stroke = -(k1*R_valve*exp(k2*V_ES) + P_0_LV);
%% plots
x = V_ES;
y = P_cvp;
[X,Y] = meshgrid(x,y);

figure; 
for S_idx = 1:numel(S)
    S_val = S(S_idx);
    Z = squeeze(tilde_V_ED(S_idx, :, :));
    subplot(2, 2, S_idx); contour(X,Y,Z,'ShowText','on'); hold on; plot(V_ES, P_cvp_zero_stroke, 'k--'); xlabel('V_{ES} [ml]'); ylabel('P_{cvp} [mmHg]'); title(['$$\tilde{V}_{ED}$$ [ml]; S=',num2str(S_val)],'interpreter','latex'); grid on; ylim([0, 40]);
end

figure; 
for S_idx = 1:numel(S)
    S_val = S(S_idx);
    Z = squeeze(hat_V_ED(S_idx, :, :));
    subplot(2, 2, S_idx); contour(X,Y,Z,'ShowText','on'); hold on; plot(V_ES, P_cvp_zero_stroke, 'k--'); xlabel('V_{ES} [ml]'); ylabel('P_{cvp} [mmHg]'); title(['$$\hat{V}_{ED}$$ [ml]; S=',num2str(S_val)],'interpreter','latex'); grid on; ylim([0, 40]);
end

%%
% x = -2:0.2:2;
% y = -2:0.2:3;
% [X,Y] = meshgrid(x,y);
% Z = X.*exp(-X.^2-Y.^2);
% contour(X,Y,Z,'ShowText','on')