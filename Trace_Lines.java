// 2016-04-05 14:32:56.014671083 +0200

import     java.util.Comparator;
import     java.util.Arrays;

//% 4-images in time series, to have 3 slopes
//bank migration
//	for each point on the bank line
//	determine orthogonal direction
//	find intersection points with other bank lines
//	regress drift
//	
//
//% median of 3 images to get rid of clouds
//% 
//% higher accuracy : oversampling (uscale)
//% verification : downscale (q25,q75 filter)
//% error estimate either from 5x5 (quadratic) or resampling of bank-line
//% is sub-pixel really more accurate?
//
//%	radial double-quadratic: f(dir) = max (2 maxima for back and forward)
//%	will be close to saddle point matrix
//trace by direction (sub-pixel accuracy)
//	- this can drift away from the maximum
//	(determine start point by quadratic function)
//	- interpolate direction from direction orthogonal to boundary of four neighbours
//	- mark 3x3 neighbourhood of integer fraction as visited
//	- step with distance 1 in direction
//	% alternative: move along direction of the edge (allows for sub-pixel-accuracy)
//
//subpixel accuracy
//	for each point in vector
//	- express values in 3x3 neighbourhood as a quadratic
//	- check that hessian is spd
//	- determine location of extreme contrast
//	- check that extremum is a maximum
//	- limit step to 0.5 pixels
//	- repace points in vector by local maximum (floating-point)


public class Trace
{
	public static int [][] trace(final float [][] val, final float minval)
	{
		// allocate memory
		boolean [][] mask = new boolean [val.length+1][val[1].length+1];

		// x,y coordinates of segments, separated by -1
		int line [][] = new int[val.length*val[0].length][2];
		
		// mark boundary pixels of mask as visited
		for (int i = 0; i < mask.length; i++)
		{
			mask[i][0] = true;
			mask[i][mask[0].length] = true;
		} // for i

		for (int i = 0; i < mask[0].length; i++)
		{
			mask[0][i] = true;
			mask[mask.length][i] = true;
		} // for i

		// flat array and sort all points
		int [][] id = new int[val.length*val[0].length][2];
		for (int i=0; i<val.length; i++)
		for (int j=0; j<val[0].length; j++)
		{
			id[i*val[0].length+j][0] = i;
			id[i*val[0].length+j][1] = j;
		}
                Arrays.sort(id, new Comparator<int[]>() {
		    @Override
		    public int compare(int[] r1, int[] r2) {
		        return Float.compare(val[r1[0]][r1[1]], val[r2[0]][r2[1]]);
		    }
		});
		// trace lines
		for (int i=0; i<id.length; i++)
		{
			int x = id[i][0];
			int y = id[i][1];
			// if not yet processed
			if (!mask[x+1][y+1])
			{
				// trace from curent start point
				trace_(val, mask, line, x, y, minval);
				// TODO move points to achieve subpixel accuracy
				// TODO resample
			}
			// stop if there are only points left below contrast limit
			if (val[x][y] < minval)
			{
				break;
			}
		} // for i
		return line;
	} // trace

	// trace by max
	private static void trace_(final float val [][], boolean [][] mask, int [][] line, int x, int y, final double minval)
	{
		//  TODO, move in both directions for start point
		while (true)
		{
			// TODO push current point to vector
	
			// find neighbour with maximum contrast
			int [] dx = {-1,  0,  1, -1, 1, -1, 0, 1};
			int [] dy = {-1, -1, -1,  0, 0,  1, 1, 1};
			float contrast = 0;
			int   next = -1;
			for (int i=0; i<8; i++)
			{
				if (!mask[x+dx[i]+1][y+dy[i]+1])
				{
					// todo treat ties (recurse)
					if (val[x+dx[i]+1][y+dy[i]+1] > contrast)
					{
						next = i;
					} // if
				} // if 
			} // for i
			int [] dx2 = {-1,  0,  1, -1, 0, 1, -1, 0, 1};
			int [] dy2 = {-1, -1, -1,  0, 0, 0,  1, 1, 1};
			// mask 3x3 neighbourhood around current point as visited
			for (int i=0; i<9; i++)
			{
				mask[x+dx2[i]+1][y+dy2[i]+1] = true;
			} // for
			if (next < 0 || val[x+dx[next]+1][y+dy[next]+1] < minval)
			{
				return;
			} // if
			// update position
			x = x + dx[next];
			y = y + dy[next];
		} // while
	} // trace_
} // class Trace


