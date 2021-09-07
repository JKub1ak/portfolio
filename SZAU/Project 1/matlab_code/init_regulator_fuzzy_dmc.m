
"Initializing fuzzy dmc"

load("step_responses/STEP_fuzzy3_10s.mat");
global fuzzy_dmc_data;

% Choose membership function:
% 0 - trapmf() and triamf()
% 1 - sigmf() and dsigmf()
fuzzy_dmc_data.mf = 0;

% Break points of membership functions (used if mf==0)
fuzzy_dmc_data.points = TS_data.points;
% fuzzy_dmc_data.points = [10398, data.Vp(2), 15097];

% Sigma values of membership functions (used if mf==1)
fuzzy_dmc_data.slopes = [0.0025, 0.0025, 0.0025, 0.0025];


lambda = 1;
% Process the step response
fuzzy_dmc_data.step_r = STEP_RESPONSE-STEP_RESPONSE(:,1);
fuzzy_dmc_data.D = 4000; % in seconds
fuzzy_dmc_data.D = int32(fuzzy_dmc_data.D*steps_per_second);
fuzzy_dmc_data.N =  int32(2000*steps_per_second);
fuzzy_dmc_data.Nu = 1;
psi = 1;
Lambda = eye(fuzzy_dmc_data.Nu)*lambda;
Psi = eye(fuzzy_dmc_data.N)*psi;

% Prep M matrices
M1 = zeros(fuzzy_dmc_data.N,fuzzy_dmc_data.Nu);
for i=1:fuzzy_dmc_data.N
   for j=1:fuzzy_dmc_data.Nu
	  if (i>=j)
		 M1(i,j)=fuzzy_dmc_data.step_r(1,i-j+1);
	  end
   end
end
M2 = zeros(fuzzy_dmc_data.N,fuzzy_dmc_data.Nu);
for i=1:fuzzy_dmc_data.N
   for j=1:fuzzy_dmc_data.Nu
	  if (i>=j)
		 M2(i,j)=fuzzy_dmc_data.step_r(2,i-j+1);
	  end
   end
end
M3 = zeros(fuzzy_dmc_data.N,fuzzy_dmc_data.Nu);
for i=1:fuzzy_dmc_data.N
   for j=1:fuzzy_dmc_data.Nu
	  if (i>=j)
		 M3(i,j)=fuzzy_dmc_data.step_r(3,i-j+1);
	  end
   end
end

% Prep K matrices (Nu x N)
fuzzy_dmc_data.K1 = (M1'*Psi*M1+Lambda)^(-1)*M1'*Psi;
fuzzy_dmc_data.K2 = (M2'*Psi*M2+Lambda)^(-1)*M2'*Psi;
fuzzy_dmc_data.K3 = (M3'*Psi*M3+Lambda)^(-1)*M3'*Psi;

% Prep MP matrices
fuzzy_dmc_data.MP1=zeros(fuzzy_dmc_data.N,fuzzy_dmc_data.D-1);
for i=1:fuzzy_dmc_data.N
   for j=1:fuzzy_dmc_data.D-1
	  if i+j<=fuzzy_dmc_data.D
		 fuzzy_dmc_data.MP1(i,j)=fuzzy_dmc_data.step_r(1,i+j)-fuzzy_dmc_data.step_r(1,j);
	  else
		fuzzy_dmc_data. MP1(i,j)=fuzzy_dmc_data.step_r(1,fuzzy_dmc_data.D)-fuzzy_dmc_data.step_r(1,j);
	  end
   end
end
fuzzy_dmc_data.MP2=zeros(fuzzy_dmc_data.N,fuzzy_dmc_data.D-1);
for i=1:fuzzy_dmc_data.N
   for j=1:fuzzy_dmc_data.D-1
	  if i+j<=fuzzy_dmc_data.D
		 fuzzy_dmc_data.MP2(i,j)=fuzzy_dmc_data.step_r(2,i+j)-fuzzy_dmc_data.step_r(2,j);
	  else
		fuzzy_dmc_data. MP2(i,j)=fuzzy_dmc_data.step_r(2,fuzzy_dmc_data.D)-fuzzy_dmc_data.step_r(2,j);
	  end
   end
end
fuzzy_dmc_data.MP3=zeros(fuzzy_dmc_data.N,fuzzy_dmc_data.D-1);
for i=1:fuzzy_dmc_data.N
   for j=1:fuzzy_dmc_data.D-1
	  if i+j<=fuzzy_dmc_data.D
		 fuzzy_dmc_data.MP3(i,j)=fuzzy_dmc_data.step_r(3,i+j)-fuzzy_dmc_data.step_r(3,j);
	  else
		fuzzy_dmc_data. MP3(i,j)=fuzzy_dmc_data.step_r(3,fuzzy_dmc_data.D)-fuzzy_dmc_data.step_r(3,j);
	  end
   end
end
