//
//  Canvas.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

/** An area of the screen that allows drawing. */
public class Canvas: UIView {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // -- PRIVATE VARS
    
    /** The touch points. */
    internal var currentPoint: CGPoint = CGPoint()
    internal var lastPoint: CGPoint = CGPoint()
    internal var lastLastPoint: CGPoint = CGPoint()
    internal var eraserStartPoint: CGPoint = CGPoint()
    
    /** The next node to be drawn on the canvas. */
    internal var nextNode: Node? = nil
    
    /** A collection of the layers on this canvas. */
    internal var _canvasLayers: [CanvasLayer] = []
    internal var _currentCanvasLayer: Int = 0
    
    /** The current brush that is being used to style drawings. */
    internal var _currentBrush: Brush = Brush.Default
    
    /** The current tool that is being used to draw. */
    internal var _currentTool: CanvasTool = CanvasTool.pen
    
    /** The copied nodes. */
    internal var _copiedNodes: [Node] = []
    
    
    
    // -- PUBLIC VARS
    
    /** Events delegate. */
    public var delegate: CanvasEvents?
    
    /** The brush that is currently being used to style drawings. */
    public var currentBrush: Brush {
        set { _currentBrush = newValue }
        get { return _currentBrush }
    }
    
    /** The tool that is currently being used to draw on the canvas. */
    public var currentTool: CanvasTool {
        set { _currentTool = newValue }
        get { return _currentTool }
    }
    
    /** The action to use for the eyedropper: set stroke or fill color. */
    public var eyedropperOptions: EyedropperOptions = .stroke
    
    /** The undo redo manager. */
    public var undoRedoManager: UndoRedoManager = UndoRedoManager()
    
    
    
    
    // -- COMPUTED PROPS
    
    /** The layer that you are currently on. */
    public var currentCanvasLayer: Int {
        return self._currentCanvasLayer
    }
    
    /** The layer that you are currently on. */
    public var currentLayer: CanvasLayer? {
        if self._currentCanvasLayer < 0 || self._currentCanvasLayer >= self._canvasLayers.count {
            return nil
        } else {
            return self._canvasLayers[self._currentCanvasLayer]
        }
    }
    
    /** The layers of the canvas. */
    public var canvasLayers: [CanvasLayer] {
        return self._canvasLayers
    }
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public init(createDefaultLayer: Bool) {
        super.init(frame: CGRect.zero)
        setup(createDefaultLayer: createDefaultLayer)
    }
    
    private func setup(createDefaultLayer: Bool = false) {
        if createDefaultLayer == true {
            let defLay = CanvasLayer(type: LayerType.raster)
            self.addLayer(newLayer: defLay, position: .above)
        }
        backgroundColor = .clear
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    // -- UNDO / REDO / CLEAR --
    
    /** Allows the user to define custom behavior for undo and redo. For example, a custom function to undo changing the tool. */
    public func addCustomUndoRedo(cUndo: @escaping () -> Any?, cRedo: @escaping () -> Any?) {
        undoRedoManager.add(undo: cUndo, redo: cRedo)
    }
    
    
    /** Undo the last action on the canvas. */
    public func undo() {
        let _ = undoRedoManager.performUndo()
        setNeedsDisplay()
        self.delegate?.didUndo(on: self)
    }
    
    
    /** Redo the last action on the canvas. */
    public func redo() {
        let _ = undoRedoManager.performRedo()
        setNeedsDisplay()
        self.delegate?.didRedo(on: self)
    }
    
    
    /** Clears the entire canvas. */
    public func clear() {
        for i in 0..<_canvasLayers.count { clearLayer(at: i) }
        setNeedsDisplay()
    }
    
    
    /** Clears a drawing on the layer at the specified index. */
    public func clearLayer(at: Int) {
        if at < 0 || at >= _canvasLayers.count { return }
        _canvasLayers[at].clear(from: self)
        undoRedoManager.clearRedos()
        setNeedsDisplay()
    }
    
    
    
    // -- IMPORT / EXPORT --
    
    /** Exports the canvas drawing. */
    public func export() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.layer.render(in: ctx)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
    
    
    /** Exports the drawing on a specific layer. */
    public func exportLayer(at: Int) -> UIImage {
        if at < 0 || at >= _canvasLayers.count { return UIImage() }
        if _canvasLayers[at].drawings.isEmpty { return UIImage() }
        UIGraphicsBeginImageContext(self.frame.size)
        
        for node in _canvasLayers[at].drawings {
            let path = build(from: node.points, using: node.instructions, tool: node.type)
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = path.boundingBox
            shapeLayer.path = path
            shapeLayer.strokeColor = node.brush.strokeColor.cgColor
            shapeLayer.fillRule = kCAFillRuleEvenOdd
            shapeLayer.fillMode = kCAFillModeBoth
            shapeLayer.fillColor = node.brush.fillColor?.cgColor ?? nil
            shapeLayer.opacity = Float(node.brush.opacity)
            shapeLayer.lineWidth = node.brush.thickness
            shapeLayer.miterLimit = node.brush.miter
            switch node.brush.shape {
            case .butt:
                shapeLayer.lineCap = kCALineCapButt
                break
            case .round:
                shapeLayer.lineCap = kCALineCapRound
                break
            case .square:
                shapeLayer.lineCap = kCALineCapSquare
                break
            }
            switch node.brush.joinStyle {
            case .bevel:
                shapeLayer.lineJoin = kCALineJoinBevel
                break
            case .miter:
                shapeLayer.lineJoin = kCALineJoinMiter
                break
            case .round:
                shapeLayer.lineJoin = kCALineJoinRound
                break
            }
            
            var nPos = path.boundingBox.origin
            nPos.x += path.boundingBox.width / 2
            nPos.y += path.boundingBox.height / 2
            shapeLayer.position = nPos
            
            shapeLayer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
    
    
    /** Exports the given nodes to a UIImage. */
    public static func export(nodes: [Node], size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)

        for node in nodes {
            let path = build(from: node.points, using: node.instructions, tool: node.type)
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = path.boundingBox
            shapeLayer.path = path
            shapeLayer.strokeColor = node.brush.strokeColor.cgColor
            shapeLayer.fillRule = kCAFillRuleEvenOdd
            shapeLayer.fillMode = kCAFillModeBoth
            shapeLayer.fillColor = node.brush.fillColor?.cgColor ?? nil
            shapeLayer.opacity = Float(node.brush.opacity)
            shapeLayer.lineWidth = node.brush.thickness
            shapeLayer.miterLimit = node.brush.miter
            switch node.brush.shape {
            case .butt:
                shapeLayer.lineCap = kCALineCapButt
                break
            case .round:
                shapeLayer.lineCap = kCALineCapRound
                break
            case .square:
                shapeLayer.lineCap = kCALineCapSquare
                break
            }
            switch node.brush.joinStyle {
            case .bevel:
                shapeLayer.lineJoin = kCALineJoinBevel
                break
            case .miter:
                shapeLayer.lineJoin = kCALineJoinMiter
                break
            case .round:
                shapeLayer.lineJoin = kCALineJoinRound
                break
            }
            
            var nPos = path.boundingBox.origin
            nPos.x += path.boundingBox.width / 2
            nPos.y += path.boundingBox.height / 2
            shapeLayer.position = nPos
            
            shapeLayer.render(in: UIGraphicsGetCurrentContext()!)
        }

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img ?? UIImage()
    }
    
    
    
    // -- COPY / PASTE --
    
    /** Copies a particular node so that it can be pasted later. */
    public func copy(nodes: [Node]) {
        _copiedNodes = nodes
        self.delegate?.didCopyNodes(on: self, nodes: nodes)
    }
    
    
    /** Pastes the copied node on to the current layer. */
    public func paste() {
        guard let cl = currentLayer else { return }
        cl.drawings.append(contentsOf: _copiedNodes)
        setNeedsDisplay()
        
        undoRedoManager.add(undo: {
            cl.drawings.removeLast()
            return nil
        }, redo: {
            cl.drawings.append(contentsOf: self._copiedNodes)
            return nil
        })
        
        self.delegate?.didPasteNodes(on: self, on: cl, nodes: _copiedNodes)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    public override func draw(_ rect: CGRect) {
        // 1.) Clear all sublayers.
        layer.sublayers = []
        
        // 2.) Go through each layer and render it using either raster or vector graphics.
        for i in (0..<self._canvasLayers.count).reversed() {
            let layer = self._canvasLayers[i]
            if layer.isVisible == false { continue }
            
            if layer.type == .raster {
                drawRaster(layer: layer, rect)
            } else {
                drawVector(layer: layer, rect)
            }
        }
        
        // 3.) Draw the temporary drawing.
        guard let next = nextNode else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let path = build(from: next.points, using: next.instructions, tool: next.type)
        context.addPath(path)
        context.setLineCap(self._currentBrush.shape)
        context.setLineJoin(self._currentBrush.joinStyle)
        context.setLineWidth(self._currentBrush.thickness)
        context.setStrokeColor(self.currentBrush.strokeColor.cgColor)
        context.setMiterLimit(self._currentBrush.miter)
        context.setAlpha(self._currentBrush.opacity)
        context.setBlendMode(.normal)
        context.strokePath()
    }
    
    private func drawRaster(layer: CanvasLayer, _ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Create a CGContext to draw all of the lines on that layer.
        for node in layer.drawings {
            // Draw using the context.
            let path = build(from: node.points, using: node.instructions, tool: node.type)
            
            context.addPath(path)
            context.setLineCap(node.brush.shape)
            context.setLineJoin(node.brush.joinStyle)
            context.setLineWidth(node.brush.thickness)
            context.setMiterLimit(node.brush.miter)
            context.setAlpha(node.brush.opacity)
            context.setBlendMode(.normal)
            
            context.setFillColor(node.brush.fillColor?.cgColor ?? UIColor.clear.cgColor)
            context.setStrokeColor(node.brush.strokeColor.cgColor)
            context.drawPath(using: CGPathDrawingMode.eoFillStroke)
            
//            context.stroke(path.boundingBox)
        }
    }
    
    private func drawVector(layer: CanvasLayer, _ rect: CGRect) {
        for node in layer.drawings {
            let path = build(from: node.points, using: node.instructions, tool: node.type)
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = path.boundingBox
            shapeLayer.path = path
//            shapeLayer.backgroundColor = UIColor.orange.cgColor
            shapeLayer.strokeColor = node.brush.strokeColor.cgColor
            shapeLayer.fillRule = kCAFillRuleEvenOdd
            shapeLayer.fillMode = kCAFillModeBoth
            shapeLayer.fillColor = node.brush.fillColor?.cgColor ?? nil
            shapeLayer.opacity = Float(node.brush.opacity)
            shapeLayer.lineWidth = node.brush.thickness
            shapeLayer.miterLimit = node.brush.miter
            switch node.brush.shape {
            case .butt:
                shapeLayer.lineCap = kCALineCapButt
                break
            case .round:
                shapeLayer.lineCap = kCALineCapRound
                break
            case .square:
                shapeLayer.lineCap = kCALineCapSquare
                break
            }
            switch node.brush.joinStyle {
            case .bevel:
                shapeLayer.lineJoin = kCALineJoinBevel
                break
            case .miter:
                shapeLayer.lineJoin = kCALineJoinMiter
                break
            case .round:
                shapeLayer.lineJoin = kCALineJoinRound
                break
            }
            
            var nPos = path.boundingBox.origin
            nPos.x += path.boundingBox.width / 2
            nPos.y += path.boundingBox.height / 2
            shapeLayer.position = nPos
            
            self.layer.addSublayer(shapeLayer)
        }
    }
    
}
