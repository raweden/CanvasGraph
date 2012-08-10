//
// Context2D.j
// Core Canvas
//
// Created by Raweden.
// Copyright 2012 Raweden. All rights reserved.
//


//
// This 'class' needs to be improved in the future.
//


/**
 *
 *
 */
Context2D = function () {

    var _stack = [];

    var _levels = 0;    // number of times ctx.save() called.

    // Drawing The Context

    /**
     * Never Override This method.
     */
    this.drawInNativeContext = function(context){
        var len = _stack.length;
        var fn;

        for (var i = 0; i < len; i++){
            fn = _stack[i];
            fn(context);
        }

        // if all save calls have been restored, we have nothing to do here.
        if(_levels == 0){
            return;
        }

        // restoring save() calls that have not be restored, this for avoid bugs.
        while(_levels > 0){
            context.restore();
            _levels--;
        }
    }


    /**
     * clears the commands stored in the drawing command stack, this should be
     * preformed on every draw.
     */
    this.clear = function () {
        _stack.length = 0;
    }


    // Transfomation and Clipping.


    this.clip = function(){
        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.clip();
        });
    }

    this.save = function(){
        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.save();
            _levels++;
        });
    }

    this.restore = function(){
        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            if (_levels > 0) {
                ctx.restore();
                _levels--;
            }
        });
    }


    // Drawing shadows


    /**
     *
     * @param color 24 bit integer value that represents the RGB value.
     */
    this.setShadow = function(offsetX, offsetY, blur, color, alpha){

        var r = color >> 16;
        var g = color >> 8 & 0xFF;
        var b = color & 0xFF;
        var color = 'rgba('+r+', '+g+', '+b+', '+alpha+')';

        if(_ratio !== 1){
            offsetX *= _ratio;
            offsetY *= _ratio;
        }

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx){
            if(ctx.setShadow){
                // currently only implemented by safari
                ctx.setShadow(offsetX, offsetY, blur, r, g, b, alpha);
            }else{
                ctx.shadowBlur = blur;
                ctx.shadowColor = color;
                ctx.shadowOffsetY = offsetX;
                ctx.shadowOffsetY = offsetY;
            }
        });

    }


    /**
     *
     */
    this.clearShadow = function(){
        // pusing the drawing command into the command stack.
        _stack.push(function (ctx){
            if(ctx.setShadow){
                // currently only implemented by safari
                ctx.clearShadow();
            }else{
                // @Todo: does this realy removes the shadow?
                ctx.shadowColor = null;
            }
        });

    }

   /**
     *
     */
    Object.defineProperty(this, "shadowBlur", {
        set: function (value) {
            value *= _ratio;

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.shadowBlur = value;
            });
        }
    });


    /**
     *
     */
    Object.defineProperty(this, "shadowColor", {
        set: function (value){

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.shadowColor = value;
            });
        }
    });

    /**
     *
     */
    Object.defineProperty(this, "shadowOffsetX", {
        set: function (value) {
            value *= _ratio;

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.shadowOffsetX = value;
            });
        }
    });

    /**
     *
     */
    Object.defineProperty(this, "shadowOffsetY", {
        set: function (value) {
            value *= _ratio;

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.shadowOffsetY = value;
            });
        }
    });


    // Drawing fills


    /**
     *
     */
    Object.defineProperty(this, "fillStyle", {
        set: function (value){

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.fillStyle = value;
            });
        }
    });


    /**
     *
     */
    this.fill = function(){

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.fill();
        });
    }


    /**
     *
     */
    this.fillRect = function (x, y, width, height){

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.fillRect(x * _ratio, y * _ratio, width * _ratio, height * _ratio);
        });
    }


    // Drawing strokes


    /**
     *
     */
    Object.defineProperty(this, "lineWidth", {
        set: function (value) {
            value *= _ratio;

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.lineWidth = value;
            });
        }
    });


    /**
     *
     */
    Object.defineProperty(this, "lineCap", {
        set: function (value){

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.lineCap = value;
            });
        }
    });


    /**
     *
     */
    Object.defineProperty(this, "lineJoin", {
        set: function (value){

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.lineJoin = value;
            });
        }
    });


    /**
     *
     */
    Object.defineProperty(this, "miterLimit", {
        set: function (value){
            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.miterLimit = value;
            });
        }
    });


    /**
     *
     */
    Object.defineProperty(this, "strokeStyle", {
        set: function (value){

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.strokeStyle = value;
            });
        }
    });


    /**
     * An array which specifies the lengths of alternating dashes and gaps (write-only).
     */
    Object.defineProperty(this, "lineDash", {
        set: function (value) {

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                if(ctx.lineDash){
                    ctx.lineDash = value;
                }
                if(ctx.mozDash){
                    ctx.mozDash = value;
                }
                if(ctx.webkitLineDash){
                    ctx.webkitLineDash = value;
                }
            });
        }
    });


    /**
     * Specifies where to start a dasharray on a line (write-only).
     */
    Object.defineProperty(this, "lineDashOffset", {
        set: function (value) {

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx){
                if(ctx.lineDashOffset){
                    ctx.lineDashOffset = value;
                }
                if(ctx.mozDashOffset){
                    ctx.mozDashOffset = value;
                }
                if(ctx.webkitLineDashOffset){
                    ctx.webkitLineDashOffset = value;
                }
            });
        }
    });


    /**
     *
     */
    this.stroke = function(){

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.stroke();
        });
    }


    this.strokeRect = function () {
        if (_ratio !== 1) {
            width *= _ratio;
            height *= _ratio
            x *= _ratio;
            y *= _ratio;
        }

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.strokeRect();
        });
    }


    // Drawing Images


    /**
     *
     * drawImage(image, dx, dy)
     *
     * drawImage(image, dx, dy, sw, sh)
     *
     * drawImage(image, sx, sy, sw, sh, dx, dy, dw, dh)
     */
    this.drawImage = function () {
        var i = 0;
        if (arguments.length == 3) {
            var image = arguments[i++];
            var dy = arguments[i++];
            var dx = arguments[i++];

            // applying scale factor if used.
            if (_ratio !== 0) {
                dy *= _ratio;
                dx *= _ratio;
            }

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.drawImage(image, dx, dy);
            });

        }else if (arguments.length == 5) {
            var image = arguments[i++];
            var dy = arguments[i++];
            var dx = arguments[i++];
            var sw = arguments[i++];
            var sh = arguments[i++];
            // applying scale factor if used.
            if (_ratio !== 0) {
                dy *= _ratio;
                dx *= _ratio; //sw *= _ratio;sh *= _ratio;
            }

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.drawImage(image, dx, dy, sw, sh);
            });
        }else if (arguments.length == 9) {
            var image = arguments[i++];
            var dy = arguments[i++];
            var dx = arguments[i++];
            var dw = arguments[i++];
            var dh = arguments[i++];
            //
            var sy = arguments[i++];
            var sx = arguments[i++];
            var sw = arguments[i++];
            var sh = arguments[i++];

            // applying scale factor if used.
            if (_ratio !== 0) {
                dy *= _ratio;
                dx *= _ratio;
                dw *= _ratio;
                dh *= _ratio; // sy *= _ratio; sx *= _ratio;sw *= _ratio; sh *= _ratio;
            }

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.drawImage(image, sx, sy, sw, sh, dx, dy, dw, dh);
            });
        }
        else {
            throw new Error(".drawImage() invalid number of arguments supplied");
        }
    }


    /**
     *
     */
    this.drawImageWithCaps = function(image, x, y, width, height, leftCap, topCap){

        // @TODO a weak map could be use here to cache the patterns generated by the slicing.

        var rightCap = image.width - (leftCap+1);
        var bottomCap  = image.height - (topCap+1);
        var xCap = width - leftCap - rightCap;
        var yCap = height - topCap - bottomCap;

        _stack.push(function (ctx) {

            ctx.save();
            ctx.translate(x,y);
            // drawing top left cap.
            ctx.drawImage(image,0,0,leftCap,topCap,0,0,leftCap,topCap);

            // drawing bottom left cap.
            ctx.drawImage(image,0,topCap+1,leftCap,bottomCap,0,height-bottomCap,leftCap,bottomCap);

            // drawing top right cap.
            ctx.drawImage(image,leftCap+1,0,rightCap,topCap,width-rightCap,0,rightCap,topCap);

            // drawing bottom right cap.
            ctx.drawImage(image,leftCap+1,topCap+1,rightCap,bottomCap,width-rightCap,height-bottomCap,rightCap,bottomCap);

            // drawing center repeat
            ctx.fillStyle = Quartz.createPatternBuffer(ctx,image,leftCap,topCap,1,1,'repeat');
            ctx.fillRect(leftCap,topCap,xCap,yCap);

            // drawing top repeat
            ctx.fillStyle = Quartz.createPatternBuffer(ctx,image,leftCap,0,1,topCap,'repeat-x');
            ctx.fillRect(leftCap,0,xCap,topCap);

            // drawing left repeat
            ctx.fillStyle = Quartz.createPatternBuffer(ctx,image,0,topCap,leftCap,1,'repeat-y');
            ctx.fillRect(0,topCap,leftCap,yCap);

            // drawing right repeat
            ctx.save();
            ctx.translate(width-rightCap,topCap);
            ctx.fillStyle = Quartz.createPatternBuffer(ctx,image,image.width-rightCap,topCap,rightCap,1,'repeat-y');
            ctx.fillRect(0,0,rightCap,yCap);
            ctx.restore();

            // drawing bottom repeat
            ctx.save();
            ctx.translate(leftCap,height-bottomCap);
            ctx.fillStyle = Quartz.createPatternBuffer(ctx,image,leftCap,topCap+1,1,bottomCap,'repeat-x');
            ctx.fillRect(0,0,xCap,bottomCap);
            ctx.restore();

            // restores the translation.
            ctx.restore();
        });

    }


    // Drawing text


    /**
     * Picks the font to be drawed with (write-only).
     */
    Object.defineProperty(this, "font", {
        set: function (value) {
            // precarculates the value if hd.
            if (_ratio != 1) {
                value = scaleFontValue(value);
            }

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.font = value;
            });
        }
    });


    /**
     * (write-only).
     */
    Object.defineProperty(this, "textAlign", {
        set: function (value){

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.textAlign = value;
            });
        }
    });


    /**
     * (write-only).
     */
    Object.defineProperty(this, "textBaseline", {
        set: function (value) {

            // pusing the drawing command into the command stack.
            _stack.push(function (ctx) {
                ctx.textBaseline = value;
            });
        }
    });


    /**
     *
     */
    this.fillText = function (text, x, y) {
        if (_ratio !== 1) {
            x *= _ratio;
            y *= _ratio;
        }

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.fillText(text, x, y);
        });
    }


    this.strokeText = function (text, x1, y) {
        if (_ratio !== 1) {
            x *= _ratio;
            y *= _ratio;
        }

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.fillText(text, x, y);
        });
    }


    this.createLinearGradient = function(x1, y1, x2, y2){
        if (_ratio != 1) {
            x1 *= _ratio;
            y1 *= _ratio;
            x2 *= _ratio;
            y2 *= _ratio;
        }

        return Quartz.createLinearGradient(x1, y1, x2, y2);
    }


    this.createRadialGradient = function(x1, y1, r1, x2, y2, r2){
        if(_ratio != 1){
            x1 *= _ratio;
            y1 *= _ratio;
            r1 *= _ratio;
            x2 *= _ratio;
            y2 *= _ratio;
            r2 *= _ratio;
        }

        return Quartz.createRadialGradient(x1, y1, r1, x2, y2, r2);
    }


    this.createPattern = function(image, repeat){
        return Quartz.createPattern(image, repeat);
    }


    // Drawing paths


    this.arc = function (x, y, radius, start, end, anticlockwise) {
        if (typeof anticlockwise != 'boolean') {
            anticlockwise = false;
        }
        if (_ratio !== 1) {
            x *= _ratio;
            y *= _ratio;
            radius *= _ratio;
        }

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.arc(x, y, radius, start, end, anticlockwise);
        });
    }


    this.arcTo = function (x1, y1, x2, y2, radius) {
        if (_ratio !== 1) {
            x1 *= _ratio;
            y1 *= _ratio;
            x2 *= _ratio;
            y2 *= _ratio;
        }

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.arcTo(x1, y1, x2, y2, radius);
        });
    }


    this.bezierCurveTo = function (cp1x, cp1y, cp2x, cp2y, x, y) {
        if (_ratio !== 1) {
            cp1x *= _ratio;
            cp1y *= _ratio;
            cp2x *= _ratio;
            cp2y *= _ratio;
            x *= _ratio;
            y *= _ratio;
        }

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y)
        });
    }


    /**
     * Macro Method for creating the path of a rounded rectangle.
     */
    this.roundRect = function (x, y, width, height, radius) {

        if (typeof radius === "undefined") {
            radius = 5;
        }
        //process only if radius is less than half of size and width.
        if (radius >= width /2 || radius >= height/2)
        return;

        x *= _ratio;
        y *= _ratio;
        width *= _ratio;
        height *= _ratio;
        radius *= _ratio;

        var minx = x, midx = x + (width/2), maxx = x + width;
        var miny = y, midy = y + (height/2), maxy = y + height;
        // CGRectGetMinX, CGRectGetMidX, CGRectGetMaxX

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx){
            // @Todo: Remove the beginPath() and closePath() calls
            ctx.moveTo(minx, midy);
            ctx.beginPath();
            ctx.arcTo(minx, miny, midx, miny, radius);
            ctx.arcTo(maxx, miny, maxx, midy, radius);
            ctx.arcTo(maxx, maxy, midx, maxy, radius);
            ctx.arcTo(minx, maxy, minx, midy, radius);
            ctx.closePath();
        });
    };

    /**
     * Macro Method for creating the path of a ellipse.
     */
    this.ellipse = function(x, y, width, height){
        x *= _ratio;
        y *= _ratio;
        width *= _ratio;
        height *= _ratio;

        var kappa = 0.5522848;
        var ox = (width / 2) * kappa;   // control point offset horizontal
        var oy = (height / 2) * kappa;  // control point offset vertical
        var xe = x + width;             // x-end
        var ye = y + height;            // y-end
        var xm = x + width / 2;         // x-middle
        var ym = y + height / 2;        // y-middle

        // pusing the drawing command into the command stack.
        _stack.push(function(ctx){
            ctx.beginPath();
            ctx.moveTo(x, ym);
            ctx.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
            ctx.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
            ctx.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
            ctx.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
            ctx.closePath();
        });
    }


    /**
     *
     */
    this.lineTo = function (x, y) {

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.lineTo(x * _ratio, y * _ratio);
        });
    }


    /**
     *
     */
    this.moveTo = function (x, y) {

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.moveTo(x * _ratio, y * _ratio);
        });
    }


    /**
     *
     */
    this.quadraticCurveTo = function (cpx, cpy, x, y) {
        if (_ratio !== 1) {
            cpx *= _ratio;
            cpy *= _ratio;
            x *= _ratio;
            y *= _ratio;
        }

        // pusing the drawing command into the command stack.
        _stack.push(function (ctx) {
            ctx.quadraticCurveTo(cpx, cpy, x, y);
        });
    }


    /**
     *
     */
    this.rect = function (x, y, width, height) {
        if (_ratio !== 1) {
            width *= _ratio;
            height *= _ratio;
            x *= _ratio;
            y *= _ratio;
        }

        // pushing drawing command.
        _stack.push(function (ctx) {
            ctx.rect(x, y, width, height);
        });
    }


    /**
     *
     */
    this.closePath = function () {
        _stack.push(function (ctx) {
            ctx.closePath();
        });
    }


    /**
     *
     */
    this.beginPath = function () {
        _stack.push(function (ctx) {
            ctx.beginPath();
        });
    }

};


// Utility methods for CSS strings.


/**
 * Helper method for scaling font value of a css string.
 *
 * @Todo consider to use the parser in node-canvas
 */
var scaleFontValue = function(font){

    var font = font.split(' ');

    for(var i = 0;i<font.length;i++){
        var value = font[i];
        var index = value.indexOf('pt');
        if(index !== -1){
            value = value.substr(0, index);
            value = parseInt(value);
            console.log("org-size: "+value);
            value = (value * _ratio) + 'pt';
            console.log("new-size: "+value);
            font[i] = value;
        }
    }

    font = font.join(' ');

    return font;
}
