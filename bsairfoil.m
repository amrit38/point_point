function [z,cp,z_delta,cp_delta] = bsairfoil(zp,xp,x,n_upper,n_lower,varargin)
if size(xp,1)>size(xp,2)
    xp = xp';
end
if size(zp,1)>size(zp,2)
    zp = zp';
end


k=3;


if isempty(varargin)
    cp ={[0 xp(1:n_upper) 1],
     [0 xp(n_upper+1:end) 1],
     [0 zp(1:n_upper) 0],
     [0 zp(n_upper+1:end) 0]};

     cpu=[cp{1};cp{3}];
     cpl=[cp{2};cp{4}];
     z(1,:) = generateAirfoil(cpu,n_upper+2,k,x);
     z(2,:) = generateAirfoil(cpl,n_lower+2,k,x);
else
    cp ={[0 xp(1:n_upper) 1],
     [0 xp(n_upper+1:end) 1],
     [0 zp(1:n_upper) 0],
     [0 zp(n_upper+1:end) 0]};

    cpu=[cp{1};cp{3}];
    cpl=[cp{2};cp{4}];
    nx=length(x)/2;
    z(1,:) = generateAirfoil(cpu,n_upper+2,k,x(1:nx));
    z(2,:) = generateAirfoil(cpl,n_lower+2,k,x(1+nx:2*nx));

    zp_delta=varargin{1};
    cp_delta ={[0 xp(1:n_upper) 1],
     [0 xp(n_upper+1:end) 1],
     [0 zp_delta(1:n_upper) 0],
     [0 zp_delta(n_upper+1:end) 0]};
    cpu_delta=[cp_delta{1};cp_delta{3}];
    cpl_delta=[cp_delta{2};cp_delta{4}];
    z_delta(1,:) = generateAirfoil(cpu_delta,n_upper+2,k,x(1:nx));
    z_delta(2,:) = generateAirfoil(cpl_delta,n_lower+2,k,x(1+nx:2*nx));
end
end



function z = generateAirfoil(cp,N,k,x)
sp=b_spline(cp,N,k);
t = [0 [1.0 - cos((1:501-1.0)*pi/2.0/(501 - 1.0))]];
q=fnval(sp,t);
z=interp1(q(1,:),q(2,:),x,'pchip');
end



function sp=b_spline(cp,N,k)
if N-k >= 3
    s=[0 0.25 0.5 0.75 1];
    d = augknt(s,N-k);
elseif N-k == 2
    s=[0 0.25 0.75 1];
    d = augknt(s,3);
elseif N-k == 1
    s=[0 0.5 1];
    d = augknt(s,3);
end
sp = spmak(d,cp);
end

