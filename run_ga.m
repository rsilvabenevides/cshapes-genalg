%% Created by Rodrigo Benevides - aug/2019

% options = optimoptions('ga','PopulationSize',30,'EliteCount',3,'MaxGenerations',100,'MaxStallGenerations',20,...
% 'CrossoverFraction',0.2,'PlotInterval',1,'PlotFcn',{@gaplotbestf,@gaplotstopping});

options = optimoptions('ga','PopulationSize',10,'EliteCount',2,'MaxGenerations',7,'MaxStallGenerations',5,...
'CrossoverFraction',0.5,'PlotInterval',1,'PlotFcn',{@gaplotbestf,@gaplotstopping,'gaplotgenealogy'},'OutputFcn',@exxit);

nvar = 6;
lowbound = [190 230 150 190 145 170];
upbound = [230 300 200 250 195 215];

fitfunc = @myfitness;

[x,fval,exitflag,output] = ga(fitfunc,nvar,[],[],[],[],lowbound,upbound,[],[],options);

