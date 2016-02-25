function [ newMS ] = FuncUpdateMS( MS )
%FuncUpdateMS updates the MS values according to the stepwise model
Mu = 1/10000; % the mutation rate (10^-4)

n = length(MS);
MutateVector = binornd(1,Mu,1,n);
MutDirection = binornd(MutateVector,1/2);
newMS = MS + (2*MutDirection - MutateVector);

end

