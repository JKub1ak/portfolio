% Before usage: comment the 6th line in init_sim and change datatype to 0

span = linspace(-1,1,2001);
U = zeros(1,length(span));
Y = zeros(1,length(span));
global sim_data;
for i = 1:length(span)
	U(i) = span(i);
	sim_data.u0 = U(i);
	main
	Y(i) = process_data.y(length(process_data.y));
end

figure(1);
plot(U,Y);
title('static characteristic');
xlabel('U');
ylabel('Y');