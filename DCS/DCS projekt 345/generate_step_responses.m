% 1 - show pictures
figurative = 1;
% 1 - get step response
get_step = 0;

% Matrix of base values for [hr hl fr fl]
% base_matrix =  [50 50 30 30;
% 				50 50 60 60];
% base_matrix = [0 0 30 30];
% base_matrix =  [ 0  0 30 30;
% 				 0  0 30 60;
% 				 0  0 60 30;
% 				 0  0 60 60;
% 				50  0 30 30;
% 				50  0 30 60;
% 				50  0 60 30;
% 				50  0 60 60;
% 				 0 50 30 30;
% 				 0 50 30 60;
% 				 0 50 60 30;
% 				 0 50 60 60;
% 				50 50 30 30;
% 				50 50 30 60;
% 				50 50 60 30;
% 				50 50 60 60];
% base_matrix =  [30 30 30 30;
% 				30 30 30 60;
% 				30 30 60 30;
% 				30 30 60 60;
% 				60 30 30 30;
% 				60 30 30 60;
% 				60 30 60 30;
% 				60 30 60 60;
% 				30 60 30 30;
% 				30 60 30 60;
% 				30 60 60 30;
% 				30 60 60 60;
% 				60 60 30 30;
% 				60 60 30 60;
% 				60 60 60 30;
% 				60 60 60 60];
base_matrix = [50 31.4422 61.5 66.75]; % Punkt pracy


% Matrix of step values to be added to above in simulation
step_matrix = [0 1 0 0];
% step_matrix =  [0 1 0 0;
% 				0 0 1 0;
% 				0 0 0 1];
% step_matrix =  [1 0 0 0;
% 				0 1 0 0];
% step_matrix =  [1 0 0 0;
% 				0 1 0 0;
% 				0 0 1 0;
% 				0 0 0 1];

% Length of the simulation
simLength = 4000;

% 1 - Stabilize object before starting the sim propper
stabilize = 1;
% Length of stabilization period
stabilizeLength = 2000;
			   
step_response = zeros(length(base_matrix(:,1)),length(step_matrix(:,1)),simLength);
for l = 1:length(base_matrix(:,1))
	for i = 1:length(step_matrix(:,1))

		% Initialize only here
		init_simulator

		tl = TLamb;
		tr = TRamb;
	% Pass stabilizuj¹cy
		if stabilize == 1
			% Initilize things
			hr = base_matrix(l, 1);
			hl = base_matrix(l, 2);
			fr = base_matrix(l, 3);
			fl = base_matrix(l, 4);

			% Run sim here
			sim_length = stabilizeLength;
			clean_run_sim
		end

	% Pass stepowy

		% Initilize things
		hr = base_matrix(l, 1)+step_matrix(i,1);
		hl = base_matrix(l, 2)+step_matrix(i,2);
		fr = base_matrix(l, 3)+step_matrix(i,3);
		fl = base_matrix(l, 4)+step_matrix(i,4);

		% Run sim here
		sim_length = simLength;
		clean_run_sim

		if get_step == 1
			step_response(l,i,:) = TLv;
		end

		if figurative == 1
			figure;
			subplot(4,1,1);
			plot(FLv,'r');
			hold on;
			grid on;
			plot(FRv, 'b--');
			xlabel('k');
			ylabel('U(k)');
			title('Sterowanie wentylatorów - zakLócenie DV');
			legend('FLU', 'FRU');

			subplot(4,1,2);
			plot(HLv,'r');
			hold on;
			grid on;
			plot(HRv, 'b--');
			xlabel('k');
			ylabel('U(k)');
			title('Sterowanie grzaLek');
			legend('HL', 'HR');

			subplot(4,1,3);
			plot(TLv,'r');
			hold on;
			grid on;
			xlabel('k');
			ylabel('TL(k)');
			title('Temperatura lewa TL - Step Response');
			legend('TL');

			subplot(4,1,4);
			plot(TRv,'r');
			hold on;
			grid on;
			xlabel('k');
			ylabel('TR(k)');
			title('Temperatura prawa TR - Step Response');
		end
	end
end