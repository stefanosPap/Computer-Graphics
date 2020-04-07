# Computer Graphics Project
This project refers to the application of the computer graphics theory.

## Running
In order to display the functionality of each part, there are one or more demo scripts at each part which can be run without any arguments. 
## Description 
### **Part 1 - Implements scanline algorithm for filling triangles.It uses two methods of colouring.**

The **first** method is **Flat** method and it gives one specific color to each triangle which is computed as the mean of the three vertices' colours.

The **result** of the first method exists in *FlatDuck.jpg* image.
##### Flat
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%201/FlatDuck.jpg)

The **second** method is **Gouraud** method.This method gives a color to each triangle's side which is computed as the linear interpolation of the two corresponding vertices' colors.The color of every inner pixel is computed as the linear interpolation of the two corresponding active points of the current scanline.
	
The **result** of the second method exists in *GouraudDuck.jpg* image.
##### Gouraud
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%201/GouraudDuck.jpg)

-------------------------------------------------------------------------------------------------------------------------

### **Part 2 - Implements transformations, perspective projections and photographs the initial image.**

Firstly it **translates** the image by a constant vector **t1** then it **rotates** it by a constant matrix **R** and finally it **translates** it by another constant vector **t2**.  

The **result** of the three transformations exists in *0.jpg, 1.jpg, 2.jpg, 3.jpg* image.
##### Iitial position
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%202/0.jpg)
##### Translation by t1
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%202/1.jpg)
##### Rotaion by R
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%202/2.jpg)
##### Translation by t2
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%202/3.jpg)

--------------------------------------------------------------------------------------------------------------------------

### **Part 3 - Implements object's illumination.**

Firstly, it implements three different types of illumination **ambient**,**diffusion** and **specular**. It uses two methods to paint the objects. 

The **first** method is **shadeGouraud** and is implemented as the **Gouraud** method in Part 1. The only difference is that it computes vertices' colour as the summary of ambient, diffusion and specular light.

The **results** of the first method exist in *gouraud_ambient.jpg* , *gouraud_diffusion.jpg*, *gouraud_specular.jpg* and *gouraud_all.jpg* images.
##### Gouraud Ambient
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%203/gouraud_ambient.jpg)
##### Gouraud Diffusion
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%203/gouraud_diffusion.jpg)
##### Gouraud Specular
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%203/gouraud_specular.jpg)
##### Gouraud All
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%203/gouraud_all.jpg)
The **second** method is **shadePhong** method. This method computes the normal vector of each side as the linear interpolation of the two corresponding vertices' normal vectors. It also computes the coefficients *ka*,*kd* and *ks* in a similar way. Having these parameters it computes the three types of lighting and gives a specific colour to each active point. The normal vectors and the coefficients *ka*,*kd*,*ks* of every inner pixel are computed as the linear interpolation of the two corresponding active points of the current scanline and similarly a specific color according to lighting's summary  is given to the pixel.


The **results** of the second method exist in *phong_ambient.jpg* , *phong_diffusion.jpg*, *phong_specular.jpg* and *phong_all.jpg* images.
##### Phong Ambient
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%203/phong_ambient.jpg)
##### Phong Diffusion
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%203/phong_diffusion.jpg)
##### Phong Specular
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%203/phong_specular.jpg)
##### Phong All
![alt text](https://github.com/stefanosPap/Computer-Graphics/blob/master/part%203/phong_all.jpg)
