//
//  Enums.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

/** Determines what type of canvas this is: one that uses raster graphics or svg. */
public enum CanvasType {
    /** A canvas that uses pixel-based graphics. */
    case raster
    
    /** A canvas that uses Scalable Vector Graphics. */
    case vector
}


/** The position of the layer. */
public enum LayerPosition {
    case above
    case below
}
