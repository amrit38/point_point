function R=co_model(x)
persistent cok_model;
persistent cok_x0;
persistent cok_d;
if isempty(cok_model)
    load cok.mat;
    cok_model=cok;
    cok_x0=x0;
    cok_d=d;
end
m=length(cok_model);
xx=(x-cok_x0)./cok_d % scaling

for k=1:m
    R(1,k)=cok_model{k}.predict(xx')
end
