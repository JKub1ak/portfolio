%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
global data;

% Length of simulation
global simLength; simLength = 10000; %s

% Default input values
Fin0 = 78;  %cm^3/s
FD0 = 29.5; %cm^3/s

% Model linearization:
% 0 - nonlinear model
% 1 - model linearized around data.Vps
% k - fuzzy model with k local linearizations, 1<k<6
global linear; linear = 0;

% Variable determins if the simulation should be initiated
% 0 - no initiation (it must have been initiated already)
% 1 - initiate sim
init_sim = 1;

% Initialize simulation
if init_sim ~= 0
	init_simulation
	init_TS
end

% Regulator:
% 0 - no regulator
% 2 - dmc
% 3 - fuzzy dmc
regulator = 0;

% Value V2 the regulators try to achieve
global setpoint; setpoint = 13500; %cm^3

% Specifies which noise to implement:
% 0 - no noise
% 1 - fast changing noise with low amplitude
% 2 - moderetely quickly changing noise with low amplitude
% 3 - slowly changing nosie with low amplitude
% 4 - very slowly changing nosie with large amplitude (simLength ~20000s)
noise = 0;

% Preallocation of arrays
Fin = ones(1,simLength*steps_per_second);
FD = ones(1,simLength*steps_per_second);
V1 = zeros(1,simLength*steps_per_second);
V2 = zeros(1,simLength*steps_per_second);
Fin = Fin*Fin0;
FD = FD*FD0;

% Noise construction
if noise == 1
	for j = 1:length(FD)
		if 3000*steps_per_second <j && j< 3500*steps_per_second
			FD(j) = FD(j)+3;
		end
		if 4000*steps_per_second <j && j< 4250*steps_per_second
			FD(j) = FD(j)-3;
		end
		if 4250*steps_per_second <j && j< 5000*steps_per_second
			FD(j) = FD(j)+5;
		end
		if 5500*steps_per_second <j && j< 6500*steps_per_second
			FD(j) = FD(j)-5;
		end
		if 8000*steps_per_second <j && j< 9000*steps_per_second
			FD(j) = FD(j)+3;
		end
	end
elseif noise == 2
	for j = 1:length(FD)
		if 3000*steps_per_second <j && j< 5000*steps_per_second
			FD(j) = FD(j)+3;
		end
		if 7000*steps_per_second <j && j< 10000*steps_per_second
			FD(j) = FD(j)-3;
		end
	end
elseif noise == 3
	for j = 1:length(FD)
		if 3000*steps_per_second <j && j< 7000*steps_per_second
			FD(j) = FD(j)+3;
		end
	end
elseif noise == 4
	for j = 1:length(FD)
		if j > 3000*steps_per_second && j < 13000*steps_per_second
			FD(j) = 2*FD(j);
		end
	end
end

% Initialize regulator
if regulator == 2
	init_regulator_dmc
elseif regulator == 3
	init_regulator_fuzzy_dmc
end

% Main loop
"Starting main loop"
for k = 1:int32(simLength*steps_per_second)
	
	
% 	Regulation step
	if regulator == 2
		Fin(k) = step_regulator_dmc(Fin, V2, k);
	elseif regulator == 3
		Fin(k) = step_regulator_fuzzy_dmc(Fin,V2,k);
	end
	
% 	Input delay
	if k > data.thau*steps_per_second
		F1in = Fin(int32(k-data.thau*steps_per_second));
	else 
		F1in = Fin(1);
	end
	
% 	Simulation step
	fd = FD(k);
	[V1(k),V2(k)] = step_simulation(V1_last,V2_last,F1in,fd);
	V1_last = V1(k);
	V2_last = V2(k);
end

time_points = time_step:time_step:simLength;
figure
	subplot(2,1,1);
	plot(time_points,V2);

	subplot(2,1,2);
	plot(time_points,Fin);