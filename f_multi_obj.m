function F=f_multi_obj(x,x0,f)
R=co_model(x);
R1=co_model(x0);
%F=[-R(1) R(2)]; % Here you set what you want to optimize (e.g., -Cl and Cd)
F=[R(1)+(f-R1(1))]

end
% cd('bsairfoil')
% x1=[x'];
% A=area(x1);
% cd ..
% if (A<=0.0779)
%  F=F+beta*((A-0.0779)/0.0779)^2;
% end
