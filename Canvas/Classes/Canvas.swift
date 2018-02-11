//
//  Canvas.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation


/** The position to add a new layer on: above or below. */
public enum LayerPosition {
    case above
    case below
}


/** A component that the user can draw on. */
public class Canvas: UIView {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // -- PRIVATE VARS --
    
    /** The type of tool that is currently being used. */
    internal var currentTool: CanvasTool!
    
    /** The touch points. */
    internal var currentPoint: CGPoint = CGPoint()
    internal var lastPoint: CGPoint = CGPoint()
    internal var lastLastPoint: CGPoint = CGPoint()
    
    /** The arrays of the nodes, the undos, and the redos. */
    internal var undos: NSMutableArray!
    internal var redos: NSMutableArray!
    
    /** The different layers of the canvas. */
    internal var layers: [CanvasLayer]!
    internal var currentCanvasLayer: Int = 0
    
    /** Whether or not the canvas should create a default layer. */
    internal var createDefaultLayer: Bool = true
    
    
    
    // -- PUBLIC VARS --
    
    /** The brush to use when drawing. */
    public var currentBrush: Brush!
    
    /** The delegate. */
    public var delegate: CanvasDelegate?
    
    
    
    // -- PUBLIC COMPUTED PROPERTIES --
    
    /** Returns all of layers on the canvas. */
    public var canvasLayers: [CanvasLayer] { return self.layers }
    
    /** Returns the current canvas layer as an object. */
    public var currentLayer: CanvasLayer? {
        if layers.count == 0 { return nil }
        if currentCanvasLayer >= layers.count { return nil }
        return layers[currentCanvasLayer]
    }
    
    /** Returns the index of the current layer, or -1 if there are no layers. */
    public var currentLayerIndex: Int {
        if layers.count == 0 { return -1 }
        return currentCanvasLayer
    }
    
    
    
    
    
    
    
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
    
    public init(createDefaultLayer b: Bool) {
        super.init(frame: CGRect.zero)
        self.createDefaultLayer = b
        setupCanvas()
    }
    
    
    /** Configure the Canvas. */
    private func setupCanvas() {
        undos = NSMutableArray()
        redos = NSMutableArray()
        
        backgroundColor = .clear
        
        if createDefaultLayer == true { layers = [CanvasLayer()] }
        else { layers = [] }
        
        currentTool = .pen
        currentBrush = Brush.Default
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Sets the tool that the canvas should use to draw. */
    public func setTool(tool: CanvasTool) {
        self.currentTool = tool
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    public override func draw(_ rect: CGRect) {
        for layer in layers {
            layer.draw()
            layer.nextNode?.draw()
        }
    }
    
    
    
    
    
}

