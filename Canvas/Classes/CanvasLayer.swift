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
    
    // -- PRIVATE VARS --
    
    /** The canvas that this layer is on. */
    internal var canvas: Canvas!
    
    /** The next node to be drawn on the screen, whether that be a curve, a line, or a shape. */
    internal var nextNode: Node?
    
    /** The image that the user is drawing on. */
    internal var drawImage: UIImage!
    
    /** The background drawing in case the user wants to import an image. */
    internal var backgroundImage: UIImage!
    
    /** All of the nodes on this layer. */
    internal var nodeArray: [Node]!
    
    
    // -- PUBLIC VARS --
    
    /** Whether or not this layer is visible. True by default. */
    public var isVisible: Bool
    
    /** Whether or not this layer allows drawing. True by default. */
    public var allowsDrawing: Bool
    
    
    
    // -- PUBLIC COMPUTED VARS --
    
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
        backgroundImage = UIImage()
        nodeArray = []
        isVisible = true
        allowsDrawing = true
        canvas = nil
    }
    
    internal convenience init(canvas: Canvas) {
        self.init()
        self.canvas = canvas
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
        // If there is no reference to a canvas, then draw at the point CGPoint.zero
        // Otherwise, draw inside the frame of the canvas.
        guard let cv = canvas else {
            if self.isVisible == true {
                self.backgroundImage.draw(at: CGPoint.zero)
                self.drawImage.draw(at: CGPoint.zero)
                self.nextNode?.draw()
            }
            return
        }
        
        // If this layer knows what canvas it's on, then draw inside that frame.
        // Only used for drawing background images.
        if self.isVisible == true {
            self.backgroundImage.draw(in: cv.frame)
            self.drawImage.draw(in: cv.frame)
            self.nextNode?.draw()
        }
    }
    
    
}
