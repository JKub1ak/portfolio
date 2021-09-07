function reg = step_regulator_fuzzy_dmc(Uv, Yv, K)

	% Get globals
	global fuzzy_dmc_data setpoint data time_step;
	D = fuzzy_dmc_data.D;
	k = K-1;
	
	% Regulator startup condition
	if k > 3
		Y0 = Yv(k);
	else
		reg = Uv(1);
		return;
	end
	
	% Calculate membership
	if fuzzy_dmc_data.mf == 1
		p(1) = 1-sigmf(Y0,[fuzzy_dmc_data.slopes(1),10999]);
		p(2) = dsigmf(Y0,[fuzzy_dmc_data.slopes(2),10999,fuzzy_dmc_data.slopes(3),14519]);
		p(3) = sigmf(Y0,[fuzzy_dmc_data.slopes(4),14519]);
	else
		p(1) = trapmf(Y0,[0, 0, fuzzy_dmc_data.points(1), fuzzy_dmc_data.points(2)]);
		p(2) = trimf(Y0,[fuzzy_dmc_data.points(1), fuzzy_dmc_data.points(2), fuzzy_dmc_data.points(3)]);
		p(3) = trapmf(Y0,[fuzzy_dmc_data.points(2), fuzzy_dmc_data.points(3), inf, inf]);
	end

	% Calculate regulations from each local regulator
	DY = setpoint-Y0;
	if k < D+1
		DU = [(fliplr(Uv(2:k)-Uv(1:k-1)))';zeros(D-k,1)];
	else
		DU = (fliplr(Uv(k-D+2:k)-Uv(k-D+1:k-1)))';
	end
	DUk(1) = fuzzy_dmc_data.K1(1,:)*(DY-fuzzy_dmc_data.MP1*DU);
	
	if k < D+1
		DU = [(fliplr(Uv(2:k)-Uv(1:k-1)))';zeros(D-k,1)];
	else
		DU = (fliplr(Uv(k-D+2:k)-Uv(k-D+1:k-1)))';
	end
	DUk(2) = fuzzy_dmc_data.K2(1,:)*(DY-fuzzy_dmc_data.MP2*DU);
	
	if k < D+1
		DU = [(fliplr(Uv(2:k)-Uv(1:k-1)))';zeros(D-k,1)];
	else
		DU = (fliplr(Uv(k-D+2:k)-Uv(k-D+1:k-1)))';
	end
	DUk(3) = fuzzy_dmc_data.K3(1,:)*(DY-fuzzy_dmc_data.MP3*DU);
	
	% Sum it together
	DUK = 0;
	for i = 1:length(DUk)
		DUK = DUK + p(i)*DUk(i);
	end
	
	% Normalize
	DUK = DUK/sum(p);
	
	% Check boundry condition
	if abs(DUK) > data.max_DUs*time_step
		DUK = data.max_DUs*sign(DUK);
	end
	% Calculate final regulation
	reg = Uv(k) + DUK;
	
	% Check another boundry condition
	if reg > data.Fin_MAX
		reg = data.Fin_MAX;
	elseif reg < data.Fin_MIN
		reg = data.Fin_MIN;
	end
end
