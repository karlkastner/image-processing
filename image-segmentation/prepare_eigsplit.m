% 2015-08-30 06:52:07.843015382 +0200
% Karl Kastner, Berlin

function A = prepare_eigsplit(X,k)
	% normalise columns
	X = bsxfun(@minus,X,median(X));
	X = bsxfun(@times,X,1./qstd(X));
	% prepare nearest neighbour distance matrix
	if (nargin()<2)
		k = 10;
	end
	NN = knnsearch(X,X,'K',k);
	n = size(X,1);
	D = zeros((k-1)*n,3);
	m = 0;
	for idx=1:n
		% get the similiarity (inverse distance)
		for jdx=2:k
			d = X(idx,:) - X(NN(idx,jdx),:);
			s = 1./sum(d.*d);
			m=m+1;
			D(m,:) = [idx, NN(idx,jdx), s];
		end
	end
	% set off-diagonal
	A = sparse(D(:,1),D(:,2),D(:,3),n,n);
	% make symmetric
%	A = 0.5*(A+A');
	A = max(A,A');
	% set diagonal
	ddx = sub2ind([n n],1:n,1:n);
	A(ddx) = 1;
end

