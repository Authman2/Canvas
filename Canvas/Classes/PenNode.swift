//
//  PenTool.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/9/18.
//

import Foundation

/** A standard pen tool for drawing on the canvas. */
class PenNode: Node {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    

    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    override func setInitialPoint(point: CGPoint) {
        self.firstPoint = point
        move(to: point)
    }
    
    override func move(from: CGPoint, to: CGPoint) {
        self.lastPoint = to
        addQuadCurve(to: midpoint(a: from, b: to), controlPoint: from)
    }
    
    override func addPathLastLastPoint(p1: CGPoint, p2: CGPoint, currentPoint: CGPoint) -> CGRect {
        let mid1 = midpoint(a: p1, b: p2)
        let mid2 = midpoint(a: currentPoint, b: p2)
        
        let subpath = CGMutablePath()
        subpath.move(to: mid1)
        subpath.addQuadCurve(to: mid2, control: p2)
        let bounds = subpath.boundingBox
        
        path.addPath(subpath)
        subpath.closeSubpath()
        return bounds
    }
    
    override func contains(point: CGPoint) -> Bool {
        return points.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= 5 && abs(point.y - p.y) <= 5 })
    }
    
    override func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.addPath(path)
        context.setLineCap(brush.shape)
        context.setLineJoin(brush.joinStyle)
        context.setLineWidth(brush.thickness)
        context.setStrokeColor(brush.color.cgColor)
        context.setBlendMode(.normal)
        context.setMiterLimit(brush.miter)
        context.setFlatness(brush.flatness)
        context.setAlpha(brush.opacity)
        context.strokePath()
    }
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}

