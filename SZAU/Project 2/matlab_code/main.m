make_plots = 0;
printing = 0;
save_data = 0;

% Initialize simulation
init_sim
global sim_data;

% Generate input data for the process simulation
u_gen

if make_plots==1
	figure(1);
	plot(sim_data.u);
	title('U');
	if printing == 1
		print('input_data','-dpng','-r400');
	end
end
% Initialize the process
init_process
global process_data;

for k = sim_data.delay+1:sim_data.sim_length
	step_process(k);
end

if make_plots==1
	figure(2)
	plot(process_data.y);
	title('Y');
	if printing == 1
		print('output_data','-dpng','-r400');
	end
end

if save_data == 1
	if sim_data.datatype == 1
		file = fopen('dane.txt','w');
		save('dane.mat','sim_data','process_data');
	elseif sim_data.datatype == 2
		file = fopen('dane_wer.txt','w');
		save('dane_wer.mat','sim_data','process_data');
	elseif sim_data.datatype == 3
		file = fopen('dane_test.txt','w');
		save('dane_test.mat','sim_data','process_data');
	else
		fprintf('error while saving data');
		return
	end
	for k = 1:sim_data.sim_length
		fprintf(file,'%2.16e ',sim_data.u(k));
		fprintf(file,'%2.16e\r\n',process_data.y(k));
	end
	fclose(file);
end