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
    
    
    /** All of the nodes on this layer. */
    public var nodes: [Node] {
        return self.drawings
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
    
    
    /** Returns the node at the given index. */
    public func get(at: Int) -> Node? {
        if at < 0 || at >= drawings.count { return nil }
        return drawings[at]
    }
    
    
    /** Selects the given nodes on this layer. */
    public func select(nodes: [Node], on canvas: Canvas) {
        self.selectedNodes = nodes
        canvas.setNeedsDisplay()
    }
    
    
    /** Returns the nodes that are selected. */
    public func getSelectedNodes() -> [Node] {
        return self.selectedNodes
    }
    
    
    /** Removes the node at the given index from this layer. */
    public func removeNode(at: Int) -> Node {
        let n = self.drawings.remove(at: at)
        return n
    }
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
