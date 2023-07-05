function hsv = hsv2rgb_uint8_array(A)
	hsv = arrayfun(@fun,A(:,:,1),A(:,:,2),A(:,:,3));

	function hsv = fun(r,g,b)
		max_ = max(r,max(g,b));
		min_ = min(r,min(g,b));
		% todo max = min
		hsv(1) = ...
		  (42.5)*uint8(max_ == r).*(uint8(0) + (g-b)/(max_ - min_)) ...
		+ (42.5)*uint8(max_ == g).*(uint8(2) + (b-r)/(max_ - min_)) ...
		+ (42.5)*uint8(max_ == b).*(uint8(4) + (r-g)/(max_ - min_));
	
		% todo max = zero
		hsv(2) = (max_ - min_)./max_;
		hsv(3) = max_;
	end
end % hsv2rgb_uint8_array
