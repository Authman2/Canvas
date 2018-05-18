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
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    mutating func setInitialPoint(point: CGPoint) {
        firstPoint = point
        mutablePath.move(to: point)
    }
    
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
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    mutating func setBoundingBox() {
        boundingBox = CGRect(x: self.firstPoint.x, y: self.firstPoint.y, width: self.lastPoint.x - self.firstPoint.x, height: self.lastPoint.y - self.firstPoint.y)
    }
    
    
}
