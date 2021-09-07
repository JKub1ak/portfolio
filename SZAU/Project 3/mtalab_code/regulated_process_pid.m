function E = regulated_process_pid(x)
%regulated_process
%   Detailed explanation goes here
% reg = "pid";
kp = 10; kk = 1000;
Tp = 0.05;
Kp = x(1);
Ti = x(2);
Td = x(3);

% PID vars
r_1 = Kp * (1 + Tp/(2*Ti) + Td/Tp);
r_2 = Kp * (Tp/(2*Ti) - 2*Td/Tp - 1);
r_3 = Kp * Td/Tp;

% Process vars
% u = ones(kk, 1)*0.5;
u = zeros(kk, 1);
y = zeros(kk, 1);
x_1 = zeros(kk, 1);
x_2 = zeros(kk, 1);

% Setpoint trajectory
y_zad = ones(kk, 1)*0.1;
% y_zad(1:100) = y_zad(1:100)*0.5;

u_min = -1;
u_max = 1;
alpha_1 = -1.535262;
alpha_2 = 0.586646;
beta_1 = 0.027970;
beta_2 = 0.023414;


for k = (kp:kk)
    g_1 = (exp(4.5*u(k-3)) - 1)/(exp(4.5*u(k-3)) + 1);
    x_1(k) = -alpha_1*x_1(k-1) + x_2(k-1) + beta_1*g_1;
    x_2(k) = -alpha_2*x_1(k-1) + beta_2*g_1;
    g_2 = 1 - exp(-1.8*x_1(k));
    y(k) = g_2;
    
    u(k) = u(k-1) + r_1*(y_zad(k) - y(k)) + r_2*(y_zad(k-1) - y(k-1)) ...
           + r_3*(y_zad(k-2) - y(k-2));
       
    if u > u_max
        u(k) = u_max;
    elseif  u < u_min
        u(k) = u_min;
    end
end

global plot_process
if plot_process
    figure;
    plot(1:kk,y)
    hold on
    plot(1:kk,x_1)
    plot(1:kk,x_2)
end

% Error functions

% Cost calculation
lambda = 5;
u_1 = [u(1); u];
E = sum((y - y_zad).^2);
E = E + sum((lambda*(u_1(1:kk) - u)).^2);

if isnan(E) || isinf(E)
    E = 10^9;
end

% Thought out aproach

end

