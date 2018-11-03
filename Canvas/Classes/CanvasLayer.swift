//
//  CanvasLayer.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

/** A layer of the canvas that contains drawing data. */
public class CanvasLayer {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // -- PRIVATE VARS
    
    /** The array of nodes on this layer. */
    internal var drawings: [Node] = []
    
    /** The type of layer this is: raster or vector. */
    internal var type: LayerType = .raster
    
    
    
    // -- PUBLIC VARS
    
    /** Whether or not this layer is visible. */
    public var isVisible: Bool = true
    
    /** Whether or not this layer allows drawing. */
    public var allowsDrawing: Bool = true
    
    
    
    
    // -- COMPUTED PROPERTIES
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    init(type: LayerType) {
        self.type = type
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
