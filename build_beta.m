function Beta = build_beta(x,f,bounds)

n = size(bounds,2);
U = [];
F=[]
for i=1:size(x,1)
 
    
    
    % compute new row of U matrix
    U_temp = [1 x(i,:)];
    for j=1:n
        for k=j:n
            U_temp = cat(2,U_temp,x(i,j)*x(i,k));
        end
    end
    U = cat(1,U,U_temp);
end

F = cat(1,F,f(i))

Beta = (U'*U)\U'*f;
if max(isnan(Beta)) || max(isinf(abs(Beta)))
    error('Beta wasn''t found properly.')
end
end