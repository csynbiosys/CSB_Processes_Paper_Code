function ratio = c2c1ratio(d1,d2,kf)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

syms x;
c1=(d2-d1)*(d2-d1+kf)*kf;
c3=kf*d2*(d2+kf);
c4=d1*(d2+kf)*(d2-d1+kf);
c5=d1*d2*(d1-d2);

M=vpasolve((d2-d1+kf)*d2/(d1*kf)-(x^(d2-d1+kf)-1)/(x^kf-1),x,[0,inf]);
V=[d2/kf+1,1-(d1-d2)/kf,1,0;-d2/kf,(d1-d2)/kf,0,1];
C=V*[c1;c3*M^(-d1);c4*M^(-d2);c5*M^(-d1-kf)];
ratio=double(C(2)/C(1));
end

