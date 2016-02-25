function [RunsData, Runs] = updateSimRun(RunsData, Runs)
if (isempty(RunsData.Tall))
    RunsData.Tall = Runs.T;
    X = Runs.X;
    RunsData.Xalldiff = [X(1,:);X(2:end,:)-X(1:end-1,:)];
    RunsData.XallMin = X;
    RunsData.XallMax = X;
    RunsData.XallMinDiff = RunsData.Xalldiff;
    RunsData.XallMaxDiff = RunsData.Xalldiff;
else
    T = Runs.T;
    Tall = RunsData.Tall;
    X = Runs.X;
    XallDiff = RunsData.Xalldiff;
    XallMinDiff = RunsData.XallMinDiff;
    XallMaxDiff = RunsData.XallMaxDiff;
    
    [Tsort, inds] = sort([Tall; T]);
    indsnew = (inds > length(Tall));
    indsold = ~indsnew;

    XDiff = [X(1,:);X(2:end,:)-X(1:end-1,:)];
    
    XallDiff2 = zeros(length(Tsort),size(X,2));
    XDiff2 = zeros(length(Tsort),size(X,2));
    XallMinDiff2 = zeros(length(Tsort),size(X,2));
    XallMaxDiff2 = zeros(length(Tsort),size(X,2));
    
    XallDiff2(indsold,:) = XallDiff;
    XallMinDiff2(indsold,:) = XallMinDiff;
    XallMaxDiff2(indsold,:) = XallMaxDiff;
    XDiff2(indsnew,:) = XDiff;
    
    RunsData.Xalldiff = XallDiff2+XDiff2;
    X2 = cumsum(XDiff2);
    
    RunsData.XallMin = min(X2,cumsum(XallMinDiff2));
    RunsData.XallMax = max(X2,cumsum(XallMaxDiff2));
    X = RunsData.XallMin;
    RunsData.XallMinDiff = [X(1,:);X(2:end,:)-X(1:end-1,:)];
    X = RunsData.XallMax;
    RunsData.XallMaxDiff = [X(1,:);X(2:end,:)-X(1:end-1,:)];
    
    RunsData.Tall = Tsort;
end

RunsData.Xall = cumsum(RunsData.Xalldiff)/length(RunsData.Seeds);
RunsData.XallL = RunsData.Xall-RunsData.XallMin;
RunsData.XallU = RunsData.XallMax-RunsData.Xall;
