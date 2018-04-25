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
        undoRedoManager = aDecoder.decodeObject(forKey: "canvas_undoRedoManager") as! UndoRedoManager
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
        undoRedoManager = UndoRedoManager()
        
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
    public func addCustomUndoRedo(cUndo: @escaping () -> Any?, cRedo: @escaping () -> Any?) {
        undoRedoManager.add(undo: cUndo, redo: cRedo)
    }
    
    
    /** Undo the last drawing stroke. */
    public func undo() {
        let undid = undoRedoManager.performUndo()
        
        // Handle standard undo.
        if undid is ([Node], Int) {
            if let (nodes, index) = undid as? ([Node], Int) {
                self.layers[index].nodeArray = nodes
                self.layers[index].updateLayer(redraw: true)
                self.setNeedsDisplay()
            }
        }
        // Handle paint undo.
        else if undid is (Node, UIColor?, Int, Int) {
            if let (node, color, type, layerIndex) = undid as? (Node, UIColor?, Int, Int) {
                switch type {
                // Brush
                case 0:
                    node.brush.color = color!
                    break
                // Fill
                case 1:
                    if node is RectangleNode { (node as! RectangleNode).fillColor = color }
                    else if node is EllipseNode { (node as! EllipseNode).fillColor = color }
                    break
                default:
                    break
                }
                
                // Update drawing
                self.layers[layerIndex].updateLayer(redraw: true)
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
                self.layers[index].nodeArray = nodes
                self.layers[index].updateLayer(redraw: true)
                self.setNeedsDisplay()
            }
        }
        // Handle paint undo.
        else if redid is (Node, UIColor?, Int, Int) {
            if let (node, color, type, layerIndex) = redid as? (Node, UIColor?, Int, Int) {
                switch type {
                // Brush
                case 0:
                    node.brush.color = color!
                    break
                // Fill
                case 1:
                    if node is RectangleNode { (node as! RectangleNode).fillColor = color }
                    else if node is EllipseNode { (node as! EllipseNode).fillColor = color }
                    break
                default:
                    break
                }
                
                // Update drawing
                self.layers[layerIndex].updateLayer(redraw: true)
                self.setNeedsDisplay()
            }
        }
        
        delegate?.didRedo(on: self)
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
    
    
    
    // -- COPY / PASTE / DELETE --
    
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
        delegate?.didPasteNode(on: self, pastedNode: copy)
    }
    
    
    /** Removes the selected node from the layer it is on. */
    public func delete() {
        guard let sel = selectedNode else { return }
        guard let curLayer = currentLayer else { return }
        
        if let idx = curLayer.nodeArray.index(of: sel) {
            curLayer.nodeArray.remove(at: idx)
            curLayer.updateLayer(redraw: false)
            self.setNeedsDisplay()
        }
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
    
    
    /** Handles grabbing a color from an area on the canvas. */
    func handleEyedrop(point: CGPoint) {
        // Only track the eyedropper on the canvas.
        if hitTest(point, with: nil) != self { return }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmap = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixels: [UInt8] = [0,0,0,0]
        
        if let context = CGContext(data: &pixels, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmap.rawValue) {
        
            context.translateBy(x: -point.x, y: -point.y)
            self.layer.render(in: context)
        
            let r = CGFloat(pixels[0])/CGFloat(255)
            let g = CGFloat(pixels[1])/CGFloat(255)
            let b = CGFloat(pixels[2])/CGFloat(255)
            let a = CGFloat(pixels[3])/CGFloat(255)
            
            let color = UIColor(red: r, green: g, blue: b, alpha: a)
            let nBrush = self.currentBrush.mutableCopy() as! Brush
            nBrush.color = color
            self.setBrush(brush: nBrush)
            self.delegate?.didSampleColor(on: self, color: color)
        }
    }
    
    
    /** Handles painting on the canvas with the paint bucket tool. */
    func handlePaintBucket(point: CGPoint) {
        // Only paint on the current layer.
        guard let cLayer = currentLayer else { return }
        
        // First, check if you click directly on a node. If so, just fill its color.
        for node in cLayer.nodeArray {
            if node.contains(point: point) {
                // Handle painting inside of a rectangle or ellipse.
                if node is RectangleNode {
                    paintRect(node: node as! RectangleNode, point: point, cLayer: cLayer)
                    return
                }
                else if node is EllipseNode {
                    paintEllipse(node: node as! EllipseNode, point: point, cLayer: cLayer)
                    return
                }
                
                // Change the brush used on the node.
                let lastColor = node.brush.color
                let newColor = currentBrush.color
                let cpy = node.brush.mutableCopy() as! Brush
                cpy.color = currentBrush.color
                
                node.brush = cpy
                cLayer.updateLayer(redraw: true)
                setNeedsDisplay()
                
                // Undo/Redo
                // Undoing a paint action means finding the node that was just painted and setting its brush color
                // or fill color back to what it was previously. You must save (painted node, previous color, new color, brush or fill)
                undoRedoManager.add(undo: {
                    return (node, lastColor, 0, self.currentCanvasLayer)
                }, redo: {
                    return (node, newColor, 0, self.currentCanvasLayer)
                })
                undoRedoManager.clearRedos()
                
                delegate?.didPaintNode(on: self, paintedNode: node)
                
                return
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
    
    
    /** Helper method for painting a rectangle. */
    private func paintRect(node: RectangleNode, point: CGPoint, cLayer: CanvasLayer) {
        // If the point is contained, that means update the fill color.
        if node.containsInner(point: point) {
            
            // Change the node's fill color.
            let lastColor = node.fillColor
            let newColor = currentBrush.color
            node.fillColor = currentBrush.color
            cLayer.updateLayer(redraw: true)
            setNeedsDisplay()
            
            // Undo/Redo
            undoRedoManager.add(undo: {
                return (node, lastColor, 1, self.currentCanvasLayer)
            }, redo: {
                return (node, newColor, 1, self.currentCanvasLayer)
            })
            undoRedoManager.clearRedos()
        }
            
        // Otherwise, update just the stroke color.
        else {
            // Change the brush used on the node.
            let lastColor = node.brush.color
            let newColor = currentBrush.color
            let cpy = node.brush.mutableCopy() as! Brush
            cpy.color = currentBrush.color
            
            node.brush = cpy
            cLayer.updateLayer(redraw: true)
            setNeedsDisplay()
            
            // Undo/Redo
            undoRedoManager.add(undo: {
                return (node, lastColor, 0, self.currentCanvasLayer)
            }, redo: {
                return (node, newColor, 0, self.currentCanvasLayer)
            })
            undoRedoManager.clearRedos()
        }
        delegate?.didPaintNode(on: self, paintedNode: node)
    }
    
    /** Helper method for painting an ellipse. */
    private func paintEllipse(node: EllipseNode, point: CGPoint, cLayer: CanvasLayer) {
        // If the point is contained, that means update the fill color.
        if node.containsInner(point: point) {
            
            // Change the node's fill color.
            let lastColor = node.fillColor
            let newColor = currentBrush.color
            node.fillColor = currentBrush.color
            cLayer.updateLayer(redraw: true)
            setNeedsDisplay()
            
            // Undo/Redo
            undoRedoManager.add(undo: {
                return (node, lastColor, 1, self.currentCanvasLayer)
            }, redo: {
                return (node, newColor, 1, self.currentCanvasLayer)
            })
            undoRedoManager.clearRedos()
        }
        // Otherwise, update just the stroke color.
        else {
            // Change the brush used on the node.
            let lastColor = node.brush.color
            let newColor = currentBrush.color
            let cpy = node.brush.mutableCopy() as! Brush
            cpy.color = currentBrush.color
            
            node.brush = cpy
            cLayer.updateLayer(redraw: true)
            setNeedsDisplay()
            
            // Undo/Redo
            undoRedoManager.add(undo: {
                return (node, lastColor, 0, self.currentCanvasLayer)
            }, redo: {
                return (node, newColor, 0, self.currentCanvasLayer)
            })
            undoRedoManager.clearRedos()
        }
        delegate?.didPaintNode(on: self, paintedNode: node)
    }
    
    
    
}

