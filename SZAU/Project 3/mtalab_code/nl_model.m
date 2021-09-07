function y_k = nl_model(u_k_3, u_k_4, y_k_1, y_k_2)

alpha_1 = -1.535262;
alpha_2 = 0.586646;
beta_1 = 0.027970;
beta_2 = 0.023414;

y_k = g2(-alpha_1*g2_inv(y_k_1) -alpha_2*g2_inv(y_k_2) + beta_1*g1(u_k_3) + beta_2*g1(u_k_4));

end

