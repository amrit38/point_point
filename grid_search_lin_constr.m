function [x,F,n_fun]=grid_search_lin_constr(f,x0,d0,d_min,n_max,Mdecr,lb,ub,constr_f,varargin)
% -------------------------------------
% Input arguments
% f - objective function
% x0 - initial solution
% d0 - initial grid size (vector)
% d_min - minimum grid size
% n_max - maximum number of fu
% Mdecr - multiplier for grid size reduction
% lb - lower bounds for x
% ub - upper bounds for x
% varargin
% -------------------------------------
% Output arguments
% x - final solution
% F - objective function value at final solution
% -------------------------------------

% initialization
x=x0;
d=d0;
n=length(x0);
% evaluate objective function at starting point
[F,n_fun,data_set]=update_data_set(f,x,0,[],varargin{:});
fprintf('\nIteration  Objective    Fun. Eval.  Step Size    Optimization Step\n');
fprintf('------------------------------------------------------------------\n');
fprintf('Iter=%-5i F=%-10.5f n_fun=%-5i D=%-10f (initial solution)\n',0,F,n_fun,norm(d));
% main loop
count=0;
while norm(d)>=d_min && n_fun<=n_max
    count=count+1;
    F_min=F;
    x_min=x;
    % find search direction
    clear x_tmp;
    for j=1:n
        x_tmp{j}=x;
        x_tmp{j}(j)=x(j)+d(j);
        [F_tmp(j,1),n_fun,data_set]=update_data_set(f,x_tmp{j},n_fun,data_set,varargin{:});
    end
    h=-(F_tmp-F)./d;
    h=norm(d)*h/norm(h);
    % perform line search
    x_ref=x_min;
    while n_fun<=n_max
        x_ref=x_ref+h;
        x_tmp=round_to_grid(x_ref,x,d);
        if min(x_tmp-lb)>=0 && min(ub-x_tmp)>=0 && check_constr(x_tmp,constr_f,varargin{:}) % point within the domain
            [F_tmp,n_fun,data_set]=update_data_set(f,x_tmp,n_fun,data_set,varargin{:});
            if F_tmp<F_min % better point found => store it and continue line search
                F_min=F_tmp;
                x_min=x_tmp;
                h=2*h;
            else %no better solution found => terminate the loop
                break;
            end
        else
            break;
        end
    end
    fprintf('           F=%-10.5f n_fun=%-5i D=%-10f (line search)\n',F_min,n_fun,norm(d));
    if n_fun>n_max
        break;
    end
    if F_min>=F % line search failed => perform poll search
        for j=1:2*n
            x_tmp=x;
            x_tmp(ceil(j/2))=x(ceil(j/2))+((-1)^j)*d(ceil(j/2));
            if min(x_tmp-lb)>=0 && min(ub-x_tmp)>=0 && check_constr(x_tmp,constr_f,varargin{:}) % point within the domain
                [F_tmp,n_fun,data_set]=update_data_set(f,x_tmp,n_fun,data_set,varargin{:});
                if F_tmp<F_min % better point found
                    F_min=F_tmp;
                    x_min=x_tmp;
                end
            end
        end
        fprintf('Iter=%-5i F=%-10.5f n_fun=%-5i D=%-10f (poll search)\n',count,F_min,n_fun,norm(d));
        if F_min>=F % poll search failed => reduce grid size
            d=d/Mdecr;
        else
            % perform line search in the direction of best result of poll search
            h=x_min-x;
            x_ref=x_min;
            while n_fun<=n_max
                x_ref=x_ref+h;
                x_tmp=round_to_grid(x_ref,x,d);
                if min(x_tmp-lb)>=0 && min(ub-x_tmp)>=0 && check_constr(x_tmp,constr_f,varargin{:}) % point within the domain
                    [F_tmp,n_fun,data_set]=update_data_set(f,x_tmp,n_fun,data_set,varargin{:});
                    if F_tmp<F_min % better point found => store it and continue line search
                        F_min=F_tmp;
                        x_min=x_tmp;
                        h=2*h;
                    else % no better solution found => terminate the loop
                        break;
                    end
                else
                    break;
                end
            end
            fprintf('           F=%-10.5f n_fun=%-5i D=%-10f (line search after polling)\n',F_min,n_fun,norm(d));
            if n_fun>n_max
                F=F_min;
                x=x_min;
                break;
            end
        end
        if n_fun>n_max
            F=F_min;
            x=x_min;
            break;
        end
    end
    F=F_min;
    x=x_min;
end
fprintf('\nFinal solution:\n');
fprintf('---------------\n');
fprintf('F=%1.3e\n',F);
fprintf('x=[');
for j=1:n
    fprintf('%1.5f',x(j));
    if j<n
        fprintf(' ');
    end
end
fprintf(']\n\n');


function F=check_data_set(x,data_set)
F=[];
eps=1e-8;
for j=1:length(data_set)
   if norm(x-data_set{j}.x)<eps
       F=data_set{j}.F;
       return;
   end
end

function [F,n_fun,data_set]=update_data_set(f,x,n_fun,data_set,varargin)
F=check_data_set(x,data_set);
if isempty(F)
    F=feval(f,x,varargin{:});
    n_fun=n_fun+1;
    data_set{length(data_set)+1}.x=x;
    data_set{length(data_set)}.F=F;
end

function y=round_to_grid(x,x0,d)
s=(x-x0)./d;
y=x0+round(s).*d;

function test=check_constr(x,constr_fun,varargin)
cineq=[];
ceq=[];
if ~isempty(constr_fun)
    [cineq,ceq]=feval(constr_fun,x,varargin{:});
end
test=0;
if isempty(cineq) || max(cineq)<=0
    test=1;
end
