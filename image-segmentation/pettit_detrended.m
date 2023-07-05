% Di 5. Jan 17:41:47 CET 2016
% Karl Kastner, Berlin
function [mdx p rnkmax U Y_ U_] = pettit_detrended(X,Y,level)

	X = cvec(X);
	Y = cvec(Y);
%	[X sdx] = sort(X);
%	Y = Y(sdx);
%	p = (1:length(sdx));
	% inverse index
%	sdx(sdx) = p;
	
	% median of slopes
	dX = bsxfun(@minus,X,X');
	dY = bsxfun(@minus,Y,Y');
	dydx = dY./dX;
	slope = nanmedian(dydx(:));
	% remove trend and recompute differences
	Y_ = Y - slope*X;
	[mdx p rnkmax U U_] = pettit(Y_);

	% invert indices
%	U   = U(sdx);
%	mdx = sdx(mdx);
	if (nargin() > 2 && level > 1)
		fdx=1:mdx;
		[mdx1 p1 rnkmax1 U(fdx,2)] = pettit_detrended(X(fdx),Y(fdx),level-1);
		fdx=mdx+1:T;
		[mdx2 p2 rnkmax2 U(fdx,2)] = pettit_detrended(X(fdx),Y(fdx),level-1);
		mdx = [mdx mdx1 mdx2];
		p   = [p p1 p2];
		rnkmax = [rnkmax rnkmax1 rnkmax2];
		
	end

end

