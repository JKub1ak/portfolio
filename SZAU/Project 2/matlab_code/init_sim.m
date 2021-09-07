global sim_data;
sim_data.sim_length = 2500;
sim_data.delay = 3;
sim_data.x0 = [0,0];

sim_data.u0 = 0;
sim_data.umin = -1;
sim_data.umax = 1;
if sim_data.u0 > sim_data.umax
	sim_data.u0 = sim_data.umax;
elseif sim_data.u0 < sim_data.umin
	sim_data.u0 = sim_data.umin;
end
sim_data.u = ones(1,sim_data.sim_length)*sim_data.u0;
sim_data.datatype = 2; %0 - static input, 1 - learning data, 2 - verification data, 3 - test data