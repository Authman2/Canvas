//
//  Canvas.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation
// 1.) Remove eraser tool, and replace it with scissor tool
// 2.)

/** The position to add a new layer on: above or below. */
public enum LayerPosition {
    case above
    case below
}

/** A component that the user can draw on. */
public class Canvas: UIView, Codable {
    
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
                currentLayer?.selectedNodes = []
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
    
    /** The next node to draw. */
    internal var nextNode: Node?
    
    /** The last copied node. */
    internal var copiedNode: Node?
    
    
    
    // -- PUBLIC VARS --
    
    /** The delegate. */
    public var delegate: CanvasDelegate?
    
    /** Whether or not the canvas should allow for multiple touches at a time. False by default. */
    public var allowsMultipleTouches: Bool!
    
    /** A condition that, when true, will preempt any drawing when a touch occurs on the canvas. */
    public var preemptTouch: Bool!
    
    /** The undo/redo manager. */
    public var undoRedoManager: UndoRedoManager!
    
    
    
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
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        currentDrawingBrush = aDecoder.decodeObject(forKey: "canvas_currentDrawingBrush") as! Brush
        currentPoint = aDecoder.decodeCGPoint(forKey: "canvas_currentPoint")
        lastPoint = aDecoder.decodeCGPoint(forKey: "canvas_lastPoint")
        lastLastPoint = aDecoder.decodeCGPoint(forKey: "canvas_lastLastPoint")
        undoRedoManager = aDecoder.decodeObject(forKey: "canvas_undoRedoManager") as! UndoRedoManager
        layers = aDecoder.decodeObject(forKey: "canvas_layers") as! [CanvasLayer]
        currentCanvasLayer = aDecoder.decodeInteger(forKey: "canvas_currentCanvasLayer")
        createDefaultLayer = aDecoder.decodeBool(forKey: "canvas_createDefaultLayer")
        allowsMultipleTouches = aDecoder.decodeBool(forKey: "canvas_allowsMultipleTouches")
        preemptTouch = aDecoder.decodeObject(forKey: "canvas_preempTouches") as? Bool ?? false
    }
    
    public required init(from decoder: Decoder) throws {
        super.init(frame: CGRect.zero)
        let container = try decoder.container(keyedBy: CanvasCodingKeys.self)
        currentDrawingBrush = try container.decode(Brush.self, forKey: CanvasCodingKeys.canvasDrawingBrush)
        currentDrawingBrush = Brush.Default
        currentPoint = try container.decode(CGPoint.self, forKey: CanvasCodingKeys.canvasCurrentPoint)
        lastPoint = try container.decode(CGPoint.self, forKey: CanvasCodingKeys.canvasLastPoint)
        lastLastPoint = try container.decode(CGPoint.self, forKey: CanvasCodingKeys.canvasLastLastPoint)
        currentCanvasLayer = try container.decode(Int.self, forKey: CanvasCodingKeys.canvasCurrentLayer)
        createDefaultLayer = try container.decode(Bool.self, forKey: CanvasCodingKeys.canvasCreateDefaultLayer)
        allowsMultipleTouches = try container.decode(Bool.self, forKey: CanvasCodingKeys.canvasAllowsMultipleTouches)
        preemptTouch = try container.decode(Bool.self, forKey: CanvasCodingKeys.canvasPreemptTouches)
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
        undoRedoManager = UndoRedoManager()
        
        allowsMultipleTouches = false
        preemptTouch = false
        
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
    public func addCustomUndoRedo(cUndo: @escaping () -> Any?, cRedo: @escaping () -> Any?) {
        undoRedoManager.add(undo: cUndo, redo: cRedo)
    }
    
    
    /** Undo the last drawing stroke. */
    public func undo() {
        let undid = undoRedoManager.performUndo()
        
        // Handle standard undo.
        if undid is ([Node], Int) {
            if let (nodes, index) = undid as? ([Node], Int) {
                self.layers[index].drawingArray = nodes
                self.setNeedsDisplay()
            }
        }
        
        delegate?.didUndo(on: self)
    }
    
    
    /** Redo the last drawing stroke. */
    public func redo() {
        let redid = undoRedoManager.performRedo()
        
        // Handle standard redo.
        if redid is ([Node], Int) {
            if let (nodes, index) = redid as? ([Node], Int) {
                self.layers[index].drawingArray = nodes
                self.setNeedsDisplay()
            }
        }
        
        delegate?.didRedo(on: self)
    }
    
    
    /** Clears the entire canvas. */
    public func clear() {
        for i in 0..<layers.count { clearLayer(at: i) }
        setNeedsDisplay()
    }
    
    
    /** Clears a drawing on the layer at the specified index. */
    public func clearLayer(at: Int) {
        if at < 0 || at >= layers.count { return }
        layers[at].clear()
        undoRedoManager.clearRedos()
        setNeedsDisplay()
    }
    
    
    
    
    // -- IMPORT / EXPORT --
    
    /** Import an image onto the canvas. */
    public func importImage(image: UIImage) {
        guard let cL = currentLayer else { return }
        cL.importedImage = image
        setNeedsDisplay()
        
        undoRedoManager.add(undo: {
            cL.importedImage = nil
            self.setNeedsDisplay()
            return nil
        }, redo: {
            cL.importedImage = image
            self.setNeedsDisplay()
            return nil
        })
    }
    
    
    /** Imports a drawing from an SVG string. */
    // todo
    func importSVG(svgString: String) {
        // 1.) Convert SVG to CMutableGPath
        // 2.) Create new node with that path.
        // 3.) Go to the current layer and add that node.
    }
    
    
    /** Exports the canvas drawing. */
    public func export(exported: (_ img: UIImage) -> Void) {
        UIGraphicsBeginImageContext(frame.size)
        if let ctx = UIGraphicsGetCurrentContext() {
            layer.render(in: ctx)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            exported(img ?? UIImage())
        } else {
            exported(UIImage())
        }
        UIGraphicsEndImageContext()
    }
    
    
    /** Exports the drawing on a specific layer. */
    public func exportLayer(at: Int, exported: (_ img: UIImage) -> Void) {
        if at < 0 || at >= layers.count { exported(UIImage()); return }
        if layers[at].drawingArray.isEmpty { exported(UIImage()); return }
        
        UIGraphicsBeginImageContext(frame.size)

        for node in layers[at].drawingArray {
            node.shapeLayer.render(in: UIGraphicsGetCurrentContext()!)
        }

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        exported(img ?? UIImage())
    }
    
    
    /** Exports the given nodes to a UIImage. */
    public func export(nodes: [Node], exported: (_ img: UIImage) -> Void) {
        UIGraphicsBeginImageContext(frame.size)
        
        for node in nodes {
            node.shapeLayer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        exported(img ?? UIImage())
    }
    
    

    
    
    // -- COPY / PASTE --
    
    /** Copies a particular node so that it can be pasted later. */
    public func copy(node: Node) {
        copiedNode = node
        delegate?.didCopyNode(on: self, copiedNode: node)
    }
    
    
    /** Pastes the copied node on to the current layer. */
    public func paste() {
        guard let cl = currentLayer else { return }
        guard let cp = copiedNode else { return }
        cl.drawingArray.append(cp)
        setNeedsDisplay()
        
        undoRedoManager.add(undo: {
            cl.drawingArray.removeLast()
            return nil
        }, redo: {
            cl.drawingArray.append(cp)
            return nil
        })
        
        delegate?.didPasteNode(on: self, pastedNode: cp)
    }
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    public override func draw(_ rect: CGRect) {
        layer.sublayers = []
        for i in (0..<layers.count).reversed() {
            let layer = layers[i]
            if layer.isVisible == false { continue }
            else {
                // Draw the imported image.
                if layer.importedImage != nil {
                    layer.importedImage!.draw(in: frame)
                }
                
                // Draw the nodes.
                for n in layer.drawingArray { self.layer.addSublayer(n.shapeLayer) }
                
                // Draw the temporary stroke before it converts to svg.
                switch currentDrawingTool {
                case .selection:
                    if layer.isDragging == false {
                        drawTemporarySelection()
                    }
                    break
                case .pen:
                    drawTemporaryPen()
                    break
                case .eraser:
                    drawTemporaryEraser()
                    break
                case .line:
                    drawTemporaryLine()
                    break
                case .rectangle:
                    drawTemporaryRectangle()
                    break
                case .ellipse:
                    drawTemporaryEllipse()
                    break
                default:
                    break
                }
            }
        }
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *         OTHER        *
     *                      *
     ************************/
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(currentDrawingBrush, forKey: "canvas_currentDrawingBrush")
        aCoder.encode(currentPoint, forKey: "canvas_currentPoint")
        aCoder.encode(lastPoint, forKey: "canvas_lastPoint")
        aCoder.encode(lastLastPoint, forKey: "canvas_lastLastPoint")
        aCoder.encode(undoRedoManager, forKey: "canvas_undoRedoManager")
        aCoder.encode(layers, forKey: "canvas_layers")
        aCoder.encode(currentCanvasLayer, forKey: "canvas_currentCanvasLayer")
        aCoder.encode(createDefaultLayer, forKey: "canvas_createDefaultLayer")
        aCoder.encode(allowsMultipleTouches, forKey: "canvas_allowsMultipleTouches")
        aCoder.encode(preemptTouch, forKey: "canvas_preempTouches")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CanvasCodingKeys.self)
        try container.encode(currentDrawingBrush, forKey: .canvasDrawingBrush)
        try container.encode(currentPoint, forKey: CanvasCodingKeys.canvasCurrentPoint)
        try container.encode(lastPoint, forKey: CanvasCodingKeys.canvasLastPoint)
        try container.encode(lastLastPoint, forKey: CanvasCodingKeys.canvasLastLastPoint)
//        try container.encode(undoRedoManager, forKey: CanvasCodingKeys.canvasUndoRedoManager)
        try container.encode(currentCanvasLayer, forKey: CanvasCodingKeys.canvasCurrentLayer)
        try container.encode(createDefaultLayer, forKey: CanvasCodingKeys.canvasCreateDefaultLayer)
        try container.encode(allowsMultipleTouches, forKey: CanvasCodingKeys.canvasAllowsMultipleTouches)
        try container.encode(preemptTouch, forKey: CanvasCodingKeys.canvasPreemptTouches)
    }
    
}

