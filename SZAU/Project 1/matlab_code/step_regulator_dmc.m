function reg = step_regulator_dmc(Uv, Yv, K)
	
	% Get globals
	global dmc_data setpoint data time_step;
	D = dmc_data.D;
	k = K-1;
	
	% Regulator startup condition
	if k > 3
		Y0 = Yv(k);
	else
		reg = Uv(1);
		return;
	end
	
	% Calculate regulation
	DY = setpoint-Y0;
	if k < D+1
		DU = [(fliplr(Uv(2:k)-Uv(1:k-1)))';zeros(D-k,1)];
	else
		DU = (fliplr(Uv(k-D+2:k)-Uv(k-D+1:k-1)))';
	end
	DUk = dmc_data.K(1,:)*(DY-dmc_data.MP*DU);
	
	% Check boundry condition
	if abs(DUk) > data.max_DUs*time_step
		DUk = data.max_DUs*sign(DUk);
	end
	
	% Calculate final regulation
	reg = Uv(k) + DUk;
	
	% Check another boundry condition
	if reg > data.Fin_MAX
		reg = data.Fin_MAX;
	elseif reg < data.Fin_MIN
		reg = data.Fin_MIN;
	end
end

