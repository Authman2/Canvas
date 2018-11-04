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
    
    /** The nodes on this layer that are selected. */
    internal var selectedNodes: [Node] = []
    
    
    
    
    // -- PUBLIC VARS
    
    /** Whether or not this layer is visible. */
    public var isVisible: Bool = true
    
    /** Whether or not this layer allows drawing. */
    public var allowsDrawing: Bool = true
    
    
    
    
    // -- COMPUTED PROPERTIES
    
    /** The number of nodes (drawings) on this layer. */
    public var nodeCount: Int {
        return self.drawings.count
    }
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public init(type: LayerType) {
        self.type = type
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Clears the drawing on this layer. */
    public func clear(from canvas: Canvas) {
        drawings = []
        canvas.setNeedsDisplay()
    }
    
    
    /** Adds a new node (drawing) to this layer. */
    public func add(node: Node, on canvas: Canvas) {
        drawings.append(node)
        canvas.setNeedsDisplay()
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
