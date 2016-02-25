function Tree = generateTree(Rules,Nodes,Node,NameInds,Name)

global NullInd;
if (~exist('NullInd') || isempty(NullInd))
    NullInd = 0;
end

if (~exist('Name'))
    Name = [];
end
if (isempty(Node.Children))
    Tree.Newick = Node.Name;
    Tree.tree = [];
    return;
end
Tree.Newick = createNewick(Rules,Nodes,Node,NameInds,Name);
Tree.tree = phytreeread(Tree.Newick);
end

function newick = createNewick(Rules,Nodes,Node,NameInds,Name)
    global NullInd;
    if (length(Node.Children) == 0)
        newick = Node.Name;
        return;
    end

    if (length(Node.Children) == 1)
        if (Node.ChildrenType == 0)
            time = Node.EventTime-Node.CreationTime;
            newick = ['(' Node.Children{1} ':' num2str(time) ',' Name '_Null_' num2str(NullInd) ':' num2str(eps) ')' Node.Name];
            NullInd = NullInd+1;
            return;
        end
    end
    
    type = Node.ChildrenType;
    for rep=1:length(Node.Children)
        indChild(rep) = NameInds{type(rep)}.(Node.Children{rep});
    end
    
    if (length(Node.Children) == 1)
        Node1 = Nodes{type(1)}(indChild(1));
        newick1 = createNewick(Rules,Nodes,Node1,NameInds,Name);
        time = Node.EventTime-Node.CreationTime;
        newick = ['(' newick1 ':' num2str(time) ',' Name '_Null_' num2str(NullInd) ':' num2str(eps) ')' Node.Name];
        NullInd = NullInd+1;
        return;
    end
    
    if (length(Node.Children) == 2)
        Node1 = Nodes{type(1)}(indChild(1));
        newick1 = createNewick(Rules,Nodes,Node1,NameInds,Name);
        Node2 = Nodes{type(2)}(indChild(2));
        newick2 = createNewick(Rules,Nodes,Node2,NameInds,Name);
        time = Node.EventTime-Node.CreationTime;
        newick = ['(' newick1 ':' num2str(time) ',' newick2 ':' num2str(time) ')' Node.Name];
        return;
    end
end