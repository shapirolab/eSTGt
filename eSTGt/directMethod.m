function [OutputRun] = directMethod(Rules,InitialPopulation,TimeSpan,updating_fcn,myguiHandles,RunName)
%directMethod Runs the Gillespie direct method algorithm and mantains the
%history

MAX_LENGTH = 1000000;

numSpecies = length(Rules.AllNames);
T = zeros(MAX_LENGTH, 1);
R = zeros(MAX_LENGTH, 1);
Id = zeros(MAX_LENGTH, 2);
X = zeros(MAX_LENGTH, numSpecies);
LiveNodes = cell(MAX_LENGTH,length(Rules.AllNames));
T(1)     = TimeSpan(1);
R(1)     = 0;
Id(1,:)     = [0 0];
X(1,:)   = InitialPopulation;
Rules.Propensities = X(1,Rules.IndsRep).*Rules.Rates;
exe_counter = 1;
startTime = tic;
Nodes = cell(length(Rules.AllNames),1);
% Create the tree structure
% for each cell type create a list of nodes
for i=1:length(Rules.StartNames)
    for n=1:InitialPopulation(i)
        Nodes{i}(n).Name = [RunName '_' Rules.AllNames{i} '_' int2str(n)];
        Nodes{i}(n).Type = i;
        Nodes{i}(n).Children = {};
        Nodes{i}(n).ChildrenType = [];
        Nodes{i}(n).Parent = {};
        Nodes{i}(n).CreationTime = 0;
        Nodes{i}(n).RootInd = n;
        Nodes{i}(n).RootType = i;
        % Initialize internal states
        if (isfield(Rules.Prod{i},'InternalStates'))
            fn = fieldnames(Rules.Prod{i}.InternalStates);
            for j=1:size(fn,1)
                Nodes{i}(n).InternalStates.(fn{j}) = repmat(Rules.Prod{i}.InternalStates.(fn{j}).InitVal,1,Rules.Prod{i}.InternalStates.(fn{j}).DupNum);
            end   
        end
    end
    LiveNodes{1,i} = 1:InitialPopulation(i);
end

DeadInd = 1;
tic;
ttime = toc;
while (T(exe_counter) < TimeSpan(2))
    S = sum(Rules.Propensities);
    CS = cumsum(Rules.Propensities);
    rnd = rand(1,2);
    tau = (1/S)*log(1/rnd(1));
    mu  = find((CS >= rnd(2)*S),1,'first');

    if (S == 0 || (T(exe_counter) + tau >= TimeSpan(2)))
        T = T(1:exe_counter+1);
        X = X(1:exe_counter+1,:);
        R = R(1:exe_counter+1);
        Id = Id(1:exe_counter+1,:);
        LiveNodes = LiveNodes(1:exe_counter+1,:);


        T(end) = TimeSpan(2);
        X(end,:) = X(exe_counter,:);
        R(end) = 0;
        Id(end,:) = [0 0];
        LiveNodes(end,:) = LiveNodes(exe_counter,:);
        if (isempty(myguiHandles))
            disp(' *** Finished Simulation Run ***');
        else
            set(myguiHandles.textStatus,'String','Finished Simulation Run');
            drawnow;
        end
        break;
    end
    
    T(exe_counter+1) = T(exe_counter) + tau;
    R(exe_counter+1) = mu;
    X(exe_counter+1,:) = X(exe_counter,:) + Rules.stoich_matrix(mu,:);    
    exe_counter = exe_counter + 1;
  
    % update Nodes
    LiveNodes(exe_counter,:) = LiveNodes(exe_counter-1,:);
    [Rules,DeadInd,Nodes,id,livenodes,Xupdate] = updateNode(Rules,DeadInd,Nodes,X(exe_counter,:),R(exe_counter),T(exe_counter),LiveNodes(exe_counter,:),RunName);

    X(exe_counter,:) = Xupdate;
    Id(exe_counter,:) = id;
    LiveNodes(exe_counter,:) = livenodes;
    
    % updating the rules rates and probabilties
    [updated_Rules] = updating_fcn(Rules, T(exe_counter), X(exe_counter,:));
    Rules = updated_Rules;
    Rules.Rates = cell2mat(cellfun(@(x) (x.Probs*x.Rate), Rules.Prod,'UniformOutput',false));
    Rules.Propensities = X(exe_counter,Rules.IndsRep).*Rules.Rates;
    %if (mod(exe_counter,1000) == 0)
    ttmp = toc;
    if (ttmp - ttime > 5)
        ttime = ttmp;
        if (isempty(myguiHandles))
            disp(['Current Simulation Time (Real Clock): ' num2str(T(exe_counter)) ' (' num2str(toc(startTime)) ' sec.)']);
            drawnow('update');
        else
            set(myguiHandles.textStatus,'String',['Current Simulation Time: ' num2str(T(exe_counter))]);
            plot(myguiHandles.axesPopSize,T(1:exe_counter),X(1:exe_counter,:));
            xlabel('Time');
            ylabel('Population Size');
            legend(myguiHandles.Rules.AllNames);
            drawnow;
            if (get(myguiHandles.checkboxStop,'Value') == 1)
                break;
            end
        end
    end
    
    if (exe_counter >= MAX_LENGTH)
        T = T(1:exe_counter);
        X = X(1:exe_counter,:);
        R = R(1:exe_counter);
        Id = Id(1:exe_counter,:);
        LiveNodes = LiveNodes(1:exe_counter,:);
        warning('Execution limit exceeded');
        return;
    end
    
end

% sort the nodes according to time
% for i=1:length(Nodes)
%     [a b] = sort(extractfield(Nodes{i},'CreationTime'));
%     Nodes{i} = Nodes{i}(b);
%     [a b] = sort(extractfield(Nodes{i}(1:Rules.InitPop(i)),'RootInd'));
%     Nodes{i}(1:Rules.InitPop(i)) = Nodes{i}(b);
% end

% create naming hash for fast access
for k=1:length(Nodes)
    if (isempty(Nodes{k}))
        continue;
    end
    Names = extractfield(Nodes{k},'Name');
    for i=1:length(Names)
        NameInds{k}.(Names{i})=i;
    end
end

OutputRun.T = T;
OutputRun.R = R;
OutputRun.X = X;
OutputRun.Id = Id;
OutputRun.Nodes = Nodes;
OutputRun.NameInds = NameInds;
OutputRun.LiveNodes = LiveNodes;

if (~isempty(myguiHandles))
    set(myguiHandles.textStatus,'String','Done');
    drawnow;
end

end

function [Rules,DeadInd,Nodes,id,livenodes,Xupdate] = updateNode(Rules,DeadInd,Nodes,X,R,T,livenodes,RunName)
    if (R == 0)
        return;
    end
    Xupdate = X;
    parentType = Rules.IndsRep(R);
    childrenType = Rules.stoich_matrix(R,:);
    childrenType(parentType) = childrenType(parentType)+1;

    r = randi(length(livenodes{parentType}));
    rnd = livenodes{parentType}(r);
    livenodes{parentType}(r) = [];
    id = [Nodes{parentType}(rnd).RootType Nodes{parentType}(rnd).RootInd];
    Nodes{parentType}(rnd).EventTime = T;
 
    if (sum(childrenType) == 0)
        Nodes{parentType}(rnd).Children = {[RunName '_Dead_' int2str(DeadInd)]};
        Nodes{parentType}(rnd).ChildrenType = [0];
        DeadInd = DeadInd+1;
    else
        for type=1:length(childrenType)
            if (childrenType(type) == 0)
                continue;
            end

            for rep=1:childrenType(type)
                len = length(Nodes{type});
                Nodes{type}(len+1).Name = [RunName '_' Rules.AllNames{type} '_' int2str(len+1)];
                livenodes{type}(end+1) = len+1;
                Nodes{type}(len+1).Type = type;
                Nodes{type}(len+1).CreationTime = T;
                Nodes{type}(len+1).Children = {};
                Nodes{type}(len+1).ChildrenType = [];
                Nodes{type}(len+1).Parent = {Nodes{parentType}(rnd).Name};
                Nodes{type}(len+1).RootType = Nodes{parentType}(rnd).RootType;
                Nodes{type}(len+1).RootInd = Nodes{parentType}(rnd).RootInd;

                Nodes{parentType}(rnd).Children = [Nodes{parentType}(rnd).Children Nodes{type}(len+1).Name];
                Nodes{parentType}(rnd).ChildrenType = [Nodes{parentType}(rnd).ChildrenType type];
                % update internal states
                if (type <= length(Rules.Prod))
                    if (isfield(Rules.Prod{type},'InternalStatesNames'))
                        for j=1:length(Rules.Prod{type}.InternalStatesNames)
                            % if the internal state name exist in the father (even if
                            % it not of the same type) then update the child
                            % accordingly.
                            ISname = Rules.Prod{type}.InternalStatesNames{j};
                            if (isfield(Nodes{parentType}(rnd),'InternalStates') && isfield(Nodes{parentType}(rnd).InternalStates,ISname))
                                Nodes{type}(len+1).InternalStates.(ISname) = Rules.Prod{type}.InternalStates.(ISname).hFunc(Nodes{parentType}(rnd).InternalStates.(ISname), T, Nodes, parentType, rnd, rep);
                            else
                                Nodes{type}(len+1).InternalStates.(ISname) = repmat(Rules.Prod{type}.InternalStates.(ISname).InitVal,1,Rules.Prod{type}.InternalStates.(ISname).DupNum);
                            end
                        end
                    end
                    if (isfield(Rules.Prod{type},'CondTransitions'))
                        for cond=1:length(Rules.Prod{type}.CondTransitions)
                            if (checkCondition(Rules.Prod{type},Nodes{type}(len+1),cond))
                                Nodes{type}(len+1).EventTime = T;
                                % Delete the father
                                livenodes{type} = livenodes{type}(1:end-1);
                                Xupdate(type)=Xupdate(type)-1;
                                
                                % If got to here it means that the conditional transition have occured
                                [~, typeCon] = ismember(Rules.Prod{type}.CondTransitions{cond}.Transition,Rules.AllNames);

                                % if the transition is to a type that has a rule
                                if (typeCon > 0)
                                    Xupdate(typeCon)=Xupdate(typeCon)+1;
                                    lenCon = length(Nodes{typeCon});
                                    Nodes{typeCon}(lenCon+1).Name = [RunName '_' Rules.AllNames{typeCon} '_' int2str(lenCon+1)];
                                    livenodes{typeCon}(end+1) = lenCon+1;
                                    Nodes{typeCon}(lenCon+1).Type = typeCon;
                                    Nodes{typeCon}(lenCon+1).CreationTime = T;
                                    Nodes{typeCon}(lenCon+1).Children = {};
                                    Nodes{typeCon}(lenCon+1).ChildrenType = [];
                                    Nodes{typeCon}(lenCon+1).Parent = {Nodes{type}(len+1).Name};
                                    Nodes{typeCon}(lenCon+1).RootType = Nodes{type}(len+1).RootType;
                                    Nodes{typeCon}(lenCon+1).RootInd = Nodes{type}(len+1).RootInd;

                                    Nodes{type}(len+1).Children = [Nodes{type}(len+1).Children Nodes{typeCon}(lenCon+1).Name];
                                    Nodes{type}(len+1).ChildrenType = [Nodes{type}(len+1).ChildrenType typeCon];
                                    % update internal states
                                    if (isfield(Rules.Prod{typeCon},'InternalStatesNames'))
                                        for j=1:length(Rules.Prod{typeCon}.InternalStatesNames)
                                            % if the internal state name exist in the father (even if
                                            % it not of the same type) then update the child
                                            % accordingly.
                                            ISname = Rules.Prod{typeCon}.InternalStatesNames{j};
                                            if (isfield(Nodes{type}(len+1),'InternalStates') && isfield(Nodes{type}(len+1).InternalStates,ISname))
                                                Nodes{typeCon}(lenCon+1).InternalStates.(ISname) = Nodes{type}(len+1).InternalStates.(ISname);
                                            else
                                                Nodes{typeCon}(lenCon+1).InternalStates.(ISname) = repmat(Rules.Prod{typeCon}.InternalStates.(ISname).InitVal,1,Rules.Prod{typeCon}.InternalStates.(ISname).DupNum);
                                            end
                                        end
                                    end
                                else
                                    % if dead
                                    if (strcmp(Rules.Prod{type}.CondTransitions{cond}.Transition,'{0}'))
                                        Nodes{type}(len+1).Children = {[RunName '_Dead_' int2str(DeadInd)]};
                                        Nodes{type}(len+1).ChildrenType = [0];
                                        DeadInd = DeadInd+1;
                                    end
                                end
                                break; % don't check other transitional conditions
                            end
                        end
                    end
                end
            end
        end
    end
    
    % Remove Internal States to save space
    
%     if (isfield(Nodes{parentType}(rnd),'InternalStates'))
%         for Itmp = fieldnames(Nodes{parentType}(rnd).InternalStates)'
%             Nodes{parentType}(rnd).InternalStates.(Itmp{1}) = [];
%         end
%     end

end

function res = checkCondition(Prod,Node,CondInd)
res=0;

u_Names = fieldnames(Node.InternalStates);
for i=1:length(u_Names)
    eval([u_Names{i} '=[' num2str(Node.InternalStates.(u_Names{i})) '];']);
end

eval(['res=(' Prod.CondTransitions{CondInd}.Condition ');']);

end
