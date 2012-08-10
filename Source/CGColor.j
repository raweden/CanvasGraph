//
// CGColor.j
// Core Canvas
//
// Created by Raweden. Sat Jul 28 2012
// Copyright 2012 Raweden. All rights reserved.
//

// 
// Notes
//
// All CGColor instances represents their value by a ARGB value as a 32-bit unsigned integer.
// 

/**
 * Creates a CGColor object from a 32-bit unsigned integer representing a argb value.
 *
 * @param {int} color32 A 32-bit unsigned integer.
 * @return {CGColor}
 */
CGColorCreate = function(color32){
	return {value:color32};
}

/**
 * Creates a CGColor object from a 32-bit unsigned integer representing a argb value.
 *
 * @param {CGColor} A CGColor object which to clone.
 * @return {CGColor}
 */
CGColorCreateCopy = function(color){
	return CGColorCreate(color.value);
}

/**
 * Creates a CGColor object from a CSS-color string.
 *
 * @param {String} str A valid css string.
 * @return {CGColor}
 */
CGColorCreateCSS = function(str){
	var a = 0xFF;
	var r = 0x00;
	var g = 0x00;
	var b = 0x00;
	//var sa, sr, sg, sb;
	str = str.trim();
	var len;

	if(str[0] == "#"){
		len = str.length - 1;
		if(len == 6){
			r = str.substr(1, 2);
			r = parseInt(r, 16);
			g = str.substr(3, 2);
	        g = parseInt(g, 16);
	        b = str.substr(5, 2);
	        b = parseInt(b, 16);
		}else if(len == 3){
			r = str[1];
			r = parseInt(r + r, 16);
	        g = str[2];
	        g = parseInt(g + g, 16);
	        b = str[3];
	        b = parseInt(b + b, 16);
		}else{
			throw new TypeError('Unexpected length of hex color');
		}

		return CGColorCreate(0xFF << 24 | red << 16 | green << 8 | blue);
	}

	return;

	// Parsing Method Notation.

	var start = str.indexOf("(");
	start = start !== -1 ? (start + 1) : 0;

    var end = str.indexOf(")", start);
    end = end !== -1 ? (end - start) : str.length;

    // parsing the function name.
    var type = str.substr(0, start - 1);
    type = type.trim();

    // parsing the function arguments
    var args = str.substr(start, end);
    args = args.split(",");

    args = args.map(function(str,index,array){
        return str.trim();
    });

    switch(type){
        case 'rgba':
        	{

        	}
            return rgba.apply(null, fn.args);
        case 'rgb':
        	{

        	}
            return rgb.apply(null, fn.args);
        case 'hsv':
        	{

        	}
            return hsv.apply(null, fn.args);
        case 'hsl':
        	{

        	}
            return hsl.apply(null, fn.args);
        case 'hsla':
        	{

        	}
            return hsla.apply(null, fn.args);
        default:
        	throw Error("not color functin notation");
        	break;
    }
}

/**
 * Creates a CGColor object from a 8-bit integer, representing a grayscale value.
 *
 * @param {int} gray8 A integer value between 0-256.
 * @return {CGColor}
 */
CGColorCreateGenericGray = function(gray8){
	gray8 = gray8 & 0xFF;
	return CGColorCreate(0xFF << 24 | gray8 << 16 | gray8 << 8 | gray8);
}

/**
 * Creates a CGColor object from a rgb components.
 *
 * @param {int} red   A integer value between 0-255.
 * @param {int} green A integer value between 0-255.
 * @param {int} blue  A integer value between 0-255.
 * @return {CGColor}
 */
CGColorCreateGenericRGB = function(red, green, blue){
	red = red & 0xFF;
	green = green & 0xFF;
	blue = blue & 0xFF;
	return CGColorCreate(0xFF << 24 | red << 16 | green << 8 | blue);
}

CGColorCreateGenericCMYK = function(c, m, y, k){
	return CGColorCreate();
}

/**
 * Creates a copy of the CGColor with the specified alpha value.
 * @param {CGColor} color
 * @param {Number} alpha A float value between 0.0 - 1.0
 * @return {CGColor}
 */
CGColorCreateCopyWithAlpha = function(color, alpha){
	alpha = Math.max(0, alpha);
	alpha = Math.min(1, alpha);
	alpha = Math.ceil(255 * alpha);

	var color32 = color.value;
	var r = color32 >>> 16 & 0xFF;
	var g = color32 >>>  8 & 0xFF;
	var b = color32 & 0xFF;
	return CGColorCreate(alpha << 24 | r << 16 | g << 8 | b);
}


// Getting Information about the color represented


/**
 * Returns a boolean value that indicates whether the specified colors represents the same color.
 *
 * @param {CGColor} color1
 * @param {CGColor} color2
 * @return {Boolean}
 */
CGColorEqualToColor = function(color1, color2){
	if(color1 == color2){
		return true;
	}

	return color1.value === color2.value;
}

/**
 * Returns a boolean value that indicates whether the specified colors has transparacy.
 *
 * @param {CGColor} color
 * @return {Boolean}
 */
CGColorHasAlpha = function(color){
	var a = color.value >>> 24;
	return a !== 0xFF;
}

CGColorGetAlpha = function(color){
	return color.value >>> 24;
}


CGColorGetRed = function(color){
	return color.value >>> 16 & 0xFF;
}


CGColorGetGreen = function(color){
	return color.value >>> 8 & 0xFF;
}


CGColorGetBlue = function(color){
	return color.value & 0xFF;
}

/*
//32bit
var color:uint = 0xFF003366;
var a:uint = color >>> 24; 			//Outputs 255
var r:uint = color >>> 16 & 0xFF; 	//Outputs 0
var g:uint = color >>>  8 & 0xFF; 	//Outputs 51
var b:uint = color & 0xFF; 			//Outputs 102


//32bit
var a:uint = 0xFF;
var r:uint = 0x00;
var g:uint = 0x33;
var b:uint = 0x66;
var color:uint = a << 24 | r << 16 | g << 8 | b; //Outputs 4278203238
 */


// Getting CSS Equal (This isn't standarn API)

CGColorToCSS = function(color, type){

}

CGColorToCSS_RGBA = function(color){
	var color32 = color.value;
	var a = (color32 >>> 24) / 255; // returns the decimal equant.
	var r = color32 >>> 16 & 0xFF;
	var g = color32 >>>  8 & 0xFF;
	var b = color32 & 0xFF;

	return "rgba("+r+", "+g+", "+b+", "+a+")";
}

CGColorToCSS_RGB = function(color){
	var color32 = color.value;
	var r = color32 >>> 16 & 0xFF;
	var g = color32 >>>  8 & 0xFF;
	var b = color32 & 0xFF;

	return "rgb("+r+", "+g+", "+b+")";
}

CGColorToCSS_HSV = function(color){
	throw new Error('hsv is currently not supported');
}

CGColorToCSS_HSL = function(color){
	return 'hsl('+h+', '+s+'%, '+l+'%)';
}

CGColorToCSS_HSLA = function(color){
	return "hsla("+h+", "+s+"%, "+l+"%, "+(_alpha)+")";
}

CGColorToCSS_HEX = function(color){
	var color32 = color.value;
	var r = color32 >>> 16 & 0xFF;
	var g = color32 >>>  8 & 0xFF;
	var b = color32 & 0xFF;
	var str = "#";
	str += (r < 16) ? '0' + r.toString(16) : n.toString(16);
	str += (g < 16) ? '0' + g.toString(16) : g.toString(16);
	str += (b < 16) ? '0' + b.toString(16) : b.toString(16);
	return str;
}
