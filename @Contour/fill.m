% 2016-03-04 16:00:55.625931887 +0100
% Karl Kastner, Berlin

function fillcontour(X,Y,Z,varargin)
	if (iscell(X))
		C1 = X;
	else
		C1 = contourc(X(:,1),Y(1,:)',Z);
		C1 = extract_contour(C1);
	end

	for kdx=1:length(C1)
		fill(C1{kdx}(1,:),C1{kdx}(2,:),varargin{:});
		hold on
	end
end
