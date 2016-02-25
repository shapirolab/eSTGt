function [ Runs, RunsData ] = RunSim(Rules, Seeds, TimeSpan)
%RUNSIM Runs the stochastic simulation program
%   [ RUNS, RUNSDATA ] = RUNSIM(RULES, SEEDS, TIMESPAN) recieves the RULES
%   as retruned by the function ParseeSTGProgram, SEEDS that contain the
%   random seeds for multiple simulations execution, and TIMESPAN that
%   contains a vector [START, END] with the start and end times of the
%   simulation and returns two outputs - RUNS, which is an array of
%   structures containing the simulation results for each random seed, and
%   RUNSDATA, which includes common information for all runs.
%
%   See also PARSEESTGPROGRAM

RunsData.Seeds = Seeds;
RunsData.NumRuns = 0;
RunsData.Tall = [];

if (length(unique(Seeds)) ~= length(Seeds))
    disp('Error: Seeds values should be unique');
    return;
end

% Run multiple simulations for each seed value
for seed = Seeds
    s = RandStream('mcg16807','Seed',seed);
    RandStream.setGlobalStream(s);
    
	RunsData.NumRuns = RunsData.NumRuns + 1;
	NumRuns = RunsData.NumRuns;
    RunName = ['Run' num2str(NumRuns)];
    disp(['Running "' RunName '", Seed: ' num2str(seed)]);
    Runs(NumRuns) = RunSimuLin(Rules,Rules.InitPop,[0 TimeSpan],Rules.funcHandle,[],RunName);

    [RunsDataTmp, RunsTmp] = updateSimRun(RunsData, Runs(NumRuns));
    RunsData = RunsDataTmp;
    Runs(NumRuns) = RunsTmp;
end

end

