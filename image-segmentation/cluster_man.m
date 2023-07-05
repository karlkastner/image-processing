% 2013-07-15 13:37:55.000000000 +0200
% Karl Kastner, Berlin

function A = distance(f)
	A = zeros(size(f,1));
	% build the distance matrix
	for idx=1:size(f,1)
		A(idx,idx) = norm(f(idx,:));
		for jdx = idx+1:size(f,1)
			A(idx,jdx) = norm(f(idx,:)-f(jdx,:));
			A(jdx,idx) = A(idx,jdx);
		end % for jdx
	end % idx
end % distance

function A = neighbours(A)
	% construct a neighbourhood matrix from the distance matrix
	% take those neighbours to be adjacent, which are closer than the average distance
	m = 0.75*mean(A - diag(diag(A)));
	% = median(A - diag(diag(A)));
	m = quantile( A - diag(diag(A)), 0.125);
	A = (A < ones(size(A,1),1)*m) - eye(size(A));
	% symmetrise
	A = max(A,A');
	% balance to make the row and column sums zero
	A = A + diag(sum(A));
end % neighbours()

function c = cluster_spectral(f)
	A = distance(f);
	A = neighbours(A);
	% cut based on the neighbourhood matrix
%	Di = diag(1./sqrt(diag(A)));
	Di = diag(1./sqrt(sum(A)));
	L = eye(size(A)) - Di*A*Di;
	[v e] = eig(A);
%v(:,2)
%	m2 = mean(v(:,2));
%	m2 = 0; %mean(v(:,2));
	m2 = median(v(:,2));
%	m2 = median(v(:,end-1));
	c = (v(:,2) < m2) + 1;
	c = ones(size(f,1),1);
end % cluster_spectral

% choose two centrers, assign elements to the centres, recompute centrers, etc
function c = cluster_mean(f)
	A = distance(f);
	n = size(A,1);
	c = (1:n);
	n = round(n/2);
	change = true;
	while (change)
%		m1 = mean()
	end % while
end % cluster_mean


