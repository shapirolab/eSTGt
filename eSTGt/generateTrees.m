function Tree = generateTrees(Rules,Nodes)
for k=1:length(Nodes)
    Names = cellfun(@(x) (x.Name),Nodes{k},'UniformOutput',false);
    for i=1:length(Names)
        NameInds{k}.(Names{i})=i;
    end
end

global NullInd;
NullInd = 0;

% find multiple roots (when the initial population is > 1)
for type = 1:length(Nodes)
    rootInds{type} = find(cellfun(@isempty,(cellfun(@(x) x.Parent, Nodes{type}, 'UniformOutput',false))) == 1);
    for i=1:length(rootInds{type})
        if (isempty(Nodes{type}{rootInds{type}(i)}.Children))
            continue;
        end
        Tree.Newick{type,i} = createNewick(Rules,NameInds,Nodes,Nodes{type}{rootInds{type}(i)});
        Tree.tree{type,i} = phytreeread(Tree.Newick{type,i});
    end
end
end



function newick = createNewick(Rules,NameInds,Nodes,Node)
    global NullInd;
    if (length(Node.Children) == 0)
        newick = Node.Name;
        return;
    end

    if (length(Node.Children) == 1)
        str = strtok(Node.Children{1},'_[0-9]+');
        if (strcmp('Dead',str) == 1)
            time = Node.EventTime-Node.CreationTime;
            newick = ['(' Node.Children{1} ':' num2str(time) ',Null_' num2str(NullInd) ':0)' Node.Name];
            NullInd = NullInd+1;
            return;
        end
    end
    
    for rep=1:length(Node.Children)
        str = strtok(Node.Children{rep},'_[0-9]+');
        type(rep) = strmatch(str,Rules.AllNames,'exact');
        
        indChild(rep) = NameInds{type(rep)}.(Node.Children{rep});
    end
    
    if (length(Node.Children) == 1)
        Node1 = Nodes{type(1)}{indChild(1)};
        newick1 = createNewick(Rules,NameInds,Nodes,Node1);
        time = Node.EventTime-Node.CreationTime;
        newick = ['(' newick1 ':' num2str(time) ',Null_' num2str(NullInd) ':0)' Node.Name];
        NullInd = NullInd+1;
        return;
    end
    
    if (length(Node.Children) == 2)
        Node1 = Nodes{type(1)}{indChild(1)};
        newick1 = createNewick(Rules,NameInds,Nodes,Node1);
        Node2 = Nodes{type(2)}{indChild(2)};
        g=strcmp('C_207',Node2.Name);
        newick2 = createNewick(Rules,NameInds,Nodes,Node2);
        time = Node.EventTime-Node.CreationTime;
        newick = ['(' newick1 ':' num2str(time) ',' newick2 ':' num2str(time) ')' Node.Name];
        return;
    end
end