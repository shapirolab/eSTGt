function [ Rules ] = ParseeSTGProgram( programFile )
%PARSEESTGPROGRAM parses a string containing an eSTG program
%   RULES = PARSEESTGPROGRAM(PROGRAMFILE) recieves a file name string
%   PROGRAMFILE containing an eSTG program and creates a data structure
%   that can be passed to RunSim
%
%   See also RunSim

try
    % Parse the rules
    % The following parsing assumes a single rule for each species. In case
    % there are more than one they should first be converted to one rule and
    % then continue with the parsing.
    xml_data = xmlread(programFile);
    [pathstr,name,ext] = fileparts(programFile);
    addpath(pathstr);
    numRules = xml_data.getElementsByTagName('Rule').getLength;
    for i=1:numRules
        str = char(xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('Prod').item(0).getFirstChild.getData);
        str(isspace(str)) = '';
        Rule= parseRule(str);
        Rules.Prod{i} = Rule;
        % Parse the internal states
        numInternalStates = xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('InternalState').getLength;
        Rules.Prod{i}.InternalStates = struct;
        Rules.Prod{i}.InternalStatesNames = {};
        for j=1:numInternalStates
            nameIS = char(xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('InternalState').item(j-1).getElementsByTagName('Name').item(0).getFirstChild.getData);
            nameIS(isspace(nameIS)) = '';
            initvalIS = str2num(char(xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('InternalState').item(j-1).getElementsByTagName('InitVal').item(0).getFirstChild.getData));
            hFunIS = char(xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('InternalState').item(j-1).getElementsByTagName('FuncHandleName').item(0).getFirstChild.getData);
            hFunIS(isspace(hFunIS)) = '';
            dupNumIS = 1;
            try
                dupNumIS = str2num(char(xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('InternalState').item(j-1).getElementsByTagName('DuplicateNum').item(0).getFirstChild.getData));
            catch
            end
            Rules.Prod{i}.InternalStates.(nameIS).InitVal = initvalIS;
            Rules.Prod{i}.InternalStates.(nameIS).hFunc = str2func(hFunIS);
            Rules.Prod{i}.InternalStates.(nameIS).DupNum = dupNumIS;
            Rules.Prod{i}.InternalStatesNames{j} = nameIS;
        end
        
        % Parse the conditional transitions
        numCondTransitions = xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('ConditionalTransition').getLength;
        for j=1:numCondTransitions
            condition = char(xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('ConditionalTransition').item(j-1).getElementsByTagName('Condition').item(0).getFirstChild.getData);
            condition(isspace(condition)) = '';
            transition = char(xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('ConditionalTransition').item(j-1).getElementsByTagName('Transition').item(0).getFirstChild.getData);
            transition(isspace(transition)) = '';

            Rules.Prod{i}.CondTransitions{j}.Condition = condition;
            Rules.Prod{i}.CondTransitions{j}.Transition = transition;
        end
        
        
    end

    % Parse the simulation time
    try
       SimTime = str2num(char(xml_data.getElementsByTagName('ExecParams').item(0).getElementsByTagName('SimTime').item(0).getFirstChild.getData));
       if (~isempty(SimTime))
           Rules.SimTime = SimTime;
       end
    catch
    end

    % Parse the seed
    try
       Seed = str2num(char(xml_data.getElementsByTagName('ExecParams').item(0).getElementsByTagName('Seed').item(0).getFirstChild.getData));
       if (~isempty(SimTime))
           Rules.Seed = Seed;
       end
    catch
    end
    
    
    % Parse the initial population size
    try
        InitPop = [];
        for i=1:numRules
            num = str2num(char(xml_data.getElementsByTagName('Rule').item(i-1).getElementsByTagName('InitPop').item(0).getFirstChild.getData));
            if (isempty(num))
                assert('Initial Population not a number');
            end
            InitPop = [InitPop num];
        end
        Rules.InitPop = InitPop;
    catch
    end

    % Parse the updating function handle name
    try
        funcHandle = char(xml_data.getElementsByTagName('FunHandleName').item(0).getFirstChild.getData);
        funcHandle(isspace(funcHandle)) = '';
        hUpdateFunc = str2func(funcHandle);
        Rules.funcHandle = hUpdateFunc;
    catch
    end  
    
catch exception
    rethrow(exception);
end

% Prepare the rules for simulation
Rules = prepareRules(Rules);
Rules.ProgramString = RulesToProgram(Rules);

end

