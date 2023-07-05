% Fri Jun 27 23:11:38 WIB 2014
% Karl Kastner, Berlin

% TODO the current half pixel algorithm works consistently, but is directional dependent
%      improving this requires to increase cases based on last step
% TODO algortithm fails to detect one pixel wide lakes starting behind a one pixel boundary (reef style)
% TODO compression: only store next field in case of direction change	

classdef Contour < handle
	properties (Constant)
		top	= 1;
                tr      = 2;
		right	= 3;
		br      = 4;
		bottom	= 5;
		bl      = 6;
		left	= 7;
		tl      = 8;

		lastdir = [  7 8  1  2  3 4 5 6];
		%lastdir = [  8  1  2  3 4 5 6 7];
		nextdir = [  2  3  4  5 6 7 8 1];
		drow    = [ -1 -1  0 +1 +1 +1  0 -1];
		dcol    = [  0 -1 -1 -1  0 +1 +1 +1];
		%      t   tr    r   br    b   bl   l   tl
		% TODO avoid doubles by multiplying indices with 2
		hw      = [  0.5  0.5    0 -0.5 -0.5 -0.5   0  0.5;
                               0 -0.5 -0.5 -0.5    0  0.5 0.5  0.5]';

		WATER   = 0;
		LAND    = 1;
		VISITED = 2; % processed land areas
	end % properties (constant)
	properties
		% properties of the bitmap map
		X
		Y
		map;
		nrow;
		ncol;
		% no declaration of fields here, otherwise further on there is an empty first element
		% = struct('row',[],'col',[],'X',[],'Y',[],'level',[],'area',[]);
		contour;
	end % properties

	methods

	function obj = Contour(x,y,map)
		obj.X = x;
		obj.Y = y;
		obj.map  = map;
		obj.nrow = size(map,1);
		obj.ncol = size(map,2);
		if (length(x) ~= obj.ncol || length(y) ~= obj.nrow)
			error('dimensions do not coincide with scales');
		end
	end % constructor

	% TODO, support multiple levels
	function obj = extract(obj,level)
		% threshold the image
		obj.map = int8(obj.map > level);

		ready = 1;
		% scan the image until land is found
		for idx=1:obj.nrow
		for jdx=0:obj.ncol-1
			if (obj.map(idx,jdx+1) > obj.LAND)
				ready = 0;
			end
			if (ready && obj.LAND == obj.map(idx,jdx+1))
				% land found, start to parse island
				contour = obj.step(obj.left,idx,jdx);
				obj.contour(end+1).row = contour(:,1);
				obj.contour(end).col   = contour(:,2);
				obj.contour(end).level = level;
				ready = 0;
			end
			if (obj.WATER == obj.map(idx,jdx+1))
				% this is a water pixel, so set the ready flag
				ready = 1;
			end
		end % for jdx
		end % for idx

		% convert indices to coordinates
		for idx=1:length(obj.contour);
			dx = obj.X(2)-obj.X(1);
			dy = obj.Y(2)-obj.Y(1);
			x0 = obj.X(1);
			y0 = obj.Y(1);
			obj.contour(idx).X = x0 + dx*(obj.contour(idx).col-1);
			obj.contour(idx).Y = y0 + dy*(obj.contour(idx).row-1);
		end % for idx

		% calculate the contained area and length of the contours
		obj.calculate_area();
	end % function extract_contour

	% parse one individual contour
	function [contour obj] = step(obj, last, row, col)
		% remember first pixel
		% TODO already stored in the stack, avoid this by avoiding double indices
		firstrow = row; %obj.drow(last);
		firstcol = col+1; % + obj.dcol(last);

		dc = 1;
		dr = 0;
		% update index
		row = row + dr;
		col = col + dc;
	
		%contour = [firstrow firstcol-0.5]; %zeros(0,2);
		contour = zeros(0,2);

		% pseudo recursion
		% go from one coastline pixel to the next until the pointer
		% went once around the island
		found = 1;
		while (found)
	
		% add this point to the contour
		% the loop is closed by adding the initial point twice
		contour(end+1,:) = [row+obj.hw(last,2) col+obj.hw(last,1)];

		% mark point as visited (do not scan an island twice)
		obj.map(row,col) = obj.VISITED; %size(contour,1)+1; %obj.VISITED;

%		global DEBUG
%		if (DEBUG)
%			imagesc(obj.map + 100*int16(obj.map==1));
%			caxis([0 3]);
%			ax = caxis();
%			caxis([min(obj.map(:)) ax(2)]);
%			axis xy
%			drawnow();
%			pause(0.1);
%		end

		% try to step into the next field
		found = 0;
		last = obj.lastdir(last);
		% no land in the four directions -> one pixel island
		for idx=1:length(obj.dcol)
			dc = obj.dcol(last);
			dr = obj.drow(last);
			if (   (col+dc)<=obj.ncol && (col+dc) > 0 ...
			    && (row+dr)<=obj.nrow && (row+dr) > 0 ...
			    && obj.WATER ~= obj.map(row+dr,col+dc))
				found = 1;
				break;
			end
			% the next field is ninety degrees away
			last = obj.nextdir(last);
		end % for idx

		%imagesc(uint16(obj.map)+uint16(100*(obj.map==1)))
		%axis xy
		%drawnow()
		%pause(0.4)

		% update index
		row = row + dr;%obj.drow(last);
		col = col + dc;%obj.dcol(last);		
		if (row == firstrow && col == firstcol)
			% close the loop
			contour(end+1,:) = [row+obj.hw(last,2) col+obj.hw(last,1)];
			break;
		end % if loop closed
		end % while
		% correct column of first contour to close the loop
		contour(1,2) = contour(1,2) - obj.hw(obj.left,1) - 0.5;
		contour(1,1) = contour(1,1) - obj.hw(obj.left,2);
		contour(end+1,:) = contour(1,:);
	end % step()

	% determine, whether structure is cw or ccw
	% lakes lead to ccw oriented contours and yield negative areas by defenition
	% Note: the lenght does not converge for many natural boundaries (fractals)
	function obj = calculate_area(obj)
		for idx=1:length(obj.contour)
			x = obj.contour(idx).X;
			y = obj.contour(idx).Y;
			psx = (obj.X(2)-obj.X(1));
			psy = (obj.Y(2)-obj.Y(1));
			obj.contour(idx).area = 0.5*psx*psy*sum(x(1:end-1).*y(2:end)-x(2:end).*(y(1:end-1)));
			obj.contour(idx).leng = sum(sqrt( diff(psx*x).^2 + diff(psy*y).^2 ));
		end % for idx
	end % calculate area

	% TODO also include area and length
	function [shp obj] = export_shp(obj)
		% matlab has problems with several attributes, so only the necessary ones are copied
		n = length(obj.contour)
		for idx=1:length(obj.contour)
		[shp(idx).X] = obj.contour(idx).X;
		[shp(idx).Y] = -obj.contour(idx).Y;
		[shp(idx).level] = obj.contour(idx).level;
		end
		%for idx=1:n
		%	obj.Geometry = 'Line';
			%s.X = obj.contour(idx).X
			%s.Y = obj.contour(idx).Y;
			%s(idx).
		%end
		%obj.contour.level
		cg  = repmat({'Line'},n,1);                                         
		size(shp)
		[shp.Geometry] = deal(cg{:});
		%[obj.contour(1:n).Geometry] = deal(cg{:});
		%shp = obj.contour;
	end % export_shp
	end % methods
end % class Contour

