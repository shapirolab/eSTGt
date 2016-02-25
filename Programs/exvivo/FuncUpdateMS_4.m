function [ newMS ] = FuncUpdateMS_4( MS )
%FuncUpdateMS updates the MS values
Mu = 1/10000;

n = length(MS);
MutateVector = binornd(1,Mu,1,n);
MutDirection = binornd(MutateVector,1/2);
newMS = MS + int8(2*MutDirection - MutateVector);

end

