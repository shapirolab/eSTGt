% Parses a string rule
function Rule = parseRule(RuleStrOrig)
RuleStrOrig(isspace(RuleStrOrig)) = '';
RuleStr = RuleStrOrig;

Rule.String = RuleStrOrig;

% Parse the 'From' species
ind = strfind(RuleStr,'->');
Rule.Start = RuleStr(1:ind-1);
RuleStr = RuleStr(ind+2:end);

% Parse the rate (if exists)
ind = strfind(RuleStr,'{');
if (ind > 1)
    Rule.Rate = str2num(RuleStr(1:ind(1)-1));
    if (Rule.Rate==inf)
        Rule.Rate = 10^100;
    end    
    RuleStr = RuleStr(ind(1):end);
else
    Rule.Rate = 0;
end

% Parse the 'To' species
indL = strfind(RuleStr,'{');
indR = strfind(RuleStr,'}');

for i=1:length(indL)
    Rule.End{i} = regexp( RuleStr(indL(i)+1:indR(i)-1),',','split');
end

% Parse the probabilities
inds = strfind(RuleStr,'}_');
inds2 = strfind(RuleStr,'|');
if (length(inds2) == 0)
    Rule.Probs = 1;
else
    for i=1:length(inds2)
        Rule.Probs(i) = str2num(RuleStr(inds(i)+2:inds2(i)-1));
    end
    Rule.Probs = [Rule.Probs 1-sum(Rule.Probs)];
end

for i=1:length(Rule.End)
    if (length(Rule.End{i}) == 1)
        singleStr{i} = cell2mat([Rule.Start '->' num2str(Rule.Rate) '{' Rule.End{i}(1) '}_' num2str(Rule.Probs(i))]);
    else
        singleStr{i} = cell2mat([Rule.Start '->' num2str(Rule.Rate) '{' Rule.End{i}(1) ',' Rule.End{i}(2) '}_' num2str(Rule.Probs(i))]);
    end
end
if (length(Rule.End) == 1)
    singleStr{1} = singleStr{1}(1:end-2);
end


Rule.StringSingle = singleStr;

end
