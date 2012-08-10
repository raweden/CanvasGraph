//
// CGGeom.j
// Core Canvas
//
// Created by Raweden.
// Copyright 2012 Raweden. All rights reserved.
//


#pragma mark CGPoint


/**
 * Returns a point with the specified cordinates.
 *
 * @param {Number} x
 * @param {Number} y
 * @return {CGPoint}
 */
function CGPointMake(x, y){
    return {x:x, y:y};
}

/**
 *
 * @group CGPoint
 *
 * @param {CGPoint} point
 * @return {CGPoint} A point object which is identical clone.
 */
function CGPointMakeCopy(point){
    return CGPointMake(point.x, point.y);
}

/**
 *
 * @group CGPoint
 *
 * @return {CGPoint}
 */
function CGPointMakeZero(){
    return CGPointMake(0.0, 0.0);
}

/**
 *
 * @group CGPoint
 *
 * @param {CGPoint} lhsPoint
 * @param {CGPoint} rhsPoint
 * @return {Boolean}
 */
function CGPointEqualToPoint(lhsPoint, rhsPoint){
    return (lhsPoint.x == rhsPoint.x && lhsPoint.y == rhsPoint.y);
}

/**
 *
 * @group CGPoint
 *
 * @param {CGPoint} point
 * @return {String}
 */
function StringFromPoint(point){
    return ("{" + point.x + ", " + point.y + "}");
}

/**
 *
 * @group CGPoint
 * @TODO consider to improve this method.
 *
 * @param {String} aString
 * @return {CGPoint}
 */
function CGPointFromString(aString){
    var comma = aString.indexOf(',');
    return { x:parseFloat(aString.substr(1, comma - 1)), y:parseFloat(aString.substring(comma + 1, aString.length)) };
}

// @TODO consider to remove this method, it's not good practicly of having a low-level method that relies upon DOM.
function CGPointFromEvent(anEvent){
    return CGPointMake(anEvent.clientX, anEvent.clientY);
}


#pragma mark CGSize


/**
 *
 * @group CGSize
 *
 * @param {Number} width
 * @param {Number} height
 * @return {CGSize}
 */
function CGSizeMake(width, height){
    return {width:width, height:height};
}


/**
 *
 * @group CGSize
 *
 * @param {CGSize} aSize
 * @return {CGSize}
 */
function CGSizeMakeCopy(aSize){
    return CGSizeMake(aSize.width, aSize.height);
}

/**
 *
 * @group CGSize
 *
 * @return {CGSize}
 */
function CGSizeMakeZero(){
    return CGSizeMake(0.0, 0.0);
}

/**
 *
 * @group CGSize
 *
 * @param {CGSize} aSize
 * @return {CGSize}
 */
function CGSizeEqualToSize(lhsSize, rhsSize){
    return (lhsSize.width == rhsSize.width && lhsSize.height == rhsSize.height);
}

/**
 *
 * @group CGSize
 *
 * @param {CGSize} aSize
 * @return {CGSize}
 */
function CGStringFromSize(aSize){
    return "{" + aSize.width + ", " + aSize.height + "}";
}

/**
 *
 * @group CGSize
 *
 * @param {CGSize} aSize
 * @return {CGSize}
 */
function CGSizeFromString(aString){
    var comma = aString.indexOf(',');
    return { width:parseFloat(aString.substr(1, comma - 1)), height:parseFloat(aString.substring(comma + 1, aString.length)) };
}


#pragma mark CGRect


/**
 *
 * @group CGRect
 *
 * @param {Number} x
 * @param {Number} x
 * @param {Number} width
 * @param {Number} height
 * @return {CGRect}
 */
function CGRectMake(x, y, width, height){
    return {origin:CGPointMake(x, y), size:CGSizeMake(width, height)};
}

/**
 *
 * @group CGRect
 *
 * @return {CGRect}
 */
function CGRectMakeZero(){
    return CGRectMake(0.0, 0.0, 0.0, 0.0);
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {CGRect}
 */
function CGRectMakeCopy(aRect){
    return CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
}

/**
 * TODO: Depricated.
 *
 * @param {CGRect} aRect
 * @return {CGRect}
 */
function CGRectCreateCopy(aRect){
    return CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} lhsRect
 * @param {CGRect} rhsRect
 * @return {Boolean}
 */
function CGRectEqualToRect(lhsRect, rhsRect){
    return (CGPointEqualToPoint(lhsRect.origin, rhsRect.origin) && CGSizeEqualToSize(lhsRect.size, rhsRect.size));
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {String}
 */
function CGStringFromRect(aRect){
    return "{" + StringFromPoint(aRect.origin) + ", " + CGStringFromSize(aRect.size) + "}";
}

// TODO most methods which converts object to string got a name which does not make sense.

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @param {Number} dx
 * @param {Number} dy
 * @return {CGRect}
 */
function CGRectOffset(aRect, dx, dy){
    return CGRectMake(aRect.origin.x + dx, aRect.origin.y + dy, aRect.size.width, aRect.size.height);
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @param {Number} dx
 * @param {Number} dy
 * @return {CGRect}
 */
function CGRectInset(aRect, dx, dy){
    return CGRectMake(aRect.origin.x + dx, aRect.origin.y + dy, aRect.size.width - 2 * dx, aRect.size.height - 2 * dy);
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @param {CGInset} anInset
 * @return {CGRect}
 */
function CGRectInsetByInset(aRect, anInset){
    return CGRectMake(aRect.origin.x + anInset.left, aRect.origin.y + anInset.top, aRect.size.width - anInset.left - anInset.right, aRect.size.height - anInset.top - anInset.bottom);
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Number}
 */
function CGRectGetHeight(aRect){
    return aRect.size.height;
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Number}
 */
function CGRectGetMaxX(aRect){
    return aRect.origin.x + aRect.size.width;
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Number}
 */
function CGRectGetMaxY(aRect){
    return aRect.origin.y + aRect.size.height;
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Number}
 */
function CGRectGetMidX(aRect){
    return aRect.origin.x + (aRect.size.width / 2.0);
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Number}
 */
function CGRectGetMidY(aRect){
    return aRect.origin.y + (aRect.size.height / 2.0);
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Number}
 */
function CGRectGetMinX(aRect){
    return aRect.origin.x;
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Number}
 */
function CGRectGetMinY(aRect){
    return aRect.origin.y;
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Number}
 */
function CGRectGetWidth(aRect){
    return aRect.size.width;
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Boolean}
 */
function CGRectIsEmpty(aRect){
    return (aRect.size.width <= 0.0 || aRect.size.height <= 0.0);
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @return {Boolean}
 */
function CGRectIsNull(aRect){
    return (aRect.size.width <= 0.0 || aRect.size.height <= 0.0);
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} aRect
 * @param {CGPoint} aPoint
 * @return {Boolean}
 */
function CGRectContainsPoint(aRect, aPoint){
    return (aPoint.x >= CGRectGetMinX(aRect) && aPoint.y >= CGRectGetMinY(aRect) && aPoint.x < CGRectGetMaxX(aRect) && aPoint.y < CGRectGetMaxY(aRect));
}

/**
 * Creates two rectangles -- slice and rem -- from inRect, by dividing inRect
 * with a line that's parallel to the side of inRect specified by edge.
 * The size of slice is determined by amount, which specifies the distance from edge.
 * @group CGRect
 *
 * slice and rem must not be NULL, must not be the same object, and must not be the
 * same object as inRect.
 */
function CGRectDivide(inRect, slice, rem, amount, edge){
    slice.origin = CGPointMakeCopy(inRect.origin);
    slice.size = CGSizeMakeCopy(inRect.size);
    rem.origin = CGPointMakeCopy(inRect.origin);
    rem.size = CGSizeMakeCopy(inRect.size);

    switch(edge){
        case CGMinXEdge:
            slice.size.width = amount;
            rem.origin.x += amount;
            rem.size.width -= amount;
            break;

        case CGMaxXEdge:
            slice.origin.x = CGRectGetMaxX(slice) - amount;
            slice.size.width = amount;
            rem.size.width -= amount;
            break;

        case CGMinYEdge:
            slice.size.height = amount;
            rem.origin.y += amount;
            rem.size.height -= amount;
            break;

        case CGMaxYEdge:
            slice.origin.y = CGRectGetMaxY(slice) - amount;
            slice.size.height = amount;
            rem.size.height -= amount;
    }
}

/**
 * Returns a `Boolean` value that indicates whether CGRect `lhsRect`
 * contains CGRect `rhsRect`.
 * @group CGRect
 *
 * @param {CGRect} lhsRect The CGRect to test if `rhsRect` is inside of.
 * @param {CGRect} rhsRect The CGRect to test if it fits inside `lhsRect`.
 * @return {Boolean} A boolean `YES` if `rhsRect` fits inside `lhsRect`.
 */
function CGRectContainsRect(lhsRect, rhsRect){
    var union = CGRectUnion(lhsRect, rhsRect);
    return CGRectEqualToRect(union, lhsRect);
}

/**
 * Returns `YES` if the two rectangles intersect
 * @group CGRect
 *
 * @param {CGRect} lhsRect The first CGRect
 * @param {CGRect} rhsRect The second CGRect
 * @return {Boolean} `YES` if the two rectangles have any common spaces, and `NO`, otherwise.
 */
function CGRectIntersectsRect(lhsRect, rhsRect){
    var intersection = CGRectIntersection(lhsRect, rhsRect);
    return !CGRectIsEmpty(intersection);
}

/**
 * Makes the origin and size of a CGRect all integers. Specifically, by making
 * the southwest corner the origin (rounded down), and the northeast corner a CGSize (rounded up).
 * @group CGRect
 *
 * @param {CGRect} aRect the rectangle to operate on
 * @return {CGRect} the modified rectangle (same as the input)
 */
function CGRectIntegral(aRect){
    aRect = CGRectStandardize(aRect);

    // Store these out separately, if not the GetMaxes will return incorrect values.
    var x = FLOOR(CGRectGetMinX(aRect)),
        y = FLOOR(CGRectGetMinY(aRect));

    aRect.size.width = CEIL(CGRectGetMaxX(aRect)) - x;
    aRect.size.height = CEIL(CGRectGetMaxY(aRect)) - y;

    aRect.origin.x = x;
    aRect.origin.y = y;

    return aRect;
}

/**
 * Returns the intersection of the two provided rectangles as a new rectangle.
 * @group CGRect
 *
 * @param {CGRect} lhsRect The first rectangle used for calculation
 * @param {CGRect} rhsRect The second rectangle used for calculation
 * @return {CGRect} The intersection of the two rectangles
 */
function CGRectIntersection(lhsRect, rhsRect){
    var intersection = CGRectMake(
        MAX(CGRectGetMinX(lhsRect), CGRectGetMinX(rhsRect)),
        MAX(CGRectGetMinY(lhsRect), CGRectGetMinY(rhsRect)),
        0, 0);

    intersection.size.width = MIN(CGRectGetMaxX(lhsRect), CGRectGetMaxX(rhsRect)) - CGRectGetMinX(intersection);
    intersection.size.height = MIN(CGRectGetMaxY(lhsRect), CGRectGetMaxY(rhsRect)) - CGRectGetMinY(intersection);

    return CGRectIsEmpty(intersection) ? CGRectMakeZero() : intersection;
}

/**
 * Normalizes the rectangle.
 * @group CGRect
 *
 * @return {CGRect}
 */
function CGRectStandardize(aRect){
    var width = CGRectGetWidth(aRect),
        height = CGRectGetHeight(aRect),
        standardized = CGRectMakeCopy(aRect);

    if (width < 0.0){
        standardized.origin.x += width;
        standardized.size.width = -width;
    }

    if (height < 0.0){
        standardized.origin.y += height;
        standardized.size.height = -height;
    }

    return standardized;
}

/**
 *
 * @group CGRect
 *
 * @param {CGRect} lhsRect
 * @param {CGRect} rhsRect
 * @return {CGRect}
 */
function CGRectUnion(lhsRect, rhsRect){
    var lhsRectIsNull = !lhsRect || lhsRect === CGRectNull;
    var rhsRectIsNull = !rhsRect || rhsRect === CGRectNull;

    if (lhsRectIsNull)
        return rhsRectIsNull ? CGRectNull : rhsRect;

    if (rhsRectIsNull)
        return lhsRectIsNull ? CGRectNull : lhsRect;

    var minX = MIN(CGRectGetMinX(lhsRect), CGRectGetMinX(rhsRect)),
        minY = MIN(CGRectGetMinY(lhsRect), CGRectGetMinY(rhsRect)),
        maxX = MAX(CGRectGetMaxX(lhsRect), CGRectGetMaxX(rhsRect)),
        maxY = MAX(CGRectGetMaxY(lhsRect), CGRectGetMaxY(rhsRect));

    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}


/**
 * Returns a CGRect from a string notation.
 * @group CGRect
 *
 * @param {Number} aString [description]
 * @return {CGRect}
 */
function CGRectFromString(aString){
    var comma = aString.indexOf(',', aString.indexOf(',') + 1);
    return { origin:CGPointFromString(aString.substr(1, comma - 1)), size:CGSizeFromString(aString.substring(comma + 2, aString.length)) };
}

CGRectNull = CGRectMake(Infinity, Infinity, 0.0, 0.0);


#pragma mark CGInset


/**
 *
 * @group CGInset
 *
 * @param {Number} top
 * @param {Number} right
 * @param {Number} bottom
 * @param {Number} left
 * @return {CGInset}
 */
function CGInsetMake(top, right, bottom, left){
    return {top:top, right:right, bottom:bottom, left:left};
}

/**
 *
 * @group CGInset
 *
 * @param {CGInset} anInset
 * @return {CGInset}
 */
function CGInsetMakeCopy(anInset){
    return CGInsetMake(anInset.top, anInset.right, anInset.bottom, anInset.left)
}

/**
 *
 * @group CGInset
 *
 * @return {CGInset}
 */
function CGInsetMakeZero(){
    CGInsetMake(0, 0, 0, 0);
}

/**
 *
 * @group CGInset
 *
 * @param {CGInset} anInset
 * @return {Boolean}
 */
function CGInsetIsEmpty(anInset){
    return (anInset.top === 0 && anInset.right === 0 && anInset.bottom === 0 && anInset.left === 0);
}

/**
 *
 * @group CGInset
 *
 * @param {CGInset} lhsInset
 * @param {CGInset} rhsInset
 * @return {Boolean}
 */
function CGInsetEqualToInset(lhsInset, rhsInset){
    return (lhsInset.top === rhsInset.top && lhsInset.right === rhsInset.right && lhsInset.bottom === rhsInset.bottom && lhsInset.left === rhsInset.left);
}

/**
 * Combines two insets by adding their individual elements and returns the result.
 * @group CGInset
 *
 * @param {CGInset} lhsInset
 * @param {CGInset} rhsInset
 * @return {CGInset}
 */
function CGInsetUnion(lhsInset, rhsInset)
{
    return CGInsetMake(lhsInset.top + rhsInset.top,
                        lhsInset.right + rhsInset.right,
                        lhsInset.bottom + rhsInset.bottom,
                        lhsInset.left + rhsInset.left);
}

/**
 * Subtract one inset from another by subtracting their individual elements and returns the result.
 * @group CGInset
 *
 * @param {CGInset} lhsInset
 * @param {CGInset} rhsInset
 * @return {CGInset}
 */
function CGInsetDifference(lhsInset, rhsInset){
    return CGInsetMake(lhsInset.top - rhsInset.top,
                        lhsInset.right - rhsInset.right,
                        lhsInset.bottom - rhsInset.bottom,
                        lhsInset.left - rhsInset.left);
}

/**
 *
 * @group CGInset
 *
 * @param aString {String}
 * @return {CGInset}
 */
function CGInsetFromString(aString){
    var numbers = aString.substr(1, aString.length - 2).split(',');

    return CGInsetMake(parseFloat(numbers[0]), parseFloat(numbers[1]), parseFloat(numbers[2]), parseFloat(numbers[3]));
}

/**
 *
 * @group CGInset
 *
 * @param anInset {CGInset}
 * @return {String}
 */
function StringFromCGInset(anInset){
    return '{' + anInset.top + ", " + anInset.left + ", " + anInset.bottom + ", " + anInset.right + '}';
}

CGMinXEdge = 0;
CGMinYEdge = 1;
CGMaxXEdge = 2;
CGMaxYEdge = 3;
