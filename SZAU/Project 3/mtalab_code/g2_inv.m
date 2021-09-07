function x = g2_inv(y)
if(y >= 1)
    x = -10^9;
else
    x = -log(1 - y)/1.8;
end

end

