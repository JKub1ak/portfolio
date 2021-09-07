global sim_data;
init_sim

global process_data;
init_process

global regulator_data;
init_regulators
s = zeros(1,regulator_data.N);

% Start simulation
for k = sim_data.delay+1:regulator_data.delay
	step_process(k); %model has one more time unit of delay
	regulator_data.y_mod(k) = process_data.y(k);
end
for k = regulator_data.delay+1:sim_data.sim_length
	% Process simulation
	step_process(k);
	
	% Model calculations
	in_arx = [sim_data.u(k-3) sim_data.u(k-4) process_data.y(k-1) process_data.y(k-2)];
	if regulator_data.algorithm == 0
		regulator_data.y_mod(k) = w20 + w2*tanh(w10+w1*in_arx');
	elseif regulator_data.algorithm == 1
		regulator_data.y_mod(k) = in_arx*W;
	end
	
	% Model error
	regulator_data.d(k) = process_data.y(k)-regulator_data.y_mod(k);
		
	y0=zeros(regulator_data.N,1);
	if regulator_data.algorithm == 0
		% Process unforced response prediction
		for i = 1:regulator_data.N
			switch i
				case 1
					u1 = sim_data.u(k-2);
					u2 = sim_data.u(k-3);
					y1 = process_data.y(k);
					y2 = process_data.y(k-1);
				case 2
					u1 = sim_data.u(k-1);
					u2 = sim_data.u(k-2);
					y1 = y0(1);
					y2 = process_data.y(k);
				otherwise
					u1 = sim_data.u(k-1);
					u2 = sim_data.u(k-1);
					y1 = y0(i-1);
					y2 = y0(i-2);
			end
			y0(i) = w20 + w2*tanh(w10+w1*[u1 u2 y1 y2]') + regulator_data.d(k);
		end
		
		% Model Linearization
		regulator_data.linear_weights(k,:) = [...
			 (w20 + w2*tanh(w10+w1*(in_arx'+[regulator_data.delta;0;0;0]))-regulator_data.y_mod(k))/regulator_data.delta
			 (w20 + w2*tanh(w10+w1*(in_arx'+[0;regulator_data.delta;0;0]))-regulator_data.y_mod(k))/regulator_data.delta
			-(w20 + w2*tanh(w10+w1*(in_arx'+[0;0;regulator_data.delta;0]))-regulator_data.y_mod(k))/regulator_data.delta
			-(w20 + w2*tanh(w10+w1*(in_arx'+[0;0;0;regulator_data.delta]))-regulator_data.y_mod(k))/regulator_data.delta];
	
		% Dynamic step response
		s = zeros(1,regulator_data.N);
		for i = 1:regulator_data.N
			for j = 1:min(i-2,2) %indexes moved by two (to avoid needing [0 0 b3 b4] and do away with just [b3 b4])
				if regulator_data.algorithm == 0
					s(i) = s(i) + regulator_data.linear_weights(k,j);
				elseif regulator_data.algorithm == 1
					s(i) = s(i) + W(j);
				end
			end
			for j = 1:min(i-1,2)
				if regulator_data.algorithm == 0
					s(i) = s(i) - regulator_data.linear_weights(k,j+2)*s(i-j);
				elseif regulator_data.algorithm == 1
					s(i) = s(i) - W(j+2)*s(i-j);
				end
			end
			regulator_data.save_s(k,i) = s(i);
		end
	
		% Dynamic control matrix
		M=zeros(regulator_data.N,regulator_data.Nu);
		for i=1:regulator_data.N
			M(i,1)=s(i);
		end
		for i=2:regulator_data.Nu
			M(i:regulator_data.N,i) = M(1:regulator_data.N-i+1,1);
		end

		% Calculate K(k) matrix
		K = inv(M'*M+eye(regulator_data.Nu)*regulator_data.lambda)*M';
		
	elseif regulator_data.algorithm == 1
		
		uv = [sim_data.u(k-1);
			  sim_data.u(k-2);
			  sim_data.u(k-3);
			  sim_data.u(k-4)];
		yv = [process_data.y(k-1);
			  process_data.y(k-2)];
			
		% Process unforced response prediction
		for i = 1:regulator_data.N
			y0(i) = b*yv + c*uv + regulator_data.d(k);
			
			yv(2:length(yv)) = yv(1:length(yv)-1);
			yv(1) = y0(i);
			
			uv(2:length(uv)) = uv(1:length(uv)-1);
			
% 			for j=1:n+1
% 				y0(i) = y0(i) + bf(i,j)*process_data.y(k+1-j);
% 			end
% 			for j=2:m
% 				y0(i) = y0(i) + cf(i,j)*(sim_data.u(k+1-j)-sim_data.u(k-j));
% 			end
		end
	end
	
	if regulator_data.algorithm == 0 || regulator_data.algorithm == 1
		% Delta U(k)
		if regulator_data.foresight == 0
			dU = K(1,:)*(regulator_data.y_req(k)*ones(regulator_data.N,1)-y0);
		elseif regulator_data.foresight == 1
			if k+regulator_data.N <= sim_data.sim_length
				y_req = regulator_data.y_req(k:k+regulator_data.N-1)';
			else
				y_req = [regulator_data.y_req(k:sim_data.sim_length) regulator_data.y_req(sim_data.sim_length)*ones(1,k+regulator_data.N-sim_data.sim_length-1)]';
			end
			dU = K(1,:)*(y_req-y0);
		end
		
		if dU<regulator_data.min_dU
			dU=regulator_data.min_dU;
		elseif dU>regulator_data.max_dU
			dU=regulator_data.max_dU;
		end
		sim_data.u(k) = sim_data.u(k-1) + dU;
	elseif regulator_data.algorithm == 2
		e = regulator_data.y_req(k) - process_data.y(k);
		integral = integral + e*regulator_data.T;
		sim_data.u(k) = K*(e + regulator_data.Ks/regulator_data.Ts*integral + regulator_data.Td*(process_data.y(k)-process_data.y(k-1))/regulator_data.T);
	end
	
	if sim_data.u(k) > sim_data.umax
		sim_data.u(k) = sim_data.umax;
	elseif sim_data.u(k) < sim_data.umin
		sim_data.u(k) = sim_data.umin;
	end
end

figure
plot(process_data.y)
hold on
plot(regulator_data.y_req);
% figure
% plot(process_data.y);
% hold on
% plot(regulator_data.y_mod);
figure
plot(sim_data.u);
fprintf('error=%d\n',sum((process_data.y-regulator_data.y_req).^2)/length(process_data.y));