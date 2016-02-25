function OutputRun = RunSimuLin(Rules,InitialPopulation,TimeSpan,updating_fcn,myguiHandles,RunName)
%RUNSIMULIN Runs the Lineage Simulation
%   This function gets production rules and runs the simulation accordingly
    if (exist('myguiHandles') ~= 1)
        myguiHandles = [];
    end
    OutputRun = directMethod(Rules,InitialPopulation,TimeSpan,updating_fcn,myguiHandles,RunName);
    OutputRun.Name = RunName;
end

