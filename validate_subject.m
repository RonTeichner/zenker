%% validate the subject
correct_validation=1;
%% check total volume:
if isempty(find((V_a_save+V_v_save)>4000))==0
        correct_validation=0;
end
if isempty(find((V_a_save+V_v_save)<500))==0
        correct_validation=0;
end

%% check diastola:
if isempty(find((V_ED_save)>200))==0
        correct_validation=0;
end
if isempty(find((V_ED_save)<10))==0
        correct_validation=0;
end

%% check heart rate
if isempty(find((f_HR)>=F_HR_max))==0
        correct_validation=0;
end
if isempty(find((f_HR)<F_HR_min))==0
        correct_validation=0;
end
if correct_validation==0
    % write the parameters of the non viable subject:
    non_validated=sprintf('non_validated_subject_I_ex_%g_M_%g_max_C_PRSW_%g.mat',withdrawal_rate,M_c,c_PRSW_max);
    disp(non_validated)
end