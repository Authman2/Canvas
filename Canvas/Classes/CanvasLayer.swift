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
    
    /** The (possibly nil) node that is selected and being moved. */
    internal var selectNode: Node?
    
    /** The image that the user is drawing on. */
    internal var drawImage: UIImage!
    
    /** The background drawing in case the user wants to import an image. */
    internal var backgroundImage: UIImage!
    
    /** All of the nodes on this layer. */
    var nodeArray: [Node]!
    
    
    // -- PUBLIC VARS --
    
    /** Whether or not this layer is visible. True by default. */
    public var isVisible: Bool
    
    /** Whether or not this layer allows drawing. True by default. */
    public var allowsDrawing: Bool
    
    /** The opacity of everything on this layer. */
    public var opacity: CGFloat {
        didSet {
            if backgroundImage != nil { backgroundImage = backgroundImage.withOpacity(opacity) }
            drawImage = drawImage.withOpacity(opacity)
            canvas.updateDrawing(redraw: false)
            canvas.setNeedsDisplay()
        }
    }
    
    
    // -- PUBLIC COMPUTED VARS --
    
    /** Returns the number of nodes on this layer. */
    public var nodeCount: Int { return self.nodeArray.count }
    
    /** Whether or not his layer has a background image. */
    public var hasBackgroundImage: Bool { return self.backgroundImage != nil }
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public init(canvas: Canvas) {
        nextNode = nil
        drawImage = UIImage()
        backgroundImage = nil
        nodeArray = []
        isVisible = true
        allowsDrawing = true
        self.canvas = canvas
        opacity = 1
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/

    /** Returns a UIImage that is a combination of the background image and the drawing image. */
    internal func mergedWithBackground() -> UIImage {
        switch backgroundImage {
        case nil: return drawImage
        default: return backgroundImage + drawImage
        }
    }
    
    
    /** Clears the drawing on this layer. */
    public func clear() {
        backgroundImage = UIImage()
        drawImage = UIImage()
        nodeArray = []
        canvas.updateDrawing(redraw: true)
        canvas.setNeedsDisplay()
    }
    
    
    /** Returns all the nodes on this layer. */
    public func getNodes() -> [Node] { return self.nodeArray }
    
    
    /** Returns the background image of this layer. */
    public func getBackgroundImage() -> UIImage { return backgroundImage }
    
    
    /** Returns the drawing image. */
    public func getDrawingImage() -> UIImage { return drawImage }
    
    
    /** Takes an array of nodes as input and draws them all on this layer. */
    public func drawFrom(nodes: [Node], background: UIImage? = nil) {
        self.nodeArray.append(contentsOf: nodes)
        
        if background != nil { self.backgroundImage = background }
        
        canvas.updateDrawing(redraw: true)
        canvas.setNeedsDisplay()
    }
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    public func draw() {
        if isVisible == false { return }
        
        // If there is no background image, draw at CGPoint.zero, otherwise inside frame.
        if backgroundImage == nil {
            self.drawImage.draw(at: CGPoint.zero)
            self.nextNode?.draw()
        } else {
            let cv = self.canvas!
            self.backgroundImage.draw(in: cv.frame)
            self.drawImage.draw(in: cv.frame)
            self.nextNode?.draw()
        }
    }
    
    
    
    
    
    /************************
     *                      *
     *        TOUCHES       *
     *                      *
     ************************/
    
    /** Handles a touch on this layer when it comes to selecting nodes. */
    func onTouch(touch: UITouch) {
        let loc = touch.location(in: canvas)
        
        for node in nodeArray {
            if node is EraserNode { continue }
            
            if node.contains(point: loc) {
                self.selectNode = node
                break
            }
        }
    }
    
    /** Handles movement events on a node. */
    func onMove(touch: UITouch) {
        guard let selNode = selectNode else { return }
        let loc = touch.location(in: canvas)
        
        selNode.moveNode(to: loc)
        canvas.updateDrawing(redraw: true)
        canvas.setNeedsDisplay()
    }
    
    /** Handles when a touch is released. */
    func onRelease() {
        selectNode = nil
    }
    
}
