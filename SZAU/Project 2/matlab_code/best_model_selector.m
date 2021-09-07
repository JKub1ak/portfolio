clear all;
neuron_num = 6;
model_num = 0;
arx_err_v = zeros(1,2500);
oe_err_v = zeros(1,2500);
arx_qerr = zeros(1,5);
oe_qerr = zeros(1,5);
while 1
	model_num = model_num+1;
% 	model_string = sprintf('modele/model_%d_neur_%d.mat',model_num,neuron_num);
% 	model_string = sprintf('modele/II_5_model_%d.mat',model_num);
% 	model_string = sprintf('modele/II_6_model_%d.mat',model_num);
% 	model_string = sprintf('modele/III_2_model_%d_trainscg.mat',model_num);
	model_string = sprintf('modele/III_2_model_%d_trainlm.mat',model_num);
	if exist(model_string,'file') == 0
		break;
	end
	
	load('dane_wer.mat');
	load(model_string,'w1','w10','w2','w20');
	
	ym_arx = process_data.y;
	ym_oe = ym_arx;
	for k = 5:sim_data.sim_length
		in_arx = [sim_data.u(k-3) sim_data.u(k-4) process_data.y(k-1) process_data.y(k-2)]'; 
		ym_arx(k) = w20 + w2*tanh(w10+w1*in_arx);

		in_oe = [sim_data.u(k-3) sim_data.u(k-4) ym_oe(k-1) ym_oe(k-2)]';
		ym_oe(k) = w20 + w2*tanh(w10+w1*in_oe);
	end
	arx_err_v = process_data.y - ym_arx;
	oe_err_v = process_data.y - ym_oe;
	arx_qerr(model_num) = sum(arx_err_v.^2)/length(arx_err_v);
	oe_qerr(model_num) = sum(oe_err_v.^2)/length(oe_err_v);
	
	clear w1 w10 w2 w20;
end

[min_arx_qerr, min_arx_qerr_index] = min(arx_qerr);
 [min_oe_qerr, min_oe_qerr_index]  = min(oe_qerr);

fprintf(...
	sprintf('\nneuron count: %d\narx_qerr=%d of model number %d\noe_qerr=%d of model number %d\n\n',...
		neuron_num,min_arx_qerr,min_arx_qerr_index,min_oe_qerr,min_oe_qerr_index))


