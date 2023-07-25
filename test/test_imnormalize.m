f_C ={
'input/nature-anisotropic-mexico_-103.147245_27.656891.png'
'input/nature-isotropic-mexico_-107.158326_31.337108.png'
'input/plantation-hexagonal-spain_-5.356567_37.401112.png'
'input/plantation-striped-spain_-2.685893_37.565588.png'
'input/pattern_2d_+07.79111_+047.92607.png'
}
for idx=1:4 %length(f_C)
	f = f_C{idx};
	img = imread(f);
	subplot(2,4,idx)
	imagesc(img);

	q1 = 0.025;
	q2 = 0.975;
	img = imnormalize(img,q1,q2);

	subplot(2,4,4+idx)
	imagesc(img);
end
	

% = 0.001; img_ = imnormalize(img,0.025,1-q); subplot(2,2,1); imagesc(img); axis equal; subplot(2,2,2); imagesc(img_); axis equal; min(img_(:)), max(img_(:))
