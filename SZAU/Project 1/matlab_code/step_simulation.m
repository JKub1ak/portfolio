function [V1,V2] = step_simulation(V1_last,V2_last,F1in,FD)

	global data linear time_step;

	if linear == 0
		root = [nthroot(V1_last/data.C1, 6), sqrt(V2_last/data.A2)];
	elseif linear == 1
		root = [nthroot(data.Vp(1)/data.C1,6) + ...
				1/(6*nthroot(data.C1,6)*data.Vp(1).^(5/6)) * (V1_last - data.Vp(1)),...
			    sqrt(data.Vp(2)/data.A2) + ...
			    1/(2*sqrt(data.A2*data.Vp(2))) * (V2_last-data.Vp(2))];
	elseif linear == 2
		root = TS2_lin(V1_last,V2_last);
	elseif linear == 3
		root = TS3_lin(V1_last,V2_last);
	elseif linear == 4
		root = TS4_lin(V1_last,V2_last);
	elseif linear == 5
		root = TS5_lin(V1_last,V2_last);
	end
	
    V1 = V1_last + ...
        (F1in + FD - data.alpha(1) * root(1)) * time_step;
    V2 = V2_last + ...
		(data.alpha(1) * root(1) - data.alpha(2) * root(2)) * time_step;
	
	if V1 < data.V1_MIN
		V1 = data.V1_MIN;
	elseif V1 > data.V1_MAX
		V1 = data.V1_MAX;
	end
	
	if  V2 < data.V1_MIN
		 V2 = data.V1_MIN;
	elseif V2 > data.V2_MAX
		V2 = data.V2_MAX;
	end
end

