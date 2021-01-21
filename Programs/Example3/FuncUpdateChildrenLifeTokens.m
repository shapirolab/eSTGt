function [ newChildrenLifeTokens ] = FuncUpdateChildrenLifeTokens( ChildrenLifeTokens, T, Nodes, parentType, rnd, rep )

p = rand;
my_token = ChildrenLifeTokens(rep);
left_child_token = round(my_token*p);
right_child_token = my_token - left_child_token;

newChildrenLifeTokens = [left_child_token, right_child_token];

end