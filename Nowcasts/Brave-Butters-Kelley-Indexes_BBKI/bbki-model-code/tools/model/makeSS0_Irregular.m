function ss0 = makeSS0_Irregular(ss0A)
% Use SS0A from latest model run to create the initial values in ss0.
%
% Ross Cole, 2019

Z0 = [ones(1,4) 0 0; zeros(2,6)];
for r = 2:size(Z0,1)
    for c = 1:6
        if ss0A.Z(r,c)~=0
            Z0(r,c) = ss0A.Z(r,c);
        end
    end
end

T0 = ss0A.T(1:6,1:6,1);
R0 = ss0A.R(1:6,1:4,1);
H0 = ss0A.H;
Q0 = ss0A.Q;

ss0 = StateSpaceEstimation(Z0,H0,T0,Q0,'R',R0);

end