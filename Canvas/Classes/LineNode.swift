//
//  LineNode.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/13/18.
//

import Foundation

/** A straight line node. */
class LineNode: Node {
    
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
    }
    
    override func move(from: CGPoint, to: CGPoint) {
        self.lastPoint = to
    }
    
    override func contains(point: CGPoint) -> Bool {
        return points.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= 5 && abs(point.y - p.y) <= 5 })
    }
    
    override func moveNode(to: CGPoint) {
        let dx = lastPoint.x - firstPoint.x
        let dy = lastPoint.y - firstPoint.y
        var dists: [(CGFloat, CGFloat)] = []
        
        for i in 0..<points.count {
            let dx = points[i].x - firstPoint.x
            let dy = points[i].y - firstPoint.y
            
            dists.append((dx,dy))
        }
        
        firstPoint.x = firstPoint.x - (firstPoint.x - to.x)
        firstPoint.y = firstPoint.y - (firstPoint.y - to.y)
        
        lastPoint.x = firstPoint.x + dx
        lastPoint.y = firstPoint.y + dy
        
        for i in 0..<points.count {
            points[i].x = firstPoint.x + dists[i].0
            points[i].y = firstPoint.y + dists[i].1
        }
    }
    
    override func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineCap(brush.shape)
        context.setLineJoin(brush.joinStyle)
        context.setLineWidth(brush.thickness)
        context.setStrokeColor(brush.color.cgColor)
        context.setMiterLimit(brush.miter)
        context.setFlatness(brush.flatness)
        context.setAlpha(brush.opacity)
        
        context.move(to: self.firstPoint)
        context.addLine(to: self.lastPoint)
        
        context.strokePath()
    }
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
