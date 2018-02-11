//
//  Canvas.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation


/** A component that the user can draw on. */
public class Canvas: UIView {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // -- PRIVATE VARS --
    
    /** The next node to be drawn on the screen, whether that be a curve, a line, or a shape. */
    var nextNode: Node?
    
    /** The image that the user is drawing on. */
    var drawingImage: UIImage!
    
    /** The touch points. */
    var currentPoint: CGPoint = CGPoint()
    var lastPoint: CGPoint = CGPoint()
    var lastLastPoint: CGPoint = CGPoint()
    
    /** The arrays of the nodes, the undos, and the redos. */
    var nodeArray: NSMutableArray!
    var undos: NSMutableArray!
    var redos: NSMutableArray!
    
    
    // -- PUBLIC VARS --
    
    /** The type of tool that is currently being used. */
    public var currentTool: CanvasTool!
    
    /** The brush to use when drawing. */
    public var currentBrush: Brush!
    
    /** The delegate. */
    public var delegate: CanvasDelegate?
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCanvas()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        setupCanvas()
    }
    
    
    /** Configure the Canvas. */
    private func setupCanvas() {
        nodeArray = NSMutableArray()
        undos = NSMutableArray()
        redos = NSMutableArray()
        
        backgroundColor = .clear
        drawingImage = UIImage()
        
        currentTool = .pen
        currentBrush = Brush.Default
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
    
    public override func draw(_ rect: CGRect) {
        self.drawingImage.draw(at: CGPoint.zero)
        self.nextNode?.draw()
    }
    
    
    
    
    
}

