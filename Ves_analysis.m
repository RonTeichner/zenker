clear all; close all; clc;
%% Parameters
c_PRSW_min=25.9;%mm Hg the minimal contractility 
c_PRSW_max=70;
V_ED_0=7.1441;%ml % ventricular pressure volume relationship (Eq. 7)
P_th=0;%3; % thoracic pressure
P_0_LV=2.03;%+P_th;%  % ventricular pressure volume relationship (Eq. 7)
k_E_LV=0.0657;% 1/ml % ventricular pressure volume relationship 

%% Inputs:
S       = linspace(0,1,4);      % S is bounded between 0 and 1
V_ED    = V_ED_0 : 2 : 60;  % [ml]
P_a     = 20 : 2 : 140;     % [mmHg]

%% P_LV_ED:

P_LV_ED = P_th + P_0_LV*( exp(k_E_LV*(V_ED - V_ED_0)) - 1 );

figure; 
plot(V_ED, P_LV_ED);
title('End-diastolic ventricle pressure vs end-diastolic vol');
grid on;
xlabel('V_{ED} [ml]'); ylabel('P_{ED} [mmHg]');

%% C_PRSW, hat_V_ES

C_PRSW = S*(c_PRSW_max - c_PRSW_min) + c_PRSW_min;

hat_V_ES = zeros(numel(C_PRSW), numel(P_a), numel(V_ED));
tilde_V_ES = zeros(numel(C_PRSW), numel(P_a), numel(V_ED));

for C_PRSW_idx = 1:numel(C_PRSW)
    C_PRSW_val = C_PRSW(C_PRSW_idx);
    for V_ED_idx = 1:numel(V_ED)
        V_ED_val = V_ED(V_ED_idx);
        P_LV_ED_val = P_LV_ED(V_ED_idx);
        for P_a_idx = 1:numel(P_a)
            P_a_val = P_a(P_a_idx);
            hat_V_ES(C_PRSW_idx, P_a_idx, V_ED_idx) = V_ED_val - C_PRSW_val*( (V_ED_val-V_ED_0)/(P_a_val-P_LV_ED_val) );
            
            if P_a_val > P_LV_ED_val
                tilde_V_ES(C_PRSW_idx, P_a_idx, V_ED_idx) = max(hat_V_ES(C_PRSW_idx, P_a_idx, V_ED_idx), V_ED_0);
            else
                tilde_V_ES(C_PRSW_idx, P_a_idx, V_ED_idx) = V_ED_0;
            end
            
        end
    end
end

%% plots
x = V_ED;
y = P_a;
[X,Y] = meshgrid(x,y);

figure; 
for S_idx = 1:numel(S)
    S_val = S(S_idx);
    Z = squeeze(tilde_V_ES(S_idx, :, :));
    subplot(2, 2, S_idx); contour(X,Y,Z,'ShowText','on'); xlabel('V_{ED} [ml]'); ylabel('P_a [mmHg]'); title(['$$\tilde{V}_{ES}$$ [ml]; S=',num2str(S_val)],'interpreter','latex'); grid on;
end

%%
% x = -2:0.2:2;
% y = -2:0.2:3;
% [X,Y] = meshgrid(x,y);
% Z = X.*exp(-X.^2-Y.^2);
% contour(X,Y,Z,'ShowText','on')