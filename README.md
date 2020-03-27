**Part 1 - Implements scanline algorithm for filling triangles.It uses two methods of coloring.**

The **first** method is **Flat** method and it gives one specific color to each triangle which is computed as the mean of the three vertices' colors.

The **result** of the first method exists in *FlatDuck.jpg* image. 

The **second** method is **Gouraud** method.This method gives a color to each triangle's side which is computed as the linear interpolation of the two corresponding vertices' colors.The color of every inner pixel is computed as the linear interpolation of the two corresponding active points of the current scanline.
	
The **result** of the second method exists in *GouraudDuck.jpg* image.

**Part 2 - Implements transformations, perspective projections and photographs the initial image.**

Firstly it **translates** the image by a constant vector **t1** then it **rotates** it by a constant matrix **R** and finally it **translates** it by another constant vector **t2**.  

The **result** of the three transformations exists in *0.jpg, 1.jpg, 2.jpg, 3.jpg* image.

**Part 3 - Implements object's illumination.**

Firstly, it implements three different types of illymination **ambient**,**diffusion** and **specular**. It uses two methods to paint the objects. 

The **first** method is **shadeGouraud** and is implemented as the **Gouraud** method in Part 1. The only difference is that it computes vertices' colour as the summary of ambient, diffusion and specular light.

The **second** method is **shadePhong** method. This method computes the normal vector of each side as the linear interpolation of the two corresponding vertices' normal vectors. It also computes the coefficients *ka*,*kd* and *ks* in a similar way. Having these parameters it computes the three types of lighting and gives a specific colour to each active point. The normal vectors and the coefficients *ka*,*kd*,*ks* of every inner pixel are computed as the linear interpolation of the two corresponding active points of the current scanline and similarly a specific color according to lighting's summary  is given to the pixel.
