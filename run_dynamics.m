% run_dynamics(iterations)

%load simulation_parameters

V_ES_save=zeros(1,iterations);
V_ED_save=zeros(1,iterations);
V_a_save=zeros(1,iterations);
V_v_save=zeros(1,iterations);
S_save=zeros(1,iterations);
P_a_save=zeros(1,iterations);
f_HR_save=zeros(1,iterations);
cardiac_output_save=zeros(1,iterations);
P_LV_ES_save=zeros(1,iterations);
P_v_save=zeros(1,iterations);
blood_flow_save=zeros(1,iterations);
P_p_Save=zeros(1,iterations);
Rtpr_save=zeros(1,iterations);
HRV_save=zeros(1,iterations);
%% set initial conditions:
V_ES = V_ES_start;
V_ED =V_ED_start;
V_a = V_a_start;
V_v = V_v_start;
S = S_start;
O2_control=O2_control_start;

%% run the dynamical steps:
time=0;
for i=1:iterations
    time=time+dt;
    %% calculate the current valus of function:
    calculate_current_values % this script calculates the current valus of all relevant functions
    
    %% calculate the deltas:
    % the end diastolic volume:
    delta_V_ES = (V_til_ES-V_ES)*f_HR;
    
    % the end diastolic volume:
    delta_V_ED = (V_til_ED-V_ED)*f_HR;
    
    % the volume in the arteries:
  
    delta_V_a =-peripheral_blood_flow + (V_ED-V_ES)*f_HR;% corrected - see lines!!!
    
    % the volume in the veins:
    delta_V_v = - delta_V_a+I_ex(i);
    
    % the baroreflex output:
    exponential_baro=exp( -k_width*(P_a-P_a_set) );
    delta_S = 1./tau_Baro * (1 - 1./(1+exponential_baro) -S);
    
    % oxygen saturation reflex:
    exponential_O2=exp( -k_width*(O2_veins-O2_veins_set) );
    delta_O2_control= 1./tau_O2 * (1 - 1./(1+exponential_O2) -O2_control);
    
    %% apply the change in all the magnitudes:
    V_ES = V_ES+delta_V_ES*dt; % the end diastolic volume
    V_ED = V_ED+delta_V_ED*dt; % the end diastolic volume
    V_a = V_a + dt*delta_V_a; % the volume in the arteries
    V_v = V_v + dt*delta_V_v; % the volume in the veins
    S =S+ dt*delta_S; %the baroreflex output 
    % steady state S:
    %S=1-1./(1+exp(-k_width.*(P_a-P_a_set) ) );
    
    O2_control =O2_control+ dt*delta_O2_control; %the oxygen control reflex

    % save values:
    V_ES_save(i) = V_ES;
    V_ED_save(i) = V_ED;
    V_a_save(i) = V_a;
    V_v_save(i) = V_v;
    S_save(i) = S;
    P_a_save(i)=P_a;
    P_v_save(i)=P_v;
    f_HR_save(i)=f_HR;
    P_LV_ES_save(i)=P_LV_ES;
    P_p_Save(i)=(V_ED-V_ES)/C_a;
    Rtpr_save(i)=R_TPR;
    cardiac_output_save(i)=cardiac_output;
    blood_flow_save(i)=peripheral_blood_flow;
    HRV_save(i)=alpha_HRV*S;
end