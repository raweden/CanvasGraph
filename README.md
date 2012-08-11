# Core Canvas

Core Canvas is a graphics rendering library which provides a hierarchical display list, which is all rendered ontop of the Html5 Canvas API. 

### Features 
* A Core Graphics like API. 
* Resolution independent drawing, which also enables rendering to high resolution displays (iDevices) and rendering with magnification.
* Abstract support of WebGL. It's posible to render a 3D content within the layer hierarchy. 
* Independent of user interaction event. This library focuses on rendering content and are therefor knows nothing about mouse, touch and keyboard.
* Just like Core Graphics, this library contains wrappers for points, rectangles, transformation and colors. And also utilities for apply transforms to rectangles and points.

### Related Libraries

A UI library written on-top of this library is under developement and will soon be publiched as a repository here.

### Road Map
A more detailed description of to road map is found within the [TODO.md](https://github.com/raweden/CoreCanvas/blob/master/TODO.md) and [Ideas.md](https://github.com/raweden/CoreCanvas/blob/master/Ideas.md) 

*Sorted in most likely order to be implemented.*

* Rasterization to multiple top-level canvases.
* Rasterization to with scale factor.
* PostScript intergration.
* Better font measurement and advanced/dynamic text layout (awaiting canvas v.5 to be implemented by vendors).

### Legal

This library where developed by [raweden.se](http://raweden.se), and is released for free under the MIT license, which means you can use it for almost any purpose (including commercial projects). I appreciate credit where possible, but it is not a requirement.

![CC](http://raweden.se/public/github/by.png)  ![CC](http://raweden.se/public/github/sa.png)