% Fri  3 Jan 11:11:07 +08 2020
function [n,msk,bnd] = floodfill(v,msk,id,jd,marker)
	if (nargin()<5)
		marker = 1;
	end
	if (isempty(msk))
		msk = zeros(size(v));
	end
	[n,msk,bnd] = floodfill_(v,msk,id,jd,marker);
end
function [n,msk,bnd] = floodfill_(v,msk,id,jd,marker);
	if (msk(id,jd))
		bnd = [];
		n = 0;
	else
		n = 1;
		bnd = [];
		msk(id,jd)  = marker;
		if (v(id-1,jd) == v(id,jd))
			[n_,msk,bnd_] = floodfill_(v,msk,id-1,jd,marker);
			n   = n+n_;
			bnd = [bnd;bnd_];
		else
			bnd = [bnd,id-1,jd];
		end
		if (v(id+1,jd) == v(id,jd))
			[n_,msk,bnd_] = floodfill_(v,msk,id+1,jd,marker);
			n   = n+n_;
			bnd = [bnd;bnd_];
		else
			bnd = [bnd;id+1,jd];
		end
		if (v(id,jd-1) == v(id,jd))
			[n_,msk,bnd_] = floodfill_(v,msk,id,jd-1,marker);
			n   = n+n_;
			bnd = [bnd;bnd_];
		else
			bnd = [bnd;id,jd-1];
		end
		if (v(id,jd+1) == v(id,jd))
			[n_,msk,bnd_] = floodfill_(v,msk,id,jd+1,marker);
			n   = n+n_;
			bnd = [bnd;bnd_];
		else
			bnd = [bnd;id,jd+1];
		end
	end
end

