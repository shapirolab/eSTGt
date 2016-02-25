function [ newMS ] = FuncUpdateMS_5( MS )
%FuncUpdateMS updates the MS values
Mu = 1/100000;

n = length(MS);
MutateVector = binornd(1,Mu,1,n);
MutDirection = binornd(MutateVector,1/2);
newMS = MS + int8(2*MutDirection - MutateVector);

end

