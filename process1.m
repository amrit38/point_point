clear all
clc
% load('reduced_design_space.mat')
p=30
d0=0.005/2
file ='con_0.1\iter4'
source=[file,'\last\opt_fine.mat']
desti='points_generation'
delete([desti,'\opt_fine.mat'],[desti,'\x.mat'])
copyfile(source,desti)
cd(desti)
x=point_generation(d0,p)
cd ..

4.8+6.8+6.19+4.56+7.4