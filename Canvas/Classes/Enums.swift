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


/** The position of the layer. */
public enum LayerPosition: Int {
    case above = 0
    case below = 1
}


/** Determines what type of shape a node is. */
public enum CanvasTool: Int {
    case pen = 0
    case eraser = 1
    case line = 2
    case rectangle = 3
    case ellipse = 4
    case paint = 5
    case eyedropper = 6
}
