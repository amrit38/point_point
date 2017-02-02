function [cineq,ceq]=f_constr(x,varargin)
load('zopt_rae2822_8DV.mat')
P.xp=xp;
P.x0=zopt;
P.n_upper=4;
P.n_lower=4;
x0=varargin{1};
g=varargin{2};
con=varargin{3};
G=varargin{4};
load('thickness_const_rae2822.mat')
tu2080_0 = yu2080;
tl2080_0 = yl2080;
thick80_0 = tu2080_0(2)-tl2080_0(2);
[A0,A,tu2080,tl2080]=area_thickness_const(x,P);
thick80=tu2080(2)-tl2080(2);

cineq(1)=A0-A;
%if varargin{2}==1
% R=co_model(x);
% R1=co_model(x0);   
  %  cd(PWD)
  R=RSM(x,x0,G,g)
cineq(2)=R-con
%end
ceq=[];
end

function [A0,A,tu2080,tl2080]=area_thickness_const(y,P)
x=y;
x0=P.x0;
Nt=400;

% new shape
xp(1,:) = P.xp;
zp (1,:)= x;
xloc(:,1) = [0 [1.0 - cos((1:Nt-1.0)*pi/2.0/(Nt - 1.0))]];
[z,cp] = bsairfoil(zp,xp,xloc,P.n_upper,P.n_lower);
 yu(:,1)=z(1,:);
 yl(:,1)=z(2,:);
 yy(:,1)=[yu;yl(end-1:-1:1,1)];
 xx(:,1)=[xloc;xloc(end-1:-1:1,1)];
 xy=[xx yy];
 A=trapz(xy(:,1),xy(:,2));

x2080=[0.2 0.8];%linspace(0,1,Nt);%0:1/Nt:1;
 tu2080=interp1(xloc(:,1),yu(:,1),x2080,'pchip');
 tl2080=interp1(xloc(:,1),yl(:,1),x2080,'pchip');

% initial shape
zp0(1,:)=x0;
 [z0,cp0] = bsairfoil(zp0,xp,xloc,P.n_upper,P.n_lower);
 yu0(:,1)=z0(1,:);
 yl0(:,1)=z0(2,:);
 yy0(:,1)=[yu0;yl0(end-1:-1:1,1)];
 xy0=[xx yy0];
 A0=trapz(xy0(:,1),xy0(:,2));
end