clear all;
% load('modele/model_1_neur_6.mat');
% load('modele/II_6_model_4.mat');
load('modele/III_2_model_1_trainlm.mat','w1','w10','w2','w20');
load('dane.mat');

model_num = 1;

ym_l_oe = process_data.y;
for k = 5:sim_data.sim_length
	in_l_oe = [sim_data.u(k-3) sim_data.u(k-4) ym_l_oe(k-1) ym_l_oe(k-2)]';
% 	in_l_oe = [sim_data.u(k-3) sim_data.u(k-4) process_data.y(k-1) process_data.y(k-2)]';
	ym_l_oe(k) = w20 + w2*tanh(w10+w1*in_l_oe);
end
lEoe = sum((ym_l_oe-process_data.y).^2)/length(ym_l_oe);

figure
str = 'Training data';
plot(process_data.y);
hold on;
plot(ym_l_oe,'--');
title(str);
xlabel('Time (k)');
ylabel('y(k)');
legend('Process','Model','location','southoutside');
print('choice_model_training','-dpng','-r400');

figure
scatter(process_data.y,ym_l_oe,'.');
title(sprintf('OE error=%d',lEoe));
xlabel('Process output');
ylabel('Model output');
print('choice_model_training_y','-dpng','-r400');

clear process_data sim_data;
load('dane_wer.mat');

ym_v_oe = process_data.y;
for k = 5:sim_data.sim_length
	in_v_oe = [sim_data.u(k-3) sim_data.u(k-4) ym_v_oe(k-1) ym_v_oe(k-2)]';
% 	in_v_oe = [sim_data.u(k-3) sim_data.u(k-4) process_data.y(k-1) process_data.y(k-2)]';
	ym_v_oe(k) = w20 + w2*tanh(w10+w1*in_v_oe);
end
vEoe = sum((ym_v_oe-process_data.y).^2)/length(ym_v_oe);

figure
str = 'Verification data';
plot(process_data.y);
hold on;
plot(ym_v_oe,'--');
title(str);
xlabel('Time (k)');
ylabel('y(k)');
legend('Process','Model','location','southoutside');
print('choice_model_ver','-dpng','-r400');

figure
scatter(process_data.y,ym_v_oe,'.');
title(sprintf('OE error=%d',vEoe));
xlabel('Process output');
ylabel('Model output');
print('choice_model_ver_y','-dpng','-r400');

