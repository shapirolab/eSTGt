function [ Rules ] = updating_LotkaVolterra(Rules,T,X)
c1=2; c2=0.01; c3=5;

p1New = c1/(c1+c2*X(2));
p2New = 1-c3/(c3+c2*X(1));
r1New = c1+c2*X(2);
r2New = c3+c2*X(1);

p1New = min(1,max(0,p1New));
p2New = min(1,max(0,p2New));
Rules.Prod{1}.Probs(1) = p1New;
Rules.Prod{1}.Probs(2) = 1-p1New;
Rules.Prod{2}.Probs(1) = p2New;
Rules.Prod{2}.Probs(2) = 1-p2New;

Rules.Prod{1}.Rate = r1New;
Rules.Prod{2}.Rate = r2New;

end
