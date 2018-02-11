//
//  CanvasLayer.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation

/** A single layer that can be drawn on. The Canvas can have multiple layers which can be rearranged to have different drawings appear on top of or below others. */
public class CanvasLayer {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The next node to be drawn on the screen, whether that be a curve, a line, or a shape. */
    var nextNode: Node?
    
    /** The image that the user is drawing on. */
    var drawImage: UIImage!
    
    /** All of the nodes on this layer. */
    var nodeArray: NSMutableArray!
    
    
    
    /** Returns the number of nodes on this layer. */
    public var nodeCount: Int { return self.nodeArray.count }
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public init() {
        nextNode = nil
        drawImage = UIImage()
        nodeArray = NSMutableArray()
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    public func draw() {
        self.drawImage.draw(at: CGPoint.zero)
        self.nextNode?.draw()
    }
    
    
}
