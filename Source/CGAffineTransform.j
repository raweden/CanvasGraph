//
// CGAffineTransform.j
// Core Canvas
//
// Created by Francisco Tolmasky. Modified by Raweden.
// Copyright 2008, 280 North, Inc.
//


@import "CGGeom.j"


/**
 *
 * @group CGAffineTransform
 *
 * @param {Number} a
 * @param {Number} b
 * @param {Number} c
 * @param {Number} d
 * @param {Number} tx
 * @param {Number} ty
 * @return {CGAffineTransform}
 */
function CGAffineTransformMake(a, b, c, d, tx, ty){
    return {a:a, b:b, c:c, d:d, tx:tx, ty:ty};
}

/**
 *
 * @group CGAffineTransform
 *
 * @return {CGAffineTransform}
 */
function CGAffineTransformMakeIdentity(){
    return CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
}

/**
 * Returns a copy of the transform object.
 * @group CGAffineTransform
 *
 * @param {CGAffineTransform} aTransform The CGAffineTransform which to clone.
 * @return {CGAffineTransform}
 */
function CGAffineTransformMakeCopy(aTransform){
    return CGAffineTransformMake(aTransform.a, aTransform.b, aTransform.c, aTransform.d, aTransform.tx, aTransform.ty);
}

/**
 * Creates a new CGAffineTransform object with the specified scale transform.
 * @group CGAffineTransform
 *
 * @param {Number} sx Scaling applied along the x axis.
 * @param {Number} sy Scaling applied along the y axis.
 * @return {CGAffineTransform}
 */
function CGAffineTransformMakeScale(sx, sy){
    return CGAffineTransformMake(sx, 0.0, 0.0, sy, 0.0, 0.0);
}

/**
 * Creates a new CGAffineTransform object with the specified translation.
 * @group CGAffineTransform
 *
 * @param {Number} tx Translation along the x axis.
 * @param {Number} ty Translation along the y axis.
 * @return {CGAffineTransform}
 */
function CGAffineTransformMakeTranslation(tx, ty){
    return CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, tx, ty);
}

/**
 * Applies translation to a CGAffineTransform object.
 * @group CGAffineTransform
 *
 * @param {CGAffineTransform} aTransform The CGAffineTransform object on which to modify the translation.
 * @param {Number} tx         Translation along the x axis.
 * @param {Number} ty         Translation along the y axis.
 * @return {CGAffineTransform} A new CGAffineTransform object.
 */
function CGAffineTransformTranslate(aTransform, tx, ty){
    return CGAffineTransformMake(aTransform.a, aTransform.b, aTransform.c, aTransform.d, aTransform.tx + aTransform.a * tx + aTransform.c * ty, aTransform.ty + aTransform.b * tx + aTransform.d * ty);
}

/**
 * Applies the scaling
 * @group CGAffineTransform
 *
 * @param {CGAffineTransform} aTransform The CGAffineTransform object which is used as the base.
 * @param {Number} sx         Scaling along the x axis.
 * @param {Number} sy         Scaling along the y axis.
 * @return {CGAffineTransform}
 */
function CGAffineTransformScale(aTransform, sx, sy){
    return CGAffineTransformMake(aTransform.a * sx, aTransform.b * sx, aTransform.c * sy, aTransform.d * sy, aTransform.tx, aTransform.ty);
}

/**
 *
 * @group CGAffineTransform
 *
 * @param {CGAffineTransform} lhs
 * @param {CGAffineTransform} rhs
 * @return {CGAffineTransform}
 */
function CGAffineTransformConcat(lhs, rhs){
    return CGAffineTransformMake(lhs.a * rhs.a + lhs.b * rhs.c, lhs.a * rhs.b + lhs.b * rhs.d, lhs.c * rhs.a + lhs.d * rhs.c, lhs.c * rhs.b + lhs.d * rhs.d, lhs.tx * rhs.a + lhs.ty * rhs.c + rhs.tx, lhs.tx * rhs.b + lhs.ty * rhs.d + rhs.ty);
}

/**
 * Applies transformation of a CGAffineTransform to a point object.
 * @group CGAffineTransform
 *
 * @param {CGPoint} aPoint
 * @param {CGAffineTransform} aTransform
 * @return {CGPoint}
 */
function CGPointApplyAffineTransform(aPoint, aTransform){
    return CGPointMake(aPoint.x * aTransform.a + aPoint.y * aTransform.c + aTransform.tx, aPoint.x * aTransform.b + aPoint.y * aTransform.d + aTransform.ty);
}

/**
 * Applies transformation of a CGAffineTransform to a size object.
 * @group CGAffineTransform
 *
 * @param {CGSize} aSize
 * @param {CGAffineTransform} aTransform
 * @return {CGSize}
 */
function CGSizeApplyAffineTransform(aSize, aTransform){
    return CGSizeMake(aSize.width * aTransform.a + aSize.height * aTransform.c, aSize.width * aTransform.b + aSize.height * aTransform.d);
}

/**
 * Applies transformation of a CGAffineTransform to a CGRect object.
 * @group CGAffineTransform
 *
 * @param {CGRect} aRect
 * @param {CGAffineTransform} aTransform
 * @return {CGRect}
 */
function CGRectApplyAffineTransform(aRect, aTransform){
    return {origin:CGPointApplyAffineTransform(aRect.origin, aTransform), size:CGSizeApplyAffineTransform(aRect.size, aTransform)};
}

/**
 * Determines whether the transform object is identity.
 * @group CGAffineTransform
 *
 * @param {CGAffineTransform} aTransform
 * @return {Boolean}
 */
function CGAffineTransformIsIdentity(aTransform){
    return (aTransform.a == 1 && aTransform.b == 0 && aTransform.c == 0 && aTransform.d == 1 && aTransform.tx == 0 && aTransform.ty == 0);
}

/**
 * Determines whether the two transforms is equal.
 * @group CGAffineTransform
 *
 * @param {CGAffineTransform} lhs
 * @param {CGAffineTransform} rhs
 * @return {Boolean}
 */
function CGAffineTransformEqualToTransform(lhs, rhs){
    return (lhs.a == rhs.a && lhs.b == rhs.b && lhs.c == rhs.c && lhs.d == rhs.d && lhs.tx == rhs.tx && lhs.ty == rhs.ty);
}

/**
 * Returns a string that describes the CGAffineTransform object.
 * @group CGAffineTransform
 *
 * @param {[type]} aTransform [description]
 * @return {String}
 */
function CGStringCreateWithCGAffineTransform(aTransform){
    return " [[ " + aTransform.a + ", " + aTransform.b + ", 0 ], [ " + aTransform.c + ", " + aTransform.d + ", 0 ], [ " + aTransform.tx + ", " + aTransform.ty + ", 1]]";
}


function CGAffineTransformConcatTo(lhs, rhs, to){
    var tx = lhs.tx * rhs.a + lhs.ty * rhs.c + rhs.tx;
    to.ty = lhs.tx * rhs.b + lhs.ty * rhs.d + rhs.ty;
    to.tx = tx;
    var a = lhs.a * rhs.a + lhs.b * rhs.c;
    var b = lhs.a * rhs.b + lhs.b * rhs.d;
    var c = lhs.c * rhs.a + lhs.d * rhs.c;
    to.d = lhs.c * rhs.b + lhs.d * rhs.d;
    to.a = a;
    to.b = b;
    to.c = c;
}

/*
a  b  0 cos sin 0
c  d  0 -sin cos 0
tx ty 1 0 0 1
*/

/**
 * FIXME: !!!!
 * @return void
 * @group CGAffineTransform
 */
function CGAffineTransformCreateCopy(aTransform){
    return CGAffineTransformMakeCopy(aTransform);
}

/**
 * Returns a transform that rotates a coordinate system.
 * @group CGAffineTransform
 *
 * @param anAngle the amount in radians for the transform
 * to rotate a coordinate system
 * @return CGAffineTransform the transform with a specified
 * rotation
 *
*/
function CGAffineTransformMakeRotation(anAngle){
    var sin = SIN(anAngle);
    var cos = COS(anAngle);
    return CGAffineTransformMake(cos, sin, -sin, cos, 0.0, 0.0);
}

/**
 * Rotates a transform.
 * @group CGAffineTransform
 * @param {CGAffineTransform} aTransform the transform to rotate
 * @param {Number} anAngle the amount to rotate in radians
 * @return {void}
*/
function CGAffineTransformRotate(aTransform, anAngle){
    var sin = SIN(anAngle);
    var cos = COS(anAngle);

    return {a:aTransform.a * cos + aTransform.c * sin,
            b:aTransform.b * cos + aTransform.d * sin,
            c:aTransform.c * cos - aTransform.a * sin,
            d:aTransform.d * cos - aTransform.b * sin,
            tx:aTransform.tx,
            ty:aTransform.ty};
}

/**
 * Inverts a transform.
 * @group CGAffineTransform
 *
 * @param {CGAffineTransform} aTransform the transform to invert
 * @return {CGAffineTransform} an inverted transform
*/
function CGAffineTransformInvert(aTransform)
{
    var determinant = 1 / (aTransform.a * aTransform.d - aTransform.b * aTransform.c);

    return {
        a:determinant * aTransform.d,
        b:-determinant * aTransform.b,
        c:-determinant * aTransform.c,
        d:determinant * aTransform.a,
        tx:determinant * (aTransform.c * aTransform.ty - aTransform.d * aTransform.tx),
        ty:determinant * (aTransform.b * aTransform.tx - aTransform.a * aTransform.ty)
    };
}

/**
 * Applies a transform to the rectangle's points. The transformed rectangle
 * will be the smallest box that contains the transformed points.
 * @group CGAffineTransform
 *
 * @param {CGRect} aRect the rectangle to transform
 * @param {CGAffineTransform} anAffineTransform the transform to apply
 * @return {CGRect} the new transformed rectangle
 */
function CGRectApplyAffineTransform(aRect, anAffineTransform){
    var top = CGRectGetMinY(aRect);
    var left = CGRectGetMinX(aRect);
    var right = CGRectGetMaxX(aRect);
    var bottom = CGRectGetMaxY(aRect);
    var topLeft = CGPointApplyAffineTransform(CGPointMake(left, top), anAffineTransform);
    var topRight = CGPointApplyAffineTransform(CGPointMake(right, top), anAffineTransform);
    var bottomLeft = CGPointApplyAffineTransform(CGPointMake(left, bottom), anAffineTransform);
    var bottomRight = CGPointApplyAffineTransform(CGPointMake(right, bottom), anAffineTransform);
    var minX = MIN(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
    var maxX = MAX(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
    var minY = MIN(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
    var maxY = MAX(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);

    return CGRectMake(minX, minY, (maxX - minX), (maxY - minY));
}

/**
 * Creates and returns a string representation of an affine transform.
 * @group CGAffineTransform
 *
 * @param {CGAffineTransform} anAffineTransform the transform to represent as a string
 * @return {String} a string describing the transform
 */
function CPStringFromCGAffineTransform(anAffineTransform){
    return '{' + anAffineTransform.a + ", " + anAffineTransform.b + ", " + anAffineTransform.c + ", " + anAffineTransform.d + ", " + anAffineTransform.tx + ", " + anAffineTransform.ty + '}';
}
