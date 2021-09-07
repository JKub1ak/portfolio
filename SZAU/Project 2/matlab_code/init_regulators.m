global regulator_data;
global process_data sim_data;

regulator_data.algorithm = 2;	% 0 - neural network model and NPL algorithm
								% 1 - linear model and GPC algorithm
								% 2 - PID

% Lets predictive regulators see changes to y_req
regulator_data.foresight = 0;	% 0 - no foresight
								% 1 - yes foresight

if regulator_data.algorithm == 0
	load('modele/model_1_neur_6.mat','w1','w10','w2','w20');
elseif regulator_data.algorithm == 1
	load('modele/linear_model.mat');
end

N = 20;
% N = 50;
% Nu = 2;
Nu = N;
% lambda = 30;
% lambda = 500;
% lambda = 800;
lambda = 1000;
% lambda = 1;

regulator_data.N = N;
regulator_data.Nu = Nu;
regulator_data.lambda = lambda;

if regulator_data.algorithm == 2
	Kk = 1; Tk = 15;
	
% 	K = 1;
% 	Ts = 1;
% 	Ks = 0;
% 	Td = 0;
 	
% 	K = 0.6*Kk;
% 	Ts = 0.5*Tk;
% 	Ks = 1;
% 	Td = 0.125*Tk;
	
	K = 0.5*Kk * 0.25;
	Ts = Tk*0.5;
	Ks = 1;
	Td = Tk*0.01;
	
	regulator_data.K = K;
	regulator_data.Ts = Ts;
	regulator_data.Ks = Ks;
	regulator_data.Td = Td;
	
	integral = 0;
	regulator_data.T = 1;
end

regulator_data.delta = 0.000001; % Numerical derivative length

regulator_data.delay = 4;
regulator_data.y_mod = process_data.y;
regulator_data.d = zeros(sim_data.sim_length);
regulator_data.save_s = zeros(sim_data.sim_length,regulator_data.N);

regulator_data.linear_weights = zeros(sim_data.sim_length,4);

regulator_data.y_req = zeros(1,sim_data.sim_length);
y_zad_gen
% regulator_data.y_req(50:1000) = 0.5;
% regulator_data.y_req(1000:1750) = -3;
% regulator_data.y_req(1750:sim_data.sim_length) = -1.6;
% regulator_data.y_req = ones(1,sim_data.sim_length)*-0.1;

regulator_data.min_dU = -inf;
regulator_data.max_dU = inf;


	
% Calculate GPC model
if regulator_data.algorithm == 1
	% b1 = W(3); b2 = W(4); c1 = 0; c2 = 0; c3 = W(1); c4 = W(2);
	n = 2; m = 4; 
	b = W(3:4)';
	c = [0 0 W(1:2)'];

	b_f = zeros(1,n+1); % b z falką i tylko dolnym indeksem
	b_f(1) = b(1)+1;
	for i=2:n
		b_f(i) = b(i)-b(i-1);
	end
	b_f(n+1) = -b(n);

	bf = zeros(regulator_data.N+1,n+1);	% b z falką i indeksami górnym i dolnym
	for j=1:n+1						% indexes moved by +1
		bf(1,j) = b_f(j);
	end
	for i=2:regulator_data.N+1
		for j=1:n+1
			if j<=n
				bf(i,j) = bf(i-1,1)*b_f(j)+bf(i-1,j+1);
			else
				bf(i,j) = bf(i-1,1)*b_f(j);
			end
		end
	end

	cf = zeros(regulator_data.N+1,m);		% c z falką i indeksami górnym i dolnym
	for j=1:m						% indexes moved by +1
		cf(1,j) = c(j);
	end
	for i=2:regulator_data.N+1
		for j=1:m
			if j<m
				cf(i,j) = bf(i-1,1)*c(j)+cf(i-1,j+1);
			else
				cf(i,j) = bf(i-1,1)*c(j);
			end
		end
	end
	
	% Calculate control matrix
	M = zeros(regulator_data.N,regulator_data.Nu);
	for i=1:regulator_data.N
		M(i,1)=cf(i,1);
	end
	for i=2:regulator_data.Nu
		M(i:regulator_data.N,i) = M(1:regulator_data.N-i+1,1);
	end
	
	% Calculate MP matrix
	MP = zeros(regulator_data.N,m-1);
	for i=1:regulator_data.N
		for j=1:m-1
			if i+j<=m
				MP(i,j)=cf(1,i+j)-cf(1,j);
			else
				MP(i,j)=cf(1,m)-cf(1,j);
			end
		end
	end
	

	% Calculate K matrix
	K = inv(M'*M+eye(regulator_data.Nu)*regulator_data.lambda)*M';
end


% 		elseif regulator_data.algorithm == 1
% 			for j=1:n+1
% 				y0(i) = y0(i) + bf(i-1,j)*process_data.y(k-1+j);
% 			end
% 			for j=2:m
% 				y0(i) = y0(i) + cf(i-1,j)*(sim_data.u(k+1-j)-sim_data.u(k-j));
% 			end
