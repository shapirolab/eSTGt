function [ res ] = count_unique( V )
%count_unique 
[U, ia, iu] = unique(V);   %// Vector of unique values and their indices
counts = histc(iu, 1:numel(U));  %// Count values
res = [counts(:), U];

end

