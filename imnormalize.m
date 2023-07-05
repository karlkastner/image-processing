% Wed  5 Jul 13:25:51 CEST 2023
function img = imnormalize(img,q_black,q_white)
	if (3 == ndims(img)) 
		img_bw = im2gray(img);
	else
		img_bw = img;
	end
	oldlim = quantile(img_bw,[q_black,q_white]);
	oldmin = oldlim(1);
	oldmax = oldlim(2);

	newmax = 1;
	newmin = 0;

	img = newmin + max(img - oldmin)*(newmax - oldmax)/(oldmax - oldmin);
	img = min(max(img,0),1);
end

