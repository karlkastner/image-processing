% 2015-06-08 13:48:17.958164114 +0200
% Karl Kastner, Berlin
function w = meansplit(X)
	switch (length(X))
	case {0}
		w = [];
	case {1}
		w = 1;
	otherwise
		mu     = mean(X);
		fdx    = X < mu;
		w      = zeros(size(X));
		w(fdx) = 2*meansplit(X(fdx));
		w(~fdx) = 2*meansplit(X(~fdx))+1;
	end
end

