global plot_process
plot_process = 0;
problem.fitnessfcn = @regulated_process_npl;
problem.nvars = 3;
problem.Aineq = [];
problem.bineq = [];
problem.Aeq = [];
problem.beq = [];
problem.LB = [2, 5, 0.5];
problem.UB = [100, 10, 100];
problem.nonlcon = [];
problem.options = [];

plot_process = 0;
sol = pso(problem);
plot_process = 1;
E_npl = regulated_process_pid(sol);
fprintf('NPL: E=%.4f, N=%.4f, Nu=%.4f, lambda=%.4f\n', E_npl, sol(1), sol(2), sol(3))
