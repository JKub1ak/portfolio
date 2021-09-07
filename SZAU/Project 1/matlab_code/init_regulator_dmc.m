"Initializing dmc"

load("step_responses/STEP_WPto79lin_10s.mat");
global dmc_data;

lambda = 1;
% Process the step response
dmc_data.step_r = STEP_WPto79-STEP_WPto79(1);
dmc_data.D = 4000; % in seconds
dmc_data.D = int32(dmc_data.D*steps_per_second);
if linear == 1
	dmc_data.N =  int32(2000*steps_per_second);
else
	dmc_data.N =  int32(2000*steps_per_second);
end
dmc_data.Nu = 1;
psi = 1;
Lambda = eye(dmc_data.Nu)*lambda;
Psi = eye(dmc_data.N)*psi;

% Prep M matrix
M = zeros(dmc_data.N,dmc_data.Nu);
for i=1:dmc_data.N
   for j=1:dmc_data.Nu
	  if (i>=j)
		 M(i,j)=dmc_data.step_r(i-j+1);
	  end
   end
end

% Prep K matrix (Nu x N)
dmc_data.K = (M'*Psi*M+Lambda)^(-1)*M'*Psi;

% Prep MP matrix
dmc_data.MP=zeros(dmc_data.N,dmc_data.D-1);
for i=1:dmc_data.N
   for j=1:dmc_data.D-1
	  if i+j<=dmc_data.D
		 dmc_data.MP(i,j)=dmc_data.step_r(i+j)-dmc_data.step_r(j);
	  else
		dmc_data. MP(i,j)=dmc_data.step_r(dmc_data.D)-dmc_data.step_r(j);
	  end
   end
end
