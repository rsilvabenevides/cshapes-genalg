function [vec] = defect_generate(initial_size,final_size,numcells)

% Created by Rodrigo Benevides - aug/2019
% generates gaussian profiles for defefct parameters

if initial_size < final_size
    vec = [];
    for ii=1:numcells
        new = (final_size-initial_size)*exp(-(ii-numcells)^2/(2*(numcells/3)^2))+initial_size;
        vec = [vec, new];
    end
else
    vec = [];
    for ii=1:numcells
        new = (initial_size-final_size)*(1-exp(-(ii-numcells)^2/(2*(numcells/3)^2)))+final_size;
        vec = [vec, new];
%         vec = [vec,ii];
    end
        
end
end
