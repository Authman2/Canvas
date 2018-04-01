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
    internal var currentDrawingTool: CanvasTool! {
        didSet {
            if currentDrawingTool != .selection {
                currentLayer?.selectNode = nil
            }
        }
    }
    
    /** The brush to use when drawing. */
    internal var currentDrawingBrush: Brush!
    
    /** The touch points. */
    internal var currentPoint: CGPoint = CGPoint()
    internal var lastPoint: CGPoint = CGPoint()
    internal var lastLastPoint: CGPoint = CGPoint()
    
    /** The different layers of the canvas. */
    internal var layers: [CanvasLayer]!
    internal var currentCanvasLayer: Int = 0
    
    /** Whether or not the canvas should create a default layer. */
    internal var createDefaultLayer: Bool = true
    
    /** The node that was last copied using the selection tool. */
    internal var copiedNode: Node?
    
    
    // -- PUBLIC VARS --
    
    /** The delegate. */
    public var delegate: CanvasDelegate?
    
    /** Whether or not the canvas should allow for multiple touches at a time. False by default. */
    public var allowsMultipleTouches: Bool!
    
    /** A condition that, when true, will preempt any drawing when a touch occurs on the canvas. */
    public var preemptTouch: (() -> Bool)?
    
    /** The undo/redo manager. */
    public var undoRedoManager: UndoRedoManger!
    
    
    
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
    
    /** Returns the selected node if there is one (assuming the current tool is the selection tool). */
    public var selectedNode: Node? {
        guard let layer = self.currentLayer else { return nil }
        if self.currentTool == .selection { return layer.selectNode }
        return nil
    }
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        currentDrawingTool = CanvasTool(rawValue: aDecoder.decodeInt32(forKey: "canvas_currentDrawingTool")) ?? .pen
        currentDrawingBrush = aDecoder.decodeObject(forKey: "canvas_currentDrawingBrush") as! Brush
        currentPoint = aDecoder.decodeCGPoint(forKey: "canvas_currentPoint")
        lastPoint = aDecoder.decodeCGPoint(forKey: "canvas_lastPoint")
        lastLastPoint = aDecoder.decodeCGPoint(forKey: "canvas_lastLastPoint")
        undoRedoManager = aDecoder.decodeObject(forKey: "canvas_undoRedoManager") as! UndoRedoManger
        layers = aDecoder.decodeObject(forKey: "canvas_layers") as! [CanvasLayer]
        currentCanvasLayer = aDecoder.decodeInteger(forKey: "canvas_currentCanvasLayer")
        createDefaultLayer = aDecoder.decodeBool(forKey: "canvas_createDefaultLayer")
        copiedNode = aDecoder.decodeObject(forKey: "canvas_copiedNode") as? Node
        allowsMultipleTouches = aDecoder.decodeBool(forKey: "canvas_allowsMultipleTouches")
        preemptTouch = aDecoder.decodeObject(forKey: "canvas_preempTouches") as? (() -> Bool)
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
        undoRedoManager = UndoRedoManger()
        
        allowsMultipleTouches = false
        preemptTouch = nil
        
        backgroundColor = .clear
        contentMode = UIViewContentMode.scaleAspectFit
        isMultipleTouchEnabled = allowsMultipleTouches == false ? true : false
        
        if createDefaultLayer == true { layers = [CanvasLayer(canvas: self)] }
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
    
    /** Allows the user to define custom behavior for undo and redo. For example, a custom function to undo changing the tool. */
    public func addCustomUndoRedo(cUndo: @escaping () -> Void, cRedo: @escaping () -> Void) {
        undoRedoManager.add(undo: cUndo, redo: cRedo)
    }
    
    
    /** Undo the last drawing stroke. */
    public func undo() {
        undoRedoManager.performUndo()
        
//        // If there is a separately defined undo function, run that instead.
//        if last.3 != nil {
//            last.3!.0()
//            return
//        }
//
//        // Remove that node from the layer that it is on.
//        if let idx = layers[last.1 ?? 0].nodeArray.index(where: { (found) -> Bool in return found.id == last.2 }) {
//            layers[last.1 ?? 0].nodeArray.remove(at: idx)
//        }
//
//        // Update.
//        layers[last.1 ?? 0].updateLayer(redraw: true)
//        setNeedsDisplay()
    }
    
    
    /** Redo the last drawing stroke. */
    public func redo() {
        undoRedoManager.performRedo()
        
//        // If there is a separately defined redo function, run that instead.
//        if last.3 != nil {
//            last.3!.1()
//            return
//        }
//
//        // Add the node back to the canvas on the layer it was on.
//        last.0?.id = last.2 ?? 0
//        layers[last.1 ?? 0].nodeArray.append(last.0!)
//
//        // Update.
//        layers[last.1 ?? 0].updateLayer(redraw: true)
//        setNeedsDisplay()
    }
    
    
    /** Clears the entire canvas. */
    public func clear() {
        for layer in layers {
            layer.clear()
            layer.updateLayer(redraw: true)
        }
        setNeedsDisplay()
    }
    
    
    /** Clears a drawing on the layer at the specified index. */
    public func clearLayer(at: Int) {
        if at < 0 || at >= layers.count { return }
        layers[at].clear()
        layers[at].updateLayer(redraw: true)
        setNeedsDisplay()
    }
    
    
    
    
    // -- IMPORT / EXPORT --
    
    /** Takes a UIImage as input and adds it to the canvas as a separate layer. Returns the newly added layer. */
    public func importImage(image: UIImage) -> CanvasLayer {
        // Adding the canvas as a parameter to this layer lets it know how to draw
        // the background image.
        let newLayer = CanvasLayer(canvas: self)
        newLayer.backgroundImage = image
        newLayer.allowsDrawing = false
        
        undoRedoManager.clearRedos()
        
        addDrawingLayer(newLayer: newLayer)
        for layer in layers { layer.updateLayer(redraw: true) }
        setNeedsDisplay()
        
        return newLayer
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
    
    
    
    // -- COPY / PASTE --
    
    /** Copies a node so that it can be pasted later on. */
    public func copy(node: Node) {
        self.copiedNode = node.copy() as? Node
        delegate?.didCopyNode(on: self, copiedNode: self.copiedNode)
    }
    
    
    /** Pastes the copied node onto the specified layer (the current layer by default). */
    public func paste(on: Int? = nil) {
        guard let copy = copiedNode else { return }
        let onLayer = on ?? currentLayerIndex
        if onLayer >= layers.count { return }
        if onLayer < 0 { return }

        layers[onLayer].drawFrom(nodes: [copy], appending: true)
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    public override func draw(_ rect: CGRect) {
        for layer in layers {
            if layer.isVisible == false { continue }
            else {
                layer.draw()
                layer.nextNode?.draw()
            }
        }
    }
    
    
    /************************
     *                      *
     *         OTHER        *
     *                      *
     ************************/
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(currentDrawingTool.rawValue, forKey: "canvas_currentDrawingTool")
        aCoder.encode(currentDrawingBrush, forKey: "canvas_currentDrawingBrush")
        aCoder.encode(currentPoint, forKey: "canvas_currentPoint")
        aCoder.encode(lastPoint, forKey: "canvas_lastPoint")
        aCoder.encode(lastLastPoint, forKey: "canvas_lastLastPoint")
        aCoder.encode(undoRedoManager, forKey: "canvas_undoRedoManager")
        aCoder.encode(layers, forKey: "canvas_layers")
        aCoder.encode(currentCanvasLayer, forKey: "canvas_currentCanvasLayer")
        aCoder.encode(createDefaultLayer, forKey: "canvas_createDefaultLayer")
        aCoder.encode(copiedNode, forKey: "canvas_copiedNode")
        aCoder.encode(allowsMultipleTouches, forKey: "canvas_allowsMultipleTouches")
        aCoder.encode(preemptTouch, forKey: "canvas_preempTouches")
    }
    
    
    
    
}

