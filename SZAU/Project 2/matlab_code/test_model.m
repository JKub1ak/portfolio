clear all;
run('sieci/uczenie.m');
run('sieci/model.m');
load('dane_wer.mat');

model_num = 1;
while 1
% 	if exist(sprintf('modele/model_%d_neur_%d.mat',model_num,length(w2)),'file') ~= 0
% 	if exist(sprintf('modele/II_5_model_%d.mat',model_num),'file') ~= 0
	if exist(sprintf('modele/II_6_model_%d.mat',model_num),'file') ~= 0
		model_num = model_num+1;
	else
		break;
	end
end

% print(sprintf('out/arx_%d_neur_%d_norm',model_num,length(w2)),'-dpng','-r400');
% print(sprintf('out/II_5_model_%d_norm',model_num),'-dpng','-r400');
close
% print(sprintf('out/arx_%d_neur_%d_learn',model_num,length(w2)),'-dpng','-r400');
% print(sprintf('out/II_5_model_%d_learn',model_num),'-dpng','-r400');
print(sprintf('out/II_6_model_%d_learn',model_num),'-dpng','-r400');
close

ym_arx = process_data.y;
ym_oe = ym_arx;
for k = 5:sim_data.sim_length
	in_arx = [sim_data.u(k-3) sim_data.u(k-4) process_data.y(k-1) process_data.y(k-2)]'; 
	ym_arx(k) = w20 + w2*tanh(w10+w1*in_arx);
	
	in_oe = [sim_data.u(k-3) sim_data.u(k-4) ym_oe(k-1) ym_oe(k-2)]';
	ym_oe(k) = w20 + w2*tanh(w10+w1*in_oe);
end

figure
str = sprintf('Model %d ARX with %d neurons',model_num,length(w2));
plot(process_data.y);
hold on;
plot(ym_arx);
title(str);
legend('Process','Model','location','southoutside');
% print(sprintf('out/arx_%d_neur_%d',model_num,length(w2)),'-dpng','-r400');

figure
scatter(process_data.y,ym_arx,'.');
title(sprintf('ARX error=%d',Earx));
% print(sprintf('out/arx_%d_neur_%d_err',model_num,length(w2)),'-dpng','-r400');

figure
str = sprintf('Model %d OE with %d neurons',model_num,length(w2));
plot(process_data.y);
hold on;
plot(ym_oe);
title(str);
legend('Process','Model','location','southoutside');
% print(sprintf('out/oe_%d_neur_%d',model_num,length(w2)),'-dpng','-r400');

figure
scatter(process_data.y,ym_oe,'.');
title(sprintf('OE error=%d',Eoe));
% print(sprintf('out/oe_%d_neur_%d_err',model_num,length(w2)),'-dpng','-r400');


% if exist('out/logs.txt','file') ~= 2
% 	file = fopen('out/logs.txt','a');
% 	fprintf(file,'neurons\tmodel\terr_arx\t\t\terr_oe\n');
% else
% 	file = fopen('out/logs.txt','a');
% end
% fprintf(file,sprintf('%d\t\t%d\t\t%d\t%d\n',length(w2),model_num,Earx,Eoe));
% fclose(file);
% save(sprintf('modele/model_%d_neur_%d.mat',model_num,length(w2)),'w20','w2','w10','w1','Earx','Eoe','farx','foe','krok','ng','wspucz');
% save(sprintf('modele/II_5_model_%d.mat',model_num),'w20','w2','w10','w1','Earx','Eoe','farx','foe','krok','ng','wspucz');
save(sprintf('modele/II_6_model_%d.mat',model_num),'w20','w2','w10','w1','Earx','Eoe','farx','foe','krok','ng','wspucz');
close all;
