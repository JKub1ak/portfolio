global sim_data;
global regulator_data;

rng('default');
if sim_data.datatype == 1
	rng(2006);
elseif sim_data.datatype == 2
	rng(2004);
elseif sim_data.datatype == 3
	rng(2005);
else
	return
end

y_max = 0.8;
y_min = -4.8;
ampl = y_max-y_min;
startdelay = 10;
changedelay = 75;
% changedelay = 40;
for k=startdelay:sim_data.sim_length
	if mod(k-startdelay,changedelay)==0
		input = ampl*(rand(1,1))+y_min;
	end
	regulator_data.y_req(k) = input;
end

% figure
% plot(y);