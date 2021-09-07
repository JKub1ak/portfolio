function root = TS3_lin(V1_last,V2_last)
	global data TS_data;
	
	% Poprzedniki
	p(1) = trapmf(V2_last,[0, 0, TS_data.points(1), TS_data.points(2)]);
	p(2) = trimf(V2_last,[TS_data.points(1), TS_data.points(2), TS_data.points(3)]);
	p(3) = trapmf(V2_last,[TS_data.points(2), TS_data.points(3), inf, inf]);
	
	% Następniki
	VLs = TS_data.VLs;
	
	root = [0,0];
	for i = 1:length(VLs)
		if p(i) ~= 0
			root = root + p(i)*...
				   [nthroot(VLs(i,1)/data.C1,6) + ...
					1/(6*nthroot(data.C1,6)*VLs(i,1).^(5/6)) * (V1_last - VLs(i,1)),...
					sqrt(VLs(i,2)/data.A2) + ...
					1/(2*sqrt(data.A2*VLs(i,2))) * (V2_last-VLs(i,2))];
		else
			root = root + [0,0];
		end
	end
	root = root/sum(p);
		
end

