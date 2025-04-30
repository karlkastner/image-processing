% 2024-11-08 21:21:06.774999964 +0100
function g = graythresh_scaled(x)
	minx = min(x,[],'all');
	maxx = max(x,[],'all');
	g = graythresh((x-minx)/(maxx-minx));
	g = minx + g*(maxx-minx);
end
