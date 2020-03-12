% define parameters: find the values from the litarture (for kids)

%% physiological quantities:
 F_HR_min=2/3;%Hz -the minimal heart rat  
 F_HR_max=3;%Hz the maximal heart rate 

 c_PRSW_min=25.9;%mm Hg the minimal contractility 
 %c_PRSW_max=103.8;% mm Hg % the maximal contractility 

 R_TPR_min = 1.2;%0.5335;%mm Hg s/ml - the minimal periferal resistance
 R_TPR_max = 2.7;%2.134;%mm Hg s/ml  -the minimal periferal resistance
 
 V_a0=20;% ml %unstressed volume in the arteries!!!!!!!
 V_v0_min =900; %minimal venous unstressed volume 
 V_v0_max = 1100; % maximal venous unstressed volume  
 
 %V_ED_0=7.14;%ml % the volume at which the passive interventricular presure is 0; 
 C_a=1;%ml/mm Hg % the arterial contractility
 C_v=111.11; %ml/mm Hg % the venous contractility
 
 P_th=0;%3; % thoracic pressure
 T_Sys=4/15;% s % "time of systole" - 80% of cardiac cycle in a maximal heart rate*
k_E_LV=0.0657;% 1/ml % ventricular pressure volume relationship 
P_0_LV=2.03;%+P_th;%  % ventricular pressure volume relationship (Eq. 7)
V_ED_0=7.1441;%ml % ventricular pressure volume relationship (Eq. 7)


R_valve=0.0025;% mm Hg s/ml % atrial resistance

% P_CVP= []; % pressure in the central vein  - is ongoingly evaluated 
%P_ED=2.0325; % this value is P0lv from the the parameters file of the code of zenker et al. 


k1=- P_0_LV/R_valve*exp(-k_E_LV*V_ED_0);
k2=k_E_LV;
% k3 is ongoingly changed
k_width= 0.1838;% mm 1/Hg% the baroreflex parameter
P_a_set=70;%70;% - for baroreflex: this parameter is taken from the value "apSetpoint" in the authors code
tau_Baro= 20; %for baroreflex
tau_O2 = 20; % the time constant of the oxygen control - an arbitrary for now

%SaO2=0.9;%0.97;% oxygen saturation in the arteries
%SvO2=0.92;% oxygen saturation in the veins
O2_a=200; %ml O2 per liter blood the concentration of oxygen in the arteries - ml O2 in 1 L blood. 
O2_veins_set=160; %based on Doyle et al PNAS %50.0387*0.2-6;% baseline - based on steady state results
%M_C=0;% units???%1000*0.36/60; %mililiter per second- metabolic consumption (Doyle 2014 see appendix). 

alpha_HRV=1; % For the heart rate variability
%% simulation parameters:

save simulation_parameters