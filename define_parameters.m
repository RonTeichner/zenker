% define parameters:

%% physiological quantities:
 F_HR_min=[];%the minimal heart rat \\ should be defined!!!!!
 F_HR_max=[];% the maximal heart rate \\ should be defined!!!!!

 c_PRSW_min=[];% the minimal contractility \\ should be defined!!!!
 c_PRSW_max=[];% the maximal contractility \\ should be defined!!!!

 R_TPR_min = [];% the minimal periferal resistance
 R_TPR_max = [];% the minimal periferal resistance
 
 V_a0=[]; % minumal volume in the arteries
 V_ED_0=[]; % the volume at which the passive interventricular presure is 0; 
 C_a=[]; % the arterial resistence??
 
 T_Sys=[]; % "time of systole" - 80% of cardiac cycle in a maximal heart rate*
k_E_LV=[]; % ventricular pressure volume relationship 
P_0_LV=[]; % ventricular pressure volume relationship (Eq. 7)
V_ED_0=[]; % ventricular pressure volume relationship (Eq. 7)

R_valve=[]; % atrial resistance
P_CVP= []; % pressure in the central vein ?? 

k1=- P_0_LV/R_valve*exp(-k_E_LV*V_ED_0);
k2=k_E_LV;
k3=-(P_CVP+P_0_LV)/R_valve;

k_width= [];% the baroreflex parameter

I_external = [];% fluids change 

%% simulation parameters:
dt=1; %in seconds. 

save simulation_parameters