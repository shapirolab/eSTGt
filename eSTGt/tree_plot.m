function [handles,x,y] = tree_plot(tr,colors,scale,varargin)

LINSCALE = 0;
LOGSCALE = 1;

%PLOT renders a phylogenetic tree.
%
%   PLOT(TREE) renders a phylogenetic tree object into a MATLAB figure as a
%   phylogram. The significant distances between branches and nodes are in
%   horizontal direction, vertical coordinates are accommodated only for
%   display purposes. Handles to graph elements are stored in the
%   'UserData' figure field, such that graphic properties can be easily
%   modified.
%
%   PLOT(TREE,ACTIVEBRANCHES) hides the non'active branches and all their
%   descendants. ACTIVEBRANCHES is a logical array of size
%   [numBranches x 1] indicating the active branches.
%
%   PLOT(...,'TYPE',type) selects the method to render the phylogenetic
%   tree. Options are: 'square' (default), 'angular', and 'radial'.
%
%   PLOT(...,'ORIENTATION',orient) will orient the phylogenetic tree within
%   the figure window. Options are: 'top', 'bottom', 'left' (default), and,
%   'right'. Orientation parameter is valid only for phylograms or
%   cladograms.
%
%   PLOT(...,'BRANCHLABELS',value) hides/unhides branch labels. Options are
%   true or false. Branch labels are placed next to the branch node.
%   Defaults to false (true) when TYPE is (is not) 'radial'.
%
%   PLOT(...,'LEAFLABELS',value) hides/unhides leaf labels. Options are
%   true or false. Leaf labels are placed next to the leaf nodes. Defaults
%   to false (true) when TYPE is (is not) 'radial'.
%
%   PLOT(...,'TERMINALLABELS',value) hides/unhides terminal labels. Options
%   are true (default) or false. Terminal labels are placed over the axis
%   tick labels, ignored when 'radial' type is used.
%
%   H = PLOT(...) returns a structure with handles to the graph elements.
%
%   Example:
%
%       tr = phytreeread('pf00002.tree')
%       plot(tr,'type','radial')
%
%       % Graph element properties can be modified as follows:
%
%       h=get(gcf,'UserData')
%       set(h.branchNodeLabels,'FontSize',6,'Color',[.5 .5 .5])
%
%   See also PHYTREE, PHYTREE/VIEW, PHYTREEREAD, PHYTREETOOL, SEQLINKAGE.

% Copyright 2003-2006 The MathWorks, Inc.
% $Revision: 1.1.6.10 $ $Author: batserve $ $Date: 2006/06/16 20:06:45 $

MARKER_SIZE=5;
display_branch_labels='off';
%display_branch_labels='on';


terminal_colors={'r','b','c','g','y','m','k','b','r','c','g'};
internal_color={'r','b','c','g','y','m','k','b','r','c','g'};
terminal_colors = colors;
internal_color = colors;
if numel(tr)~=1
    error('Bioinfo:phytree:plot:NoMultielementArrays',...
        'Phylogenetic tree must be an 1-by-1 object.');
end


% set defaults
dispBranchLabels = NaN;
dispLeafLabels = NaN;
dispTerminalLabels = true;
renderType = 'square';
orientation = 'left';
rotation = 0;

tr = struct(tr);
tr.numBranches = size(tr.tree,1);

tr_names2=tr.names;
% modify branch names for easier visualization
for i=1:length(tr.names),
    if ~isempty(findstr(tr.names{i},'en=')),
        index=findstr(tr.names{i},'=');
        tr.names{i}=tr.names{i}(index+1:end);
    end
    if ~isempty(findstr(tr.names{i},'Branch')),
        tr.names{i} = '';
    end
end

if nargin>1 && islogical(varargin{1})
    activeBranches = varargin{1};
    argStart = 2;
else
    activeBranches = true(tr.numBranches,1);
    argStart = 1; 
end

if nargin - argStart > 0
    if rem(nargin - argStart-1,2) == 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%301111%%%%%%%%%%%%%%
        error('Bioinfo:phytree:plot:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'type','orientation','rotation',...
        'branchlabels','leaflabels','terminallabels','Group','display_branch_labels'};
    for j = argStart:2:nargin-argStart-2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%301111%%%%%%%%%%%%%%
        pname = varargin{j};
        pval = varargin{j+1};
        k = find(strncmpi(pname,okargs,numel(pname)));
        if isempty(k)
            error('Bioinfo:phytree:plot:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:phytree:plot:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1 % type
                    oktypes={'square','angular','radial'};
                    l = strmatch(lower(pval),oktypes); %#ok
                    if isempty(l)
                        error('Bioinfo:phytree:plot:UnknownTypeName',...
                            'Unknown option for %s.',upper(okargs{k}));
                    else
                        if l==4
                            l=1;
                        end
                        renderType = oktypes{l};
                    end
                case 2 % orientation
                    oktypes={'left','right','top','bottom'};
                    l = strmatch(lower(pval),oktypes); %#ok
                    if isempty(l)
                        error('Bioinfo:phytree:plot:UnknownOrientation',...
                            'Unknown option for %s.',upper(okargs{k}));
                    else
                        orientation = oktypes{l};
                    end
                case 3 % rotation
                    if isreal(pval(1))
                        rotation = double(pval(1));
                    else
                        error('Bioinfo:phytree:plot:NotValidType',...
                            'ROTATION must be numeric and real');
                    end
                case 4 % branch labels
                    dispBranchLabels = opttf(pval);
                case 5 % leaf labels
                    dispLeafLabels = opttf(pval);
                case 6 % terminal labels
                    dispTerminalLabels = opttf(pval);
                case 7 % group to color differently
                    group = pval;
                case 8 % display branch labels
                    if pval,
                        display_branch_labels='on';
                    else
                        display_branch_labels='off';
                    end
            end
        end
    end
end

% set dependent defaults
if isnan(dispBranchLabels)
    if isequal(renderType,'radial')
        dispBranchLabels = true;
    else
        dispBranchLabels = false;
    end
end
if isnan(dispLeafLabels)
    if isequal(renderType,'radial')
        dispLeafLabels = true;
    else
        dispLeafLabels = false;
    end
end

%tr.dist = tr.dist(2:end-1);
%tr.names = tr.names(2:end-1);
tr = doBasicCalculations(tr,activeBranches,renderType);
%ind_nonzero = find(tr.x>0);
%tr.x = log(tr.x);
%tr.x = tr.x(ind_nonzero);
%tr.y = tr.y(ind_nonzero);
%tr.dist = tr.dist(ind_nonzero);
%tr.par = tr.par(ind_nonzero);
%tr.activeNodes = tr.activeNodes(ind_nonzero);
%tr.lastleaf = tr.lastleaf(ind_nonzero);
%tr.names = tr.names(ind_nonzero);
%tr.numLabels = length(tr.x);
x=tr.x;
y=tr.y;
nodeIndex   = 1:tr.numLabels;
leafIndex   = 1:tr.numLeaves;
branchIndex = tr.numLeaves+1:tr.numLabels;


% check empty names
for ind = nodeIndex
    if isempty(tr.names{ind})
        if ind > tr.numLeaves
            %tr.names{ind} = ['Branch ' num2str(ind-tr.numLeaves)];
        else
            tr.names{ind} = ['Leaf ' num2str(ind)];
        end
    end
end

% rendering graphic objects
fig = figure('Renderer','ZBuffer');
h.axes = axes; hold on;
sepUnit = max(tr.x)*[-1/20 21/20];


% setting the axes

switch renderType
    case {'square','angular'}
        switch orientation
            case 'left'
                set(h.axes,'YTick',1:numel(tr.terminalNodes),'Ydir','reverse',...
                    'YtickLabel','','YAxisLocation','Right')
                if dispTerminalLabels
                    set(h.axes,'Position',[.05 .10 .7 .85])
                else
                    set(h.axes,'Position',[.05 .10 .9 .85])
                end
                xlim(sepUnit);
                ylim([0 numel(tr.terminalNodes)+1]);
            case 'right'
                set(h.axes,'YTick',1:numel(tr.terminalNodes),'Xdir','reverse','Ydir','reverse',...
                    'YtickLabel','','YAxisLocation','Left')
                if dispTerminalLabels
                    set(h.axes,'Position',[.25 .10 .7 .85])
                else
                    set(h.axes,'Position',[.05 .10 .9 .85])
                end
                xlim(sepUnit);
                ylim([0 numel(tr.terminalNodes)+1]);
            case 'top'
                set(h.axes,'XTick',1:numel(tr.terminalNodes),...
                    'XtickLabel','','XAxisLocation','Top')
                if dispTerminalLabels
                    set(h.axes,'Position',[.10 .05 .85 .7])
                else
                    set(h.axes,'Position',[.10 .05 .85 .9])
                end
                ylim(sepUnit);
                xlim([0 numel(tr.terminalNodes)+1]);
            case 'bottom'
                set(h.axes,'XTick',1:numel(tr.terminalNodes),'Xdir','reverse','Ydir','reverse',...
                    'XtickLabel','','XAxisLocation','Bottom')
                if dispTerminalLabels
                    set(h.axes,'Position',[.10 .25 .85 .7])
                else
                    set(h.axes,'Position',[.10 .05 .85 .9])
                end
                ylim(sepUnit);
                xlim([0 numel(tr.terminalNodes)+1]);
        end
    case 'radial'
        set(h.axes,'XTick',[],'YTick',[])
        set(h.axes,'Position',[.05 .05 .9 .9])
        dispTerminalLabels = false;
        axis equal
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% drawing lines
switch renderType
    case 'square'
        X = tr.x([nodeIndex;repmat([tr.par(1:tr.numLabels-1) tr.numLabels],2,1)]);
        Y = tr.y([repmat(nodeIndex,2,1);[tr.par(1:tr.numLabels-1) tr.numLabels]]);
        switch orientation
            case {'left','right'}
                h.BranchLines = plot(X,Y,'-k');
                delete(h.BranchLines(~tr.activeNodes))
                h.BranchLines = h.BranchLines(tr.activeNodes);
            case {'top','bottom'}
                
                if scale==LOGSCALE,
                    Y(3,end-1) = Y(2,end-1);
                    X(2,end-1) = X(1,end-1)/2;
                    X(3,end-1) = X(1,end-1)/2;
                    plot(Y(:,2:end),X(:,2:end),'-k');
                else                
                
                h.BranchLines = plot(Y,X,'-k');
                delete(h.BranchLines(~tr.activeNodes))
                h.BranchLines = h.BranchLines(tr.activeNodes);
                end
        end
    case 'angular'
        X = tr.x([nodeIndex;[tr.par(1:tr.numLabels-1) tr.numLabels]]);
        Y = tr.y([nodeIndex;[tr.par(1:tr.numLabels-1) tr.numLabels]]);
        switch orientation
            case {'left','right'}
                h.BranchLines = plot(X,Y,'-k');
                delete(h.BranchLines(~tr.activeNodes))
                h.BranchLines = h.BranchLines(tr.activeNodes);
            case {'top','bottom'}
                h.BranchLines = plot(Y,X,'-k');
                delete(h.BranchLines(~tr.activeNodes))
                h.BranchLines = h.BranchLines(tr.activeNodes);
        end
    case 'radial'
        R = tr.x;
        A = tr.y / numel(tr.terminalNodes)*2*pi+rotation*pi/180;
        tr.x = R .* sin(A);
        tr.y = R .* cos(A);
        X = tr.x([nodeIndex;[tr.par(1:tr.numLabels-1) tr.numLabels]]);
        Y = tr.y([nodeIndex;[tr.par(1:tr.numLabels-1) tr.numLabels]]);
        h.BranchLines = plot(X,Y,'-k');
        delete(h.BranchLines(~tr.activeNodes))
        h.BranchLines = h.BranchLines(tr.activeNodes);
end

% drawing nodes
switch renderType
    case {'square','angular'}
        switch orientation
            case {'left','right'}
                % in case we don't want internal nodes
                %h.BranchDots = plot(tr.x(branchIndex(tr.activeNodes(branchIndex))),...
                %    tr.y(branchIndex(tr.activeNodes(branchIndex))),'o',...
                %    'MarkerSize',MARKER_SIZE,'MarkerEdgeColor','k',...
                %    'MarkerFaceColor','w');
                h.LeafDots = plot(tr.x(leafIndex(tr.activeNodes(leafIndex))),...
                    tr.y(leafIndex(tr.activeNodes(leafIndex))),'o',...
                    'MarkerSize',MARKER_SIZE,'MarkerEdgeColor','k',...
                    'MarkerFaceColor','k');
                %                  h.LeafDots = plot(tr.x(leafIndex(tr.activeNodes(leafIndex))),...
                %                     tr.y(leafIndex(tr.activeNodes(leafIndex))),'square',...
                %                     'MarkerSize',MARKER_SIZE,'MarkerEdgeColor','k',...
                %                     'MarkerFaceColor','w');
            case {'top','bottom'}
                if scale==LOGSCALE,
                    Y_to_plot = tr.y(leafIndex(tr.activeNodes(leafIndex)));
                    Y_to_plot(1) = Y(1,end-1);
                    X_to_plot = tr.x(leafIndex(tr.activeNodes(leafIndex)));
                    X_to_plot(1) = X(2,end-1);
                    h.LeafDots = plot(Y_to_plot,X_to_plot,'o','MarkerSize',MARKER_SIZE,'MarkerEdgeColor','k',...
                        'MarkerFaceColor','k');
                else
                    
                    h.LeafDots = plot(tr.y(leafIndex(tr.activeNodes(leafIndex))),...
                        tr.x(leafIndex(tr.activeNodes(leafIndex))),'o',...
                        'MarkerSize',MARKER_SIZE,'MarkerEdgeColor','k',...
                        'MarkerFaceColor','k');
                end

%                 h.BranchDots = plot(tr.y(branchIndex(tr.activeNodes(branchIndex))),...
%                     tr.x(branchIndex(tr.activeNodes(branchIndex))),'o',...
%                     'MarkerSize',MARKER_SIZE,'MarkerEdgeColor','k',...
%                     'MarkerFaceColor','k');
%                 h.LeafDots = plot(tr.y(leafIndex(tr.activeNodes(leafIndex))),...
%                     tr.x(leafIndex(tr.activeNodes(leafIndex))),'square',...
%                     'MarkerSize',MARKER_SIZE,'MarkerEdgeColor','k',...
%                     'MarkerFaceColor','w');
        end
    case 'radial'
        h.BranchDots = plot(tr.x(branchIndex(tr.activeNodes(branchIndex))),...
            tr.y(branchIndex(tr.activeNodes(branchIndex))),'o',...
            'MarkerSize',MARKER_SIZE,'MarkerEdgeColor','k',...
            'MarkerFaceColor','k');
        h.LeafDots = plot(tr.x(leafIndex(tr.activeNodes(leafIndex))),...
            tr.y(leafIndex(tr.activeNodes(leafIndex))),'square',...
            'MarkerSize',MARKER_SIZE,'MarkerEdgeColor','k',...
            'MarkerFaceColor','w');
end

% remove underscores from groups

for iter=1:length(group),
    for ind = 1:length(group{iter})
        group{iter}{ind}(group{iter}{ind}=='_')=' ';
    end
    %     for ind = 1:length(group{2})
    %         group{2}{ind}(group{2}{ind}=='_')=' ';
    %     end
end

% color group nodes appropriately

for iter=1:length(group),
    if (isempty(group{iter}))
        continue;
    end
    terminal_color=terminal_colors{iter};
    for i=1:length(tr.names),
        ind=find(strcmp(group{iter},tr.names{i}));
        if ~isempty(ind),
            if length(terminal_color)==3,
                if strcmp(orientation,'bottom')
                plot(tr.y(i),tr.x(i),['b' 'o'],'MarkerSize',MARKER_SIZE,'MarkerEdgeColor',terminal_color,...
                    'MarkerFaceColor',terminal_color);
            else
                plot(tr.x(i),tr.y(i),['b' 'o'],'MarkerSize',MARKER_SIZE,'MarkerEdgeColor',terminal_color,...
                    'MarkerFaceColor',terminal_color);
                end
            else
            if strcmp(orientation,'bottom')
                plot(tr.y(i),tr.x(i),[terminal_color 'o'],'MarkerSize',MARKER_SIZE,'MarkerEdgeColor',terminal_color,...
                    'MarkerFaceColor',terminal_color);
            else
                plot(tr.x(i),tr.y(i),[terminal_color 'o'],'MarkerSize',MARKER_SIZE,'MarkerEdgeColor',terminal_color,...
                    'MarkerFaceColor',terminal_color);
            end
            end
        end
    end
end

% % color significant branch nodes in green
% if ~isempty(group{end})
% sig_branch_size = zeros(1,length(group{end}));
% sig_branch_size(find(group{end}<0.00001)) = 5;
% sig_branch_size(find(group{end}>=0.00001 & group{end}<0.0001)) = 4;
% sig_branch_size(find(group{end}>=0.0001 & group{end}<0.001)) = 3;
% sig_branch_size(find(group{end}>=0.001)) = 2;
% for i=1:length(tr_names2),
%     ind=find(strcmp(group{end-1},tr_names2{i}));
%     if ~isempty(ind),
%         if strcmp(orientation,'bottom')
%              %plot(tr.y(i),tr.x(i),[internal_color 'o'],'MarkerSize',MARKER_SIZE,'MarkerEdgeColor',internal_color,...
%              %    'MarkerFaceColor',internal_color);  
%              plot(Y(:,i),X(:,i),['-' internal_color], 'LineWidth', sig_branch_size(ind));             
%         else
%               %plot(tr.x(i),tr.y(i),[internal_color 'o'],'MarkerSize',MARKER_SIZE,'MarkerEdgeColor',internal_color,...
%               %   'MarkerFaceColor',internal_color); 
%              plot(X(:,i),Y(:,i),['-' internal_color], 'LineWidth', sig_branch_size(ind));
%              
%              
%              
%         end
%     end
% end
% end

indicator_names = zeros(1,length(tr_names2));
if ~isempty(group{end})
    groups = group{end};
    groups_names = group{end-1};
    for k=1:length(groups),
        cur_group = groups{k};
        if (length(groups_names) < k)
            continue;
        end
        cur_group_names = groups_names{k};
        sig_branch_size = zeros(1,length(cur_group));
        sig_branch_size(find(cur_group<0.00001)) = 5;
        sig_branch_size(find(cur_group>=0.00001 & cur_group<0.0001)) = 4;
        sig_branch_size(find(cur_group>=0.0001 & cur_group<0.001)) = 3;
        sig_branch_size(find(cur_group>=0.001)) = 2;
        for i=1:length(tr_names2),
            ind=find(strcmp(cur_group_names,tr_names2{i}));
            if ~isempty(ind),
                if indicator_names(i)==0,
                    line_type = '-';
                elseif indicator_names(i)==1,
                    line_type = '--';
                elseif indicator_names(i)==2,
                    line_type = ':';
                end
                indicator_names(i) = indicator_names(i)+1;
                if strcmp(orientation,'bottom')
                    %plot(Y(:,i),X(:,i),['-' internal_color{k}], 'LineWidth', sig_branch_size(ind));
                    plot(Y(:,i),X(:,i),line_type,'color',internal_color{k}, 'LineWidth', sig_branch_size(ind));
                else
                    %plot(X(:,i),Y(:,i),['-' internal_color{k}], 'LineWidth', sig_branch_size(ind));
                    plot(X(:,i),Y(:,i),line_type,'color', internal_color{k}, 'LineWidth', sig_branch_size(ind));

                end
                hold on;
            end
        end
    end
end

% resize figure if needed
switch renderType
    case {'square','angular'}
        switch orientation
            case {'left','right'}
                correctFigureSize(fig, 15 * numel(tr.terminalNodes),0);
                fontRatio = max(get(fig,'Position').*[0 0 0 1])/numel(tr.terminalNodes);
            case {'top','bottom'}
                correctFigureSize(fig, 0, 15 * numel(tr.terminalNodes));
                fontRatio = max(get(fig,'Position').*[0 0 1 0])/numel(tr.terminalNodes);
        end
    case 'radial'
        temp = 10/pi*numel(tr.terminalNodes);
        correctFigureSize(fig,temp,temp);
        fontRatio = max(get(fig,'Position').*[0 0 1 0])/numel(tr.terminalNodes);
end

set(h.axes,'Fontsize',min(9,ceil(fontRatio/1.5)));


% set branch node labels
if dispBranchLabels,
    X = tr.x(branchIndex(tr.activeNodes(tr.numLeaves+1:tr.numLabels)));
    Y = tr.y(branchIndex(tr.activeNodes(tr.numLeaves+1:tr.numLabels)));  
    switch renderType
        case {'square','angular'}
            switch orientation
                case {'left'}
                    if scale==LINSCALE,
                        h.branchNodeLabels = text(X+sepUnit(1)/2,Y,tr.names(branchIndex(tr.activeNodes(tr.numLeaves+1:tr.numLabels))));
                     elseif scale==LOGSCALE,
                        h.branchNodeLabels = text(X,Y,tr.names(branchIndex(tr.activeNodes(tr.numLeaves+1:tr.numLabels))));
                    end
                    set(h.branchNodeLabels,'color',[0 0.75 0.75],'clipping','on')
                    set(h.branchNodeLabels,'vertical','bottom')
                    set(h.branchNodeLabels,'horizontal','right')
                   %set(h.branchNodeLabels,'Fontsize',min(8,ceil(fontRatio/2)));
                   set(h.branchNodeLabels,'Fontsize',7);
                case {'right'}
                    h.branchNodeLabels = text(X+sepUnit(1)/2,Y,tr.names(branchIndex(tr.activeNodes(tr.numLeaves+1:tr.numLabels))));
                    set(h.branchNodeLabels,'color',[0 0.75 0.75],'clipping','on')
                    set(h.branchNodeLabels,'vertical','bottom')
                    set(h.branchNodeLabels,'Fontsize',min(8,ceil(fontRatio/2)));
                case {'top'}
                    h.branchNodeLabels = text(Y,X-sepUnit(1)/2,tr.names(branchIndex(tr.activeNodes(tr.numLeaves+1:tr.numLabels))));
                    set(h.branchNodeLabels,'color',[0 0.75 0.75],'clipping','on')
                    set(h.branchNodeLabels,'vertical','bottom','Rotation',30)
                    set(h.branchNodeLabels,'Fontsize',min(8,ceil(fontRatio/2)));
                case {'bottom'}
                    if scale==LINSCALE,
                        h.branchNodeLabels = text(Y,X+sepUnit(1)/2,tr.names(branchIndex(tr.activeNodes(tr.numLeaves+1:tr.numLabels))));
                    elseif scale==LOGSCALE,
                        h.branchNodeLabels = text(Y,X,tr.names(branchIndex(tr.activeNodes(tr.numLeaves+1:tr.numLabels))));
                    end
                    set(h.branchNodeLabels,'color',[0 0.7 1],'clipping','on')
                    set(h.branchNodeLabels,'vertical','bottom','Rotation',10)
                    %set(h.branchNodeLabels,'vertical','bottom')
                    set(h.branchNodeLabels,'Fontsize',min(8,ceil(fontRatio/2)));
                    set(h.branchNodeLabels,'Fontsize',7);
            end
        case 'radial'
            h.branchNodeLabels = text(X,Y,tr.names(branchIndex(tr.activeNodes(tr.numLeaves+1:tr.numLabels))));
            set(h.branchNodeLabels,'color',[0 0 .8],'clipping','on')
            set(h.branchNodeLabels,'vertical','bottom')
            set(h.branchNodeLabels,'Fontsize',min(8,ceil(fontRatio*1.2)));
            for ind = 1:numel(h.branchNodeLabels)
                if X(ind)<0
                    set(h.branchNodeLabels(ind),'horizontal','right')
                    set(h.branchNodeLabels(ind),'Position',get(h.branchNodeLabels(ind),'Position')+[sepUnit(1)/2 0 0])
                else
                    set(h.branchNodeLabels(ind),'horizontal','left')
                    set(h.branchNodeLabels(ind),'Position',get(h.branchNodeLabels(ind),'Position')-[sepUnit(1)/2 0 0])
                end
            end
    end
end
% set leaf nodes labels
if dispLeafLabels,
    X = tr.x(leafIndex(tr.activeNodes(1:tr.numLeaves)));
    Y = tr.y(leafIndex(tr.activeNodes(1:tr.numLeaves)));
    switch renderType
        case {'square','angular'}
            switch orientation
                case {'left'}
                    h.leafNodeLabels = text(X-sepUnit(1)/2,Y,tr.names(leafIndex(tr.activeNodes(1:tr.numLeaves))));
                    %set(h.leafNodeLabels,'color',[.5 .5 .5],'clipping','on')
                    set(h.leafNodeLabels,'color','b','clipping','on')
                    set(h.leafNodeLabels,'horizontal','left')
                    set(h.leafNodeLabels,'Fontsize',min(8,ceil(fontRatio/2)));
                case {'right'}
                    h.leafNodeLabels = text(X-sepUnit(1)/2,Y,tr.names(leafIndex(tr.activeNodes(1:tr.numLeaves))));
                    set(h.leafNodeLabels,'color',[.5 .5 .5],'clipping','on')
                    set(h.leafNodeLabels,'horizontal','right')
                    set(h.leafNodeLabels,'Fontsize',min(8,ceil(fontRatio/2)));
                case {'top'}
                    h.leafNodeLabels = text(Y,X-sepUnit(1)/2,tr.names(leafIndex(tr.activeNodes(1:tr.numLeaves))));
                    set(h.leafNodeLabels,'color',[.5 .5 .5],'clipping','on')
                    set(h.leafNodeLabels,'horizontal','left','Rotation',60)
                    set(h.leafNodeLabels,'Fontsize',min(8,ceil(fontRatio/2)));
                case {'bottom'}
                    h.leafNodeLabels = text(Y,X-sepUnit(1),tr.names(leafIndex(tr.activeNodes(1:tr.numLeaves))));
                    set(h.leafNodeLabels,'color',[.5 .5 .5],'clipping','on')
                    set(h.leafNodeLabels,'horizontal','right','Rotation',60)
                    set(h.leafNodeLabels,'Fontsize',min(8,ceil(fontRatio/2)));
            end
        case 'radial'
            h.leafNodeLabels = text(X,Y,tr.names(leafIndex(tr.activeNodes(1:tr.numLeaves))));
            set(h.leafNodeLabels,'color',[.5 .5 .5],'clipping','on')
            set(h.leafNodeLabels,'Fontsize',min(8,ceil(fontRatio*1.2)));
            % textHeight = mean(cell2mat(get(h.leafNodeLabels,'Extent')))*[0 0 0 1]';
            for ind = 1:numel(h.leafNodeLabels)
                if X(ind)<0
                    set(h.leafNodeLabels(ind),'horizontal','right')
                    set(h.leafNodeLabels(ind),'Position',get(h.leafNodeLabels(ind),'Position')+[sepUnit(1) 0 0])
                else
                    set(h.leafNodeLabels(ind),'horizontal','left')
                    set(h.leafNodeLabels(ind),'Position',get(h.leafNodeLabels(ind),'Position')-[sepUnit(1) 0 0])
                end
                %             a=atan(Y(ind)/X(ind))*180/pi;
                %             if a > 0  a = max(0,a-60)/2; else
                %                       a = min(0,a+60)/2; end
                %             set(h.leafNodeLabels(ind),'Rotation',a)
            end
            [sortedY,hsY]=sort(Y);
            idx=hsY(X(hsY)>0 & sortedY>0);
            if numel(idx)
                extentY = get(h.leafNodeLabels(idx(1)),'Extent')*[0;0;0;1];
                positionY = get(h.leafNodeLabels(idx(1)),'Position')*[0;1;0];
                for i = 2:numel(idx)
                    position = get(h.leafNodeLabels(idx(i)),'Position');
                    positionY = max(positionY+extentY,position(2));
                    position(2) = positionY;
                    set(h.leafNodeLabels(idx(i)),'Position',position)
                end
            end
            idx=hsY(X(hsY)<0 & sortedY>0);
            if numel(idx)
                extentY = get(h.leafNodeLabels(idx(1)),'Extent')*[0;0;0;1];
                positionY = get(h.leafNodeLabels(idx(1)),'Position')*[0;1;0];
                for i = 2:numel(idx)
                    position = get(h.leafNodeLabels(idx(i)),'Position');
                    positionY = max(positionY+extentY,position(2));
                    position(2) = positionY;
                    set(h.leafNodeLabels(idx(i)),'Position',position)
                end
            end
            idx=flipud(hsY(X(hsY)>0 & sortedY<0));
            if numel(idx)
                extentY = get(h.leafNodeLabels(idx(1)),'Extent')*[0;0;0;1];
                positionY = get(h.leafNodeLabels(idx(1)),'Position')*[0;1;0];
                for i = 2:numel(idx)
                    position = get(h.leafNodeLabels(idx(i)),'Position');
                    positionY = min(positionY-extentY,position(2));
                    position(2) = positionY;
                    set(h.leafNodeLabels(idx(i)),'Position',position)
                end
            end
            idx=flipud(hsY(X(hsY)<0 & sortedY<0));
            if numel(idx)
                extentY = get(h.leafNodeLabels(idx(1)),'Extent')*[0;0;0;1];
                positionY = get(h.leafNodeLabels(idx(1)),'Position')*[0;1;0];
                for i = 2:numel(idx)
                    position = get(h.leafNodeLabels(idx(i)),'Position');
                    positionY = min(positionY-extentY,position(2));
                    position(2) = positionY;
                    set(h.leafNodeLabels(idx(i)),'Position',position)
                end
            end
    end
end


% correct axis limits given the extent of labels
if dispBranchLabels
    E = cell2mat(get(h.branchNodeLabels,'Extent'));
    if strcmp(get(gca,'XDir'),'reverse')
        E(:,1) = E(:,1) - E(:,3);
    end
    if strcmp(get(gca,'YDir'),'reverse')
        E(:,2) = E(:,2) - E(:,4);
    end
    E=[E;[xlim*[1;0] ylim*[1;0] diff(xlim) diff(ylim)]];
    mins = min(E(:,[1 2]));
    maxs = max([sum(E(:,[1 3]),2) sum(E(:,[2 4]),2)]);
    axis([mins(1) maxs(1) mins(2) maxs(2)])
end




if dispLeafLabels
    E = cell2mat(get(h.leafNodeLabels,'Extent'));
    if strcmp(get(gca,'XDir'),'reverse')
        E(:,1) = E(:,1) - E(:,3);
    end
    if strcmp(get(gca,'YDir'),'reverse')
        E(:,2) = E(:,2) - E(:,4);
    end
    E=[E;[xlim*[1;0] ylim*[1;0] diff(xlim) diff(ylim)]];
    mins = min(E(:,[1 2]));
    maxs = max([sum(E(:,[1 3]),2) sum(E(:,[2 4]),2)]);
    axis([mins(1) maxs(1) mins(2) maxs(2)])
end

% set terminal nodes labels
switch renderType
    case {'square','angular'}
        X = tr.x(tr.terminalNodes) * 0;
        Y = tr.y(tr.terminalNodes);
        switch orientation
            case {'left'}
                X = X + max(xlim) - sepUnit(1)/2;
                h.terminalNodeLabels = text(X,Y,tr.names(tr.terminalNodes),'Color','b');
            case {'right'}
                X = X + max(xlim) - sepUnit(1)/2;
                h.terminalNodeLabels = text(X,Y,tr.names(tr.terminalNodes));
                set(h.terminalNodeLabels,'Horizontal','right')
            case {'top'}
                X = X + max(ylim) - sepUnit(1)/2;
                h.terminalNodeLabels = text(Y,X,tr.names(tr.terminalNodes));
                set(h.terminalNodeLabels,'Rotation',90)
            case {'bottom'}
                X = X + max(ylim) - sepUnit(1)/2;
                h.terminalNodeLabels = text(Y,X,tr.names(tr.terminalNodes));
                set(h.terminalNodeLabels,'Rotation',270)
        end
    case 'radial'
        h.terminalNodeLabels = text(0,0,' ');
end

% set group text color
if dispTerminalLabels
    for iter=1:length(group),
        terminal_color=terminal_colors{iter};
        for i=1:length(tr.names(tr.terminalNodes)),
            ind=find(strcmp(group{iter},tr.names{tr.terminalNodes(i)}));
            if ~isempty(ind),
                set(h.terminalNodeLabels(i),'color',terminal_color,'clipping','off')
            end
        end
    end
end

if scale==LOGSCALE,
    set(h.axes,'Yscale','log');
    set(gca,'YLimMode','auto');
end

set(gca,'XTick',[]);



% if dispTerminalLabels
%     set(h.terminalNodeLabels,'Fontsize',min(9,ceil(fontRatio/1.5)));
% end

% if ~dispBranchLabels
%     set(h.branchNodeLabels,'visible','off');
% end
% if ~dispLeafLabels
%     set(h.leafNodeLabels,'visible','off');
% end
if ~dispTerminalLabels
    set(h.terminalNodeLabels,'visible','off');
end

box on
hold off

% store handles
set(fig,'UserData',h)
if nargout
    handles = h;
end

%set(h.branchNodeLabels,'visible',display_branch_labels);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tr = doBasicCalculations(tr,activeBranches,renderType)

% helper function to compute and find some features of the tree
tr.numLeaves = tr.numBranches + 1;
tr.numLabels = tr.numBranches + tr.numLeaves; 


% remove uderscores from names
for ind = 1:tr.numLabels
    tr.names{ind}(tr.names{ind}=='_')=' ';
end

% obtain parents for every node
tr.par(tr.tree(:)) = tr.numLeaves + [1:tr.numBranches 1:tr.numBranches];

% find active nodes
tr.activeNodes = true(tr.numLabels,1);
for ind =tr.numBranches:-1:1
    tr.activeNodes(tr.tree(ind,:)) = tr.activeNodes(tr.numLeaves+ind) & activeBranches(ind);
end

% propagate last leaf
tr.lastleaf = 1:tr.numLabels;
for ind = tr.numBranches:-1:1
    if ~tr.activeNodes(tr.tree(ind,1))
        tr.lastleaf(tr.tree(ind,:))=tr.lastleaf(ind+tr.numLeaves);
    end
end

tr.activeBranches = tr.activeNodes(tr.numLeaves+1:tr.numLabels)&activeBranches;
tr.activeLeaves = tr.activeNodes(1:tr.numLeaves);

% find x coordinates of branches
tr.x = tr.dist;
for ind = tr.numBranches:-1:1
    tr.x(tr.tree(ind,:)) = tr.x(tr.tree(ind,:)) + tr.x(ind+tr.numLeaves);
end

% find y coordinates of branches
tr.terminalNodes = tr.lastleaf([true,diff(tr.lastleaf(1:tr.numLeaves))~=0]);
tr.y=zeros(tr.numLabels,1);
tr.y(tr.terminalNodes)=1:length(tr.terminalNodes);
switch renderType
    case 'square'
        for ind = 1:tr.numBranches
            if tr.activeBranches(ind)
                tr.y(ind+tr.numLeaves) = mean(tr.y(tr.tree(ind,:)));
            end
        end
    case {'angular','radial'}
        for ind = 1:tr.numBranches
            if tr.activeBranches(ind)
                if tr.x(tr.tree(ind,1))/tr.x(tr.tree(ind,2))>3
                    tr.y(ind+tr.numLeaves) = tr.y(tr.tree(ind,1));
                elseif tr.x(tr.tree(ind,2))/tr.x(tr.tree(ind,1))>3
                    tr.y(ind+tr.numLeaves) = tr.y(tr.tree(ind,2));
                else
                    tr.y(ind+tr.numLeaves) = mean(tr.y(tr.tree(ind,:)));
                end
            end
        end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function correctFigureSize(fig,recommendedHeight,recommendedWidth)
% helper function to increase initial figure size depending on the screen &
% tree sizes
screenSize = diff(reshape(get(0,'ScreenSize'),2,2),[],2)-[0;100];
% 100 gives extra space for the figure header and win toolbar
position = get(fig,'Position');
if recommendedHeight > position(4)
    if recommendedHeight < sum(position([2 4]))
        position(2) = sum(position([2 4])) - recommendedHeight;
        position(4) = recommendedHeight;
    elseif recommendedHeight < screenSize(2)
        position(2) = 30;
        position(4) = recommendedHeight;
    else
        position(2) = 30;
        position(4) = screenSize(2);
    end
end
if recommendedWidth > position(3)
    if recommendedWidth < sum(position([1 3]))
        position(1) = sum(position([1 3])) - recommendedWidth;
        position(3) = recommendedWidth;
    elseif recommendedWidth < screenSize(1)
        position(1) = 30;
        position(3) = recommendedWidth;
    else
        position(1) = 30;
        position(3) = screenSize(1);
    end
end
set(fig,'Position',position)



function rotateBranch(h,varargin) %#ok
% Callback function to rotate a branch reordering the leaves. 
% Entry points: from 1) the dots context menu or 2) toggle node
tr = get(gcbf,'userdata');
if strcmp(get(h,'Type'),'uimenu') % come from a context menu
    hp = find(tr.selected(tr.numLeaves+1:tr.numLabels));
else
    % set a virtual grid to get the point
    xThres=diff(get(tr.ha,'Xlim'))/100;
    yThres=diff(get(tr.ha,'Ylim'))/100;
    cp = get(tr.ha,'CurrentPoint');
    xPos = cp(1,1); yPos = cp(1,2);
    hp = find(tr.x<(xPos+xThres) & tr.x>(xPos-xThres) & ...
        tr.y<(yPos+yThres) & tr.y>(yPos-yThres)) ;
    hp=hp(hp>tr.numLeaves)-tr.numLeaves;
    if numel(hp)
        hp=hp(1); %just in case it picked two points
    end
end
if numel(hp)
    for ind = 1:numel(hp)
        %find Leaves for every child
        childrenA = false(1,tr.numLabels);
        childrenA(tr.tree(hp(ind),1)) = true;
        for k = tr.tree(hp(ind),1)-tr.numLeaves:-1:1
            if childrenA(k+tr.numLeaves)
                childrenA(tr.tree(k,:))=true;
            end
        end
        childrenB = false(1,tr.numLabels);
        childrenB(tr.tree(hp(ind),2)) = true;
        for k = tr.tree(hp(ind),2)-tr.numLeaves:-1:1
            if childrenB(k+tr.numLeaves)
                childrenB(tr.tree(k,:))=true;
            end
        end
        permuta = 1:tr.numLabels;
        chA = find(childrenA(1:tr.numLeaves));
        chB = find(childrenB(1:tr.numLeaves));
        if chA(1)<chB(1)
            permuta([chA chB])=[chB chA];
        else
            permuta([chB chA])=[chA chB];
        end
        ipermuta = zeros(1,tr.numLabels);
        ipermuta(permuta)=1:tr.numLabels;
        tr.names = tr.names(permuta);
        tr.dist = tr.dist(permuta);
        tr.tree = ipermuta(tr.tree);
        tr.par = tr.par(permuta(1:end-1));
        tr.selected = tr.selected(permuta);
        tr.activeNodes = tr.activeNodes(permuta);
        tr.sel2root = tr.sel2root(permuta);
    end
    set(gcbf,'userdata',tr)
    updateTree(gcbf,[],[])
end