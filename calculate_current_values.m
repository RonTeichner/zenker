% calculate the current valus of the functions:

% this script calculates all relevatn values for the dyanmics. should be
% applied at each iteration in order to update the values. 

% the heart rate (affected by the baroreflex)
f_HR = S*(F_HR_max-F_HR_min) + F_HR_min; % (beats per sec)

% the cardiac output rate
cardiac_output=(V_ED-V_ES)*f_HR;

%% overall reflexes:
reflex=S-M_C;%O2_control;%1/sqrt(2)*sqrt(S.^2+O2_control.^2);

% how much stroke work increases with diastolic filling (affected by the baroreflex)
c_PRSW = S*(c_PRSW_max-c_PRSW_min) + c_PRSW_min; % mmHg

% the peripheral resistance:(affected by the baroreflex)
R_TPR = reflex*(R_TPR_max-R_TPR_min) + R_TPR_min;

% the pressure in the aretries:
P_a = (V_a-V_a0)/C_a; % mmHg

% end siastolic pressure (substitute V_ES in eq: 7 in the paper):
P_LV_ED=P_th+ P_0_LV*(exp(k_E_LV*(V_ED-V_ED_0)) -1); % mm Hg 

% the pressure in the ventricular compartment:(eq 7) as a function of V_ES
% - at the end of systole
P_LV_ES =P_th+ P_0_LV*(exp(k_E_LV*(V_ES-V_ED_0)) -1); % mm Hg should be between 15-30

% the unstressed volume - controled by the baroreflex:
V_v0 = (1-S)*(V_v0_max - V_v0_min)+ V_v0_min;

% central vein pressure
P_CVP = (V_v-V_v0)/C_v; %mmHg note that the normal values are 3-8
P_v=P_CVP;% this is my assumption..

k3= (P_CVP+P_0_LV)/R_valve; % eq 9 in the paper

% I should understand what is this....
V_hat_ES = V_ED -c_PRSW*(V_ED - V_ED_0)/(P_a - P_LV_ED);

% I should understand what is this....(Eq 4 in the paper)
V_til_ES = max(V_ED_0,V_hat_ES).*(P_a>P_LV_ED) + V_ED_0.*(P_a<=P_LV_ED);

% the volume during the begining of diastole? (using equations 10 and 11)
t_diastole=1/f_HR-T_Sys;
V_hat_ED = - 1/k2*log( k1/k3*(exp(-k2*k3*t_diastole)-1) + exp(-k2*(V_ES+k3*t_diastole) ) );%!!!!!!!!!!!!
if V_hat_ED<=0
%    error('V_hat_ED should not be negative')
end

% I should understand what is this....(Eq 13 in the paper)
V_til_ED = V_hat_ED.*(P_CVP>P_LV_ES)+V_ES.*(P_CVP<=P_LV_ES);

% peripheral blood flow and oxygen consumption
peripheral_blood_flow=(P_a-P_v)/R_TPR;

% oxygen in the veins
%O2_consumption=peripheral_blood_flow*O2_a-M_C;% the change in the oxygen in the veins
O2_veins=O2_a-M_C/peripheral_blood_flow;% the O2 concentration in the veins
% oxygen control:
%O2_consumption=SaO2*cardiac_output*P_a;%(SaO2-SvO2)*V_a*P_a; % the consumption of O2 in a peropheral tissue?????

