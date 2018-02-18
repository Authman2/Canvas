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

/** The file format of the exported image. */
public enum CanvasExportType {
    case png
    case jpeg
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
    internal var currentDrawingTool: CanvasTool!
    
    /** The brush to use when drawing. */
    internal var currentDrawingBrush: Brush!
    
    /** The touch points. */
    internal var currentPoint: CGPoint = CGPoint()
    internal var lastPoint: CGPoint = CGPoint()
    internal var lastLastPoint: CGPoint = CGPoint()
    
    /** The arrays of the undos and the redos. */
    internal var undos: [(Node, Int, Int)]!
    internal var redos: [(Node, Int, Int)]!
    
    /** The different layers of the canvas. */
    internal var layers: [CanvasLayer]!
    internal var currentCanvasLayer: Int = 0
    
    /** Whether or not the canvas should create a default layer. */
    internal var createDefaultLayer: Bool = true
    
    
    
    // -- PUBLIC VARS --
    
    /** The delegate. */
    public var delegate: CanvasDelegate?
    
    /** Whether or not the canvas should allow for multiple touches at a time. False by default. */
    public var allowsMultipleTouches: Bool!
    
    
    // -- PUBLIC COMPUTED PROPERTIES --
    
    /** The brush that the canvas is currently using. */
    public var currentBrush: Brush { return self.currentDrawingBrush }
    
    
    /** The tool that the canvas is currently using to draw. */
    public var currentTool: CanvasTool { return self.currentDrawingTool }
    
    
    /** Returns all of the layers on the canvas. */
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
    
    /** The total number of nodes on the canvas (all layers). */
    public var totalNodeCount: Int {
        var i = 0
        for layer in layers { i += layer.nodeCount }
        return i
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
        undos = []
        redos = []
        
        allowsMultipleTouches = false
        
        backgroundColor = .clear
        contentMode = UIViewContentMode.scaleAspectFit
        isMultipleTouchEnabled = allowsMultipleTouches == false ? true : false
        
        if createDefaultLayer == true { layers = [CanvasLayer()] }
        else { layers = [] }
        
        currentDrawingTool = .pen
        currentDrawingBrush = Brush.Default
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    // -- TOOLS AND BRUSHES --
    
    /** Sets the tool that the canvas should use to draw. */
    public func setTool(tool: CanvasTool) {
        self.currentDrawingTool = tool
    }
    
    
    /** Changes the brush that the canvas is currently using to style drawings. */
    public func setBrush(brush: Brush) {
        self.currentDrawingBrush = brush
    }
    
    
    
    // -- UNDO / REDO / CLEAR --
    
    /** Undo the last drawing stroke. */
    public func undo() {
        // Pop the last item off the undo stack.
        guard let last = undos.popLast() else { return }

        // Add to the redos.
        redos.append(last)
        
        // Remove that node from the layer that it is on.
        if let idx = layers[last.1].nodeArray.index(where: { (found) -> Bool in return found.id == last.2 }) {
            layers[last.1].nodeArray.remove(at: idx)
        }
        
        // Update.
        updateDrawing(redraw: true)
        setNeedsDisplay()
    }
    
    
    /** Redo the last drawing stroke. */
    public func redo() {
        // Pop the last item off the redo stack.
        guard let last = redos.popLast() else { return }
        
        // Add to the undos.
        undos.append(last)
        
        // Add the node back to the canvas on the layer it was on.
        last.0.id = last.2
        layers[last.1].nodeArray.append(last.0)
        
        // Update.
        updateDrawing(redraw: true)
        setNeedsDisplay()
    }
    
    
    /** Clears the entire canvas. */
    public func clear() {
        for layer in layers { layer.clear() }
        updateDrawing(redraw: true)
        setNeedsDisplay()
    }
    
    
    /** Clears a drawing on the layer at the specified index. */
    public func clearLayer(at: Int) {
        if at < 0 || at >= layers.count { return }
        layers[at].clear()
        updateDrawing(redraw: true)
        setNeedsDisplay()
    }
    
    
    
    
    
    // -- IMPORT / EXPORT --
    
    /** Takes a UIImage as input and adds it to the canvas as a separate layer. */
    public func importImage(image: UIImage) {
        // Adding the canvas as a parameter to this layer lets it know how to draw
        // the background image.
        let newLayer = CanvasLayer(canvas: self)
        newLayer.backgroundImage = image
        newLayer.allowsDrawing = false
        
        addDrawingLayer(newLayer: newLayer)
        updateDrawing(redraw: false)
        setNeedsDisplay()
    }
    
    
    /** Exports the image from the entire canvas to a UIImage. The output image will look as the canvas does
     at the time of export.*/
    public func export() -> UIImage {
        // Merge the images on each layer.
        var merged = UIImage()
        for i in 0..<layers.count { merged = merged + exportLayer(at: i) }
        return merged
    }
    
    
    /** Exports only the layer at the specified index. */
    public func exportLayer(at: Int) -> UIImage {
        let merged = layers[at].mergedWithBackground()
        return merged
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

