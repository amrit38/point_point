
function f = RSM_model(x,Beta)
f = Beta(1); Beta(1) = [];
for i=1:length(x)
    f = f + Beta(1)*x(i);
    Beta(1) = [];
end
for i=1:length(x)
    for j=i:length(x)
        f = f + Beta(1)*x(i)*x(j);
        Beta(1) = [];
    end
end

end
