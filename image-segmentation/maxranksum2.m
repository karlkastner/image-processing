% Mi 6. Jan 13:42:34 CET 2016
% Karl Kastner, Berlin

function [l k R rmax] = maxranksum2(X)
	n = length(X);
	R = zeros(n,n);
	rmax = 0;
	l = [];
	k = [];
	for idx=1:n
		% include equal ranks (2 change points combine into 1)
		for jdx=idx:n
			rij  = ranksum2(X,idx,jdx);
			R(idx,jdx) = rij;
			if (abs(rij) > abs(rmax))
				rmax = rij;
				% TODO, somehow the indices where swapped, dunno why
				l = n-idx;
				k = n-jdx;		
			end
		end
	end
end

