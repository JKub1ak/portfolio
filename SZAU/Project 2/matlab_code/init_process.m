global sim_data;
global process_data;
process_data.x = ones(2,sim_data.sim_length);
process_data.y = zeros(1,sim_data.sim_length);
process_data.alpha = [-1.535262,0.586646];
process_data.beta = [0.02797,0.023414];
process_data.g1 = @g1;
process_data.g2 = @g2;

process_data.x(1,1:sim_data.delay) = sim_data.x0(1);
process_data.x(2,1:sim_data.delay) = sim_data.x0(2);

function g1_out = g1(g1_in)
	g1_out = (exp(4.5*g1_in)-1)/(exp(4.5*g1_in)+1);
end
function g2_out = g2(g2_in)
	g2_out = 1-exp(-1.8*g2_in);
end