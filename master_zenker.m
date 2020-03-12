% master code: Zenker
clear all
close all
% run the physilogical dynamics:

%% define physilogical parameters:
parametrs_zenker

%% running parameters:
time_total=3600;
dt=0.01;
iterations=time_total/dt;

%% shock parameters:
withdrawal_rate_vec=0.25;%[0 0.1 0.25 0.4];
c_PRSW_max_vec=70;%[30 50 70 100];
M_C_vec=0.6;%[0 0.2 0.4 0.6 0.8];

for withdrawal_rate=withdrawal_rate_vec
    for c_PRSW_max=c_PRSW_max_vec
        for M_C=M_C_vec
            %withdrawal_rate=0.25; %(ml/sec)
            %c_PRSW_max=50;%103.8;% mm Hg % the maximal contractility
            %M_C=0.7;% metabolic consumption
            %C_a_values=[0.5:0.1:2];
            %for C_a=C_a_values
            %% initial conditions:
            % the following valus are taken from zenker. Note that the first element of
            % y0 is actually two elements!!!!!!
            V_ED_start =70; %10*7.144138964462638;%3*7.144138964462638; % mm 140 the initial condition is V0lv in the attached file y0(4)
            V_ES_start = 20;%2*7.144138964462638 ; %mm 40 same as in zenker (line 357 in file do2sim) y0(4)
            
            totalVolume= 2250;%1500; % a guess - ask danny
            %VaUnstressed = 700;
            meanVvU = (V_v0_min+ V_v0_max)/2;
            
            V_a_start =450;% totalVolume/ (VaUnstressed + meanVvU) *VaUnstressed; % same as in zenker (line 357 in file do2sim) y0(1)
            V_v_start =totalVolume-V_a_start;%totalVolume/ (VaUnstressed + meanVvU) * meanVvU; % same as in zenker (line 357 in file do2sim) y0(2)
            S_start =0.5 ;   % same as in zenker (line 357 in file do2sim) y0(3)
            O2_control_start=0.5; % initial value for oxygen control reflex
            
            
            %% liquid supply:
            start_withdrawl=500;
            finish_withdrawl=1500;
            start_suply=2000;
            finish_suply=3000;
            if finish_suply>time_total
                error('finish_suply should be smaller than total_time')
            end
            I_ex=zeros(1,iterations);
            I_ex(start_withdrawl/dt:finish_withdrawl/dt)=-withdrawal_rate;
            I_ex(start_suply/dt:finish_suply/dt)=withdrawal_rate;
            
            %% dynamics:
            
            run_dynamics
            
            %% validate the subject:
            validate_subject
            
            %% save
            if correct_validation==1
                save(sprintf('subject_I_ex_%g_M_%g_max_C_PRSW_%g.mat',withdrawal_rate,M_C,c_PRSW_max))
            end
            %end
            
        end
    end
end

%% plot results

figure(1);
plot([1:iterations]*dt,V_ES_save)
xlabel('time')
title('end systolic volume')

figure(2);
plot([1:iterations]*dt,V_ED_save)
xlabel('time')
title('end diastolic volume')

figure(3);
plot([1:iterations]*dt,V_a_save)
xlabel('time')
title('arterial volume')

figure(4);
plot([1:iterations]*dt,V_v_save)
xlabel('time')
title('venous volume')

figure(5);
plot([1:iterations]*dt,S_save)
xlabel('time')
title('baroreflex')

figure(6);
hold all
xlabel('time')
plot([1:iterations]*dt,P_a_save)
plot([1:iterations]*dt,f_HR_save*60)
plot([1:iterations]*dt,cardiac_output_save)
plot([1:iterations]*dt,P_v_save)
%plot([1:iterations]*dt,P_LV_ES_save)
%plot([1:iterations]*dt,blood_flow_save)
legend('Arterial pressure (mmHg)','heart rate (bpm)','cardiac output (ml/s)','Venous pressure (mmHg)')%,'P_LV_ES')%,'peripheral blood flow')
ylim([0 180])


% make an EPS figure
h=figure(6);
set(h,'PaperPositionMode','auto')
set(h,'position', [1 1 700 700]);
ax=gca;
%axis([-00 100 0 0.12])
set(ax,'FontSize',15)
figure_name='healthy_patient';
saveas(h,figure_name,'eps2c')




