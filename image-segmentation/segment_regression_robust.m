% Di 5. Jan 13:12:47 CET 2016
% Karl Kastner, Berlin

% TODO in case of zero order
% this can be significantly speed up by means of running sums,
% as only one row of the regression matrices changes each time

function [mindx poly_A ssr] = segment_regression(X,Y,order,ngroup)
	X = cvec(X);
	Y = cvec(Y);

	[X sdx] = sort(X);
	Y = Y(sdx);
	n = length(X);
	p1 = PolyOLS(order);
	p2 = PolyOLS(order);
	ssrmin = inf;
	mindx  = 0;

	% simpler model with one group less (for F-test)
	% note that the F-test cannot really be applied, because this is
	% not a nested model
	[mindx0 poly_A0 ssrmin0] = segment_(X,Y,order,ngroup-1);

	% model with full number of groups
	[mindx poly_A ssrmin] = segment_(X,Y,order,ngroup);

	ssr = [];

	rss0 = ssrmin0;
	rss1 = ssrmin;

	% F-Test
	[rss0 rss1]
	p0 = order;
	p1 = order+1;
	F = ((rss0-rss1)/(p1-p0))/(rss1/(n-p1+1))
	P = fcdf(F,p1-p0,n-p1)
end

function [mindx poly_A ssrmin] = segment_(X,Y,order,level)
	% avoid recomputation by storing intermediate results
	% TODO This actually only makes sense for level > 2
	% TODO this optimisation can be done recursively for level > 3
	n = length(X);
	A = -ones(n,n);
	[mindx poly_A ssrmin] = segment__(X,Y,order,level,A,1,n);
end

% exhaustive search
function [mindx poly_A ssrmin A] = segment__(X,Y,order,level,A,sdx,n)
	if (1==level)
		if (A(sdx,n) < 0)
		if (0)
			A_   = [ones(n-sdx+1,1) X(sdx:n)];
			b   = Y(sdx:n);
			f   = @(x) sign(A_*x-b).*sqrt(abs(A_*x-b));
			opt = optimset('Display', 'off') ;
			[c flag f ff]   = lsqnonlin(f,[0 0]',[],[],opt);
			res = A_*c - b;
			A(sdx,n) = sum(abs(res));
		else
			Y_ = Theil.detrend(X(sdx:n),Y(sdx:n));
			A(sdx,n)  = (n-sdx+1)*mad(Y_,0);
%			A(sdx,n)  = (n-sdx+1)*mad(Y_,1);
		end
		end
		poly_A = [];
		ssr    = A(sdx,n);
		ssrmin = A(sdx,n);
		mindx  = [];
	else
		poly_A = [];
		ssrmin = inf;
		mindx  = 0;
		for idx=sdx+order:n-order
			if (A(sdx,idx) < 0)
				if (0)
				A_   = [ones(idx-sdx+1,1) X(sdx:idx)];
				b   = Y(sdx:idx);
				f   = @(x) sign(A_*x-b).*sqrt(abs(A_*x-b));
				opt = optimset('Display', 'off') ;
				[c flag f ff]   = lsqnonlin(f,[0 0]',[],[],opt);
				res = A_*c - b;
				A(sdx,idx) = sum(abs(res));
				else
				Y_   = Theil.detrend(X(sdx:idx),Y(sdx:idx));
				A(sdx,idx) = (idx-sdx+1)*mad(Y_,0);
				%A(sdx,idx) = (idx-sdx+1)*mad(Y_,1);
				end
			end
			% TODO do not copy X and Y, but only pass references
			[mindx_ poly_A ssrmin_ A]  = segment__(X,Y,order,level-1,A,idx+1,n);
			ssrmin_ = ssrmin_ + A(sdx,idx);
			if (ssrmin_ < ssrmin)
				ssrmin = ssrmin_;
				%poly_A = [p1 poly_A];
				mindx  = [idx, mindx_];
			end % if ssrmin_ < ssrmin
		end % for idx
	end % if level > 1
end % segment_

