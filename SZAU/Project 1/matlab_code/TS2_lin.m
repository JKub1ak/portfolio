function root = TS2_lin(V1_last,V2_last)
	global data TS_data;
	
	% Poprzedniki
	p(1) = trapmf(V2_last,[0, 0, TS_data.points(1), TS_data.points(2)]);
	p(2) = trapmf(V2_last,[TS_data.points(1), TS_data.points(2), inf, inf]);
	
	% Następniki
	VLs = TS_data.VLs;
	
	roots = zeros(2,2);
	for i = 1:length(VLs)
		if p(i) ~= 0
			roots(i,:) = [nthroot(VLs(i,1)/data.C1,6) + ...
						  1/(6*nthroot(data.C1,6)*VLs(i,1).^(5/6)) * (V1_last - VLs(i,1)),...
						  sqrt(VLs(i,2)/data.A2) + ...
						  1/(2*sqrt(data.A2*VLs(i,2))) * (V2_last-VLs(i,2))];
		else
			roots(i,:) = [0,0];
		end
	end
	
	root = p(1)*roots(1,:) + p(2)*roots(2,:);
	root = root/sum(p);
		
end

