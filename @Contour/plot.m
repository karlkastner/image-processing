% 2016-03-04 16:00:55.625931887 +0100
% Karl Kastner, Berlin

function obj = plot(obj,varargin)
	Shp.plot(obj.contour_C,varargin{:});
if (0)
	ih = ishold();
	C = obj.contour_C;
	% TODO convert to shp, padd nan and than plot
	for kdx=1:length(C)
		plot(C{kdx}(1,:),C{kdx}(2,:),varargin{:});
		hold on
	end
	if (~ih)
		hold of
	end
end
end % plot

