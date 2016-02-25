function plotPopulationSize(handles,Mult)
vals = get(handles.listboxRunsAn,'Value');
valsSp = get(handles.listboxSpecies,'Value');
set(0,'DefaultAxesColorOrder',handles.colors(valsSp,:));

if (Mult == 0)
    vals = vals(end);
    set(handles.editSeed,'String',handles.RunsData.Seeds(vals));
    plot(handles.axesPopSize,handles.Runs(vals).T,handles.Runs(vals).X(:,valsSp));
end
for i=1:length(vals)
    val = vals(i);
    if (Mult == 1)
        figure;
        plot(handles.Runs(val).T,handles.Runs(val).X(:,valsSp));
    end
    xlabel('Time');
    ylabel('Population Size');
    legend(handles.Rules.AllNames(valsSp));
    title(['Population Size of ' handles.Runs(val).Name]);
end