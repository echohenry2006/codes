function c=simmat(pattern,metric,method)
% compute the similarity matrix
% FORMAT c=simmat(pattern,metric,method)
% metric - string vector for the distance metric,'cos' 'eu' 'cor' for options
% method - different method to pre-process the pattern,'noall','nopca','pca'
% simmat.m 2012-07-05 Yong Yang
nmet=length(metric);
if nmet == 0
	error('Too few arguments');
end

switch method
case 'noall'
	X=pattern;
case 'nopca'
	X=zscore(pattern);
case 'pca'
	P=zscore(pattern);
	[COEFF SCORE LATENT]=princomp(P);
	X=SCORE(:,1:3);
end

for i=1:nmet
	switch metric{i}
	case 'cos'
		%% sc
		y=pdist(X,'cosine');
		c=1-squareform(y);
		save(['c_' metric(i) '_' method ], c);
	case 'eu'
		%% eudelidean
		y=pdist(X,'euclidean');
		c=1./(squareform(y)+eps);
		save(['c_' metric(i) '_' method ], c);
	case 'cor'
		%% correlation
		y=pdist(X,'correlation');
		c=1-squareform(y);
		save(['c_' metric(i) '_' method ], c);
	otherwise
		error('Wrong argument for metric')
	end
		
end
	
	
	

 


