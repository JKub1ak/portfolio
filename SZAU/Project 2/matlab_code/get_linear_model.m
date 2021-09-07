save_data = 0;

load('dane.mat');
u = sim_data.u';
y = process_data.y';
D = sim_data.sim_length;
delay = sim_data.delay;
params = 4;

M = [u(2:D-delay) u(1:D-delay-1) y(delay+1:D-1) y(delay:D-2)];
W = M\y(delay+2:D);


ym_l_oe = process_data.y;
% for k = 5:sim_data.sim_length
% 	in_l_oe = [sim_data.u(k-3) sim_data.u(k-4) ym_l_oe(k-1) ym_l_oe(k-2)]';
% 	ym_l_oe(k) = w20 + w2*tanh(w10+w1*in_l_oe);
% end
ym_l_oe(5:sim_data.sim_length) = M*W;
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
% print('linear_model_training','-dpng','-r400');

figure
scatter(process_data.y,ym_l_oe,'.');
title(sprintf('OE error=%d',lEoe));
xlabel('Process output');
ylabel('Model output');
% print('linear_model_training_y','-dpng','-r400');

clear process_data sim_data;
load('dane_wer.mat');
u = sim_data.u';
y = process_data.y';
D = sim_data.sim_length;
delay = sim_data.delay;

M = [u(2:D-delay) u(1:D-delay-1) y(delay+1:D-1) y(delay:D-2)];

ym_v_oe = process_data.y;
% for k = 5:sim_data.sim_length
% 	in_v_oe = [sim_data.u(k-3) sim_data.u(k-4) ym_v_oe(k-1) ym_v_oe(k-2)]';
% 	ym_v_oe(k) = w20 + w2*tanh(w10+w1*in_v_oe);
% end
ym_v_oe(5:sim_data.sim_length) = M*W;
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
% print('linear_model_ver','-dpng','-r400');

figure
scatter(process_data.y,ym_v_oe,'.');
title(sprintf('OE error=%d',vEoe));
xlabel('Process output');
ylabel('Model output');
% print('linear_model_ver_y','-dpng','-r400');

if save_data == 1
	save('modele/linear_model.mat','W');
end