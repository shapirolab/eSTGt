function [ Rules ] = updating_LogisticVerhulst( Rules,T,X)
   p = Rules.Prod{1}.Probs(1);
   K = 100;
   
   pNew = 1-X(1)/(2*K); % Verhulst
   
   pNew = min(1,max(0,pNew));
   
   Rules.Prod{1}.Probs(1) = pNew;
   Rules.Prod{1}.Probs(2) = 1-pNew;
end

