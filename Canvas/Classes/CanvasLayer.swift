//
//  CanvasLayer.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation

/** A single layer that can be drawn on. The Canvas can have multiple layers which can be rearranged to have different drawings appear on top of or below others. */
public class CanvasLayer: Codable {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // -- PRIVATE VARS --
    
    /** The canvas that this layer is on. */
    internal var canvas: Canvas!
    
    /** All of the nodes on this layer. */
    internal var drawingArray: [Node]!
    
    /** An image that gets imported onto this layer. */
    internal var importedImage: UIImage?
    
    /** The nodes that have been selected. */
    internal var selectedNodes: [Node]!
    
    /** Whether or not the selected nodes are being dragged. */
    internal var isDragging: Bool!
    
    /** The transform box that contains all of the selected nodes' bounds. */
    internal var transformBox: CGRect!
    
    
    
    // -- PUBLIC VARS --
    
    /** Whether or not this layer is visible. True by default. */
    public var isVisible: Bool
    
    /** Whether or not this layer allows drawing. True by default. */
    public var allowsDrawing: Bool
    
    /** The opacity of everything on this layer. */
    public var opacity: CGFloat {
        didSet {
            for node in drawingArray { node.shapeLayer.opacity = Float(opacity) }
            importedImage = importedImage?.withOpacity(opacity)
        }
    }
    
    /** The color that all nodes should be set to and the imported image should be tinted to. */
    public var tintColor: UIColor? {
        didSet {
            if let tintColor = tintColor {
                for node in drawingArray {
                    if let _ = node.shapeLayer.strokeColor { node.shapeLayer.strokeColor = tintColor.cgColor }
                    if let _ = node.shapeLayer.fillColor { node.shapeLayer.fillColor = tintColor.cgColor }
                }
                importedImage = importedImage?.withTint(color: tintColor)
            }
        }
    }
    
    /** A name for this layer (optional). */
    public var name: String?
    
    
    
    // -- PUBLIC COMPUTED PROPERTIES --
    
    /** Returns the nodes on this layer. */
    public var nodes: [Node] { return drawingArray }
    
    /** Returns the imported image on this layer or nil. */
    public var image: UIImage? { return importedImage }
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CanvasLayerCodingKeys.self)
        drawingArray = try container.decodeIfPresent([Node].self, forKey: CanvasLayerCodingKeys.canvasLayerNodeArray) ?? []
        canvas = try container.decodeIfPresent(Canvas.self, forKey: CanvasLayerCodingKeys.canvasLayerCanvas) ?? Canvas(createDefaultLayer: true)
        isVisible = try container.decodeIfPresent(Bool.self, forKey: CanvasLayerCodingKeys.canvasLayerIsVisible) ?? true
        allowsDrawing = try container.decodeIfPresent(Bool.self, forKey: CanvasLayerCodingKeys.canvasLayerAllowsDrawing) ?? true
        name = try container.decodeIfPresent(String?.self, forKey: CanvasLayerCodingKeys.canvasLayerName) ?? nil
        selectedNodes = []
        isDragging = false
        transformBox = try container.decodeIfPresent(CGRect.self, forKey: CanvasLayerCodingKeys.canvasLayerTransformBox) ?? CGRect()
        opacity = try container.decodeIfPresent(CGFloat.self, forKey: CanvasLayerCodingKeys.canvasLayerOpacity) ?? 1
        if let tint = try container.decodeIfPresent([CGFloat]?.self, forKey: CanvasLayerCodingKeys.canvasLayerTint) ?? nil {
            tintColor = UIColor(red: tint[0], green: tint[1], blue: tint[2], alpha: tint[3])
        }
    }
    
    public init(canvas: Canvas) {
        drawingArray = []
        importedImage = nil
        isVisible = true
        allowsDrawing = true
        name = nil
        selectedNodes = []
        isDragging = false
        transformBox = CGRect()
        self.canvas = canvas
        opacity = 1
        tintColor = nil
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Clears the drawing on this layer. */
    public func clear() {
        drawingArray = []
        selectedNodes = []
        importedImage = nil
        canvas.setNeedsDisplay()
    }
    
    
    /** Sets the nodes on this layer. */
    public func setNodes(nodes: [Node]) {
        drawingArray = nodes
        canvas.setNeedsDisplay()
    }
    
    
    /** Selects the specified nodes. */
    public func select(nodes: [Node]) {
        selectedNodes = nodes
    }
    
    
    /** Add a line node to this layer. */
    public func addLineNode(firstPoint: CGPoint, lastPoint: CGPoint, movable: Bool = true) {
        var node = Node()
        node.isMovable = movable
        node.firstPoint = firstPoint
        node.lastPoint = lastPoint
        node.mutablePath.move(to: firstPoint)
        node.mutablePath.addLine(to: lastPoint)
        makeNewShapeLayer(node: &node)
    }
    
    
    /** Add a rectangle node to this layer. */
    public func addRectangleNode(topLeft: CGPoint, bottomRight: CGPoint, movable: Bool = true) {
        var node = Node()
        node.isMovable = movable
        node.firstPoint = topLeft
        node.lastPoint = bottomRight
        let w = node.lastPoint.x - node.firstPoint.x
        let h = node.lastPoint.y - node.firstPoint.y
        let rect = CGRect(x: node.firstPoint.x, y: node.firstPoint.y, width: w, height: h)
        node.mutablePath.move(to: node.firstPoint)
        node.mutablePath.addRect(rect)
        makeNewShapeLayer(node: &node)
    }
    
    
    /** Add an ellipse node to this layer. */
    public func addEllipseNode(topLeft: CGPoint, bottomRight: CGPoint, movable: Bool = true) {
        var node = Node()
        node.isMovable = movable
        node.firstPoint = topLeft
        node.lastPoint = bottomRight
        let w = node.lastPoint.x - node.firstPoint.x
        let h = node.lastPoint.y - node.firstPoint.y
        let rect = CGRect(x: node.firstPoint.x, y: node.firstPoint.y, width: w, height: h)
        node.mutablePath.move(to: node.firstPoint)
        node.mutablePath.addEllipse(in: rect)
        makeNewShapeLayer(node: &node)
    }
    
    


    /** Calculates the transform box of the selected nodes. */
    func calculateTransformBox() {
        if selectedNodes.isEmpty {
            transformBox = CGRect()
            return
        }
        
        let sel = selectedNodes[0]
        var rect = sel.shapeLayer.frame
        for i in 0..<selectedNodes.count {
            let sell = selectedNodes[i]
            rect = rect.union(sell.shapeLayer.frame)
        }
        
        transformBox = rect
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    /** Makes a new shape layer that can be rendered on screen. */
    func makeNewShapeLayer(node: inout Node) {
        let sl = CAShapeLayer()
        sl.bounds = node.mutablePath.boundingBox
        sl.path = node.mutablePath
//        sl.backgroundColor = UIColor.orange.cgColor
        sl.strokeColor = canvas.currentBrush.color.cgColor
        sl.fillRule = kCAFillRuleEvenOdd
        sl.fillMode = kCAFillModeBoth
        sl.fillColor = nil
        sl.opacity = Float(canvas.currentBrush.opacity)
        sl.lineWidth = canvas.currentBrush.thickness
        sl.miterLimit = canvas.currentBrush.miter
        switch canvas.currentBrush.shape {
        case .butt:
            sl.lineCap = kCALineCapButt
            break
        case .round:
            sl.lineCap = kCALineCapRound
            break
        case .square:
            sl.lineCap = kCALineCapSquare
            break
        }
        switch canvas.currentBrush.joinStyle {
        case .bevel:
            sl.lineJoin = kCALineJoinBevel
            break
        case .miter:
            sl.lineJoin = kCALineJoinMiter
            break
        case .round:
            sl.lineJoin = kCALineJoinRound
            break
        }
        
        var nPos = node.mutablePath.boundingBox.origin
        nPos.x += node.mutablePath.boundingBox.width / 2
        nPos.y += node.mutablePath.boundingBox.height / 2
        sl.position = nPos
        
//        print(sl.position)
//        print(sl.bounds)
//        print(node.mutablePath.boundingBox)
        node.shapeLayer = sl
        drawingArray.append(node)
        canvas.setNeedsDisplay()
    }

    
    
    

    
    
    /************************
     *                      *
     *         OTHER        *
     *                      *
     ************************/
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CanvasLayerCodingKeys.self)
        try container.encode(canvas, forKey: CanvasLayerCodingKeys.canvasLayerCanvas)
        try container.encode(isVisible, forKey: CanvasLayerCodingKeys.canvasLayerIsVisible)
        try container.encode(allowsDrawing, forKey: CanvasLayerCodingKeys.canvasLayerAllowsDrawing)
        try container.encode(name ?? "", forKey: CanvasLayerCodingKeys.canvasLayerName)
        try container.encode(transformBox, forKey: CanvasLayerCodingKeys.canvasLayerTransformBox)
        try container.encode(opacity, forKey: CanvasLayerCodingKeys.canvasLayerOpacity)
        try container.encode(tintColor?.rgba, forKey: CanvasLayerCodingKeys.canvasLayerTint)
        try container.encode(canvas, forKey: CanvasLayerCodingKeys.canvasLayerCanvas)
        try container.encode(drawingArray, forKey: CanvasLayerCodingKeys.canvasLayerNodeArray)
    }
    
    
    
    
    
    
    
}
