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
    public var opacity: CGFloat
    
    /** A name for this layer (optional). */
    public var name: String?
    
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
        drawingArray = try container.decode([Node].self, forKey: CanvasLayerCodingKeys.canvasLayerNodeArray)
        canvas = try container.decode(Canvas.self, forKey: CanvasLayerCodingKeys.canvasLayerCanvas)
        isVisible = try container.decode(Bool.self, forKey: CanvasLayerCodingKeys.canvasLayerIsVisible)
        allowsDrawing = try container.decode(Bool.self, forKey: CanvasLayerCodingKeys.canvasLayerAllowsDrawing)
        name = try container.decode(String.self, forKey: CanvasLayerCodingKeys.canvasLayerName)
        selectedNodes = []
        isDragging = false
        transformBox = try container.decode(CGRect.self, forKey: CanvasLayerCodingKeys.canvasLayerTransformBox)
        opacity = try container.decode(CGFloat.self, forKey: CanvasLayerCodingKeys.canvasLayerOpacity)
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
        sl.fillColor = nil
        sl.fillRule = kCAFillRuleEvenOdd
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
        try container.encode(canvas, forKey: CanvasLayerCodingKeys.canvasLayerCanvas)
    }
    
    
    
    
    
    
    
}
