//
//  Node.swift
//  Canvas
//
//  Created by Adeola Uthman on 5/17/18.
//

import Foundation

/** A Node on the canvas. A node is basically just any curve, line, or shape that appears on the canvas and is selectable. */
public struct Node {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The mutable path to draw. */
    internal var mutablePath: CGMutablePath
    
    /** The first point of the node. */
    internal var firstPoint: CGPoint
    
    /** The last point of the node. */
    internal var lastPoint: CGPoint
    
    /** The bounding area of the entire shape. */
    internal var boundingBox: CGRect
    
    /** The shape layer that this node draws on. */
    internal var shapeLayer: CAShapeLayer
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    init() {
        mutablePath = CGMutablePath()
        firstPoint = CGPoint()
        lastPoint = CGPoint()
        boundingBox = CGRect()
        shapeLayer = CAShapeLayer()
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Sets the first point on this node and moves there. */
    mutating func setInitialPoint(point: CGPoint) {
        firstPoint = point
        mutablePath.move(to: point)
    }
    
    
    /** Sets the last point and the current point and moves to the current point. */
    mutating func move(from: CGPoint, to: CGPoint, tool: CanvasTool) {
        lastPoint = to
        
        switch tool {
        case .pen:
            mutablePath.addQuadCurve(to: midpoint(a: from, b: to), control: from)
            break
        default:
            break
        }
    }
    
    
    /** Adds a new path to the curve and returns the bounding box of that path. */
    func addPath(p1: CGPoint, p2: CGPoint, currentPoint: CGPoint, tool: CanvasTool) -> CGRect {
        switch tool {
        case .pen:
            let mid1 = midpoint(a: p1, b: p2)
            let mid2 = midpoint(a: currentPoint, b: p2)
            
            let subpath = CGMutablePath()
            subpath.move(to: mid1)
            subpath.addQuadCurve(to: mid2, control: p2)
            let bounds = subpath.boundingBox
            
            mutablePath.addPath(subpath)
            subpath.closeSubpath()
            return bounds
        case .line:
            return CGRect()
        case .rectangle:
            return CGRect()
        case .ellipse:
            return CGRect()
        default:
            return CGRect()
        }
    }
    
    
    /** Checks whether or not this node contains a certain point. */
    func contains(point: CGPoint, tool: CanvasTool, canvas: Canvas) -> Bool {
        switch tool {
        case .pen:
            return false
        case .line:
            return false
        case .rectangle:
            return false
        case .ellipse:
            let center = CGPoint(x: boundingBox.minX + boundingBox.width / 2, y: boundingBox.minY + boundingBox.height / 2)
            let radius = boundingBox.width / 2
            let dx = point.x - center.x
            let dy = point.y - center.y
            let dist = sqrt((dx ** 2) + (dy ** 2))
            
            if let layer = canvas.layer.hitTest(point) {
                return ((layer as! CAShapeLayer).path?.contains(point))!
            }
            return dist <= radius
        default:
            return false
        }
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    /** Sets the rectangular bounding box of a curve. */
    mutating func setBoundingBox(rect: CGRect? = nil) {
        if rect != nil { boundingBox = rect!; return }
        boundingBox = CGRect(x: self.firstPoint.x, y: self.firstPoint.y, width: self.lastPoint.x - self.firstPoint.x, height: self.lastPoint.y - self.firstPoint.y)
    }
    
    
}
