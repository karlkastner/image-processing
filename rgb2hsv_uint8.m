% 2013-07-18 13:52:59 +0200
% Karl Kastner, Berlin

function hsv = rgb2hsv_uint8(A)
	hsv = zeros(size(A),'uint16');
	r = uint16(A(:,:,1));
	g = uint16(A(:,:,2));
	b = uint16(A(:,:,3));

	max_ = max(r,max(g,b));
	min_ = min(r,min(g,b));
	% todo max = min
	hsv(:,:,1) = ...
	  (max_ == r).*(0 + (uint16(10880)*(g-b))./(max_ - min_)) ...
	+ (max_ == g).*(90 + (uint16(10880)*(b-r))./(max_ - min_)) ...
	+ (max_ == b).*(4 + (uint16(10880)*(r-g))./(max_ - min_));
	hsv = min(hsv, hsv + 

	% todo max = zero
	% TODO, this can be computed in uint8
	hsv(:,:,2) = (max_ - min_)./max_;
	hsv(:,:,3) = max_;

	hsv = uint8(hsv);
end % rgb2hsv_uint8



