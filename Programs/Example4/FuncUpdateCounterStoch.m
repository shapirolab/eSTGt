function [ newCounterStoch ] = FuncUpdateCounterStoch( CounterStoch )
%FuncUpdateCounterStoch updates the stochastic counter
newCounterStoch = CounterStoch + normrnd(1,0.1);

end

