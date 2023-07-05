% Mo 8. Jun 14:39:08 CEST 2015
% Karl Kastner, Berlin

function w = eigsplit(W,level)
	if (nargin() < 2)
		level = inf;
	end
	n = size(W,1);
	switch (n)
	case {0}
		w = [];
	case {1}
		w = 1;
	case {2}
		w = ones(2,1);
	otherwise
		D = diag(sparse(sum(W,2)));
%		D = D + 1e-7*speye(size(D));
		%[v e] = eigs(D,2);
opts.issym = 1;
opts.isreal = 1;
%		[v e] = eigs(D-W,D,2,'SM',opts);
%		afunc = @(x) sqrt(D.^-1)*(D-W)*sqrt(D.^-1);
%		[v e] = eigs(afunc,size(D,1),2,'SM',opts);
		%[v e] = eigs(D-W,D,2,'SM',opts);
		[v e] = eigs(D-W,D,2,+1e-12,opts);
		%[v e] = eigs(D-W,D,2);
		e
		w      = ones(n,1);
		% eigs returns eigenvalues descending, even in sm mode
		n = 1;
		fdx = v(:,n) > 0;
		level = level-1;
		if (level > 0)
		w(fdx)  = 2*eigsplit(W(fdx,fdx),level);
		w(~fdx) = 2*eigsplit(W(~fdx,~fdx),level);
		end
		w(~fdx) = w(~fdx)+1;
	end
end


