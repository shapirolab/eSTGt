function [ Rules ] = updating_Exvivo( Rules,T,X)

CLONE_SIZE = 1000;

for i=1:length(X)
    Pop.(Rules.AllNames{i})=X(i);
end

for i=1:length(Rules.StartNames)
    I.(Rules.StartNames{i})=i;
end

%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4 == CLONE_SIZE && Pop.A4xA2 == 0 && Pop.A4xA11 == 0)
    Rules.Prod{I.A4}.Probs = [0 1 0];
end

if (Pop.A4xA2 == 1 && Pop.A4xA11 == 0)
    Rules.Prod{I.A4}.Probs = [0 0 1];
end

if (Pop.A4xA11 == 1)
    Rules.Prod{I.A4}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA2 == CLONE_SIZE)
    Rules.Prod{I.A4xA2}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11 == CLONE_SIZE && Pop.A4xA11xC8 == 0 && Pop.A4xA11xC9 == 0 && Pop.A4xA11xC1 == 0)
    Rules.Prod{I.A4xA11}.Probs = [0 1 0 0];
end

if (Pop.A4xA11xC8 == 1 && Pop.A4xA11xC9 == 0 && Pop.A4xA11xC1 == 0)
    Rules.Prod{I.A4xA11}.Probs = [0 0 1 0];
end

if (Pop.A4xA11xC9 == 1 && Pop.A4xA11xC1 == 0)
    Rules.Prod{I.A4xA11}.Probs = [0 0 0 1];
end

if (Pop.A4xA11xC1 == 1)
    Rules.Prod{I.A4xA11}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1 == CLONE_SIZE && Pop.A4xA11xC1xA8 == 0 && Pop.A4xA11xC1xA9 == 0)
     Rules.Prod{I.A4xA11xC1}.Probs = [0 1 0];
end
if (Pop.A4xA11xC1xA8 == 1 && Pop.A4xA11xC1xA9 == 0)
     Rules.Prod{I.A4xA11xC1}.Probs = [0 0 1];
end

if (Pop.A4xA11xC1xA9 == 1)
     Rules.Prod{I.A4xA11xC1}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%

if (Pop.A4xA11xC8 == CLONE_SIZE && Pop.A4xA11xC8xB6 == 0 && Pop.A4xA11xC8xB4 == 0 && Pop.A4xA11xC8xB10 == 0)
    Rules.Prod{I.A4xA11xC8}.Probs = [0 1 0 0];
end
if (Pop.A4xA11xC8xB6 == 1 && Pop.A4xA11xC8xB4 == 0 && Pop.A4xA11xC8xB10 == 0)
    Rules.Prod{I.A4xA11xC8}.Probs = [0 0 1 0];
end
if (Pop.A4xA11xC8xB4 == 1 && Pop.A4xA11xC8xB10 == 0)
    Rules.Prod{I.A4xA11xC8}.Probs = [0 0 0 1];
end
if (Pop.A4xA11xC8xB10 == 1)
    Rules.Prod{I.A4xA11xC8}.Rate = 0;
end

%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC9 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB6 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB6}.Probs = [0 1];
end
if (Pop.A4xA11xC8xB6xF2 == 1)
    Rules.Prod{I.A4xA11xC8xB6}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB6xF2 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB6xF2}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4 == CLONE_SIZE && Pop.A4xA11xC8xB4xF11 == 0 && Pop.A4xA11xC8xB4xB11 == 0)
    Rules.Prod{I.A4xA11xC8xB4}.Probs = [0 1 0];
end
if (Pop.A4xA11xC8xB4xF11 == 1 && Pop.A4xA11xC8xB4xB11 == 0)
    Rules.Prod{I.A4xA11xC8xB4}.Probs = [0 0 1];
end
if (Pop.A4xA11xC8xB4xB11 == 1)
    Rules.Prod{I.A4xA11xC8xB4}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB10 == CLONE_SIZE && Pop.A4xA11xC8xB10xC3 == 0 && Pop.A4xA11xC8xB10xG3 == 0 && Pop.A4xA11xC8xB10xH3 == 0)
    Rules.Prod{I.A4xA11xC8xB10}.Probs = [0 1 0 0];
end
if (Pop.A4xA11xC8xB10xC3 == 1 && Pop.A4xA11xC8xB10xG3 == 0 && Pop.A4xA11xC8xB10xH3 == 0)
    Rules.Prod{I.A4xA11xC8xB10}.Probs = [0 0 1 0];
end
if (Pop.A4xA11xC8xB10xG3 == 1 && Pop.A4xA11xC8xB10xH3 == 0)
    Rules.Prod{I.A4xA11xC8xB10}.Probs = [0 0 0 1];
end
if (Pop.A4xA11xC8xB10xH3 == 1)
    Rules.Prod{I.A4xA11xC8xB10}.Rate = 0;
end

%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8 == CLONE_SIZE && Pop.A4xA11xC1xA8xE8 == 0 && Pop.A4xA11xC1xA8xB8 == 0)
    Rules.Prod{I.A4xA11xC1xA8}.Probs = [0 1 0];
end
if (Pop.A4xA11xC1xA8xE8 == 1 && Pop.A4xA11xC1xA8xB8 == 0)
    Rules.Prod{I.A4xA11xC1xA8}.Probs = [0 0 1];
end
if (Pop.A4xA11xC1xA8xB8 == 1)
    Rules.Prod{I.A4xA11xC1xA8}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA9 == CLONE_SIZE && Pop.A4xA11xC1xA9xA9 == 0 && Pop.A4xA11xC1xA9xC9 == 0)
    Rules.Prod{I.A4xA11xC1xA9}.Probs = [0 1 0];
end
if (Pop.A4xA11xC1xA9xA9 == 1 && Pop.A4xA11xC1xA9xC9 == 0)
    Rules.Prod{I.A4xA11xC1xA9}.Probs = [0 0 1];
end
if (Pop.A4xA11xC1xA9xC9 == 1)
    Rules.Prod{I.A4xA11xC1xA9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA9xA9 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA9xA9}.Probs = [0 1];
end
if (Pop.A4xA11xC1xA9xA9xC9 == 1)
    Rules.Prod{I.A4xA11xC1xA9xA9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA9xC9 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA9xC9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA9xA9xC9 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA9xA9xC9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8xE8 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA8xE8}.Probs = [0 1];
end
if (Pop.A4xA11xC1xA8xE8xB6 == 1)
    Rules.Prod{I.A4xA11xC1xA8xE8}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8xB8 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA8xB8}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB10xC3 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB10xC3}.Probs = [0 1];
end
if (Pop.A4xA11xC8xB10xC3xC2 == 1)
    Rules.Prod{I.A4xA11xC8xB10xC3}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB10xG3 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB10xG3}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB10xH3 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB10xH3}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB10xC3xC2 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB10xC3xC2}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8xE8xB6 == CLONE_SIZE && Pop.A4xA11xC1xA8xE8xB6xB2 == 0 && Pop.A4xA11xC1xA8xE8xB6xD1 == 0 && Pop.A4xA11xC1xA8xE8xB6xG2 == 0)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6}.Probs = [0 1 0 0];
end
if (Pop.A4xA11xC1xA8xE8xB6xB2 == 1 && Pop.A4xA11xC1xA8xE8xB6xD1 == 0 && Pop.A4xA11xC1xA8xE8xB6xG2 == 0)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6}.Probs = [0 0 1 0];
end
if (Pop.A4xA11xC1xA8xE8xB6xD1 == 1 && Pop.A4xA11xC1xA8xE8xB6xG2 == 0)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6}.Probs = [0 0 0 1];
end
if (Pop.A4xA11xC1xA8xE8xB6xG2 == 1)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8xE8xB6xB2 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6xB2}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8xE8xB6xD1 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6xD1}.Probs = [0 1];
end
if (Pop.A4xA11xC1xA8xE8xB6xD1xC6 == 1)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6xD1}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8xE8xB6xG2 == CLONE_SIZE && Pop.A4xA11xC1xA8xE8xB6xG2xA9 == 0 && Pop.A4xA11xC1xA8xE8xB6xG2xF9 == 0)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6xG2}.Probs = [0 1 0];
end
if (Pop.A4xA11xC1xA8xE8xB6xG2xA9 == 1 && Pop.A4xA11xC1xA8xE8xB6xG2xF9 == 0)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6xG2}.Probs = [0 0 1];
end
if (Pop.A4xA11xC1xA8xE8xB6xG2xF9 == 1)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6xG2}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8xE8xB6xD1xC6 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6xD1xC6}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8xE8xB6xG2xA9 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6xG2xA9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC1xA8xE8xB6xG2xF9 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC1xA8xE8xB6xG2xF9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xB11 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xB11}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11 == CLONE_SIZE && Pop.A4xA11xC8xB4xF11xA7 == 0 && Pop.A4xA11xC8xB4xF11xB7 == 0 && Pop.A4xA11xC8xB4xF11xD7 == 0 && Pop.A4xA11xC8xB4xF11xG7 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11}.Probs = [0 1 0 0 0];
end
if (Pop.A4xA11xC8xB4xF11xA7 == 1 && Pop.A4xA11xC8xB4xF11xB7 == 0 && Pop.A4xA11xC8xB4xF11xD7 == 0 && Pop.A4xA11xC8xB4xF11xG7 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11}.Probs = [0 0 1 0 0];
end
if (Pop.A4xA11xC8xB4xF11xB7 == 1 && Pop.A4xA11xC8xB4xF11xD7 == 0 && Pop.A4xA11xC8xB4xF11xG7 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11}.Probs = [0 0 0 1 0];
end
if (Pop.A4xA11xC8xB4xF11xD7 == 1 && Pop.A4xA11xC8xB4xF11xG7 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11}.Probs = [0 0 0 0 1];
end
if (Pop.A4xA11xC8xB4xF11xG7 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xA7 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xA7}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xB7 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7}.Probs = [0 1];
end
if (Pop.A4xA11xC8xB4xF11xB7xB9 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xB7xB9 == CLONE_SIZE && Pop.A4xA11xC8xB4xF11xB7xB9xE4 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9}.Probs = [0 1 0];
end
if (Pop.A4xA11xC8xB4xF11xB7xB9xE4 == 1 && Pop.A4xA11xC8xB4xF11xB7xB9xG4 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9}.Probs = [0 0 1];
end
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xB7xB9xE4 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xE4}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4 == CLONE_SIZE && Pop.A4xA11xC8xB4xF11xB7xB9xG4xA11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xC11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xD11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xF11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xH11 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4}.Probs = [0 1 0 0 0 0];
end
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xA11 == 1 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xC11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xD11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xF11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xH11 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4}.Probs = [0 0 1 0 0 0];
end
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xC11 == 1 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xD11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xF11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xH11 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4}.Probs = [0 0 0 1 0 0];
end
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xD11 == 1 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xF11 == 0 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xH11 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4}.Probs = [0 0 0 0 1 0];
end
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xF11 == 1 && Pop.A4xA11xC8xB4xF11xB7xB9xG4xH11 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4}.Probs = [0 0 0 0 0 1];
end
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xH11 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xA11 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4xA11}.Rate = 0;
end

%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xC11 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4xC11}.Rate = 0;
end

%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xD11 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4xD11}.Rate = 0;
end

%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xF11 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4xF11}.Rate = 0;
end

%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xB7xB9xG4xH11 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xB7xB9xG4xH11}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7 == CLONE_SIZE && Pop.A4xA11xC8xB4xF11xD7xB5 == 0 && Pop.A4xA11xC8xB4xF11xD7xE4 == 0 && Pop.A4xA11xC8xB4xF11xD7xG4 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7}.Probs = [0 1 0 0];
end
if (Pop.A4xA11xC8xB4xF11xD7xB5 == 1 && Pop.A4xA11xC8xB4xF11xD7xE4 == 0 && Pop.A4xA11xC8xB4xF11xD7xG4 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7}.Probs = [0 0 1 0];
end
if (Pop.A4xA11xC8xB4xF11xD7xE4 == 1 && Pop.A4xA11xC8xB4xF11xD7xG4 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7}.Probs = [0 0 0 1];
end
if (Pop.A4xA11xC8xB4xF11xD7xG4 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xB5 == CLONE_SIZE && Pop.A4xA11xC8xB4xF11xD7xB5xC2 == 0 && Pop.A4xA11xC8xB4xF11xD7xB5xE2 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xB5}.Probs = [0 1 0];
end
if (Pop.A4xA11xC8xB4xF11xD7xB5xC2 == 1 && Pop.A4xA11xC8xB4xF11xD7xB5xE2 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xB5}.Probs = [0 0 1];
end
if (Pop.A4xA11xC8xB4xF11xD7xB5xE2 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xB5}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xB5xC2 == CLONE_SIZE && Pop.A4xA11xC8xB4xF11xD7xB5xC2xE2 == 0 && Pop.A4xA11xC8xB4xF11xD7xB5xC2xF2 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xB5xC2}.Probs = [0 1 0];
end
if (Pop.A4xA11xC8xB4xF11xD7xB5xC2xE2 == 1 && Pop.A4xA11xC8xB4xF11xD7xB5xC2xF2 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xB5xC2}.Probs = [0 0 1];
end
if (Pop.A4xA11xC8xB4xF11xD7xB5xC2xF2 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xB5xC2}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xB5xC2xE2 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xB5xC2xE2}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xB5xC2xF2 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xB5xC2xF2}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xB5xE2 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xB5xE2}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xE4 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xE4}.Probs = [0 1];
end
if (Pop.A4xA11xC8xB4xF11xD7xE4xF7 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xE4}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xG4 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xG4}.Probs = [0 1];
end
if (Pop.A4xA11xC8xB4xF11xD7xG4xC11 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xG4}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xE4xF7 == CLONE_SIZE && Pop.A4xA11xC8xB4xF11xD7xE4xF7xA9 == 0 && Pop.A4xA11xC8xB4xF11xD7xE4xF7xF9 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xE4xF7}.Probs = [0 1 0];
end
if (Pop.A4xA11xC8xB4xF11xD7xE4xF7xA9 == 1 && Pop.A4xA11xC8xB4xF11xD7xE4xF7xF9 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xE4xF7}.Probs = [0 0 1];
end
if (Pop.A4xA11xC8xB4xF11xD7xE4xF7xF9 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xE4xF7}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xE4xF7xA9 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xE4xF7xA9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xE4xF7xF9 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xE4xF7xF9}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xG4xC11 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xG4xC11}.Probs = [0 1];
end
if (Pop.A4xA11xC8xB4xF11xD7xG4xC11xB4 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xG4xC11}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xD7xG4xC11xB4 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xD7xG4xC11xB4}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xG7 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xG7}.Probs = [0 1];
end
if (Pop.A4xA11xC8xB4xF11xG7xF7 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xG7}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xG7xF7 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xG7xF7}.Probs = [0 1];
end
if (Pop.A4xA11xC8xB4xF11xG7xF7xD8 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xG7xF7}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xG7xF7xD8 == CLONE_SIZE && Pop.A4xA11xC8xB4xF11xG7xF7xD8xA6 == 0 && Pop.A4xA11xC8xB4xF11xG7xF7xD8xC6 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xG7xF7xD8}.Probs = [0 1 0];
end
if (Pop.A4xA11xC8xB4xF11xG7xF7xD8xA6 == 1 && Pop.A4xA11xC8xB4xF11xG7xF7xD8xC6 == 0)
    Rules.Prod{I.A4xA11xC8xB4xF11xG7xF7xD8}.Probs = [0 0 1];
end

if (Pop.A4xA11xC8xB4xF11xG7xF7xD8xC6 == 1)
    Rules.Prod{I.A4xA11xC8xB4xF11xG7xF7xD8}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xG7xF7xD8xA6 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xG7xF7xD8xA6}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
if (Pop.A4xA11xC8xB4xF11xG7xF7xD8xC6 == CLONE_SIZE)
    Rules.Prod{I.A4xA11xC8xB4xF11xG7xF7xD8xC6}.Rate = 0;
end
%%%%%%%%%%%%%%%%%%%%%%
end

