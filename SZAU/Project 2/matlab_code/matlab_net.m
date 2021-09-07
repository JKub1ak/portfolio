load('dane.mat');


net = feedforwardnet(6);
net.divideParam.testRatio = 0;
net.divideParam.valRatio = 0;
net.divideParam.trainRatio = 1;

% net.trainFcn = 'trainlm'; 
net.trainFcn = 'trainscg';

net.trainParam.showWindow = false;
% net.trainParam.goal = 0.00001;

net.inputs{1}.processFcns = {};
net.outputs{2}.processFcns = {};

model_num = 1;
while 1
	if exist(sprintf('modele/III_2_model_%d_%s.mat',model_num,net.trainFcn),'file') ~= 0
		model_num = model_num+1;
	else
		break;
	end
end

s = 5;
l = sim_data.sim_length;

x = [sim_data.u(s-3:l-3);
	 sim_data.u(s-4:l-4);
	 process_data.y(s-1:l-1);
	 process_data.y(s-2:l-2)];
 
y = process_data.y(s:l);

net = train(net,x,y);

% Dig out weights and biases
w20 = net.b{2};
w2 = net.LW{2,1};
w10 = net.b{1};
w1 = net.IW{1};


% y1 = process_data.y;
% for k=s:l
% 	in_arx = [sim_data.u(k-3) sim_data.u(k-4) process_data.y(k-1) process_data.y(k-2)]';
% % 	y1(k) = net(in_arx);
% 	y1(k) = w20 + w2*tanh(w10+w1*in_arx);
% end

% figure
% plot(process_data.y);
% hold on
% plot(y1);
% legend('Process','Model','location','southoutside');

clear sim_data process_data;
load('dane_wer.mat');

y2 = process_data.y;
for k=s:l
	in_arx = [sim_data.u(k-3) sim_data.u(k-4) process_data.y(k-1) process_data.y(k-2)]';
% 	y2(k) = net(in_arx);
	y2(k) = w20 + w2*tanh(w10+w1*in_arx);
end
Earx = sum((y2-process_data.y).^2)/length(y2);

figure
str = sprintf('MatLab net model ARX trained with %s',net.trainFcn);
plot(process_data.y);
title(str);
hold on
plot(y2);
legend('Process','Model','location','southoutside');
% print(sprintf('out/arx_matlab_net_%d_%s',model_num,net.trainFcn),'-dpng','-r400');

y3 = process_data.y;
for k=s:l
	in_oe = [sim_data.u(k-3) sim_data.u(k-4) y3(k-1) y3(k-2)]';
% 	y3(k) = net(in_oe);
	y3(k) = w20 + w2*tanh(w10+w1*in_oe);
end
Eoe = sum((y3-process_data.y).^2)/length(y3);

figure
str = sprintf('MatLab net model OE trained with %s',net.trainFcn);
plot(process_data.y);
title(str);
hold on
plot(y3);
legend('Process','Model','location','southoutside');
% print(sprintf('out/oe_matlab_net_%d_%s',model_num,net.trainFcn),'-dpng','-r400');

% save(sprintf('modele/III_2_model_%d_%s.mat',model_num,net.trainFcn),'w20','w2','w10','w1');