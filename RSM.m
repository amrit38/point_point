function F=RSM(x,x0,B,f) 
F=RSM_model(x,B)
F1=RSM_model(x0,B)
     F=F+(f-F1)
end