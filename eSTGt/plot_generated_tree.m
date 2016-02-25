function plot_generated_tree(tr,colorsOrder,Names)
NodeNames = regexprep(get(tr,'NodeNames'),'[a-zA-Z0-9]*_','','once');
NodeNamesFull = get(tr,'NodeNames');
tr = phytree(get(tr,'Pointers'),get(tr,'Distance'),NodeNamesFull);
list_group_names=unique(cat(1,regexprep(NodeNames,'_.+','')));
list_group_names(strmatch('Null',list_group_names))=[];
list_group_names(strmatch('DummyRoot',list_group_names))=[];
indD = strmatch('Dead',list_group_names,'exact');
list_group_names(indD) = [];
if (~isempty(indD))
    list_group_names{end+1} = 'Dead';
end
group_names{1} = NodeNamesFull(strmatch('Null',NodeNames));

[a b] = ismember(list_group_names,Names);
inds = sort(b(find(b~=0)));
list_group_names(a) = Names(inds);
for i=1:length(list_group_names)
    group_names{i+1} = NodeNamesFull(setdiff(find(~cellfun(@isempty,regexp(NodeNames,[list_group_names{i} '_[0-9]*']))),strmatch('Null',NodeNames)));
end

list = [[1 1 1];colorsOrder(inds,:);[0 0 0]];
colors = mat2cell(list,ones(1,size(list,1)),size(list,2))';
tHand = tree_plot(tr,colors,0,'BranchLabels','false','group',group_names,'display_branch_labels',0,'ORIENTATION','bottom','TERMINALLABELS','false');
hLegend  = legend(list_group_names);
set(hLegend,'FontSize',8);
hKids = get(hLegend,'Children'); 
indsT = strcmp(get(hKids,'Type'),'text');
hText = hKids(indsT);
set(hText,{'Color'},colors(length(list_group_names)+1:-1:2)');
hLine = hKids(find(indsT==1)-1);
set(hLine,{'Color'},colors(length(list_group_names)+1:-1:2)');
set(tHand.axes,'fontsize',8);
end