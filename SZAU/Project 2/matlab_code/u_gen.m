global sim_data;

rng('default');
if sim_data.datatype == 1
	rng(1006);
elseif sim_data.datatype == 2
	rng(1004);
elseif sim_data.datatype == 3
	rng(1005);
else
	return
end

ampl = 1;
startdelay = 10;
changedelay = 50;
for k=startdelay:sim_data.sim_length
	if mod(k-startdelay,changedelay)==0
		input = 2*ampl*(rand(1,1)-0.5);
	end
	sim_data.u(k) = input;
end

% figure
% plot(sim_data.u);