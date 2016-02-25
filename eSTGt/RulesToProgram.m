function ProgramString = RulesToProgram(Rules)

% The Start rule
StartStr = 'Start -> {';
for i=1:length(Rules.StartNames)
    StartStr = [StartStr num2str(Rules.InitPop(i)) '*' Rules.StartNames{i}];
    if (length(Rules.Prod{i}.InternalStatesNames) > 0)
        StartStr = [StartStr '('];
    end
    for j=1:length(Rules.Prod{i}.InternalStatesNames)
        Name = Rules.Prod{i}.InternalStatesNames{j};
        StartStr = [StartStr num2str(Rules.Prod{i}.InternalStates.(Name).InitVal) ','];
    end
    StartStr = [StartStr(1:end-1) ')'];
    StartStr = [StartStr ', '];
end
StartStr = [StartStr(1:end-2) '}'];

% Rules for each species
for i=1:length(Rules.Prod)
    RuleStr{i} = Rules.Prod{i}.Start;
    if (length(Rules.Prod{i}.InternalStatesNames) > 0)
        RuleStr{i} = [RuleStr{i} '('];
    end
    for j=1:length(Rules.Prod{i}.InternalStatesNames)
        Name = Rules.Prod{i}.InternalStatesNames{j};
        RuleStr{i} = [RuleStr{i} Name ','];
    end
    if (length(Rules.Prod{i}.InternalStatesNames) > 0)
        RuleStr{i} = [RuleStr{i}(1:end-1) ') -> ' Rules.Prod{i}.Start 'Rate {'];
    else
        RuleStr{i} = [RuleStr{i} ' -> ' Rules.Prod{i}.Start 'Rate {'];
    end
    for j=1:length(Rules.Prod{i}.End)
        for k=1:length(Rules.Prod{i}.End{j})
            RuleStr{i} = [RuleStr{i} Rules.Prod{i}.End{j}{k}];
            if (strcmp(Rules.Prod{i}.End{j}{k},'0'))
                RuleStr{i} = [RuleStr{i} ','];
            else
                [a b] = ismember(Rules.Prod{i}.End{j}{k},Rules.StartNames);
                if (b > 0)
                    if (length(Rules.Prod{b}.InternalStatesNames) > 0)
                        RuleStr{i} = [RuleStr{i} '('];
                    end
                    for s=1:length(Rules.Prod{b}.InternalStatesNames)
                        Name = Rules.Prod{b}.InternalStatesNames{s};
                        if (strcmp(Rules.Prod{i}.End{j}{k},Rules.Prod{i}.Start) == 1 || ismember(Name,Rules.Prod{i}.InternalStatesNames))
                            RuleStr{i} = [RuleStr{i} func2str(Rules.Prod{b}.InternalStates.(Name).hFunc) '(' Name '),'];
                        else
                            RuleStr{i} = [RuleStr{i} num2str(Rules.Prod{b}.InternalStates.(Name).InitVal) ','];
                        end
                    end
                    if (length(Rules.Prod{b}.InternalStatesNames) > 0)
                        RuleStr{i} = [RuleStr{i}(1:end-1) ')'];
                    end
                end
                RuleStr{i} = [RuleStr{i} ','];
            end
        end
        RuleStr{i} = [RuleStr{i}(1:end-1) '}_' Rules.Prod{i}.Start 'Prob' num2str(j) ' | {'];
    end
    RuleStr{i} = [RuleStr{i}(1:end-4)];
    
end

ProgramString = [StartStr RuleStr];
end