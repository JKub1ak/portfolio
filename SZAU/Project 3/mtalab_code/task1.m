% Task flow variables
plot_himmelblau = 1;
find_global_minimum = 1;
test_params = 1;

if plot_himmelblau
    x1 = [-5:0.05:5];
    x2 = [-5:0.05:5];

    [X1, X2] = meshgrid(x1,x2);

    y = himmelblau(X1, X2);

    figure
    mesh(X1, X2, y)
    xlabel("x_1")
    ylabel("x_2")
end

if find_global_minimum
    Aineq = [-1 0; 1 0; 0 -1; 0 1];
    bineq = [5; 5; 5; 5];
    global_min = pso(@fitnessfcn, 2, Aineq, bineq);
    disp("global minimum location")
    disp(global_min)
    disp("global minimum value")
    disp(himmelblau(global_min(1), global_min(2)))
end

if test_params
    Aineq = [-1 0; 1 0; 0 -1; 0 1];
    bineq = [5; 5; 5; 5];
    % ========= Too much attraction ===========
    disp("CognitiveAttraction + Social Attraction > 4")
    options = psooptimset('CognitiveAttraction', 2.5, ...
                          'SocialAttraction', 2.5);
    global_min = pso(@fitnessfcn, 2, Aineq, bineq, [], [], [], [], [], options);
    disp("global minimum location")
    disp(global_min)
    disp("global minimum value")
    disp(himmelblau(global_min(1), global_min(2)))
    % ========== Negative attraction ===========
    disp("CognitiveAttraction + Social Attraction < 0")
    options = psooptimset('CognitiveAttraction', -1, ...
                          'SocialAttraction', -1);
    global_min = pso(@fitnessfcn, 2, Aineq, bineq, [], [], [], [], [], options);
    disp("global minimum location")
    disp(global_min)
    disp("global minimum value")
    disp(himmelblau(global_min(1), global_min(2)))
    % ========== Velocity Limit ===========
    disp("velocity <= 1.0")
    options = psooptimset('VelocityLimit', 0.001);
    global_min = pso(@fitnessfcn, 2, Aineq, bineq, [], [], [], [], [], options);
    disp("global minimum location")
    disp(global_min)
    disp("global minimum value")
    disp(himmelblau(global_min(1), global_min(2)))
end
