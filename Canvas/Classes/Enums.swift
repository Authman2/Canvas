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
    case eraser = 1 // todo
    case line = 2
    case rectangle = 3
    case ellipse = 4
    case paint = 5 // todo
    case eyedropper = 6
}


/** Relative position of points. */
public enum RelativePointPosition: Int {
    case upperRight = 0
    case upperLeft = 1
    case lowerRight = 2
    case lowerLeft = 3
}
