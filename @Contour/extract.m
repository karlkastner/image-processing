% 2016-03-01 19:50:49.529950911 +0100
% Karl Kastner, Berlin

function [contour_C level obj] = extract(obj,X,Y,Z,varargin)

	C = contourc(X,Y,Z,varargin{:});
	%C1 = contourc(X(:,1),Y(1,:)',Z);
	%C1 = extract_contour(C1);

	C_ = {};
	id = 1;
	idx = 0;
	level = [];
	contour_C = struct();
	while (id < size(C,2))
		idx = idx+1;
		n   = C(2,id);
		level(idx)           = C(1,id);
		C_{idx}              = C(:,id+1:id+n);
		contour_C(idx).X     = C(1,id+1:id+n);
		contour_C(idx).Y     = C(2,id+1:id+n);
		contour_C(idx).level = C(1,idx);
		id = id+n+1;
	end % while
	obj.contour_C = contour_C;
end % function extract

%function [C_ level shp] = extract_contour(C)
%	C_ = {};
%	id = 1;
%	idx = 0;
%	level = [];
%	shp = struct();
%	while (id < size(C,2))
%		idx = idx+1;
%		n = C(2,id);
%		level(idx)     = C(1,id);
%		C_{idx}        = C(:,id+1:id+n);
%		shp(idx).X     = C(1,id+1:id+n);
%		shp(idx).Y     = C(2,id+1:id+n);
%		shp(idx).level = C(1,idx);
%		id = id+n+1;
%	end
%end

