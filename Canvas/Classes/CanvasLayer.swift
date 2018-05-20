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
    
    /** All of the nodes on this layer. */
    var drawingArray: [Node]!
    
    /** The nodes that have been selected. */
    var selectedNodes: [Node]!
    
    
    
    // -- PUBLIC VARS --
    
    /** Whether or not this layer is visible. True by default. */
    public var isVisible: Bool
    
    /** Whether or not this layer allows drawing. True by default. */
    public var allowsDrawing: Bool
    
    /** The opacity of everything on this layer. */
    public var opacity: CGFloat
    
    /** A name for this layer (optional). */
    public var name: String?
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public init(canvas: Canvas) {
        drawingArray = []
        isVisible = true
        allowsDrawing = true
        name = nil
        selectedNodes = []
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
        canvas.setNeedsDisplay()
    }
    
    
    /** Returns the bounding box of all the selected nodes. */
    func getTransformBox() -> CGRect {
        if selectedNodes.isEmpty { return CGRect() }
        
        var rect = selectedNodes[0].mutablePath.boundingBox
        for i in 0..<selectedNodes.count {
            rect = rect.union(selectedNodes[i].mutablePath.boundingBox)
        }
        
        return rect
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
     *        TOUCHES       *
     *                      *
     ************************/
    
    /** Handles movement events on a node. */
    func onMove(touch: UITouch) {
        for selNode in selectedNodes {
            selNode.shapeLayer.bounds = selNode.shapeLayer.bounds.offsetBy(dx: -touch.deltaX, dy: -touch.deltaY)
        }
        
        canvas.setNeedsDisplay()
        canvas.delegate?.didMoveNode(on: canvas, movedNodes: selectedNodes)
    }
    
//    /** Handles when a touch is released. */
//    func onRelease(point: CGPoint) {
//        let loc = point
//
//        // If you are not currently selecting a node, select one.
//        if selectNode == nil {
//            for node in nodeArray {
//                if node.allowsSelection == false { continue }
//                if node is EraserNode { continue }
//                if node.contains(point: loc) {
//                    selectNode = node
//                    canvas.delegate?.didSelectNode(on: canvas, selectedNode: node)
//                    break
//                }
//            }
//        }
//        // If you have a node selected and no node is pressed, unselect.
//        else {
//            for node in nodeArray {
//                if node.allowsSelection == false { continue }
//                if node is EraserNode { continue }
//                if node.contains(point: loc) {
//                    selectNode = node
//                    return
//                }
//            }
//            selectNode = nil
//        }
//    }
    
    
    
    

    
    
    /************************
     *                      *
     *         OTHER        *
     *                      *
     ************************/
    
}
