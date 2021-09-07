function step_process(k)
	global sim_data process_data;
	g1uk3 = process_data.g1(sim_data.u(k-3));
	process_data.x(1,k) = -process_data.alpha(1)*process_data.x(1,k-1)...
						  +process_data.x(2,k-1)...
						  +process_data.beta(1)*g1uk3;
	process_data.x(2,k) = -process_data.alpha(2)*process_data.x(1,k-1)...
						  +process_data.beta(2)*g1uk3;
	process_data.y(k)	= process_data.g2(process_data.x(1,k));
end