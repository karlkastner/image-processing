% Di 5. Jan 17:41:47 CET 2016
% Karl Kastner, Berlin

function [mdx p rnkmax U U_] = pettit(Y)
	Y  = cvec(Y);
	dY = bsxfun(@minus,Y,Y');
	T = length(Y);
	D = sign(dY);
	U = zeros(T,1);
	% determine test statistic
	for t=1:T
	for idx=1:t
		jdx=t+1:T;
		U(t) = U(t) + sum(D(idx,jdx));
	end % for idx
	end % for t
	[Y rank] = sort(Y);
	% TODO, this has to be made unique in case of ties (add one for each tie and to tie and all successive elements)
%	rank = rank;
	U_      = 2*cumsum(rank) - (1:T)'*(T+1);
	%U_      = 2*cumsum(rank) - (1:T)'*(T);
	%U_      = 2*cumsum(rank) - (0:T-1)'*(T+1);
%	size(unique(X))

	[rnkmax	mdx] = max(abs(U));
	% P-value
	p = 2*exp(-6*rnkmax^2/(T^3+T^2));

end

