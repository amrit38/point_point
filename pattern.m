function [xopt,F,n]= pattern(x,d0,f,g,con,B,G)
% clc
% clear all
format long
% load('zopt_rae2822_8DV.mat')
% x0=zopt';
% x0=[0.019284000000000   0.043864000000000   0.064800000000000   0.046648000000000  -0.029072000000000 -0.067928000000000  -0.042423000000000   0.006005000000000]';
x0=x

% lb=(1-sign(x0)*0.15).*x0;  
% ub=(1+sign(x0)*0.15).*x0;
d0=d0
lb=x0-d0'
ub=x0+d0'

% pattern_search
     %d0=ones(8,1)*0.001;
%      d_min=0.001;
%      Mdecr=3;
%      n_max=2^8;
 
  
%     
%      [xopt,F] = grid_search_lin_constr(@(x)f_multi_obj(x),x0,d0,d_min,n_max,Mdecr,lb,ub,...
         %@(x)f_constr(x))
       [xopt,F,n]= fmincon(@(x)RSM(x,x0,B,f),x0,[],[],[],[],lb,ub,@(x)f_constr(x,x0,g,con,G),[])
%       [xopt,F,n]= fmincon(@(x)RSM(x,x0,B,f),x0,[],[],[],[],lb,ub)

    % R=co_model(xopt)
end
