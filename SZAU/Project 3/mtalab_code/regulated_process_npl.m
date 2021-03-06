function E = regulated_process_npl(x)
%regulated_process
%   Detailed explanation goes here
% reg = "pid";
kp = 10; kk = 1000;
Tp = 0.05;
N = floor(x(1));
Nu = floor(x(2));
lambda = x(3);

if Nu > N
    E = 10^9;
    return
end

% Process vars
% u = ones(kk, 1)*0.5;
u = zeros(kk, 1);
y = zeros(kk, 1);
x_1 = zeros(kk, 1);
x_2 = zeros(kk, 1);

% Setpoint trajectory
y_zad = ones(kk + N, 1)*0.05;

u_min = -1;
u_max = 1;
delta_u_min = -0.05;
delta_u_max = 0.05;
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
    
    u_lin = u(k-3);
    x_1_lin = x_1(k);
    
    y_p = zeros(N, 1);
    u_p = ones(N, 1)*(u_lin+0.05);
    u_p(1:3) = ones(3,1)*u_lin; % 3 ticks of lag
    x_1_p = zeros(N, 1);
    x_1_p(1) = x_1(k);
    x_2_p = zeros(N, 1);
    x_2_p(1) = x_2(k);

    % Calculate SR coefficients 
    for p = (k+1):(k+N)
        g_1 = (exp(4.5*u_lin) - 1)/(exp(4.5*u_lin) + 1) + ...
          (9*exp(4.5*u_lin)/((exp(4.5*u_lin) + 1)^2))*(u_p(p-k) - u_lin);
        x_1(k+p) = -alpha_1*x_1(k-1+p) + x_2(k-1+p) + beta_1*g_1;
        x_2(k+p) = -alpha_2*x_1(k-1+p) + beta_2*g_1;
        g_2 = 1 - exp(-1.8*x_1_lin) + 1.8*exp(-1.8*x_1_lin)*(x_1(k-1+p) - x_1_lin);
        y_p(p-k) = g_2;
    end
    
    s = (y_p - y(k))/0.05;
    M = zeros(N,Nu);
    for i = 1:Nu
        for j = i:N
            M(j,i) = s(j-i+1);
        end
    end

    % calculate odpowiedz swobodna 
    u_0(1) = u(k-3);
    u_0(2) = u(k-2);
    u_0(3:N) = ones(N-2,1)*u(k-1);
    x_1_0 = zeros(N, 1);
    x_1_0(1) = x_1(k);
    x_2_0 = zeros(N, 1);
    x_2_0(1) = x_2(k);
    y_0 = zeros(N, 1);
    for i = (1:N)
        g_1 = (exp(4.5*u_0(i)) - 1)/(exp(4.5*u_0(i)) + 1);
        x_1_p(i) = -alpha_1*x_1_0(i) + x_2_0(i) + beta_1*g_1;
        x_2_p(i) = -alpha_2*x_1_0(i) + beta_2*g_1;
        g_2 = 1 - exp(-1.8*x_1_0(i));
        y_0(i) = g_2;
    end
    
    delta_u = (M'*M + lambda*eye(Nu,Nu))\M'*(y_zad(k+1:k+N) - y_0);
     if delta_u(1) > delta_u_max
        delta_u(1) = u_max;
    elseif  delta_u(1) < delta_u_min
       delta_u(1) = u_min;
    end
    u(k) = u(k-1) + delta_u(1);
    
    if u(k) > u_max
        u(k) = u_max;
    elseif  u(k) < u_min
        u(k) = u_min;
    end
end

global plot_process
if plot_process
    figure;
    plot(1:kk,y, 1:kk, u)
    title("y^{zad}="+string(y_zad(1)))
    legend("y", "u")
end
% Cost calculation
E = sum((y - y_zad(1:kk)).^2);

if isnan(E) || isinf(E)
    E = 10^9;
end
end


