//
//  Enums.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

/** Determines what type of canvas layer this is: one that uses raster graphics or svg. */
public enum LayerType: Int {
    /** A layer that uses pixel-based graphics. */
    case raster = 0
    
    /** A layer that uses Scalable Vector Graphics. */
    case vector = 1
}


/** The position of the layer relative to another. */
public enum LayerPosition: Int {
    case above = 0
    case below = 1
}


/** The type of tool to use when drawing on the canvas. */
public enum CanvasTool: Int {
    case pen = 0
    case eraser = 1
    case line = 2
    case rectangle = 3
    case ellipse = 4
    case paint = 5
    case eyedropper = 6
    case selection = 7
}


/** Relative position of points. */
public enum RelativePointPosition: Int {
    case upperRight = 0
    case upperLeft = 1
    case lowerRight = 2
    case lowerLeft = 3
}


/** Defines how the eyedropper tool should pick up colors: either by setting the stroke color or the fill color. */
public enum EyedropperOptions {
    case stroke
    case fill
}


/** Coding keys for brush. */
public enum BrushCodingKeys: CodingKey {
    case strokeColor
    case fillColor
    case thickness
    case opacity
    case miter
    case shape
    case join
}

/** Coding keys for node. */
public enum NodeCodingKeys: CodingKey {
    case type
    case points
    case instructions
    case brush
}
