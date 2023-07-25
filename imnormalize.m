% Wed  5 Jul 13:25:51 CEST 2023
% Karl Kästner, Berlin
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
function img = imnormalize(img,q_black,q_white)
	switch (class(img))
	case {'uint8'}
		img = single(img)/255.0;
	end
	newmax = 1.0;

	if (3 == ndims(img)) 
		img_bw = im2gray(img);
	else
		img_bw = img;
	end
	newmin = 0;

	oldlim = quantile(img_bw,[q_black,q_white],'all');
	oldmin = oldlim(1);
	oldmax = oldlim(2);

	%img = newmin + (img - oldmin)*(newmax - oldmax)/(oldmax - oldmin);
	img = (img - oldmin)/(oldmax - oldmin);
	img = min(max(img,0),newmax);
end

