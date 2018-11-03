//
//  Node.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

/** A point, line, shape, etc. that exists on a layer of the canvas. */
public class Node {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // -- PRIVATE VARS
    
    /** What type of node this is. */
    internal var type: CanvasTool!
    
    
    // -- PUBLIC VARS
    
    /** The points that make up this node. */
    public var points: [[CGPoint]] = []
    
    /** The instructions used to draw the points. */
    public var instructions: [CGPathElementType] = []
    
    /** The brush that this node uses for styling. */
    public var brush: Brush = .Default
    
    
    // -- COMPUTED PROPERTIES
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    init(type: CanvasTool) {
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
