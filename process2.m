
clear all
clc
PWD=pwd
% load('reduced_design_space.mat')
d0=0.005/1
con=0.10000

file ='con_0.1\iter1'
source=[file,'\out.mat']

% desti=[PWD,'\MO_airfoil_cokriging_for_leifur\MO_airfoil_cokriging_for_leifur']

delete(['out.mat'])
copyfile(source,PWD)
last=[file,'\last\opt_fine.mat']

load(last)
lb=x-d0
ub=x+d0
bounds=[lb;ub]
load out.mat

B=build_beta(x,f',bounds)
G=build_beta(x,g',bounds)

load(last)
x0=x'

[xopt,F,n]=pattern(x0,d0,f,g,con,B,G)
save opt_result xopt F d0 x0
x=xopt'
save x x
movefile('opt_result.mat',file)
movefile('x.mat',file)
% movefile('cok.mat',file)