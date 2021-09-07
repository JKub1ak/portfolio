
kp = 4;
kk = 100;
u = zeros(kk,1);
x_1 = zeros(kk,1);
x_2 = zeros(kk,1);
y = zeros(kk,1);

u = ones(kk-20+1,1)*0.1;
u(20:kk) = ones(kk-20+1,1)*0.2;

x_1(1:3) = [0.22127833, 0.22127835, 0.22127838];

for k = kp:kk
    g_1 = (exp(4.5*u(k-3)) - 1)/(exp(4.5*u(k-3)) + 1);
    x_1(k) = -alpha_1*x_1(k-1) + x_2(k-1) + beta_1*g_1;
    x_2(k) = -alpha_2*x_1(k-1) + beta_2*g_1;
    g_2 = 1 - exp(-1.8*x_1(k));
    fprintf("x_1=%.8f, x_2=%.8f, g_1=%.8f, g_2=%.8f\n", x_1(k), x_2(k), g_1, g_2);
    y(k) = g_2;
end

figure;
plot(1:kk,y, 1:kk,x_1, 1:kk,x_2)
title("nonlin")

x_1 = zeros(kk,1);
x_2 = zeros(kk,1);
y = zeros(kk,1);

x_1(1:3) = [0.22127833, 0.22127835, 0.22127838];

x_1_lin = 0.22127838;
u_lin = 0.1;

for k = kp:kk
    g_1 = (exp(4.5*u_lin) - 1)/(exp(4.5*u_lin) + 1) + ...
      (9*exp(4.5*u_lin)/((exp(4.5*u_lin) + 1)^2))*(u(k-3) - u_lin);
    x_1(k) = -alpha_1*x_1(k-1) + x_2(k-1) + beta_1*g_1;
    x_2(k) = -alpha_2*x_1(k-1) + beta_2*g_1;
    g_2 = 1 - exp(-1.8*x_1_lin) + 1.8*exp(-1.8*x_1_lin)*(x_1(k-1) - x_1_lin);
    y(k) = g_2;
end

figure;
plot(1:kk,y, 1:kk,x_1, 1:kk,x_2)
title("lin")
