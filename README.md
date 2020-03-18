
**Part 1 - Implements scanline algorithm for filling triangles.It uses two methods of coloring.**

The **first** method is **Flat** method and it gives one specific color to each triangle which is computed as the mean of the three vertices' colors.

The **result** of the first method exists in *FlatDuck.jpg* image. 

The **second** method is **Gouraud** method.This method gives a color to each triangle's side which is computed as the linear interpolation of the two corresponding vertices' colors.The color of every inner pixel is computed as the linear interpolation of the two corresponding active points of the current scanline.
	
The **result** of the second method exists in *GouraudDuck.jpg* image.

