# Todo


### Layers

* API for managing the rasterization of layers needs to be implemented. The `shouldRasterize` property determines whether a layer should be rasterized, when changed this should be flagged in the main rendering implementation which should allocate or deallocate a buffer from the pool. The `rasterizionScale` determines which scale the layer should be rasterized in. Such API has many use cases such as (but not limited to) avoid a layer being redrawn on every frame in a animations.

* **Faster Rendering for layer.content** when the render loop does stumble over layers which does specify this attributes it should internally do the scrolling if any with the underlaying `drawImage()` without the need of involving translation and such, if this is possible depends on whether the layer has any sub layers. If the layer does host a hierarchy of it's translation cannot be avoided, but maybe this idea could be used even if such to reduce rendering cost.
* **Rasterize Buffer to Layer Mapping** layer which should be rasterized should do so before put to screen, maybe even before the main render loop is invoked, meaning in a separate loop. Layer could be associated with the rasterization buffers with the use of a WeakMap, some test implementation needs to be preformed to determine whether there is a performance issue with such approach. Layer which have change their rasterization flag since last handled should be put into a list of such. Layers which are hidden or not on the displaylist should only retain the buffers for a limited amount of time, this for allowing reuse of buffers and also introduce a smoother rendering runtime at a whole.
* Consider to implement a catch statement in delegation methods which have a potential of ending the render cycle, fore most the delegation of `drawRect()`.
* `CAScrollLayer` could be implemented by setting the having a transform attribute that applies to sublayers. Such approach does however creates with the plans of implementing a iOS like Zooming API in the scroll view class. Where scaling applied to sublayers trough this property would also create a magnification of the scroller knobs.

***

* Better handling of backing stores. In their use cases: screen, window and rasterization buffer. 
* reclaiming buffer as they are no longer needed.
* shadow attributes to CALayer base class.
* animation API to core canvas.


### Core Canvas and Images

* Utilize `content` attributes of the `Layer` class to enable scrolling of images
with use of `drawImage()` which will give a performance boost when scrolling only
a simple image.
* If the `putImageData()` perfoms with bad result when for drawing the zenKit's `ImageData` objects, the the Quartz Core would need to handle internal caching of data onto off-screen canvas for offering better rendering performance.
* Add a thin layer of abstraction when handling any DOM specific API, so configuration could be done. This by implementing factory methods for creation of canvas related objects. By doing this the only a minimal configuration of Quartz Core will needed for implementation in node.
* Improve preformance of scaleable images. When a image is drawn as scalable. The corners are drawn individually, and **five** patterns are allocated to draw the part of the image which are actully stretched. These patterns could be cached as long as they are needed, every instance which draws that image at diffrent sizes often needs to allocate the same area.

### Rendering

* Implement handling of CAWebGLLayer in CGRender.j

### Improvements

* It would be useful to sometimes be able to measure the bounds of a specific drawing operations, so that enough canvas area can be allocated to allow the whole content to be rendered.

* Consider to have a somewhat accessible property named `defaultView` which exposes the default main view or window, this also need to be implemented in the Quartz for referencing the default layer onto which content should be drawn.
 
### Fixes

* Instead of using the `_mainInvalidated` property, the render loop should check the number of dirty layers, if more than one. If such is the case: render loop should be invoked.
* `ctx.roundRect()` does not work in Opera and IE and in webkit it skip rounding one corner.



