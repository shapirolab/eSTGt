% prepare the rules for simulation
function Rules = prepareRules(Rules)
    Rules.StartNames = cellfun(@(x) (x.Start), Rules.Prod,'UniformOutput',false);
    Rules.Rates = cell2mat(cellfun(@(x) (x.Probs*x.Rate), Rules.Prod,'UniformOutput',false));

    A = (cellfun(@(x) (x.End), Rules.Prod,'UniformOutput',false));
    B = cellfun(@(x) [x{:}],A, 'UniformOutput',false);
    C = {};
    for i=1:length(B)
        C = [C;B{i}'];
    end
    C = setdiff(C,'0','stable');
    Rules.AllNames = [Rules.StartNames  setdiff(C,Rules.StartNames)'];
    Rules.stoich_matrix = create_stoich_matrix(Rules);
    Rules.IndsRep = repmat(1,1,length(Rules.Prod{1}.End));
    for r = 2:length(Rules.Prod)
        Rules.IndsRep = [Rules.IndsRep repmat(r,1,length(Rules.Prod{r}.End))];
    end    
    % Assumes initial population of 1 individual per species
    Rules.Propensities = Rules.Rates; 
    Rules.InitPop = [Rules.InitPop zeros(1,length(Rules.AllNames)-length(Rules.InitPop))];
end

% prepare stoich matrix
function stoich_matrix = create_stoich_matrix(Rules)
    rows = length(cell2mat(cellfun(@(x) (x.Probs), Rules.Prod, 'UniformOutput',false)));
    stoich_matrix = zeros(rows,length(Rules.AllNames));
    line = 1;
    for prod=1:length(Rules.Prod)
       for k=1:length(Rules.Prod{prod}.End)
           ind = strmatch(Rules.Prod{prod}.Start,Rules.AllNames,'exact');
           stoich_matrix(line,ind) = stoich_matrix(line,ind)-1;
           for i=1:length(Rules.Prod{prod}.End{k})
               ind = strmatch(Rules.Prod{prod}.End{k}{i},Rules.AllNames,'exact');
               if (~isempty(ind))
                   stoich_matrix(line,ind) = stoich_matrix(line,ind)+1;
               end
           end
           line = line+1;
       end
    end
end