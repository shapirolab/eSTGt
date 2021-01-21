function [ newMS ] = FuncUpdateMS( MS, T, Nodes, parentType, rnd, rep )

%FuncUpdateMS updates the MS values according to the stepwise model
Mu = 1/100; % the mutation rate (10^-4)

n = length(MS);
MutateVector = binornd(1,Mu,1,n);
MutDirection = binornd(MutateVector,1/2);
newMS = MS + (2*MutDirection - MutateVector);

%disp([parentType, rnd]);
%disp(Nodes{parentType}(rnd).InternalStates.('MS'));
%disp(MS);
%disp(newMS);
end