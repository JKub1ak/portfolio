global plot_process
plot_process = 0;
problem.fitnessfcn = @regulated_process_pid;
problem.nvars = 3;
problem.Aineq = [];
problem.bineq = [];
problem.Aeq = [];
problem.beq = [];
problem.LB = [5, 5, 0];
problem.UB = [100, 10, 10];
problem.nonlcon = [];
problem.options = [];

sol = pso(problem);

plot_process = 1;
E_pso = regulated_process_pid(sol);

% Ziegler-Nichols
Kk = 1.01;
Tk = 14*0.05;

K_zn = 0.6*Kk;
Ti_zn = 0.5*Tk;
Td_zn = 0.125*Tk;

E_zn = regulated_process_pid([0.6*Kk, 0.5*Tk, 0.125*Tk]);

fprintf('PSO: E=%.4f, K=%.4f, Ti=%.4f, Td=%.4f\n', E_pso, sol(1), sol(2), sol(3))
fprintf('ZN: E=%.4f, K=%.4f, Ti=%.4f, Td=%.4f\n', E_zn, K_zn, Ti_zn, Td_zn)

% NPL
problem.LB = [2, 5, 0.5];
problem.UB = [100, 10, 100];
problem.fitnessfcn = @regulated_process_npl;
plot_process = 0;
sol = pso(problem);
plot_process = 1;
E_npl = regulated_process_pid(sol);
fprintf('NPL: E=%.4f, N=%.4f, Nu=%.4f, lambda=%.4f\n', E_npl, sol(1), sol(2), sol(3))
